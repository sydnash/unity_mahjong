
local gamePlayer        = require("logic.player.gamePlayer")

local base = require("logic.game")
local dssGame = class("dssGame", base)
local cardClass = require("logic.dss.card")

dssGame.cardType = {
    shou    = 1,
    peng    = 2,
    chu     = 3,
    hu      = 4,
}

local totalCardCountByCity = {
    [cityType.jintang] = 88,
}

function dssGame:getTotalCardCountByGame(cityType)
    local cnt = totalCardCountByCity[cityType]
    if cnt == nil then
        cnt = 84
    end
    return cnt
end
-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function dssGame:ctor(data, playback)
    self.super.ctor(self, data, playback)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)
end

function dssGame:onEnter(msg)
    self.super.onEnter(self, msg)
    
    if msg.Reenter ~= nil then
        self.markerTurn         = msg.Reenter.MarkerTurn
        self.markerAcId         = self:getPlayerByTurn(self.markerTurn).acId
        self.curOpTurn          = msg.Reenter.CurOpTurn
        self.curOpAcId          = self:getPlayerByTurn(self.curOpTurn).acId
        self.curOpType          = msg.Reenter.CurOpType
        self.deskStatus         = msg.Reenter.DeskStatus
        self.canBack            = (self.deskStatus == deskStatus.none)
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end
end

-------------------------------------------------------------------------------
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function dssGame:syncSeats(seats)
    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.ready = false --如果游戏中，清除ready状态
        player.que = v.QueType
        player.hu = v.HuInfo
        player.isMarker = self:isMarker(player.acId)

        player[mahjongGame.cardType.shou] = v.CardsInHand
        player[mahjongGame.cardType.chu]  = v.CardsInChuPai
        player[mahjongGame.cardType.peng] = v.ChiCheInfos

        player.fuShu = v.FuShu
        player.piaoStatus = v.PiaoStatus
        player.zhaoCnt = v.ZhaoCnt
    end
end

-- -------------------------------------------------------------------------------
-- -- 
-- -------------------------------------------------------------------------------
-- function mahjongGame:createOperationUI()
--     return require("ui.mahjongDesk.mahjongOperation").new(self)
-- end

-- -------------------------------------------------------------------------------
-- -- 
-- -------------------------------------------------------------------------------
-- function mahjongGame:createDeskUI()
--     return require("ui.mahjongDesk.mahjongDesk").new(self)
-- end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function dssGame:initMessageHandlers()
    self.super.initMessageHandlers(self)

    self.commandHandlers[protoType.sc.dss.start] = {func = self.onGameStartHandler, nr = true}
    self.commandHandlers[protoType.sc.dss.faPai] = {func = self.onFaPaiHandler, nr = true}
    self.commandHandlers[protoType.sc.dss.dang] = {func = self:onMessageHandler("onDangHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.dangNotify] = {func = self:onMessageHandler("onDangHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.anPai] = {func = self:onMessageHandler("onAnPaiHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.anPaiNotify] = {func = self:onMessageHandler("onAnPaiNotifyHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.moPai] = {func = self:onMessageHandler("onMoPaiHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.fanPai] = {func = self:onMessageHandler("onFanPaiHnadler"), nr = true}
    self.commandHandlers[protoType.sc.dss.opList] = {func = self:onMessageHandler("onOpListHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.opDo] = {func = self:onMessageHandler("onOpDoHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.bdList] = {func = self:onMessageHandler("onBdListHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.bdDo] = {func = self:onMessageHandler("onBdDoHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.piao] = {func = self:onMessageHandler("onPiaoHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.piaoNotify] = {func = self:onMessageHandler("onPiaoNotifyHandler"), nr = true}
    self.commandHandlers[protoType.sc.dss.anPaiShow] = {func = self:onMessageHandler("onAnPaiShowHandler"), nr = true}
    self.commandHandlers[protoType.sc.clear] = { func = self:onMessageHandler("onOpClearHandler"), nr = true }
end

function dssGame:onFaPaiHandler(msg)
    local func = (function()
        self:faPai(msg)
    end)
    self:pushMessage(func)
end

function dssGame:onMessageHandler(name)
    local func = function(msg)
        return self[name](msg)
    end
    self:pushMessage(func, 0, msg)
end

function dssGame:onDangHandler(msg)
    self.isMustDang = msg.IsMustDang
end

function dssGame:onDangNotifyHandler(msg)
    self.deskStatus = msg.CurDeskStatus
    local player = self:getPlayerByAcId(v.AcId)
    player.isDang = msg.IsDang
end

function dssGame:onPiaoHandler(msg)
end

function dssGame:onPiaoNotifyHandler(msg)
end

function dssGame:onAnPaiShowHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local t = {}
    for _, c in pairs(msg.Cards) do
        local cardType = cardClass.cardType(c) 
        local vec = t[cardType]
        if vec == nil then
            vec = {}
            t[cardType] = vec
        end
        table.insert(vec, c)
    end
    local cards = {}
    for _, cs in pairs(t) do
        table.insert(cards, cs)
    end
    local pengInfos = player[self.cardType.peng]
    local i = 1
    for _, info in pairs(pengInfos) do
        if info.Op ~= opType.dss.caiShen then
            info.Cards = cards[i]
            i = i + 1
        end
    end
end

function dssGame:onAnPaiHandler(msg)
end

function dssGame:onAnPaiNotifyHandler(msg)
end

function dssGame:onMoPaiHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local inhandCards = player[self.cardType.shou]
    for _, card in pairs(msg.Ids) do
        table.insert(inhandCards, card)
    end
    self:subLeftCount(#msg.Ids)
    player.fuShu = msg.FuShu
end

function dssGame:onFanPaiHnadler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local chuCards = player[self.cardType.chu]
    table.insert(chuCards, msg.Id)
    self:subLeftCount(1)
end

function dssGame:onOpListHandler(msg)
end

function dssGame:onChiPengGangType(player, op, cards, beCard)
    if beCard then --从出牌中找并删除
        for _, p in pairs(self.players) do
            table.removeItem(p[self.cardType.chu], beCard)
        end
        table.insert(cards, 1, beCard)
    end
    for _, c in pairs(cards) do --从手牌中删除
        table.removeItem(player[self.cardType.shou], c)
    end
    local info = {Op = op, Cards = cards}
    table.insert(player[self.cardType.peng], info)
end

function dssGame:onOpDoBaGang(player, msg)
    local card = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], card)
    local findInfo = nil
    for _, info in pairs(player[self.cardType.peng]) do
        if findInfo ~= nil then
            break
        end
        if info.Op ~= opType.dss.caiShen and #info.Cards <= 3 then
            if card < 0 or cardClass.typeId(info.Cards[1]) == cardClass.typeId(card) then
                table.insert(info.Cards, card)
                findInfo = info
                break
            end
        end
    end
end

function dssGame:onOpDoCaiShen(player, msg)
    local cards = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], c)
    local pengInfos = player[seat.cardType.peng]
    local caiShenInfo = nil
    if #pengInfos == 0 or pengInfos[1].Op ~= opType.dss.caiShen then
        caiShenInfo = {Op = opType.dss.caiShen, Cards = {}}
        table.insert(pengInfos, 1, caiShenInfo)
    else
        caiShenInfo = pengInfos[1]
    end
    table.insert(caiShenInfo.Cards, card)
end

function dssGame:onOpDoChi(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)
end

function dssGame:onOpDoChe(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)
end

function dssGame:onOpDoHua(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    self:onChiPengGangType(player, op, cards, nil)
end

function dssGame:onOpDoAn(player, op, delCards)
    local cards = delCards
    self:onChiPengGangType(player, op, cards, nil)
end

function dssGame:onOpDoHu(player, msg)
    player[self.cardType.hu] = msg.Card
end

function dssGame:onOpDoChu(player, msg)
    local delCard = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], delCard)
    table.insert(player[self.cardType.chu], delCard)
end

function dssGame:onOpDoHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    player.zhaoCnt = msg.ZhaoCnt
    player.fuShu = msg.FuShu
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    if op == opType.dss.hua then
        self:onOpDoHua(player, msg)
    elseif op == opType.dss.chu then
        self:onOpDoChu(player, msg)
    elseif op == opType.dss.chi then
        self:onOpDoChi(player, msg)
    elseif op == opType.dss.che then
        self:onOpDoChe(player, msg)
    elseif op == opType.dss.hu then
        self:onOpDoHu(player, msg)
    elseif op == opType.dss.gang then
    elseif op == opType.dss.pass then
    elseif op == opType.dss.an then
        self:onOpDoAn(player, op, cards)
    elseif op == opType.dss.zhao then
    elseif op == opType.dss.shou then
    elseif op == opType.dss.bao then
    elseif op == opType.dss.baGang then
        self:onOpDoBaGang(player, msg)
    elseif op == opType.dss.chiChengSan then
        self:onChiPengGangType(player, op, cards, beCard)
    elseif op == opType.dss.caiShen then
        self:onOpDoCaiShen(player, msg)
    elseif op == opType.dss.baoJiao then
    elseif op == opType.dss.gen then
    elseif op == opType.dss.weiGui then
    else
        log("on op do handler: receive not supported handler." .. tostring(op))
    end
end

function dssGame:onBdListHandler(msg)
end

function dssGame:onBdDoHandler(msg)
end

function dssGame:onOpClearHandler()
end

function dssGame:subLeftCount(cnt)
    self.leftCardsCount = self.leftCardsCount - cnt
end

function dssGame:faPai(msg)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)
    self.leftCardsCount = self.totalCardsCount
    for _, v in pairs(msg.Seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player[mahjongGame.cardType.shou] = v.Cards

        for _, _ in pairs(v.Cards) do
            self.leftCardsCount = self.leftCardsCount - 1
        end
    end
    self.deskUI:updateLeftMahjongCount(self.leftCardsCount)
end

function dssGame:onGameStartHandler(msg)
    local func = (function()
        self:faPai(msg)
        self.markerTurn = msg.Marker
        self.diceCard   = msg.DiceCardId
        self.diceTurn   = msg.DiceTurn
        self.deskStatus = msg.CurDeskStatus
        self.markerAcId = self:getPlayerByTurn(self.markerTurn).acId
        self.diceAcId   = self:getPlayerByTurn(self.diceTurn).acId
    end)
    self:pushMessage(func)
end

return dssGame
