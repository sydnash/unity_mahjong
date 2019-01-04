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
    [cityType.jintang] = 92,
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
    base.ctor(self, data, playback)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)
end

function doushisiGame:onEnter(msg)
    self:clearPlayerGameStatus()
    base.onEnter(self, msg)
    if msg.Reenter ~= nil then
        self.markerTurn         = msg.Reenter.MarkerTurn
        self.markerAcId         = self:getPlayerByTurn(self.markerTurn).acId
        self.curOpTurn          = msg.Reenter.CurOpTurn
        self.curOpAcId          = self:getPlayerByTurn(self.curOpTurn).acId
        self.curOpType          = msg.Reenter.CurOpType
        self.deskPlayStatus     = msg.Reenter.DeskStatus
        self.canBack            = (self.deskPlayStatus < 0)
        self.dangTurn           = msg.Reenter.DangTurn
        if self.dangTurn >= 0 then
            self.dangAcId = self:getPlayerByTurn(self.dangTurn).acId
        end

        self:syncSeats(msg.Reenter.SyncSeatInfos)
        self:computeXiaoJia()
    end
end

-------------------------------------------------------------------------------
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function doushisiGame:syncSeats(seats)
    self.totalCardsCount = self:getTotalCardCountByGame(self.cityType)
    self.leftCardsCount = self.totalCardsCount

    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.ready = false --如果游戏中，清除ready状态
        player.que = v.QueType
        player.hu = v.HuInfo
        player.isMarker = self:isMarker(player.acId)
        player.isDang = self:isDang(player.acId)

        player[doushisiType.cardType.shou] = v.CardsInHand
        player[doushisiType.cardType.chu]  = v.CardsInChuPai
        player[doushisiType.cardType.peng] = v.ChiCheInfos

        player.fuShu = v.FuShu
        player.piaoStatus = v.PiaoStatus
        player.zhaoCnt = v.ZhaoCnt
        player.zhangShu = #v.CardsInHand

        local cnt = #v.CardsInHand + #v.CardsInChuPai
        for _, v in pairs(v.ChiCheInfos) do
            for _, u in pairs(v.Cards) do
                cnt = cnt + 1
            end
        end
        self:subLeftCount(cnt)
    end
end

function doushisiGame:isDang(acId)
    return acId == self.dangAcId
end

function doushisiGame:computeXiaoJia()
    if self:getTotalPlayerCount() < 4 then
        return
    end
    local markerTurn = self.players[self.markerAcId].turn
    local xiaoJiaTurn = markerTurn - 1
    if xiaoJiaTurn < 0 then
        xiaoJiaTurn = xiaoJiaTurn + 4
    end
    local p = self:getPlayerByTurn(xiaoJiaTurn)
    p.isXiao = true
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:createOperationUI()
    return require("ui.doushisiDesk.doushisiOperation").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:createDeskUI()
    if self.cityType == cityType.jintang then
        return require("ui.doushisiDesk.doushisiDesk_jintang").new(self)
    end
    return require("ui.doushisiDesk.doushisiDesk").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function doushisiGame:initMessageHandlers()
    base.initMessageHandlers(self)

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

    self.deskUI:onFaPai()
    return self.operationUI:onFaPai()
end

function doushisiGame:onMessageHandler(name)
    assert(self[name], string.format("on message handler: function<%s> must exist.", name))

    local func = function(self, msg)
        if name == "onMoPaiHandler" then
            msg.isTou = true
        elseif name == "onOpDoHandler" then
            msg.isOpDo = true
        elseif name == "onOpListHandler" then
            msg.isOpList = true
        elseif name == "onFanPaiHnadler" then
            msg.isFan = true
        end
        self:pushMessage(function(msg)
            return self[name](self, msg)
        end, 0, msg)
    end
    return func
end

function doushisiGame:onDangHandler(msg)
    return self.operationUI:onDangHandler(msg.IsMustDang)
end

function doushisiGame:onDangNotifyHandler(msg)
    self.deskPlayStatus = msg.CurDeskStatus
    local player = self:getPlayerByAcId(msg.AcId)
    player.isDang = msg.IsDang

    self.dangAcId = msg.AcId
    self.dangTurn = self.players[self.dangAcId].turn

    return self.deskUI:onDangNotifyHandler(player.acId, msg.IsDang)
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

    self.operationUI:onAnPaiShow(player.acId, cards)
end

function doushisiGame:onAnPaiHandler(msg)
    self.operationUI:hideAllOpBtn()

    local data = {Cards = {}, HasTY = {}, Op = opType.doushisi.an.id, HasWarning = {}}

    if msg.HasTY == nil then
        msg.HasTY = {}
    end
    for i = 1, #msg.Cards do
        table.insert(data.Cards, msg.Cards[i])
        table.insert(data.HasTY, msg.HasTY[i])
    end
    self.operationUI:onOpListAn(data)
    data.CanPass = msg.CanPass
    if data.CanPass then
        self.operationUI:onOpListPass()
    end
    return 0.1
end

function doushisiGame:onAnPaiNotifyHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    player.fuShu = msg.FuShu
    if isNilOrNull(msg.Dos) or #msg.Dos == 0 then
        return
    end
    for _, info in pairs(msg.Dos) do
        self:onChiPengGangType(player, opType.doushisi.an.id, info.DelCards, nil)
    end
    local t = 0
    for _, info in pairs(msg.Dos) do
        local t1 = self.operationUI:onOpDoAn(player.acId, info.DelCards)
        t1 = t1 or 0
        t = t + t1
    end
    self.deskUI:onOpDoAn(player.acId)
    self.deskUI:setFuShu(player.acId, player.fuShu)
    return t
end

function doushisiGame:onMoPaiHandler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local inhandCards = player[self.cardType.shou]
    for _, card in pairs(msg.Ids) do
        table.insert(inhandCards, card)
    end
    self:subLeftCount(#msg.Ids)
    player.fuShu = msg.FuShu
    player.zhangShu = #inhandCards

    self.deskUI:onMoPai(player.acId)
    self.deskUI:updateInhandCardCount(player.acId)

    return self.operationUI:onMoPai(player.acId, msg.Ids)
end

function doushisiGame:onFanPaiHnadler(msg)
    local player = self:getPlayerByAcId(msg.AcId)
    local chuCards = player[self.cardType.chu]
    table.insert(chuCards, msg.Id)
    self:subLeftCount(1)

    self.deskUI:onFanPai(player.acId)
    return self.operationUI:onFanPai(player.acId, msg.Id)
end

function doushisiGame:onOpListHandler(msg)
    self.operationUI:onOpList(msg)
    self.deskUI:onOpList(msg)
end

function doushisiGame:onChiPengGangType(player, op, cards, beCard)
    local info = {Op = op, Cards = {}}
    if beCard then --从出牌中找并删除
        for _, p in pairs(self.players) do
            table.removeItem(p[self.cardType.chu], beCard)
        end
        table.insert(info.Cards, beCard)
    end
    for _, c in pairs(cards) do --从手牌中删除
        table.removeItem(player[self.cardType.shou], c)
        table.insert(info.Cards, c)
    end
    player.zhangShu = #player[self.cardType.shou]
    self.deskUI:updateInhandCardCount(player.acId)
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
            if card < 0 or info.Cards[1] < 0 or doushisi.typeId(info.Cards[1]) == doushisi.typeId(card) then
                table.insert(info.Cards, card)
                findInfo = info
                break
            end
        end
    end
    player.zhangShu = #player[self.cardType.shou]
    self.deskUI:updateInhandCardCount(player.acId)
    self.deskUI:onOpDoBaGang(player.acId)
    return self.operationUI:onOpDoBaGang(player.acId, card)
end

function doushisiGame:onOpDoCaiShen(player, msg)
    local card = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], card)
    table.removeItem(player[self.cardType.chu], card)
    local pengInfos = player[self.cardType.peng]
    local caiShenInfo = nil
    if #pengInfos == 0 or pengInfos[1].Op ~= opType.doushisi.caiShen.id then
        caiShenInfo = {Op = opType.doushisi.caiShen.id, Cards = {}}
        table.insert(pengInfos, 1, caiShenInfo)
    else
        caiShenInfo = pengInfos[1]
    end
    table.insert(caiShenInfo.Cards, card)

    player.zhangShu = #player[self.cardType.shou]
    self.deskUI:updateInhandCardCount(player.acId)
    return self.operationUI:onOpDoCaiShen(player.acId, card)
end

function doushisiGame:onOpDoChi(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)

    self.deskUI:onOpDoChi(player.acId)
    return self.operationUI:onOpDoChi(player.acId, cards, beCard)
end

function doushisiGame:onOpDoChe(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card
    self:onChiPengGangType(player, op, cards, beCard)

    self.deskUI:onOpDoChe(player.acId)
    return self.operationUI:onOpDoChe(player.acId, cards, beCard)
end

function doushisiGame:onOpDoHua(player, msg)
    local op = msg.Op
    local cards = msg.DelCards
    self:onChiPengGangType(player, op, cards, nil)

    self.deskUI:onOpDoHua(player.acId)
    return self.operationUI:onOpDoHua(player.acId, cards)
end

function doushisiGame:onOpDoAn(player, op, delCards)
    local cards = delCards
    self:onChiPengGangType(player, op, cards, nil)

    self.deskUI:onOpDoAn(player.acId)
    return self.operationUI:onOpDoAn(player.acId, cards)
end

function doushisiGame:onOpDoHu(player, msg)
    player[self.cardType.hu] = msg.Card

    self.deskUI:onOpDoHu(player.acId)
    return self.operationUI:onOpDoHu(player.acId, msg.Card)
end

function doushisiGame:onOpDoChu(player, msg)
    local delCard = msg.DelCards[1]
    table.removeItem(player[self.cardType.shou], delCard)
    table.insert(player[self.cardType.chu], delCard)

    player.zhangShu = #player[self.cardType.shou]
    self.deskUI:updateInhandCardCount(player.acId)
    return self.operationUI:onOpDoChu(msg.AcId, msg.DelCards[1])
end

function doushisiGame:onOpDoHandler(msg)
    self.operationUI:hideAllOpBtn()
    self.operationUI:closeAllBtnPanel()
    self.deskUI:hideClock()
    local player = self:getPlayerByAcId(msg.AcId)
    player.zhaoCnt = msg.ZhaoCnt
    player.fuShu = msg.FuShu
    local op = msg.Op
    local cards = msg.DelCards
    local beCard = msg.Card

    if op ~= opType.doushisi.chu.id and op ~= opType.doushisi.caiShen.id then
        self.operationUI:pushBackPromoteNode()
    end
    local time = 0
    if op == opType.doushisi.hua.id then
        time = self:onOpDoHua(player, msg)
    elseif op == opType.doushisi.chu.id then
        time = self:onOpDoChu(player, msg)
    elseif op == opType.doushisi.chi.id then
        time = self:onOpDoChi(player, msg)
    elseif op == opType.doushisi.che.id then
        time = self:onOpDoChe(player, msg)
    elseif op == opType.doushisi.hu.id then
        time = self:onOpDoHu(player, msg)
    elseif op == opType.doushisi.gang.id then
    elseif op == opType.doushisi.pass.id then
    elseif op == opType.doushisi.an.id then
        time = self:onOpDoAn(player, op, cards)
    elseif op == opType.doushisi.zhao.id then
    elseif op == opType.doushisi.shou.id then
    elseif op == opType.doushisi.bao.id then
    elseif op == opType.doushisi.baGang.id then
        time = self:onOpDoBaGang(player, msg)
    elseif op == opType.doushisi.chiChengSan.id then
        time = self:onOpDoChi(player, msg, true)
    elseif op == opType.doushisi.caiShen.id then
        time = self:onOpDoCaiShen(player, msg)
    elseif op == opType.doushisi.baoJiao.id then
    elseif op == opType.doushisi.gen.id then
    elseif op == opType.doushisi.weiGui.id then
    else
        log("on op do handler: receive not supported handler." .. tostring(op))
    end

    self.deskUI:setFuShu(player.acId, player.fuShu)

    return time
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
    if not isNilOrNull(msg.Seats) then
        for _, v in pairs(msg.Seats) do
            local player = self:getPlayerByAcId(v.AcId)
            player[doushisiGame.cardType.shou] = v.Cards

            for _, _ in pairs(v.Cards) do
                self.leftCardsCount = self.leftCardsCount - 1
            end
            player.zhangShu = #player[self.cardType.shou]
            self.deskUI:updateInhandCardCount(player.acId)
        end
    end
end

function doushisiGame:onGameStartHandler(msg)
    self:onGameStart(msg)
    for _, player in pairs(self.players) do
        player[doushisiGame.cardType.shou] = {}
        player[doushisiGame.cardType.chu] = {}
        player[doushisiGame.cardType.peng] = {}
    end
    self.markerTurn     = msg.Marker
    self.diceCard       = msg.DiceCardId
    self.diceTurn       = msg.DiceTurn
    self.deskPlayStatus = msg.CurDeskStatus
    self.markerAcId     = self:getPlayerByTurn(self.markerTurn).acId
    self.diceAcId       = self:getPlayerByTurn(self.diceTurn).acId
    self:faPai(msg)
    
    self.deskUI:onGameStart()
    return self.operationUI:onGameStart()
end

-------------------------------------------------------------------------------
--update
------------------------------------------------------------------------------
function doushisiGame:secondMsg()
    local size = #self.messageQueue
    if size > 1 then 
        return self.messageQueue[2]
    end
    return nil
end

function doushisiGame:update()
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
            if delay <= 0 then
                --needDelete = true --为了分散操作到每帧，即使不需要延迟，也留到下一帧再处理
            end
        else
            msg.waittime = msg.waittime + dt
            if not msg.isAdjustTime then
                local nm = self:secondMsg()
                if nm and msg.param and nm.param then
                    if msg.param.isFan or (msg.param.isOpDo and msg.param.Op == opType.doushisi.chu.id) then
                        if nm.param.isTou or nm.param.isFan then
                            msg.deleteTime = msg.deleteTime + 0.28
                        elseif nm.param.isOpList then
                            msg.deleteTime = msg.waittime + 0.2
                        elseif nm.param.isOpDo then
                            msg.deleteTime = msg.deleteTime + 0.09
                        end
                    elseif msg.param.isTou then
                        if nm.param.isOpDo then
                            msg.deleteTime = msg.deleteTime + 0.1
                        end
                    end
                    msg.isAdjustTime = true
                end
            end
            if msg.waittime >= msg.deleteTime then
                needDelete = true
            end
        end
        if needDelete then
            self:popFrontMessage()
            loop = false
        end
    end
end

doushisiGame.huType = {
    heju        = 0,
    pinghu      = 1,
    dianpao     = 2,
    zimo        = 3,
    tianhu      = 4,
    dibao       = 5,
    weigui      = 6,
}

function doushisiGame:onGameEndListener(specialData, datas, totalScores)
    datas.huAcId = specialData.HuAcId
    datas.beHuAcId = specialData.BeHuAcId
    datas.huType = specialData.HuType
    for _, v in pairs(specialData.PlayerInfos) do
        local acId = v.AcId
        local p = self.players[acId]
        local d = {
            acId            = v.AcId, 
            headerUrl       = self.players[p.acId].headerUrl,
            nickname        = p.nickname, 
            score           = v.Score,
            fanShu          = v.Fan,
            fuShu           = v.Fu,
            totalScore      = totalScores[v.AcId], 
            turn            = p.turn, 
            seat            = self:getSeatTypeByAcId(p.acId),
            inhand          = v.ShouPai,
            hu              = v.Hu,
            chiChe          = v.ChiChe,
            isCreator       = self:isCreator(v.AcId),
            isWinner        = false,
            seatType        = self:getSeatTypeByAcId(v.AcId),
            isDang          = p.isDang,
            isPiao          = p.isPiao,
            isBao           = p.isBao,
            isMarker        = p.isMarker,
            tyReplace       = v.TYReplace,
        }
        if datas.huAcId == d.acId then
            if datas.huType == self.huType.zimo then
                d.huType = "ziMo"
            elseif datas.huType == self.huType.tianhu then
                d.huType = "tianHu"
            elseif datas.huType == self.huType.dibao then
                d.huType = "diBao"
            elseif datas.huType == self.huType.weigui then
                d.huType = "weiGui"
            else
                d.huType = "hu"
            end
        elseif datas.beHuAcId == d.acId then
            if datas.huType == self.huType.dianpao then
                d.huType = "dianPao"
            end
        end
        table.insert(datas.players, d)
    end
    self:clearPlayerGameStatus()
    table.sort(datas.players, function(t1, t2)
        return t1.seatType < t2.seatType
    end)
end

function doushisiGame:onDeskStatusChanged()
    base.onDeskStatusChanged(self)
    self.deskUI:onDeskStatusChanged()
end

function doushisiGame:clearPlayerGameStatus()
    if not self.players then
        return
    end
    for _, p in pairs(self.players) do
        p.isDang = false
        p.isPiao = false
        p.isBao = false
        p.isZhuang = false
        p.isXiao = false
        p.fushu = 0
        p.zhangShu = 0
    end
end

return doushisiGame
