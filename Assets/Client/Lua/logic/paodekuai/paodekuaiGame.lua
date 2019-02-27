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
        self.curOpTurn  = msg.Reenter.CurOpTurn
        self.curOpAcId  = self:getPlayerByTurn(self.curOpTurn).acId
        self.curOpType  = msg.Reenter.CurOpType

        log(self.curOpTurn)
        log(self.curOpAcId)
        log(self.curOpType)
        
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
--        player.isMarker = self:isMarker(player.acId)

        player[pokerType.cardType.shou] = v.CardsInHand
        player[pokerType.cardType.chu]  = v.CardsInChuPai

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

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:faPai(msg)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)

    if not json.isNilOrNull(msg.Seats) then
        for _, v in pairs(msg.Seats) do
            local player = self:getPlayerByAcId(v.AcId)
            player[pokerType.cardType.shou] = v.Cards
            player.zhangShu = #player[self.cardType.shou]

            self.deskUI:updateInhandCardCount(player.acId)
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
    self.operationUI:onOpList(msg)
    self.deskUI:onOpList(msg)
end

return paodekuaiGame

--endregion
