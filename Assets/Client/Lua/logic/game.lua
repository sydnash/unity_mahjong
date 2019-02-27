--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer        = require("logic.player.gamePlayer")
local tweenManager      = require("manager.tweenManager")

local game = class("game")

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function game:ctor(data, playback)
    self.data = data
    self.playback = playback

    self.messageHandlers = tweenSerial.new(false)
    tweenManager.add(self.messageHandlers)

--    self.totalCardsCount    = 0
    self.leftCardsCount     = 0
    self.deskId             = data.DeskId
    self.cityType           = data.GameType
    self.gameType           = data.Config.Game
    self.friendsterId       = data.ClubId
    self.config             = data.Config
    self.status             = data.Status
    self.creatorAcId        = data.Creator
    self.deskPlayStatus     = -1
    self.canBack            = true
    self.isGameOverUIShow   = false

    self.messageQueue       = {}
    self.pauseMeesage       = false
    self.processSpeed       = 1.0
    self.lastProcessTime    = 0
    self:initMessageHandlers()

    if playback == nil then
        self.mode = gameMode.normal
        self:registerCommandHandlers()

        gamepref.player.currentDesk = { cityType = self.cityType, deskId = self.deskId, }
    else
        self.mode = gameMode.playback
        self:registerPlaybackHandlers(playback)
    end

    self:onEnter(data)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:initMessageHandlers()
    self.commandHandlers = {
        [protoType.sc.otherEnterDesk]           = { func = self.onOtherEnterHandler,            nr = true },
        [protoType.sc.ready]                    = { func = self.onReadyHandler,                 nr = true },
        [protoType.sc.otherExitDesk]            = { func = self.onOtherExitHandler,             nr = true },
        [protoType.sc.notifyConnectStatus]      = { func = self.onOtherConnectStatusChanged,    nr = true },
        [protoType.sc.notifyExitVote]           = { func = self.onNotifyExitVoteHandler,        nr = true },
        [protoType.sc.notifyExitVoteFailed]     = { func = self.onNotifyExitVoteFailedHandler,  nr = true },
        [protoType.sc.exitVote]                 = { func = self.onExitVoteHandler,              nr = true },
        [protoType.sc.gameEnd]                  = { func = self.onGameEndHandler,               nr = true },
        [protoType.sc.deskStatusChange]         = { func = self.onDeskStatusChangedHandler,             nr = true },
    }
end

-------------------------------------------------------------------------------
-- 初始化UI并启动消息处理循环
-------------------------------------------------------------------------------
function game:startLoop()
    if self.deskUI == nil then
        self.deskUI = self:createDeskUI()
    end
    self.deskUI:reset()
    self.deskUI:show()

    if self.operationUI == nil then
        self.operationUI = self:createOperationUI()
    end
    self.operationUI:reset()
    self.operationUI:show()

    if self.mode == gameMode.playback then 
        local ui = require("ui.playback").new(self)
        ui:show()
    end
    
    if self.mode == gameMode.normal then
        if self.data.Reenter ~= nil then
            self.deskUI:onGameSync()
            self.operationUI:onGameSync()
        else
            self.deskUI:syncPlayerInfo()
            for _, player in pairs(self.players) do
                self.deskUI:setReady(player.acId, player.ready)
                self.deskUI:setScore(player.acId, player.score)
            end
        end

        self:syncExitVote(self.data)
    end

    self:startMessageQueue()
end

function game:onGameStart()
    self.deskStatus = deskStatus.playing
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:createOperationUI()
    return nil
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:createDeskUI()
    return nil
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:stopLoop()
    self:stopMessageQueue()
end

-------------------------------------------------------------------------------
-- 注册服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function game:registerCommandHandlers()
    for k, v in pairs(self.commandHandlers) do
        networkManager.registerCommandHandler(k, function(msg) v.func(self, msg) end, v.nr)
    end

    signalManager.registerSignalHandler(signalType.deskDestroy, self.onExitDeskHandler, self)
end

-------------------------------------------------------------------------------
-- 注销服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function game:unregisterCommandHandlers()
    for k, _ in pairs(self.commandHandlers) do
        networkManager.unregisterCommandHandler(k)
    end

    signalManager.unregisterSignalHandler(signalType.deskDestroy, self.onExitDeskHandler, self)
end

-------------------------------------------------------------------------------
-- 注册回放数据的处理函数
-------------------------------------------------------------------------------
function game:registerPlaybackHandlers(playback)
    for _, v in pairs(playback) do
        local func = self.commandHandlers[v.Command].func
        func(self, v.Payload)
        self:addDelay(1.5)
    end
end

-------------------------------------------------------------------------------
-- 注销回放数据的处理函数
-------------------------------------------------------------------------------
function game:unregisterPlaybackHandlers()
    self.messageHandlers:clear()
    tweenManager.remove(self.messageHandlers)
    self:clearMessageQueue()
    self:stopMessageQueue()
end

-------------------------------------------------------------------------------
-- 进入房间
-------------------------------------------------------------------------------
function game:onEnter(msg)
    if not self:isPlayback() then
        self:clearMessageQueue()
    end
    self.data = msg
    self.deskStatus = self.data.Status

    self.players = {}
    self.playerCount = 0
    self.leftGames = msg.LeftTime
    self.creator = msg.Creator
    self:syncPlayers(msg.Players)
end

-------------------------------------------------------------------------------
-- 同步其他玩家的数据
-------------------------------------------------------------------------------
function game:syncPlayers(players)
    self.mainAcId = players[1].AcId

    for _, v in pairs(players) do
        local player = gamePlayer.new(v.AcId)
        self.players[v.AcId] = player

        player.headerUrl = v.HeadUrl
        player.nickname  = v.Nickname
        player.ip        = v.Ip
        player.sex       = Mathf.Clamp(v.Sex, sexType.boy, sexType.girl)
        player.laolai    = v.IsLaoLai
        player.connected = v.IsConnected
        player.ready     = v.Ready
        player.turn      = v.Turn
        player.score     = v.Score
        player.isCreator = self:isCreator(player.acId)
        player.location  = { status = v.HasPosition, latitude = v.Latitude, longitude = v.Longitude }

        if player.acId == gamepref.player.acId then
            self.mainAcId = player.acId
        end

        self.playerCount = self.playerCount + 1
    end
end

-------------------------------------------------------------------------------
-- 同步解散房间投票的数据
-------------------------------------------------------------------------------
function game:syncExitVote(msg)
    if self.exitDeskUI ~= nil then
        self.exitDeskUI:close()
        self.exitDeskUI = nil
    end

    if msg.IsInExitVote then
        self.leftVoteSeconds    = msg.LeftVoteTime
        self.exitVoteProposer   = msg.ExitVoteProposer

        for _, v in pairs(msg.ExitVoteParams) do
            local player = self:getPlayerByAcId(v.AcId)
            player.exitVoteState = v.Status
        end
        
        self.exitDeskUI = require("ui.exitdesk").new(self)
        self.exitDeskUI:show()
    end
end

-------------------------------------------------------------------------------
-- 准备状态
-------------------------------------------------------------------------------
function game:ready(ready)
    networkManager.ready(ready, function(msg)
        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
        else
            self:onReadyHandler(msg)
        end
    end)
end

-------------------------------------------------------------------------------
-- 其他玩家加入
-------------------------------------------------------------------------------
function game:onOtherEnterHandler(msg)
    local func = (function()
--        log("otherEnter, msg = " .. table.tostring(msg))
        local player = gamePlayer.new(msg.AcId)

        player.headerUrl    = msg.HeadUrl
        player.nickname     = msg.Nickname
        player.ip           = msg.Ip
        player.sex          = Mathf.Clamp(msg.Sex, sexType.boy, sexType.girl)
        player.laolai       = msg.IsLaoLai
        player.connected    = msg.IsConnected
        player.ready        = msg.Ready
        player.turn         = msg.Turn
        player.score        = msg.Score
        player.location     = { status = msg.HasPosition, latitude = msg.Latitude, longitude = msg.Longitude }

        self.players[player.acId] = player
        self.playerCount = self.playerCount + 1

        self.deskUI:onPlayerEnter(player)
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 准备
-------------------------------------------------------------------------------
function game:onReadyHandler(msg)
    local func = (function()
--        log("ready, msg = " .. table.tostring(msg))

        local player = self:getPlayerByAcId(msg.AcId)
        player.ready = msg.Ready

        self.deskUI:setReady(player.acId, player.ready) 
    end)
    self:pushMessage(func)
end

function game:onDeskStatusChangedHandler(msg)
    local func = function()
        self.deskPlayStatus = msg.Status
        self:onDeskStatusChanged()
    end
    self:pushMessage(func)
end

function game:onDeskStatusChanged()

end

-------------------------------------------------------------------------------
-- 结束一局
-------------------------------------------------------------------------------
function game:endGame()
    networkManager.destroyDesk(function(msg)
--        log("end game, msg = " .. table.tostring(msg))
        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        if msg.Proposer ~= nil and msg.Proposer > 0 then
            self:resetExitVoteInfo(msg)
            self.exitDeskUI = require("ui.exitDesk").new(self)
            self.exitDeskUI:show()
        else
            gamepref.player.currentDesk = nil
            self:exitGame()
        end
    end)
end

-------------------------------------------------------------------------------
-- 通过turn获取玩家
-------------------------------------------------------------------------------
function game:getPlayerByAcId(acId)
    return self.players[acId]
end

function game:getPlayerByTurn(turn)
    for _, v in pairs(self.players) do
        if v.turn == turn then
            return v
        end
    end
end
-------------------------------------------------------------------------------
-- 获取总局数
-------------------------------------------------------------------------------
function game:getTotalGameCount()
    return self.config.JuShu
end

-------------------------------------------------------------------------------
-- 获取剩余局数
-------------------------------------------------------------------------------
function game:getLeftGameCount()
    return self.leftGames
end

-------------------------------------------------------------------------------
-- 获取玩家总人数
-------------------------------------------------------------------------------
function game:getTotalPlayerCount()
    return self.config.RenShu
end

-------------------------------------------------------------------------------
-- 获取加入的玩家人数
-------------------------------------------------------------------------------
function game:getPlayerCount()
    return self.playerCount
end

-------------------------------------------------------------------------------
-- 获取牌总数
-------------------------------------------------------------------------------
function game:getTotalCardsCount()
    return self.totalCardsCount
end

-------------------------------------------------------------------------------
-- 获取牌剩余数
-------------------------------------------------------------------------------
function game:getLeftCardsCount()
    return self.leftCardsCount
end

-------------------------------------------------------------------------------
-- 获取庄家的Turn
-------------------------------------------------------------------------------
function game:getMarkerPlayer()
    return self.players[self.markerAcId]
end

-------------------------------------------------------------------------------
-- 获取庄家的Turn
-------------------------------------------------------------------------------
function game:isMarker(acId)
    return self.markerAcId == acId
end

-------------------------------------------------------------------------------
-- 根据acId获取位置
-------------------------------------------------------------------------------
function game:getSeatTypeByAcId(acId)
    local mainTurn = self:getPlayerByAcId(self.mainAcId).turn
    local turn = self:getPlayerByAcId(acId).turn
    local seat = turn - mainTurn
    local playerCount = self:getTotalPlayerCount()

    if seat < 0 then
        seat = playerCount + turn - mainTurn
    end

    if playerCount == 3 then
        if seat == seatType.top then
            seat = seatType.left
        end
    elseif playerCount == 2 then
        if seat == seatType.right then
            seat = seatType.top
        end
    end

    return seat
end

-------------------------------------------------------------------------------
-- 退出桌子
-------------------------------------------------------------------------------
function game:exitGame()
    closeAllUI()
    self:openLobbyUI()

    self:destroy()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:exitPlayback()
    self:exitGame()
end

-------------------------------------------------------------------------------
-- 退出房间的原因
-------------------------------------------------------------------------------
local exitReason = {
    playerExit      = 0,
    creatorExit     = 1,
    timeEnd         = 2,
    deskDestroy     = 3,
    enterTimeout    = 4,
    voteExit        = 5, --投票退出
    gameClosed      = 6,
    cloesByManager  = 7, --房间被亲友圈管理员关闭
}

-------------------------------------------------------------------------------
-- 服务器通知直接退出
-------------------------------------------------------------------------------
function game:onExitDeskHandler(msg)
    local func = (function()
--        log("exit desk, msg = " .. table.tostring(msg))

        if msg.Reason == exitReason.voteExit then
            --投票解散房间，关闭投票界面并显示大结算界面
            if self.exitDeskUI ~= nil then
                self.exitDeskUI:close()
            end

            local datas = { deskId          = self.deskId,
                            totalGameCount  = self:getTotalGameCount(),
                            finishGameCount = self:getTotalGameCount() - self:getLeftGameCount(),
                            players         = {},
            }

            local totalScores = { }

            if string.isNilOrEmpty(msg.Special) then
                for _, p in pairs(self.players) do
                    totalScores[p.acId] = 0
                end
            else
                local special = table.fromjson(msg.Special)
                for _, v in pairs(special.TotalResuts) do
                    totalScores[v.AcId] = v.Score
                end
            end

            for _, p in pairs(self.players) do
                local d = { acId            = p.acId, 
                            headerUrl       = self.players[p.acId].headerUrl,
                            nickname        = p.nickname, 
                            totalScore      = totalScores[p.acId], 
                            turn            = p.turn, 
                            seat            = self:getSeatTypeByAcId(p.acId),
                            isCreator       = self:isCreator(p.acId),
                            isWinner        = false,
                }

                datas.players[p.acId] = d
            end

            local ui = require("ui.gameOver.gameOver").new(self, datas)
            ui:show()

            self.isGameOverUIShow = true
            if self.gameEndUI ~= nil then
                self.gameEndUI:close()
                self.gameEndUI = nil
            end

            self.deskUI:reset()
            self.operationUI:reset()
        elseif msg.Reason == exitReason.cloesByManager then
            --被亲友圈管理员关闭
            showMessageUI("牌局已被亲友圈群主关闭，如有疑问请联系群主",
                          function()
                            self:exitGame()
                          end)
        elseif msg.Reason == exitReason.playerExit then
        elseif msg.Reason == exitReason.creatorExit or msg.Reason == exitReason.deskDestroy then
            showMessageUI("桌子已经解散",
                          function()
                            self:exitGame()
                          end)
        elseif msg.Reason == exitReason.gameClosed then
            showMessageUI("服务器正在进行维护",
                          function()
                            self:exitGame()
                          end)
        else
            if self.gameEndUI ~= nil then
                self.gameEndUI:endAll()
            end
        end
    end)

    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知其他玩家退出
-------------------------------------------------------------------------------
function game:onOtherExitHandler(msg)
    local func = (function()
    --    log("other exit, msg = " .. table.tostring(msg))
        if self.leftGames > 0 then
            local seatType = self:getSeatTypeByAcId(msg.AcId)
            self.players[msg.AcId] = nil
            self.playerCount = self.playerCount - 1
            self.deskUI:onPlayerExit(seatType, msg)
        end
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:onOtherConnectStatusChanged(msg)
    local func = (function()
        local player = self:getPlayerByAcId(msg.AcId)
        player.connected = msg.IsConnected
        if self.deskUI then
            self.deskUI:onPlayerConnectStatusChanged(player)
        end
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:resetExitVoteInfo(msg)
    self.leftVoteSeconds    = msg.LeftTime
    self.exitVoteProposer   = msg.Proposer
    for _, p in pairs(self.players) do
        p.exitVoteState = exitDeskStatus.waiting
        if p.acId == msg.Proposer then
            p.exitVoteState = exitDeskStatus.proposer
        end
    end
end

-------------------------------------------------------------------------------
-- 服务器通知发起退出投票
-------------------------------------------------------------------------------
function game:onNotifyExitVoteHandler(msg)
--    log("notify exit vote, msg = " .. table.tostring(msg))
    self:resetExitVoteInfo(msg)

    self.exitDeskUI = require("ui.exitDesk").new(self)
    self.exitDeskUI:show()
end

-------------------------------------------------------------------------------
-- 服务器通知投票失败（有人拒绝）
-------------------------------------------------------------------------------
function game:onNotifyExitVoteFailedHandler(msg)
    local func = (function()
--        log("notify exit vote failed, msg = " .. table.tostring(msg))
        local player = self.players[msg.Rejecter]
        showMessageUI(string.format("玩家 %s 拒绝了解散申请", cutoutString(player.nickname,gameConfig.nicknameMaxLength)))
        self.exitDeskUI:close()
        self.exitDeskUI = nil
    end)
    
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知有人投票
-------------------------------------------------------------------------------
function game:onExitVoteHandler(msg)
    local func = (function()
    --    log("exit vote, msg = " .. table.tostring(msg))
        if self.exitDeskUI ~= nil then
            local player = self:getPlayerByAcId(msg.AcId)
            if msg.Agree then
                player.exitVoteState = exitDeskStatus.agree
            else
                player.exitVoteState = exitDeskStatus.reject
            end
            self.exitDeskUI:setPlayerState(player)
        end
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知牌局结束
-------------------------------------------------------------------------------
function game:onGameEndHandler(msg)
    self:addDelay(1)
 
    local func = (function()
--    log("game end, msg = " .. table.tostring(msg))
        self.deskStatus = deskStatus.waiting
        self.leftGames = msg.LeftTime
        local special = table.fromjson(msg.Special)

        local totalScores = {}
        local preData = table.fromjson(special.PreData)
    
        for _, v in pairs(preData.TotalResuts) do
            totalScores[v.AcId] = v.Score
            self.players[v.AcId].score = v.Score
        end

        local datas = { deskId          = self.deskId,
                        totalGameCount  = self:getTotalGameCount(),
                        finishGameCount = self:getTotalGameCount() - self:getLeftGameCount(),
                        players         = {},
        }
        local specialData = table.fromjson(special.SpecialData)

        self:onGameEndListener(specialData, datas, totalScores)

        self.gameEndUI = require("ui.gameEnd.gameEnd").new(self, datas)
        self.gameEndUI:show()
        self.deskUI:reset()
        self.operationUI:reset()
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 同意解散房间
-------------------------------------------------------------------------------
function game:agreeExit()
    networkManager.exitVote(true, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- 拒绝解散房间
-------------------------------------------------------------------------------
function game:rejectExit()
    networkManager.exitVote(false, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- 是否是房主
-------------------------------------------------------------------------------
function game:isCreator(acId)
    return self.creator == acId
end

-------------------------------------------------------------------------------
-- 销毁游戏对象
-------------------------------------------------------------------------------
function game:destroy()
    self.playerCount = 0

    self.messageHandlers:stop()
    self.messageHandlers:clear()
    tweenManager.remove(self.messageHandlers)

    self:stopMessageQueue()

    if self.mode == gameMode.normal then
        self:unregisterCommandHandlers()
    else
        self:unregisterPlaybackHandlers()
    end

    for _, v in pairs(self.players) do
        if v.acId ~= self.mainAcId then
            v:destroy()
        end
    end

    self.deskUI = nil
    self.operationUI = nil
    self.exitDeskUI = nil

    self.deskId = nil
    clientApp.currentDesk = nil
    
    gc()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:isCreator(acId)
    return acId == self.creatorAcId
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:isPlaying()
    return self.deskStatus == deskStatus.playing
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:canBackToLobby()
    return self.canBack
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:startPlayback()
    if self.mode == gameMode.playback then
        self:resumeMessageQueue()
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:stopPlayback()
    if self.mode == gameMode.playback then
        self:pauseMessageQueue()
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:isPlayback()
    return self.mode == gameMode.playback
end

-------------------------------------------------------------------------------
--message queue op
------------------------------------------------------------------------------
function game:clearMessageQueue()
    self.messageQueue = {}
end

function game:pauseMessageQueue()
    self.pauseMeesage = true
end

function game:resumeMessageQueue()
    if self.messageQueueHandler == nil then
        return
    end

    self.pauseMeesage = false
    self.lastProcessTime = time.realtimeSinceStartup()
end

function game:startMessageQueue()
    if self.messageQueueHandler == nil then
        self.messageQueueHandler = registerUpdateListener(self.update, self)
        self:resumeMessageQueue()
    end
end

function game:stopMessageQueue()
    if self.messageQueueHandler ~= nil then
        unregisterUpdateListener(self.messageQueueHandler)
        self.messageQueueHandler = nil
        self:clearMessageQueue()
    end
end

function game:isProcessPause()
    return self.pauseMeesage
end

function game:speedUpMessageQueue(t)
    self.processSpeed = self.processSpeed + t
    if self.processSpeed < 0.2 then
        self.processSpeed = 0.2
    elseif self.processSpeed > 2.0 then
        self.processSpeed = 2.0
    end
end

function game:setMessageSpeed(speed)
    self.processSpeed = speed
end

function game:messageSpeed()
    return self.processSpeed
end

function game:pushMessage(func, delay, param)
    if delay == nil then
        delay = 0
    end
    table.insert(self.messageQueue, {func = func, delay = delay, param = param})

    self:update()
end

function game:addDelay(delay)
    self:pushMessage(function()
        return delay
    end)
end

function game:frontMessage()
    if self.messageQueue == 0 then
        return nil
    end
    return self.messageQueue[1]
end

function game:popFrontMessage()
    table.remove(self.messageQueue, 1)
end
-------------------------------------------------------------------------------
--update
------------------------------------------------------------------------------
function game:update()
    if self.pauseMeesage then
        return
    end
    local now = time.realtimeSinceStartup()
    local dt = now - self.lastProcessTime
    self.lastProcessTime = now
    dt = dt * self.processSpeed

    local loop = true
    while loop do
        loop = false
        local msg = self:frontMessage()
        if not msg then
            break
        end
        local needDelete
        if not msg.isPlayed then
            local delay = msg.func(msg.param)
            if delay == nil then
                delay = msg.delay
            end
            msg.isPlayed = true
            msg.deleteTime = now + delay
            msg.waittime = now
            if delay <= 0.0000001 then
                needDelete = true --为了分散操作到每帧，即使不需要延迟，也留到下一帧再处理
            end
        else
            msg.waittime = msg.waittime + dt
            if msg.waittime >= msg.deleteTime then
                needDelete = true
            end
        end
        if needDelete then
            self:popFrontMessage()
            loop = true
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function game:openLobbyUI()
    local lobby = require("ui.lobby").new()
    lobby:hide()

    if self.friendsterId == nil or self.friendsterId <= 0 then
        lobby:show()
        return
    end

    showWaitingUI("请稍候")
    networkManager.queryFriendsterList(function(msg)
        if msg == nil then
            closeWaitingUI()
            lobby:show()
            return
        end

        local fst = require("ui.friendster.friendster").new(msg.Clubs)
        fst:hide()

        local data = fst.friendsters[self.friendsterId]
        if data == nil then
            closeWaitingUI()
            showMessageUI("你已经不在该亲友圈")
            lobby:show()
            fst:show()
            return
        end

        showWaitingUI("请稍候")

        networkManager.queryFriendsterMembers(self.friendsterId, function(msg)
            if msg == nil or msg.RetCode ~= retc.ok then
                closeWaitingUI()
                lobby:show()
                fst:show()
                return
            end

            data:setMembers(msg.Players)

            networkManager.queryFriendsterDesks(self.friendsterId, function(msg)
                closeWaitingUI()

                if msg == nil or msg.RetCode ~= retc.ok then
                    lobby:show()
                    fst:show()
                    return
                end

                data:setDesks(msg.Desks)

                local fstDetail = require("ui.friendster.friendsterDetail").new(data, function()
                    if fst.detailUI ~= nil then
                        fst.detailUI:close()
                        fst.detailUI = nil
                    end
                end)
                fstDetail:show()

                fstDetail:refreshUI()
                fstDetail:refreshMemberList()
                fstDetail:refreshDeskList()

                lobby:show()
                fst:show()
                fst.detailUI = fstDetail
            end)
        end)
    end)
end

function game:convertConfigToString(ignoreJuShu)
    return convertConfigToString(self.cityType, self.gameType, self.config, ignoreJuShu)
end

return game

--endregion
