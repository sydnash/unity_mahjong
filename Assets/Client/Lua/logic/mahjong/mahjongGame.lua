--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer  = require("logic.player.gamePlayer")
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
}

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function mahjongGame:ctor(data)
--    log("mahjongGame, data = " .. table.tostring(data))
    self.totalMahjongCount  = 108
    self.leftMahjongCount   = 0
    self.deskId             = data.DeskId
    self.cityType           = data.GameType
    self.config             = data.Config
    self.status             = data.Status
    self.creatorAcId        = data.Creator

    self.players = {}
    self.playerCount = 1
    self:registerCommandHandlers()

    self:onEnter(data)

    self.deskUI = require("ui.mahjongDesk").new(self)
    self.deskUI:show()
    
    self.operationUI = require("ui.mahjongOperation").new(self)
    self.operationUI:show()
    
    if data.Reenter ~= nil then
        local count = 0
        local ready = true
    
        for _, v in pairs(self.players) do 
            count = count + 1
            ready = ready and v.ready
        end

        if ready and (count == self.config.RenShu) then
            self.deskUI:onGameSync()
            self.operationUI:onGameSync(data.Reenter)
        else
            for _, v in pairs(self.players) do
                self.deskUI:setReady(v.acId, v.ready)
            end
        end

        self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
    else
        local player = self:getPlayerByAcId(gamepref.acId)
        self.deskUI:setReady(player.acId, player.ready)
    end

    self:syncExitVote(data)
end

-------------------------------------------------------------------------------
-- 注册服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function mahjongGame:registerCommandHandlers()
    networkManager.registerCommandHandler(protoType.sc.otherEnterDesk, function(msg)
        self:onOtherEnterHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.ready, function(msg)
        self:onReadyHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.start, function(msg)
        return self:onGameStartHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.fapai, function(msg)
        self:onFaPaiHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.mopai, function(msg)
        self:onMoPaiHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.oplist, function(msg)
        self:onOpListHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.opDo, function(msg)
        self:onOpDoHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.clear, function(msg)
        self:onClearHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.exitDesk, function(msg)
        self:onExitDeskHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.otherExitDesk, function(msg)
        self:onOtherExitHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.notifyExitVote, function(msg)
        self:onNotifyExitVoteHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.notifyExitVoteFailed, function(msg)
        self:onNotifyExitVoteFailedHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.exitVote, function(msg)
        self:onExitVoteHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.gameEnd, function(msg)
        self:onGameEndHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.dqHint, function(msg)
        self:onDingQueHintHandler(msg)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.dqDo, function(msg)
        self:onDingQueDoHandler(msg)
    end, true)
end

-------------------------------------------------------------------------------
-- 注销服务器主动推送的消息的处理函数
-------------------------------------------------------------------------------
function mahjongGame:unregisterCommandHandlers()
    networkManager.unregisterCommandHandler(protoType.sc.otherEnterDesk)
    networkManager.unregisterCommandHandler(protoType.sc.ready)
    networkManager.unregisterCommandHandler(protoType.sc.start)
    networkManager.unregisterCommandHandler(protoType.sc.fapai)
    networkManager.unregisterCommandHandler(protoType.sc.mopai)
    networkManager.unregisterCommandHandler(protoType.sc.oplist)
    networkManager.unregisterCommandHandler(protoType.sc.opDo)
    networkManager.unregisterCommandHandler(protoType.sc.clear)
    networkManager.unregisterCommandHandler(protoType.sc.exitDesk)
    networkManager.unregisterCommandHandler(protoType.sc.otherExitDesk)
    networkManager.unregisterCommandHandler(protoType.sc.notifyExitVote)
    networkManager.unregisterCommandHandler(protoType.sc.notifyExitVoteFailed)
    networkManager.unregisterCommandHandler(protoType.sc.exitVote)
    networkManager.unregisterCommandHandler(protoType.sc.gameEnd)
    networkManager.unregisterCommandHandler(protoType.sc.dqHint)
    networkManager.unregisterCommandHandler(protoType.sc.dqDo)
end

-------------------------------------------------------------------------------
-- 进入房间
-------------------------------------------------------------------------------
function mahjongGame:onEnter(msg)
    self.leftGames = msg.LeftTime
    self.creator = msg.Creator

    local player = gamepref.player
    player.conncted     = true
    player.ready        = msg.Ready
    player.turn         = msg.Turn
    player.score        = msg.Score
    player.isCreator    = self:isCreator(player.acId)
    player.isMarker     = self:isMarker(player.turn)

    self.players[player.turn] = player
    self.playerCount = 1
    self:syncOthers(msg.Others)

    if msg.Reenter ~= nil then
        self.markerTurn         = msg.Reenter.MarkerTurn
        self.curOpTurn          = msg.Reenter.CurOpTurn
        self.curOpType          = msg.Reenter.CurOpType
        self.dices              = { msg.Reenter.Dice1, msg.Reenter.Dice2 }
        self.totalMahjongCount  = msg.Reenter.TotalMJCnt
        self.leftMahjongCount   = msg.Reenter.LeftMJCnt
        self.deskStatus         = msg.Reenter.DeskStatus
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end

    self:refreshUI()
end

-------------------------------------------------------------------------------
-- 同步其他玩家的数据
-------------------------------------------------------------------------------
function mahjongGame:syncOthers(others)
    for _, v in pairs(others) do
        local player = self.players[v.Turn]

        if player == nil or player.acId ~= v.AcId then
            player = gamePlayer.new(v.AcId)
            self.players[v.Turn] = player
        end

        player.headerUrl = v.HeadUrl
        player:loadHeaderTex()
        player.nickname  = v.Nickname
        player.ip        = v.Ip
        player.sex       = Mathf.Clamp(v.Sex, sexType.box, sexType.girl)
        player.laolai    = v.IsLaoLai
        player.connected = v.IsConnected
        player.ready     = v.Ready
        player.turn      = v.Turn
        player.score     = v.Score
        player.isCreator = self:isCreator(player.acId)
        player.isMarker  = self:isMarker(player.turn)

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

        player[mahjongGame.cardType.shou] = v.CardsInHand
        player[mahjongGame.cardType.chu]  = v.CardsInChuPai
        player[mahjongGame.cardType.peng] = v.ChiCheInfos

        if player.hu ~= nil then
            local shou = player[mahjongGame.cardType.shou]

            for k, u in pairs(shou) do
                if u == player.hu[1].HuCard then
                    table.remove(shou, k)
                    break
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
--    log("otherEnter, msg = " .. table.tostring(msg))

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

    self.players[player.turn] = player
    self.playerCount = self.playerCount + 1

    self.deskUI:onPlayerEnter(player)
end

-------------------------------------------------------------------------------
-- 准备
-------------------------------------------------------------------------------
function mahjongGame:onReadyHandler(msg)
--    log("ready, msg = " .. table.tostring(msg))

    local player = self:getPlayerByTurn(msg.Turn)
    player.ready = msg.Ready

    self.deskUI:setReady(player.acId, player.ready) 
end

-------------------------------------------------------------------------------
-- 开始游戏
-------------------------------------------------------------------------------
function mahjongGame:onGameStartHandler(msg)
--    log("start game, msg = " .. table.tostring(msg))

    for _, v in pairs(self.players) do
        v.que = -1
    end

    self.totalMahjongCount = msg.TotalMJCnt
    self.leftMahjongCount = self.totalMahjongCount
    self.dices = { msg.Dice1, msg.Dice2 }
    self.markerTurn = msg.Marker

    self.deskUI:onGameStart()
    local duration = self.operationUI:onGameStart()

    return duration
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function mahjongGame:onFaPaiHandler(msg)
--    log("fapai, msg = " .. table.tostring(msg))

    for _, v in pairs(msg.Seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player[mahjongGame.cardType.shou] = v.Cards

        for _, _ in pairs(v.Cards) do
            self.leftMahjongCount = self.leftMahjongCount - 1
        end
    end

    self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
    self.operationUI:OnFaPai()
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongGame:onMoPaiHandler(msg)
--    log("mopai, msg = " .. table.tostring(msg))

    local player = self:getPlayerByAcId(msg.AcId)
    local inhandMahjongs = player[mahjongGame.cardType.shou]

    for _, v in pairs(msg.Ids) do
        table.insert(inhandMahjongs, v)
        self.leftMahjongCount = self.leftMahjongCount - 1
    end

    self.deskUI:updateLeftMahjongCount(self.leftMahjongCount)
    self.operationUI:onMoPai(msg.AcId, msg.Ids)
end

-------------------------------------------------------------------------------
-- 操作
-------------------------------------------------------------------------------
function mahjongGame:onOpListHandler(msg)
--    log("oplist, msg = " .. table.tostring(msg))
    self.operationUI:onOpList(msg)
end

-------------------------------------------------------------------------------
-- 服务器验证的操作结果
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHandler(msg)
--    log("opdo, msg = " .. table.tostring(msg))

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
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function mahjongGame:onClearHandler(msg)
    self.operationUI:onClear()
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

        self.deskId = nil

        self.leftVoteSeconds    = msg.LeftTime
        self.exitVoteProposer   = msg.Proposer

        if msg.Proposer ~= nil and msg.Proposer > 0 then
            self.exitDeskUI = require("ui.exitDesk").new(self)
            self.exitDeskUI:show()
        else
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
-- 通过acid获取玩家
-------------------------------------------------------------------------------
function mahjongGame:getPlayerByAcId(acId)
    for _, v in pairs(self.players) do 
        if v.acId == acId then
            return v
        end
    end

    return nil
end

-------------------------------------------------------------------------------
-- 通过turn获取玩家
-------------------------------------------------------------------------------
function mahjongGame:getPlayerByTurn(turn)
    return self.players[turn]
end

-------------------------------------------------------------------------------
-- 获取我的Turn值
-------------------------------------------------------------------------------
function mahjongGame:getTurn(acId)
    local player = self:getPlayerByAcId(acId)
    return player.turn
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
function mahjongGame:getMarkerTurn()
    return self.markerTurn
end

-------------------------------------------------------------------------------
-- 获取庄家的Turn
-------------------------------------------------------------------------------
function mahjongGame:isMarker(turn)
    return self.markerTurn == turn
end

-------------------------------------------------------------------------------
-- 根据turn获取位置
-------------------------------------------------------------------------------
function mahjongGame:getSeatType(turn)
    local mineTurn = self:getTurn(gamepref.acId)

    if turn - mineTurn >= 0 then
        return turn - mineTurn
    end

    local playerCount = self:getTotalPlayerCount()
    return playerCount + turn - mineTurn
end

-------------------------------------------------------------------------------
-- 根据acId获取位置
-------------------------------------------------------------------------------
function mahjongGame:getSeatTypeByAcId(acId)
    local player = self:getPlayerByAcId(acId)
    local turn = player.turn
    local mineTurn = self:getTurn(gamepref.acId)

    if turn - mineTurn >= 0 then
        return turn - mineTurn
    end

    local playerCount = self:getTotalPlayerCount()
    return playerCount + turn - mineTurn
end

-------------------------------------------------------------------------------
-- 退出桌子
-------------------------------------------------------------------------------
function mahjongGame:exitGame()
    local loading = require("ui.loading").new()
    loading:show()

    self:destroy()

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
                        headerTex       = self.players[p.turn].headerTex,
                        nickname        = p.nickname, 
                        totalScore      = totalScores[p.acId], 
                        turn            = p.turn, 
                        seat            = self:getSeatType(p.turn),
                        isCreator       = self:isCreator(p.acId),
                        isWinner        = false,
            }

            datas.players[p.turn] = d
        end

        local ui = require("ui.gameOver").new(self, datas)
        ui:show()

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
--    log("other exit, msg = " .. table.tostring(msg))

    if self.leftGames > 0 then
        self.playerCount = self.playerCount - 1
        self.deskUI:onPlayerExit(msg.Turn)
    end
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
--    log("notify exit vote failed, msg = " .. table.tostring(msg))
    self.exitDeskUI:close()
    self.exitDeskUI = nil
end

-------------------------------------------------------------------------------
-- 服务器通知有人投票
-------------------------------------------------------------------------------
function mahjongGame:onExitVoteHandler(msg)
--    log("exit vote, msg = " .. table.tostring(msg))
    if self.exitDeskUI~= nil then
        local player = self:getPlayerByAcId(msg.AcId)
        player.exitVoteState = 1
        self.exitDeskUI:setPlayerState(player)
    end
end

-------------------------------------------------------------------------------
-- 服务器通知牌局结束
-------------------------------------------------------------------------------
function mahjongGame:onGameEndHandler(msg)
--    log("game end, msg = " .. table.tostring(msg))
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
                    headerTex       = self.players[p.turn].headerTex,
                    nickname        = p.nickname, 
                    score           = v.Score,
                    totalScore      = totalScores[v.AcId], 
                    turn            = p.turn, 
                    seat            = self:getSeatType(p.turn),
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

        datas.players[p.turn] = d
    end

    self.gameEndUI = require("ui.gameEnd").new(self, datas)
    self.gameEndUI:show()

    self.deskUI:reset()
    self.operationUI:reset()
end

-------------------------------------------------------------------------------
-- 服务器通知定缺信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueHintHandler(msg)
--    log("ding que hint, msg = " .. table.tostring(msg))
    self.operationUI:onDingQueHint(msg)
end

-------------------------------------------------------------------------------
-- 服务器通知定缺具体信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueDoHandler(msg)
--    log("ding que do, msg = " .. table.tostring(msg))

    for _, v in pairs(msg.Dos) do
        local player = self:getPlayerByAcId(v.AcId)
        player.que = v.Q
    end

    self.deskUI:onDingQueDo(msg)
    self.operationUI:onDingQueDo(msg)
end

-------------------------------------------------------------------------------
-- 同意解散房间
-------------------------------------------------------------------------------
function mahjongGame:agreeExit()
    networkManager.exitVote(true, function(ok, msg)
        if not ok then

        else
--            log("agree exit, msg = " .. tostring(msg.Agree))
        end
    end)
end

-------------------------------------------------------------------------------
-- 拒绝解散房间
-------------------------------------------------------------------------------
function mahjongGame:rejectExit()
    networkManager.exitVote(false, function(ok, msg)
        if not ok then

        else
--            log("reject exit, msg = " .. tostring(msg.Agree))
        end
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
--    log("mahjongGame:destroy")

    self.playerCount = 0
    self:unregisterCommandHandlers()

    if self.deskUI ~= nil then
        self.deskUI:close()
        self.deskUI = nil
    end

    if self.operationUI ~= nil then
        self.operationUI:close()
        self.operationUI = nil
    end

    if self.exitDeskUI ~= nil then
        self.exitDeskUI:close()
        self.exitDeskUI = nil
    end

    for _, v in pairs(self.players) do
        if v.acId ~= gamepref.acId then
            v:destroy()
        end
    end

    self.deskId = nil
    clientApp.currentDesk = nil
end

function mahjongGame:refreshUI()
    if self.deskUI ~= nil then
        self.deskUI:refreshUI()
    end

    if self.operationUI ~= nil then
        self.operationUI:refreshUI()
    end

    if self.exitDeskUI ~= nil then

    end
end

function mahjongGame:isCreator(acId)
    return acId == self.creatorAcId
end

function mahjongGame:isPlaying()
    return self.status == deskStatus.playing
end

return mahjongGame

--endregion
