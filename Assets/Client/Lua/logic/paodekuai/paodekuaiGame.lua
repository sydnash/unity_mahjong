--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType  = require("logic.poker.pokerType")
local gamePlayer = require("logic.player.gamePlayer")

local base = require("logic.game")
local paodekuaiGame = class("paodekuaiGame", base)

local totalCardCountByCity = {
    [cityType.jintang] = 52,
}

local huType = {
    hu = 0,
}

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:ctor(data, playback)
    base.ctor(self, data, playback)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:getTotalCardCountByGame(cityType)
    local cnt = totalCardCountByCity[cityType]
    return (cnt == nil) and 52 or cnt
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:createOperationUI()
    return require("ui.paodekuaiDesk.paodekuaiOperation").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:createDeskUI()
    return require("ui.paodekuaiDesk.paodekuaiDesk").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onEnter(msg)
    self:clearPlayerGameStatus()
    base.onEnter(self, msg)

    if msg.Reenter ~= nil then
        log("paodekuaiGame.onEnter, msg = " .. table.tostring(msg.Reenter))
        self.curOpTurn  = msg.Reenter.CurOpTurn
        self.curOpAcId  = self:getPlayerByTurn(self.curOpTurn).acId
        self.curOpType  = msg.Reenter.CurOpType

        local lastChupaiInfo = msg.Reenter.LastChuPaiInfo
        if lastChupaiInfo ~= nil then
            local player = self:getPlayerByTurn(lastChupaiInfo.Turn)
            player[pokerType.cardType.chu] = json.isNilOrNull(lastChupaiInfo.Cards) and {} or lastChupaiInfo.Cards
        end
        
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end
end

-------------------------------------------------------------------------------
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function paodekuaiGame:syncSeats(seats)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)

    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.ready = false --如果游戏中，清除ready状态

        player[pokerType.cardType.shou] = v.CardsInHand
        player.zhangShu = #v.CardsInHand
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:clearPlayerGameStatus()
    if self.players ~= nil then
        for _, p in pairs(self.players) do
            p.zhangShu = 0
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:initMessageHandlers()
    base.initMessageHandlers(self)

    self.commandHandlers[protoType.sc.paodekuai.start]      = {func = self:onMessageHandler("onGameStartHandler"),      nr = true}
    self.commandHandlers[protoType.sc.paodekuai.faPai]      = {func = self:onMessageHandler("onFaPaiHandler"),          nr = true}
    self.commandHandlers[protoType.sc.paodekuai.opList]     = {func = self:onMessageHandler("onOpListHandler"),         nr = true}
    self.commandHandlers[protoType.sc.paodekuai.opDo]       = {func = self:onMessageHandler("onOpDoHandler"),           nr = true}
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onGameStartHandler(msg)
    self:onGameStart(msg)

    for _, player in pairs(self.players) do
        player[pokerType.cardType.shou] = {}
        player[pokerType.cardType.chu] = {}
    end

    self:faPai(msg)
    
    self.deskUI:onGameStart()
    return self.operationUI:onGameStart()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onFaPaiHandler(msg)
    self:faPai(msg)

    self.deskUI:onFaPai()
    return self.operationUI:onFaPai()
end

function paodekuaiGame:faPai(msg)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)

    if not json.isNilOrNull(msg.Seats) then
        for _, v in pairs(msg.Seats) do
            local player = self:getPlayerByAcId(v.AcId)
            player[pokerType.cardType.shou] = v.Cards
            player.zhangShu = #player[pokerType.cardType.shou]

            self.deskUI:updateInhandCardsCount(player.acId)
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onMessageHandler(name)
    assert(self[name], string.format("onMessageHandler: function [%s] must exist.", name))

    local func = function(self, msg)
        if name == "onOpDoHandler" then
            msg.isOpDo = true
        elseif name == "onOpListHandler" then
            msg.isOpList = true
        end

        self:pushMessage(function(msg)
            return self[name](self, msg)
        end, 0, msg)
    end

    return func
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onOpListHandler(msg)
    log("paodekuaiGame.onOpListHandler, msg = " .. table.tostring(msg))

    self.operationUI:onOpList(msg)
    self.deskUI:onOpList(msg)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onOpDoHandler(msg)
    log("paodekuaiGame.onOpDoHandler, msg = " .. table.tostring(msg))

    self.operationUI:hideOpButtons()
    self.deskUI:hideClock()

    if msg.Op == opType.paodekuai.chu.id then
        self:onOpDoChu(msg)
    elseif msg.Op == opType.paodekuai.buChu.id then
        self:onOpDoBuChu(msg)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onOpDoChu(msg)
    log("paodekuaiGame:onOpDoChu, msg = " .. table.tostring(msg))
    local player = self:getPlayerByAcId(msg.AcId)
    local inhandCards = player[pokerType.cardType.shou]

    for _, id in pairs(msg.Del) do
        table.removeItem(inhandCards, id)
    end

    player.zhangShu = player.zhangShu - #msg.Del
    player[pokerType.cardType.chu] = msg.Del

    self.deskUI:onOpDoChu(msg.AcId)
    self.operationUI:onOpDoChu(msg.AcId, msg.Del, msg.DetailTyp, msg.LastPX)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onOpDoBuChu(msg)
    self.deskUI:onOpDoBuChu(msg.AcId)
    self.operationUI:onOpDoBuChu(msg.AcId)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:onGameEndListener(specialData, datas, totalScores)
--    log("paodekuaiGame.onGameEndListener, specialData = " .. table.tostring(specialData))
    datas.huAcId = specialData.HuAcId
    datas.huType = specialData.HuType

    for _, v in pairs(specialData.PlayerInfos) do
        local acId = v.AcId
        local p = self.players[acId]

        local d = {
            acId            = v.AcId, 
            headerUrl       = self.players[p.acId].headerUrl,
            nickname        = p.nickname, 
            score           = v.Score,
            totalScore      = totalScores[v.AcId], 
            turn            = p.turn,
            inhand          = v.ShouPai,
            isCreator       = self:isCreator(v.AcId),
            isWinner        = false,
            seatType        = self:getSeatTypeByAcId(v.AcId),
        }
        table.insert(datas.players, d)
    end
    
    table.sort(datas.players, function(t1, t2)
        return t1.seatType < t2.seatType
    end)

    self:clearPlayerGameStatus()

    self.deskUI:reset()
    self.operationUI:reset()
end

return paodekuaiGame

--endregion
