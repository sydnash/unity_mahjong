--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer        = require("logic.player.gamePlayer")
local tweenManager      = require("manager.tweenManager")
local locationManager   = require("logic.manager.locationManager")

local mahjongGame = class("mahjongGame")

mahjongGame.seatType = {
    mine  = 0,
    right = 1,
    top   = 2,
    left  = 3,
}

mahjongGame.cardType = {
    idle = 1,
    shou = 2,
    peng = 3,
    chu  = 4,
    hu   = 5,
    huan = 6,
}

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function mahjongGame:ctor(data, playback)
    log("mahjongGame, data = " .. table.tostring(data))
    log("mahjongGame, playback = " .. table.tostring(playback))

    self.data = data
    self.playback = playback

    self.messageHandlers = tweenSerial.new(false)
    tweenManager.add(self.messageHandlers)

    self.totalMahjongCount  = 108
    self.leftMahjongCount   = 0
    self.deskId             = data.DeskId
    self.cityType           = data.GameType
    self.gameType           = gameType.mahjong
    self.config             = data.Config
    self.status             = data.Status
    self.creatorAcId        = data.Creator
    self.deskStatus         = deskStatus.none

    self.commandHandlers = {
        [protoType.sc.otherEnterDesk]           = { func = self.onOtherEnterHandler,            nr = true },
        [protoType.sc.ready]                    = { func = self.onReadyHandler,                 nr = true },
        [protoType.sc.start]                    = { func = self.onGameStartHandler,             nr = true },
        [protoType.sc.fapai]                    = { func = self.onFaPaiHandler,                 nr = true },
        [protoType.sc.huanNZhangHint]           = { func = self.onHuanNZhangHintHandler,        nr = true },
        [protoType.sc.huanNZhangChoose]         = { func = self.onHuanNZhangChooseHandler,      nr = true },
        [protoType.sc.huanNZhangDo]             = { func = self.onHuanNZhangDoHandler,          nr = true },
        [protoType.sc.mopai]                    = { func = self.onMoPaiHandler,                 nr = true },
        [protoType.sc.oplist]                   = { func = self.onOpListHandler,                nr = true },
        [protoType.sc.opDo]                     = { func = self.onOpDoHandler,                  nr = true },
        [protoType.sc.clear]                    = { func = self.onClearHandler,                 nr = true },
        [protoType.sc.exitDesk]                 = { func = self.onExitDeskHandler,              nr = true },
        [protoType.sc.otherExitDesk]            = { func = self.onOtherExitHandler,             nr = true },
        [protoType.sc.notifyConnectStatus]      = { func = self.onOtherConnectStatusChanged,    nr = true },
        [protoType.sc.notifyExitVote]           = { func = self.onNotifyExitVoteHandler,        nr = true },
        [protoType.sc.notifyExitVoteFailed]     = { func = self.onNotifyExitVoteFailedHandler,  nr = true },
        [protoType.sc.exitVote]                 = { func = self.onExitVoteHandler,              nr = true },
        [protoType.sc.gameEnd]                  = { func = self.onGameEndHandler,               nr = true },
        [protoType.sc.dqHint]                   = { func = self.onDingQueHintHandler,           nr = true },
        [protoType.sc.dqDo]                     = { func = self.onDingQueDoHandler,             nr = true },
        [protoType.sc.quicklyStartChose]        = { func = self.onQuicklyStartChose,            nr = true },
        [protoType.sc.quicklyStartNotify]       = { func = self.onQuicklyStartNotify,           nr = true },
        [protoType.sc.quicklyStartEndNotify]    = { func = self.onQuicklyStartEndNotify,        nr = true },
    }

    if playback == nil then
        self.mode = gameMode.normal
        self:registerCommandHandlers()
    else
        self.mode = gameMode.playback
        self:registerPlaybackHandlers(playback)
    end

    self:onEnter(data)
end

-------------------------------------------------------------------------------
-- 初始化UI并启动消息处理循环
-------------------------------------------------------------------------------
function mahjongGame:startLoop()
    if self.deskUI == nil then
        self.deskUI = require("ui.mahjongDesk").new(self)
    end
    self.deskUI:show()
    
    if self.operationUI == nil then
        self.operationUI = require("ui.mahjongOperation").new(self)
    end
    self.operationUI:show()
    self.deskUI:reset()
    self.operationUI:reset()

    if self.mode == gameMode.playback then 
        local ui = require("ui.playback").new(self)
        ui:show()
    end
    
    if self.mode == gameMode.normal then
        if self.data.Reenter ~= nil then
            if self.data.Status == gameStatus.playing then
                self.deskUI:onGameSync()
                self.operationUI:onGameSync()
            else
                for _, v in pairs(self.players) do
                    self.deskUI:setReady(v.acId, v.ready)
                end
            end

            self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
        else
            local player = self:getPlayerByAcId(self.mainAcId)
            self.deskUI:setReady(player.acId, player.ready)
        end

        self:syncExitVote(self.data)
    end

    self.messageHandlers:play()
end

-------------------------------------------------------------------------------
-- 注册服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function mahjongGame:registerCommandHandlers()
    for k, v in pairs(self.commandHandlers) do
        networkManager.registerCommandHandler(k, function(msg) v.func(self, msg) end, v.nr)
    end
end

-------------------------------------------------------------------------------
-- 注销服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function mahjongGame:unregisterCommandHandlers()
    for k, _ in pairs(self.commandHandlers) do
        networkManager.unregisterCommandHandler(k)
    end
end

-------------------------------------------------------------------------------
-- 注册回放数据的处理函数
-------------------------------------------------------------------------------
function mahjongGame:registerPlaybackHandlers(playback)
    for _, v in pairs(playback) do
        local func = self.commandHandlers[v.Command].func
        func(self, v.Payload)
        self.messageHandlers:add(tweenDelay.new(1.5))
    end
end

-------------------------------------------------------------------------------
-- 注销回放数据的处理函数
-------------------------------------------------------------------------------
function mahjongGame:unregisterPlaybackHandlers()
    self.messageHandlers:clear()
    tweenManager.remove(self.messageHandlers)
end

-------------------------------------------------------------------------------
-- 进入房间
-------------------------------------------------------------------------------
function mahjongGame:onEnter(msg)
    self.players = {}
    self.playerCount = 0
    self.leftGames = msg.LeftTime
    self.creator = msg.Creator

    self:syncPlayers(msg.Players)

    if msg.Reenter ~= nil then
        self.markerAcId         = msg.Reenter.MarkerAcId
        self.curOpAcId          = msg.Reenter.CurOpAcId
        self.curOpType          = msg.Reenter.CurOpType
        self.dices              = { msg.Reenter.Dice1, msg.Reenter.Dice2 }
        self.totalMahjongCount  = msg.Reenter.TotalMJCnt
        self.leftMahjongCount   = msg.Reenter.LeftMJCnt
        self.deskStatus         = msg.Reenter.DeskStatus
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end
end

-------------------------------------------------------------------------------
-- 同步其他玩家的数据
-------------------------------------------------------------------------------
function mahjongGame:syncPlayers(players)
    self.mainAcId = players[1].acId

    for _, v in pairs(players) do
        local player = gamePlayer.new(v.AcId)
        self.players[v.AcId] = player

        player.headerUrl = v.HeadUrl
        player:loadHeaderTex()
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
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function mahjongGame:syncSeats(seats)
    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.que = v.QueType
        player.hu = v.HuInfo
        player.isMarker = self:isMarker(player.acId)

        player[mahjongGame.cardType.shou] = v.CardsInHand
        player[mahjongGame.cardType.chu]  = v.CardsInChuPai
        player[mahjongGame.cardType.peng] = v.ChiCheInfos
        player[mahjongGame.cardType.huan] = {}

        if player.hu ~= nil then
            local shou = player[mahjongGame.cardType.shou]
            local huInfo = player.hu[1]
            local detail = opType.hu.detail
            if huInfo.HuType == detail.zimo or huInfo.HuType == detail.gangshanghua or huInfo.HuType == detail.haidilao then --自摸
                if player.acId == self.mainAcId then
                    for k, u in pairs(shou) do
                        if u == player.hu[1].HuCard then
                            table.remove(shou, k)
                            break
                        end 
                    end
                else
                    table.remove(shou, 1)
                end
            end
        end

        if v.HSZChose ~= nil then
            for _, m in pairs(v.HSZChose) do
                table.insert(player[mahjongGame.cardType.huan], m)
                for k, u in pairs(player[mahjongGame.cardType.shou]) do
                    if u == m then
                        table.remove(player[mahjongGame.cardType.shou], k)
                        break
                    end
                end
            end 
        end
    end
end

-------------------------------------------------------------------------------
-- 同步解散房间投票的数据
-------------------------------------------------------------------------------
function mahjongGame:syncExitVote(msg)
    if msg.IsInExitVote then
        self.leftVoteSeconds    = msg.LeftVoteTime
        self.exitVoteProposer   = msg.ExitVoteProposer

        for _, v in pairs(msg.ExitVoteParams) do
            local player = self:getPlayerByAcId(v.AcId)
            player.exitVoteState = v.Status
        end
        
        if self.exitDeskUI ~= nil then
            self.exitDeskUI:close()
        end

        self.exitDeskUI = require("ui.exitdesk").new(self)
        self.exitDeskUI:show()
    end
end

-------------------------------------------------------------------------------
-- 准备状态
-------------------------------------------------------------------------------
function mahjongGame:ready(ready)
    networkManager.ready(ready, function(ok, msg)
        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
        else
            self:onReadyHandler(msg)
        end
    end)
end

-------------------------------------------------------------------------------
-- 其他玩家加入
-------------------------------------------------------------------------------
function mahjongGame:onOtherEnterHandler(msg)
    log("otherEnter, msg = " .. table.tostring(msg))

    local player = gamePlayer.new(msg.AcId)

    player.headerUrl    = msg.HeadUrl
    player:loadHeaderTex()
    player.nickname     = msg.Nickname
    player.ip           = msg.Ip
    player.sex          = msg.Sex
    player.laolai       = msg.IsLaoLai
    player.connected    = msg.IsConnected
    player.ready        = msg.Ready
    player.turn         = msg.Turn
    player.score        = msg.Score
    player.location     = { status = msg.HasPosition, latitude = msg.Latitude, longitude = msg.Longitude }

    self.players[player.acId] = player
    self.playerCount = self.playerCount + 1

    self.deskUI:onPlayerEnter(player)
end

-------------------------------------------------------------------------------
-- 准备
-------------------------------------------------------------------------------
function mahjongGame:onReadyHandler(msg)
    local func = tweenFunction.new(function()
        log("ready, msg = " .. table.tostring(msg))

        local player = self:getPlayerByAcId(msg.AcId)
        player.ready = msg.Ready

        self.deskUI:setReady(player.acId, player.ready) 
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 开始游戏
-------------------------------------------------------------------------------
function mahjongGame:onGameStartHandler(msg)
--    log("start game, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.totalMahjongCount = msg.TotalMJCnt
        self.leftMahjongCount = self.totalMahjongCount
        self.dices = { msg.Dice1, msg.Dice2 }
        self.markerAcId = msg.MarkerAcId

        for _, v in pairs(self.players) do
            v.que = -1
            v.isMarker = self:isMarker(v.acId)
        end

        self.deskUI:onGameStart()
        self.operationUI:onGameStart()
    end)
    self.messageHandlers:add(func)

    if self.mode == gameMode.normal then
        self.messageHandlers:add(tweenDelay.new(2.5))
    end
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function mahjongGame:onFaPaiHandler(msg)
--    log("fapai, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.deskStatus = deskStatus.fapai

        for _, v in pairs(msg.Seats) do
            local player = self:getPlayerByAcId(v.AcId)
            player[mahjongGame.cardType.shou] = v.Cards

            for _, _ in pairs(v.Cards) do
                self.leftMahjongCount = self.leftMahjongCount - 1
            end
        end

        self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
        self.operationUI:OnFaPai()
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 提示换N张
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangHintHandler(msg)
    local func = tweenFunction.new(function()
        log("mahjongGame:onHuanNZhangHintHandler, msg = " .. table.tostring(msg))
        self.deskStatus = deskStatus.hsz
        self.operationUI:onHuanNZhangHint(msg)
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangChooseHandler(msg)
    local func = tweenFunction.new(function()
        log("mahjongGame:onHuanNZhangChooseHandler, msg = " .. table.tostring(msg))
        self.operationUI:onHnzChoose(msg)
    end)
    self.messageHandlers:add(func)
end
  
-------------------------------------------------------------------------------
-- 确定换N张
-------------------------------------------------------------------------------                
function mahjongGame:onHuanNZhangDoHandler(msg)
    if self.mode == gameMode.normal then
        local func = tweenFunction.new(function()
--            log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            self.operationUI:onHuanNZhangDo(msg)
        end)
        self.messageHandlers:add(func)
    else
        local func = tweenFunction.new(function()
--            log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            self.operationUI:onHuanNZhangDoPlayback(msg)
        end)
        self.messageHandlers:add(func)
    end
    --延时，等待交互动画完成
    self.messageHandlers:add(tweenDelay.new(2))
end
-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongGame:onMoPaiHandler(msg)
--    log("mopai, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        local player = self:getPlayerByAcId(msg.AcId)
        local inhandMahjongs = player[mahjongGame.cardType.shou]

        for _, v in pairs(msg.Ids) do
            table.insert(inhandMahjongs, v)
            self.leftMahjongCount = self.leftMahjongCount - 1
        end

        self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
        self.operationUI:onMoPai(msg.AcId, msg.Ids)
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 操作
-------------------------------------------------------------------------------
function mahjongGame:onOpListHandler(msg)
--    log("oplist, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.deskStatus = deskStatus.playing
        self.operationUI:onOpList(msg)
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器验证的操作结果
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHandler(msg)
--    log("opdo, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        for _, v in pairs(msg.Do) do
            local optype = v.Op
            local acId   = v.AcId
            local cards  = v.Do.Cs
            local beAcId = v.BeAcId
            local beCard = v.Card

            if optype == opType.chu.id then
                self:onOpDoChu(acId, cards)
            elseif optype == opType.chi.id then
                self:onOpDoChi(acId, cards, beAcId, beCard)
            elseif optype == opType.peng.id then
                self:onOpDoPeng(acId, cards, beAcId, beCard)
            elseif optype == opType.gang.id then
                local t = v.Do.T
                self:onOpDoGang(acId, cards, beAcId, beCard, t)
            elseif optype == opType.hu.id then
                local t = v.Do.T
                self:onOpDoHu(acId, cards, beAcId, beCard, t)
            elseif optype == opType.guo.id then
                self:onOpDoGuo(acId)
            else
                log("unknown optype: " .. tostring(optype))
            end
        end
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function mahjongGame:onClearHandler(msg)
    local func = tweenFunction.new(function()
        self.operationUI:onClear()
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 结束一局
-------------------------------------------------------------------------------
function mahjongGame:endGame()
    networkManager.destroyDesk(function(ok, msg)
--        log("end game, msg = " .. table.tostring(msg))
        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        self.leftVoteSeconds    = msg.LeftTime
        self.exitVoteProposer   = msg.Proposer

        if msg.Proposer ~= nil and msg.Proposer > 0 then
            self.exitDeskUI = require("ui.exitDesk").new(self)
            self.exitDeskUI:show()
        else
            self.deskId = nil
            clientApp.currentDesk = nil

            self:exitGame()
        end
    end)
end

-------------------------------------------------------------------------------
-- CS 过
-------------------------------------------------------------------------------
function mahjongGame:guo()
    networkManager.guoPai(function(ok, msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 报
-------------------------------------------------------------------------------
--function mahjongGame:bao()
--    networkManager.baoPai(function(ok, msg)
--    end)
--end

-------------------------------------------------------------------------------
-- CS 吃
-------------------------------------------------------------------------------
function mahjongGame:chi(cards)
    networkManager.chiPai(cards, function(ok, msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 碰
-------------------------------------------------------------------------------
function mahjongGame:peng(cards)
    networkManager.pengPai(cards, function(ok, msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 杠
-------------------------------------------------------------------------------
function mahjongGame:gang(cards)
--    log("mahjongGame.gang, cards = " .. table.tostring(cards))
    networkManager.gangPai(cards, function(ok, msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 胡
-------------------------------------------------------------------------------
function mahjongGame:hu(cards)
    networkManager.huPai(cards, function(ok, msg)
    end)
end

-------------------------------------------------------------------------------
-- SC 出牌
-------------------------------------------------------------------------------
function mahjongGame:onOpDoChu(acId, cards)
    self.operationUI:onOpDoChu(acId, cards)
end

-------------------------------------------------------------------------------
-- SC 吃
-------------------------------------------------------------------------------
function mahjongGame:onOpDoChi(acId, cards, beAcId, beCard)

end

-------------------------------------------------------------------------------
-- SC 碰
-------------------------------------------------------------------------------
function mahjongGame:onOpDoPeng(acId, cards, beAcId, beCard)
    log("mahjongGame:onOpDoPeng, acId = " .. tostring(acId))
    self.deskUI:onPlayerPeng(acId)
    self.operationUI:onOpDoPeng(acId, cards, beAcId, beCard)
end

-------------------------------------------------------------------------------
-- SC 杠
-------------------------------------------------------------------------------
function mahjongGame:onOpDoGang(acId, cards, beAcId, beCard, t)
    self.deskUI:onPlayerGang(acId)
    self.operationUI:onOpDoGang(acId, cards, beAcId, beCard, t)
end

-------------------------------------------------------------------------------
-- SC 胡
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHu(acId, cards, beAcId, beCard, t)
    self.deskUI:onPlayerHu(acId, t)
    self.operationUI:onOpDoHu(acId, cards, beAcId, beCard, t)
end

-------------------------------------------------------------------------------
-- SC 过
-------------------------------------------------------------------------------
function mahjongGame:onOpDoGuo(acId)
    self.operationUI:onOpDoGuo(acId)
end

-------------------------------------------------------------------------------
-- 通过turn获取玩家
-------------------------------------------------------------------------------
function mahjongGame:getPlayerByAcId(acId)
    return self.players[acId]
end

-------------------------------------------------------------------------------
-- 获取总局数
-------------------------------------------------------------------------------
function mahjongGame:getTotalGameCount()
    return self.config.JuShu
end

-------------------------------------------------------------------------------
-- 获取剩余局数
-------------------------------------------------------------------------------
function mahjongGame:getLeftGameCount()
    return self.leftGames
end

-------------------------------------------------------------------------------
-- 获取玩家总人数
-------------------------------------------------------------------------------
function mahjongGame:getTotalPlayerCount()
    return self.config.RenShu
end

-------------------------------------------------------------------------------
-- 获取加入的玩家人数
-------------------------------------------------------------------------------
function mahjongGame:getPlayerCount()
    return self.playerCount
end

-------------------------------------------------------------------------------
-- 获取麻将总数
-------------------------------------------------------------------------------
function mahjongGame:getTotalMahjongCount()
    return self.totalMahjongCount
end

-------------------------------------------------------------------------------
-- 获取麻将剩余数
-------------------------------------------------------------------------------
function mahjongGame:getLeftMahjongCount()
    return self.leftMahjongCount
end

-------------------------------------------------------------------------------
-- 获取庄家的Turn
-------------------------------------------------------------------------------
function mahjongGame:getMarkerPlayer()
    return self.players[self.markerAcId]
end

-------------------------------------------------------------------------------
-- 获取庄家的Turn
-------------------------------------------------------------------------------
function mahjongGame:isMarker(acId)
    return self.markerAcId == acId
end

-------------------------------------------------------------------------------
-- 根据acId获取位置
-------------------------------------------------------------------------------
function mahjongGame:getSeatTypeByAcId(acId)
    local mainTurn = self:getPlayerByAcId(self.mainAcId).turn
    local turn = self:getPlayerByAcId(acId).turn
    local seat = turn - mainTurn
    local playerCount = self:getTotalPlayerCount()

    if seat < 0 then
        seat = playerCount + turn - mainTurn
    end

    if playerCount == 3 then
        if seat == mahjongGame.seatType.top then
            seat = mahjongGame.seatType.left
        end
    elseif playerCount == 2 then
        if seat == mahjongGame.seatType.right then
            seat = mahjongGame.seatType.top
        end
    end

    return seat
end

-------------------------------------------------------------------------------
-- 退出桌子
-------------------------------------------------------------------------------
function mahjongGame:exitGame()
    closeAllUI()

    local loading = require("ui.loading").new()
    loading:show()

    sceneManager.load("scene", "lobbyscene", function(completed, progress)
        loading:setProgress(progress)

        if completed then
            local lobby = require("ui.lobby").new()
            lobby:show()

            loading:close()
        end
    end)

    self:destroy()
end

function mahjongGame:exitPlayback()
    self:exitGame()
end

-------------------------------------------------------------------------------
-- 退出房间的原因
-------------------------------------------------------------------------------
local exitReason = {
    voteExit = 5,
}

-------------------------------------------------------------------------------
-- 服务器通知直接退出
-------------------------------------------------------------------------------
function mahjongGame:onExitDeskHandler(msg)
--    log("exit desk, msg = " .. table.tostring(msg))

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
                        headerTex       = self.players[p.acId].headerTex,
                        nickname        = p.nickname, 
                        totalScore      = totalScores[p.acId], 
                        turn            = p.turn, 
                        seat            = self:getSeatTypeByAcId(p.acId),
                        isCreator       = self:isCreator(p.acId),
                        isWinner        = false,
            }

            datas.players[p.acId] = d
        end

        local ui = require("ui.gameOver").new(self, datas)
        ui:show()

        if self.gameEndUI ~= nil then
            self.gameEndUI:close()
            self.gameEndUI = nil
        end
        self.deskUI:reset()
        self.operationUI:reset()
    else
        if self.gameEndUI ~= nil then
            self.gameEndUI:endAll()
        end
    end
end

-------------------------------------------------------------------------------
-- 服务器通知其他玩家退出
-------------------------------------------------------------------------------
function mahjongGame:onOtherExitHandler(msg)
    local func = tweenFunction.new(function()
    --    log("other exit, msg = " .. table.tostring(msg))
        if self.leftGames > 0 then
            self.players[msg.AcId] = nil
            self.playerCount = self.playerCount - 1
            self.deskUI:onPlayerExit(msg)
        end
    end)
    self.messageHandlers:add(func)
end

function mahjongGame:onOtherConnectStatusChanged(msg)
    local func = tweenFunction.new(function()
        local player = self:getPlayerByAcId(msg.AcId)
        player.connected = msg.IsConnected
        if self.deskUI then
            self.deskUI:onPlayerConnectStatusChanged(player)
        end
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知发起退出投票
-------------------------------------------------------------------------------
function mahjongGame:onNotifyExitVoteHandler(msg)
--    log("notify exit vote, msg = " .. table.tostring(msg))

    self.leftVoteSeconds    = msg.LeftTime
    self.exitVoteProposer   = msg.Proposer

    self.exitDeskUI = require("ui.exitDesk").new(self)
    self.exitDeskUI:show()
end

-------------------------------------------------------------------------------
-- 服务器通知投票失败（有人拒绝）
-------------------------------------------------------------------------------
function mahjongGame:onNotifyExitVoteFailedHandler(msg)
    local func = tweenFunction.new(function()
    --    log("notify exit vote failed, msg = " .. table.tostring(msg))
        self.exitDeskUI:close()
        self.exitDeskUI = nil
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知有人投票
-------------------------------------------------------------------------------
function mahjongGame:onExitVoteHandler(msg)
    local func = tweenFunction.new(function()
    --    log("exit vote, msg = " .. table.tostring(msg))
        if self.exitDeskUI~= nil then
            local player = self:getPlayerByAcId(msg.AcId)
            player.exitVoteState = 1
            self.exitDeskUI:setPlayerState(player)
        end
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知牌局结束
-------------------------------------------------------------------------------
function mahjongGame:onGameEndHandler(msg)
--    log("game end, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.deskStatus = deskStatus.gameend

        for _, v in pairs(self.players) do
            v.que = -1
        end

        self.leftGames = msg.LeftTime

        local datas = { deskId          = self.deskId,
                        totalGameCount  = self:getTotalGameCount(),
                        finishGameCount = self:getTotalGameCount() - self:getLeftGameCount(),
                        players         = {},
        }

        local special = table.fromjson(msg.Special)

        local totalScores = {}
        local preData = table.fromjson(special.PreData)
    
        for _, v in pairs(preData.TotalResuts) do
            totalScores[v.AcId] = v.Score
        end

        local specialData = table.fromjson(special.SpecialData)

        for _, v in pairs(specialData.PlayerInfos) do
            local p = self:getPlayerByAcId(v.AcId)
            local d = { acId            = v.AcId, 
                        headerTex       = self.players[p.acId].headerTex,
                        nickname        = p.nickname, 
                        score           = v.Score,
                        totalScore      = totalScores[v.AcId], 
                        turn            = p.turn, 
                        seat            = self:getSeatTypeByAcId(p.acId),
                        inhand          = v.ShouPai,
                        hu              = v.Hu,
                        isCreator       = self:isCreator(v.AcId),
                        isWinner        = false,
    --                    que             = 1,
            }

            for k, u in pairs(d.inhand) do 
                if u == d.hu then
                    table.remove(d.inhand, k)
                end
            end

            local peng = v.ChiChe
            if peng ~= nil then
                for _, u in pairs(peng) do
                    if d[u.Op] == nil then
                        d[u.Op] = {}
                    end

                    table.insert(d[u.Op], u.Cs)
                end
            end

            datas.players[p.acId] = d
        end

        self.gameEndUI = require("ui.gameEnd").new(self, datas)
        self.gameEndUI:show()

        self.deskUI:reset()
        self.operationUI:reset()
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知定缺信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueHintHandler(msg)
--    log("ding que hint, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.operationUI:onDingQueHint(msg)
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知定缺具体信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueDoHandler(msg)
--    log("ding que do, msg = " .. table.tostring(msg))
    local func = tweenFunction.new(function()
        self.deskStatus = deskStatus.dingque

        for _, v in pairs(msg.Dos) do
            local player = self:getPlayerByAcId(v.AcId)
            player.que = v.Q
        end

        self.deskUI:onDingQueDo(msg)
        self.operationUI:onDingQueDo(msg)
    end)
    self.messageHandlers:add(func)
end

-------------------------------------------------------------------------------
-- 服务器通知有玩家发起快速开始投票
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartNotify(msg)
    log("mahjongGame:onQuicklyStartNotify " .. table.tostring(msg))
end
-------------------------------------------------------------------------------
-- 服务器通知快速开始投票结果
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartEndNotify(msg)
    log("mahjongGame:onQuicklyStartEndNotify" .. table.tostring(msg))
end
-------------------------------------------------------------------------------
-- 服务器通知有玩家选择快速开始投票
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartChose(msg)
    log("mahjongGame:onQuicklyStartChose" .. table.tostring(msg))
end
-------------------------------------------------------------------------------
--发起快速开始
-------------------------------------------------------------------------------
function mahjongGame:proposerQuicklyStart(cb)
    networkManager.proposerQuicklyStart(cb)
end
-------------------------------------------------------------------------------
--快开始投票
-------------------------------------------------------------------------------
function mahjongGame:quicklyStartChose(agree, cb)
    networkManager.quicklyStartChose(agree, cb)
end

-------------------------------------------------------------------------------
-- 同意解散房间
-------------------------------------------------------------------------------
function mahjongGame:agreeExit()
    networkManager.exitVote(true, function(ok, msg)

    end)
end

-------------------------------------------------------------------------------
-- 拒绝解散房间
-------------------------------------------------------------------------------
function mahjongGame:rejectExit()
    networkManager.exitVote(false, function(ok, msg)

    end)
end

-------------------------------------------------------------------------------
-- 是否是房主
-------------------------------------------------------------------------------
function mahjongGame:isCreator(acId)
    return self.creator == acId
end

-------------------------------------------------------------------------------
-- 销毁游戏对象
-------------------------------------------------------------------------------
function mahjongGame:destroy()
    self.playerCount = 0

    if self.mode == gameMode.normal then
        self.messageHandlers:stop()
        tweenManager.remove(self.messageHandlers)

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
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:isCreator(acId)
    return acId == self.creatorAcId
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:isPlaying()
    return self.status == deskStatus.playing
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:startPlayback()
    if self.mode == gameMode.playback then
        self.messageHandlers:play()
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:stopPlayback()
    if self.mode == gameMode.playback then
        self.messageHandlers:stop()
    end
end

return mahjongGame

--endregion
