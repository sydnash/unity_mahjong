local gamePlayer = require("logic.player.gamePlayer")

local base = require("logic.game")
local doushisiGame = class("doushisiGame", base)
local doushisi = require("logic.doushisi.doushisi")
local doushisiType = require("logic.doushisi.doushisiType")

doushisiGame.cardType = doushisiType.cardType

doushisiGame.deskPlayStatus = {
    tuiDang     = 1,
	touPai      = 2,
	playing     = 3,
    ended       = 4,
	piao        = 5,
}

local totalCardCountByCity = {
    [cityType.jintang] = 88,
}

function doushisiGame:getTotalCardCountByGame(cityType)
    local cnt = totalCardCountByCity[cityType]
    if cnt == nil then
        cnt = 84
    end
    return cnt
end

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function doushisiGame:ctor(data, playback)
    self.super.ctor(self, data, playback)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)
end

function doushisiGame:onEnter(msg)
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
function doushisiGame:syncSeats(seats)
    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.ready = false --如果游戏中，清除ready状态
        player.que = v.QueType
        player.hu = v.HuInfo
        player.isMarker = self:isMarker(player.acId)

        player[doushisiType.cardType.shou] = v.CardsInHand
        player[doushisiType.cardType.chu]  = v.CardsInChuPai
        player[doushisiType.cardType.peng] = v.ChiCheInfos

        player.fuShu = v.FuShu
        player.piaoStatus = v.PiaoStatus
        player.zhaoCnt = v.ZhaoCnt
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:createOperationUI()
    return require("ui.dssDesk.dssDeskOperation").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:createDeskUI()
    return require("ui.mahjongDesk.mahjongDesk").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:initMessageHandlers()
    self.super.initMessageHandlers(self)

    self.commandHandlers[protoType.sc.doushisi.start] = {func = self:onMessageHandler("onGameStartHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.faPai] = {func = self:onMessageHandler("onFaPaiHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.dang] = {func = self:onMessageHandler("onDangHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.dangNotify] = {func = self:onMessageHandler("onDangNotifyHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.anPai] = {func = self:onMessageHandler("onAnPaiHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.anPaiNotify] = {func = self:onMessageHandler("onAnPaiNotifyHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.moPai] = {func = self:onMessageHandler("onMoPaiHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.fanPai] = {func = self:onMessageHandler("onFanPaiHnadler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.opList] = {func = self:onMessageHandler("onOpListHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.opDo] = {func = self:onMessageHandler("onOpDoHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.bdList] = {func = self:onMessageHandler("onBdListHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.bdDo] = {func = self:onMessageHandler("onBdDoHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.piao] = {func = self:onMessageHandler("onPiaoHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.piaoNotify] = {func = self:onMessageHandler("onPiaoNotifyHandler"), nr = true}
    self.commandHandlers[protoType.sc.doushisi.anPaiShow] = {func = self:onMessageHandler("onAnPaiShowHandler"), nr = true}
    self.commandHandlers[protoType.sc.clear] = { func = self:onMessageHandler("onOpClearHandler"), nr = true }
end

function doushisiGame:onFaPaiHandler(msg)
    self:faPai(msg)
    self.deskOpUI:onFaPai()
end

function doushisiGame:onMessageHandler(name)
    assert(self[name], string.format("on message handler: function<%s> must exist.", name))

    local func = function(msg)
        self:pushMessage(function(msg)
            self[name](self, msg)
        end, 0, msg)
    end
    return func
end

function doushisiGame:onDangHandler(msg)
    self.deskOpUI:onDangHandler(msg.IsMustDang)
end

function doushisiGame:onDangNotifyHandler(msg)
    self.deskStatus = msg.CurDeskStatus
    local player = self:getPlayerByAcId(v.AcId)
    player.isDang = msg.IsDang
end

function doushisiGame:onPiaoHandler(msg)

end

function doushisiGame:onPiaoNotifyHandler(msg)

end

function doushisiGame:onAnPaiShowHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local t = {}
    for _, c in pairs(msg.Cards) do
        local cardType = doushisi.typeId(c) 
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
        if info.Op ~= opType.doushisi.caiShen.id then
            info.Cards = cards[i]
            i = i + 1
        end
    end
end

function doushisiGame:onAnPaiHandler(msg)

end

function doushisiGame:onAnPaiNotifyHandler(msg)

end

function doushisiGame:onMoPaiHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local inhandCards = player[self.cardType.shou]
    for _, card in pairs(msg.Ids) do
        table.insert(inhandCards, card)
    end
    self:subLeftCount(#msg.Ids)
    player.fuShu = msg.FuShu
end

function doushisiGame:onFanPaiHnadler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local chuCards = player[self.cardType.chu]
    table.insert(chuCards, msg.Id)
    self:subLeftCount(1)
end

function doushisiGame:onOpListHandler(msg)
    self.deskOpUI:onOpList(msg)
end

function doushisiGame:onChiPengGangType(player, op, cards, beCard)
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

function doushisiGame:onOpDoBaGang(player, msg)
    local card = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], card)
    local findInfo = nil
    for _, info in pairs(player[self.cardType.peng]) do
        if findInfo ~= nil then
            break
        end
        if info.Op ~= opType.doushisi.caiShen.id and #info.Cards <= 3 then
            if card < 0 or doushisi.typeId(info.Cards[1]) == doushisi.typeId(card) then
                table.insert(info.Cards, card)
                findInfo = info
                break
            end
        end
    end
end

function doushisiGame:onOpDoCaiShen(player, msg)
    local cards = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], c)
    local pengInfos = player[seat.cardType.peng]
    local caiShenInfo = nil
    if #pengInfos == 0 or pengInfos[1].Op ~= opType.doushisi.caiShen.id then
        caiShenInfo = {Op = opType.doushisi.caiShen.id, Cards = {}}
        table.insert(pengInfos, 1, caiShenInfo)
    else
        caiShenInfo = pengInfos[1]
    end
    table.insert(caiShenInfo.Cards, card)
end

function doushisiGame:onOpDoChi(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)
end

function doushisiGame:onOpDoChe(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)
end

function doushisiGame:onOpDoHua(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    self:onChiPengGangType(player, op, cards, nil)
end

function doushisiGame:onOpDoAn(player, op, delCards)
    local cards = delCards
    self:onChiPengGangType(player, op, cards, nil)
end

function doushisiGame:onOpDoHu(player, msg)
    player[self.cardType.hu] = msg.Card
end

function doushisiGame:onOpDoChu(player, msg)
    local delCard = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], delCard)
    table.insert(player[self.cardType.chu], delCard)
end

function doushisiGame:onOpDoHandler(msg)
    log("players : " .. table.tostring(self.players))
    log("op do msg: " ..table.tostring(msg))
    local player = self:getPlayerByAcId(msg.AcId)
    player.zhaoCnt = msg.ZhaoCnt
    player.fuShu = msg.FuShu
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    if op == opType.doushisi.hua.id then
        self:onOpDoHua(player, msg)
    elseif op == opType.doushisi.chu.id then
        self:onOpDoChu(player, msg)
    elseif op == opType.doushisi.chi.id then
        self:onOpDoChi(player, msg)
    elseif op == opType.doushisi.che.id then
        self:onOpDoChe(player, msg)
    elseif op == opType.doushisi.hu.id then
        self:onOpDoHu(player, msg)
    elseif op == opType.doushisi.gang.id then
    elseif op == opType.doushisi.pass.id then
    elseif op == opType.doushisi.an.id then
        self:onOpDoAn(player, op, cards)
    elseif op == opType.doushisi.zhao.id then
    elseif op == opType.doushisi.shou.id then
    elseif op == opType.doushisi.bao.id then
    elseif op == opType.doushisi.baGang.id then
        self:onOpDoBaGang(player, msg)
    elseif op == opType.doushisi.chiChengSan.id then
        self:onChiPengGangType(player, op, cards, beCard)
    elseif op == opType.doushisi.caiShen.id then
        self:onOpDoCaiShen(player, msg)
    elseif op == opType.doushisi.baoJiao.id then
    elseif op == opType.doushisi.gen.id then
    elseif op == opType.doushisi.weiGui.id then
    else
        log("on op do handler: receive not supported handler." .. tostring(op))
    end
end

function doushisiGame:onBdListHandler(msg)
end

function doushisiGame:onBdDoHandler(msg)
end

function doushisiGame:onOpClearHandler()
end

function doushisiGame:subLeftCount(cnt)
    self.leftCardsCount = self.leftCardsCount - cnt
end

function doushisiGame:faPai(msg)
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

function doushisiGame:onGameStartHandler(msg)
    self:faPai(msg)
    self.markerTurn = msg.Marker
    self.diceCard   = msg.DiceCardId
    self.diceTurn   = msg.DiceTurn
    self.deskStatus = msg.CurDeskStatus
    self.markerAcId = self:getPlayerByTurn(self.markerTurn).acId
    self.diceAcId   = self:getPlayerByTurn(self.diceTurn).acId

    self.deskOpUI:onGameStart()
end

function doushisiGame:csDang(isDang)

end

return doushisiGame
