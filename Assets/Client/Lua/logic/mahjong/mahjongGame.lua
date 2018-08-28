--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer  = require("logic.player.gamePlayer")
local opType      = require("const.opType")

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
}
-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function mahjongGame:ctor(data)
    self.mahjongCount   = 108
    self.deskId         = data.DeskId
    self.cityType       = data.GameType
    self.config         = data.Config

    self.players = {}
    self:registerCommandHandlers()

    self:onEnter(data)

    self.deskUI = require("ui.desk").new(self)
    self.deskUI:show()
    
    self.operationUI = require("ui.deskOperation").new(self)
    self.operationUI:show()
    
    if data.Reenter ~= nil then
        local count = 0
        local ready = true
    
        for _, v in pairs(self.players) do 
            count = count + 1
            ready = ready and v.ready
        end

        if ready and (count == self.config.RenShu) then
            self.deskUI:onGameStart()
            self.operationUI:onGameSync(data.Reenter)
        else
            for _, v in pairs(self.players) do
                self.deskUI:setReady(v.acId, v.ready)
            end
        end
    else
        local player = self:getPlayerByAcId(gamepref.acId)
        self.deskUI:setReady(player.acId, player.ready)
    end
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
        self:onGameStartHandler(msg)
    end, false)

    networkManager.registerCommandHandler(protoType.sc.fapai, function(msg)
        self:onFaPaiHandler(msg)
    end, false)

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
end

-------------------------------------------------------------------------------
-- 进入房间
-------------------------------------------------------------------------------
function mahjongGame:onEnter(msg)
    local player = gamePlayer.new(gamepref.acId)

    player.nickname = gamepref.nickname
    player.ip       = gamepref.ip
    player.sex      = gamepref.sex
    player.laolai   = gamepref.laolai
    player.conncted = true
    player.ready    = msg.Ready
    player.turn     = msg.Turn
    player.score    = msg.Score

    self.players[player.acId] = player
    self:syncOthers(msg.Others)

    if msg.Reenter ~= nil then
        self.markerTurn = msg.Reenter.MarkerTurn
        self.curOpTurn = msg.Reenter.CurOpTurn
        self.curOpType = msg.Reenter.CurOpType
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end
end

-------------------------------------------------------------------------------
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function mahjongGame:syncSeats(seats)
    for _, v in pairs(seats) do
        local player = self.players[v.AcId]

        player[mahjongGame.cardType.shou] = v.CardsInHand
        player[mahjongGame.cardType.chu]  = v.CardsInChuPai
        player[mahjongGame.cardType.peng] = v.ChiCheInfos
    end
end

-------------------------------------------------------------------------------
-- 同步其他玩家的数据
-------------------------------------------------------------------------------
function mahjongGame:syncOthers(others)
    for _, v in pairs(others) do
        local player = gamePlayer.new(v.AcId)

        player.nickname  = v.Nickname
        player.ip        = v.Ip
        player.sex       = v.Sex
        player.laolai    = v.IsLaoLai
        player.connected = v.IsConnected
        player.ready     = v.Ready
        player.turn      = v.Turn
        player.score     = v.Score

        self.players[player.acId] = player
    end
end

-------------------------------------------------------------------------------
-- 准备状态
-------------------------------------------------------------------------------
function mahjongGame:ready(ready)
    networkManager.ready(ready, function(ok, msg)
        if not ok then

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

    player.nickname     = msg.Nickname
    player.ip           = msg.Ip
    player.sex          = msg.Sex
    player.laolai       = msg.IsLaoLai
    player.connected    = msg.IsConnected
    player.ready        = msg.Ready
    player.turn         = msg.Turn
    player.score        = msg.Score

    self.players[player.acId] = player
end

-------------------------------------------------------------------------------
-- 准备
-------------------------------------------------------------------------------
function mahjongGame:onReadyHandler(msg)
    log("ready, msg = " .. table.tostring(msg))

    local player = self:getPlayerByTurn(msg.Turn)
    player.ready = msg.Ready

    self.deskUI:setReady(player.acId, player.ready) 
end

-------------------------------------------------------------------------------
-- 开始游戏
-------------------------------------------------------------------------------
function mahjongGame:onGameStartHandler(msg)
    log("startGame, msg = " .. table.tostring(msg))

    self.markerTurn = msg.Marker

    self.deskUI:onGameStart()
    self.operationUI:onGameStart()
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function mahjongGame:onFaPaiHandler(msg)
    log("fapai, msg = " .. table.tostring(msg))

    for _, v in pairs(msg.Seats) do
        local player = self.players[v.AcId]
        player[mahjongGame.cardType.shou] = v.Cards
    end

    self.operationUI:OnMahjongDispatched()
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongGame:onMoPaiHandler(msg)
    log("mopai, msg = " .. table.tostring(msg))

    local player = self:getPlayerByAcId(msg.AcId)
    local inhandMahjongs = player[mahjongGame.cardType.shou]

    for _, v in pairs(msg.Ids) do
        table.insert(inhandMahjongs, v)
    end

    self.operationUI:onMoPai(msg.AcId, msg.Ids)
end

-------------------------------------------------------------------------------
-- 操作
-------------------------------------------------------------------------------
function mahjongGame:onOpListHandler(msg)
    log("oplist, msg = " .. table.tostring(msg))
    self.operationUI:onOpList(msg)
end

-------------------------------------------------------------------------------
-- 服务器验证的操作结果
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHandler(msg)
    log("opdo, msg = " .. table.tostring(msg))

    for _, v in pairs(msg.Do) do
        local optype = v.Op
        local acId   = v.AcId
        local cards  = v.Do.Cs
        local beAcId = v.BeAcId
        local beCard = v.Card

        if optype == opType.chu then
            self:onOpDoChu(acId, cards)
        elseif optype == opType.chi then
            self:onOpDoChi(acId, cards, beAcId, beCard)
        elseif optype == opType.peng then
            self:onOpDoPeng(acId, cards, beAcId, beCard)
        elseif optype == opType.gang then
            self:onOpDoGang(acId, cards, beAcId, beCard)
        elseif optype == opType.hu then
            self:onOpDoHu(acId, cards, beAcId, beCard)
        elseif optype == opType.guo then
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
    touch.removeListener()
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
    self.operationUI:onOpDoPeng(acId, cards, beAcId, beCard)
end

-------------------------------------------------------------------------------
-- SC 杠
-------------------------------------------------------------------------------
function mahjongGame:onOpDoGang(acId, cards, beAcId, beCard)
    self.operationUI:onOpDoGang(acId, cards, beAcId, beCard)
end

-------------------------------------------------------------------------------
-- SC 胡
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHu(acId, cards, beAcId, beCard)
    self.operationUI:onOpDoHu(acId, cards, beAcId, beCard)
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
    return self.players[acId]
end

-------------------------------------------------------------------------------
-- 通过turn获取玩家
-------------------------------------------------------------------------------
function mahjongGame:getPlayerByTurn(turn)
    for _, v in pairs(self.players) do 
        if v.turn == turn then
            return v
        end
    end

    return nil
end

-------------------------------------------------------------------------------
-- 获取我的Turn值
-------------------------------------------------------------------------------
function mahjongGame:getTurn(acId)
    local player = self:getPlayerByAcId(acId)
    return player.turn
end

-------------------------------------------------------------------------------
-- 获取玩家人数
-------------------------------------------------------------------------------
function mahjongGame:getPlayerCount()
    return self.config.RenShu
end

-------------------------------------------------------------------------------
-- 获取麻将总数
-------------------------------------------------------------------------------
function mahjongGame:getMahjongTotalCount()
    return self.mahjongCount
end

return mahjongGame

--endregion
