--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer        = require("logic.player.gamePlayer")

local base = require("logic.game")
local mahjongGame = class("mahjongGame", base)
local mahjongType   = require ("logic.mahjong.mahjongType")

--------------------------------------------------------------
--
--------------------------------------------------------------
mahjongGame.status = {
    fapai   =  1, --发牌
    hsz     =  2, --换N张
    dingque =  3, --定缺
    playing =  4, --进行中
    gameend =  5, --结束
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
    base.ctor(self, data, playback)
    self.totalCardsCount = 108
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:initMessageHandlers()
    base.initMessageHandlers(self)

    self.commandHandlers[protoType.sc.start]                    = { func = self.onGameStartHandler,             nr = true }
    self.commandHandlers[protoType.sc.fapai]                    = { func = self.onFaPaiHandler,                 nr = true }
    self.commandHandlers[protoType.sc.huanNZhangHint]           = { func = self.onHuanNZhangHintHandler,        nr = true }
    self.commandHandlers[protoType.sc.huanNZhangChoose]         = { func = self.onHuanNZhangChooseHandler,      nr = true }
    self.commandHandlers[protoType.sc.huanNZhangDo]             = { func = self.onHuanNZhangDoHandler,          nr = true }
    self.commandHandlers[protoType.sc.dqHint]                   = { func = self.onDingQueHintHandler,           nr = true }
    self.commandHandlers[protoType.sc.dqDo]                     = { func = self.onDingQueDoHandler,             nr = true }
    self.commandHandlers[protoType.sc.mopai]                    = { func = self.onMoPaiHandler,                 nr = true }
    self.commandHandlers[protoType.sc.oplist]                   = { func = self.onOpListHandler,                nr = true }
    self.commandHandlers[protoType.sc.opDo]                     = { func = self.onOpDoHandler,                  nr = true }
    self.commandHandlers[protoType.sc.clear]                    = { func = self.onClearHandler,                 nr = true }
    self.commandHandlers[protoType.sc.quicklyStartChose]        = { func = self.onQuicklyStartChose,            nr = true }
    self.commandHandlers[protoType.sc.quicklyStartNotify]       = { func = self.onQuicklyStartNotify,           nr = true }
    self.commandHandlers[protoType.sc.quicklyStartEndNotify]    = { func = self.onQuicklyStartEndNotify,        nr = true }
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:createOperationUI()
    return require("ui.mahjongDesk.mahjongOperation").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:createDeskUI()
    return require("ui.mahjongDesk.mahjongDesk").new(self)
end

-------------------------------------------------------------------------------
-- 进入房间
-------------------------------------------------------------------------------
function mahjongGame:onEnter(msg)
    base.onEnter(self, msg)
    
    if msg.Reenter ~= nil then
        self.markerAcId         = msg.Reenter.MarkerAcId
        self.curOpAcId          = msg.Reenter.CurOpAcId
        self.curOpType          = msg.Reenter.CurOpType
        self.dices              = { msg.Reenter.Dice1, msg.Reenter.Dice2 }
        self.totalCardsCount    = msg.Reenter.TotalMJCnt
        self.leftCardsCount     = msg.Reenter.LeftMJCnt
        self.deskPlayStatus     = msg.Reenter.DeskStatus
        self.canBack            = (self.deskPlayStatus < 0)
        self:syncSeats(msg.Reenter.SyncSeatInfos)
    end
end

-------------------------------------------------------------------------------
-- 同步各个位置的数据
-------------------------------------------------------------------------------
function mahjongGame:syncSeats(seats)
    self.knownMahjong = {}
    for _, v in pairs(seats) do
        local player = self:getPlayerByAcId(v.AcId)
        player.ready = false --如果游戏中，清除ready状态
        player.que = v.QueType
        player.hu = v.HuInfo
        player.isMarker = self:isMarker(player.acId)

        player[mahjongGame.cardType.shou] = v.CardsInHand
        player[mahjongGame.cardType.chu]  = v.CardsInChuPai
        player[mahjongGame.cardType.peng] = v.ChiCheInfos
        player[mahjongGame.cardType.huan] = {}
        for _, c in pairs(v.CardsInChuPai) do
            self.knownMahjong[c] = 1
        end
        for _, c in pairs(v.CardsInHand) do
            self.knownMahjong[c] = 1
        end
        for _, info in pairs(v.ChiCheInfos) do
            for _, c in pairs(info.Cs) do
                self.knownMahjong[c] = 1
            end
        end

        if not isNilOrNull(player.hu) then
            player.isHu = true
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

        self:createChuHintComputeHlper()
    end
end

function mahjongGame:onDeskStatusChanged()
    self:createChuHintComputeHlper()
    self.operationUI:onDeskPlayStatusChanged()
end

function mahjongGame:createChuHintComputeHlper()
    if self.deskPlayStatus == mahjongGame.status.playing then
        local player = self:getPlayerByAcId(self.mainAcId)
        self.chuHintComputeHelper = require("logic.mahjong.helper").new(player.que, self)
    end
end

-------------------------------------------------------------------------------
-- 开始游戏
-------------------------------------------------------------------------------
function mahjongGame:onGameStartHandler(msg)
--    log("start game, msg = " .. table.tostring(msg))
    self.canBack = false
    self.knownMahjong = {}
    self.chuHintComputeHelper = nil

    -- local func = tweenFunction.new(function()
    local func = (function()
        self:onGameStart(msg)
        self.totalCardsCount = msg.TotalMJCnt
        self.leftCardsCount = self.totalCardsCount
        self.dices = { msg.Dice1, msg.Dice2 }
        self.markerAcId = msg.MarkerAcId

        for _, v in pairs(self.players) do
            v[mahjongGame.cardType.shou] = {}
            v[mahjongGame.cardType.chu] = {}
            v[mahjongGame.cardType.peng] = {}
            v.que = -1
            v.isMarker = self:isMarker(v.acId)
        end

        self.deskUI:onGameStart()
        self.operationUI:onGameStart()
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)

    if self.mode == gameMode.normal then
        -- self.messageHandlers:add(tweenDelay.new(2.5))
        self:addDelay(2.5)
    end
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function mahjongGame:onFaPaiHandler(msg)
--    log("fapai, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
        self.deskPlayStatus = mahjongGame.status.fapai

        for _, v in pairs(msg.Seats) do
            local player = self:getPlayerByAcId(v.AcId)
            player[mahjongGame.cardType.shou] = v.Cards

            for _, c in pairs(v.Cards) do
                self.knownMahjong[c] = 1
                self.leftCardsCount = self.leftCardsCount - 1
            end
        end

        self.deskUI:updateLeftMahjongCount(self.leftCardsCount)
        self.operationUI:OnFaPai()
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 提示换N张
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangHintHandler(msg)
    -- local func = tweenFunction.new(function()
    local func = (function()
        log("mahjongGame:onHuanNZhangHintHandler, msg = " .. table.tostring(msg))
        self.deskPlayStatus = mahjongGame.status.hsz
        self.operationUI:onHuanNZhangHint(msg)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangChooseHandler(msg)
    -- local func = tweenFunction.new(function()
    local func = (function()
        log("mahjongGame:onHuanNZhangChooseHandler, msg = " .. table.tostring(msg))
        self.operationUI:onHnzChoose(msg)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end
  
-------------------------------------------------------------------------------
-- 确定换N张
-------------------------------------------------------------------------------                
function mahjongGame:onHuanNZhangDoHandler(msg)
    if self.mode == gameMode.normal then
        -- local func = tweenFunction.new(function()
        local func = (function()
--            log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            self.operationUI:onHuanNZhangDo(msg)
        end)
        -- self.messageHandlers:add(func)
        self:pushMessage(func)
    else
        -- local func = tweenFunction.new(function()
        local func = (function()
--            log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            self.operationUI:onHuanNZhangDoPlayback(msg)
        end)
        -- self.messageHandlers:add(func)
        self:pushMessage(func)
    end
    --延时，等待交互动画完成
    -- self.messageHandlers:add(tweenDelay.new(2.5))
    self:addDelay(2.5)
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongGame:onMoPaiHandler(msg)
--    log("mopai, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
        local player = self:getPlayerByAcId(msg.AcId)
        local inhandMahjongs = player[mahjongGame.cardType.shou]

        for _, v in pairs(msg.Ids) do
            self.knownMahjong[v] = 1
            table.insert(inhandMahjongs, v)
            self.leftCardsCount = self.leftCardsCount - 1
        end

        self.deskUI:updateLeftMahjongCount(self.leftCardsCount)
        self.operationUI:onMoPai(msg.AcId, msg.Ids)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 操作
-------------------------------------------------------------------------------
function mahjongGame:onOpListHandler(msg)
--    log("oplist, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
        self.deskPlayStatus = mahjongGame.status.playing
        self.operationUI:onOpList(msg)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器验证的操作结果
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHandler(msg)
--    log("opdo, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
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
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function mahjongGame:onClearHandler(msg)
    -- local func = tweenFunction.new(function()
    local func = (function()
        self.operationUI:onClear()
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- CS 过
-------------------------------------------------------------------------------
function mahjongGame:guo()
    networkManager.guoPai(function(msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 吃
-------------------------------------------------------------------------------
function mahjongGame:chi(cards)
    networkManager.chiPai(cards, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 碰
-------------------------------------------------------------------------------
function mahjongGame:peng(cards)
    networkManager.pengPai(cards, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 杠
-------------------------------------------------------------------------------
function mahjongGame:gang(cards)
--    log("mahjongGame.gang, cards = " .. table.tostring(cards))
    networkManager.gangPai(cards, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- CS 胡
-------------------------------------------------------------------------------
function mahjongGame:hu(cards)
    networkManager.huPai(cards, function(msg)
    end)
end

-------------------------------------------------------------------------------
-- SC 出牌
-------------------------------------------------------------------------------
function mahjongGame:onOpDoChu(acId, cards)
    local player = self:getPlayerByAcId(acId)
    local infos = player[mahjongGame.cardType.chu]
    table.insert(infos, cards[1])
    self.knownMahjong[cards[1]] = 1
    self.deskUI:onOpDoChu(acId, cards)
    self.operationUI:onOpDoChu(acId, cards)
end

-------------------------------------------------------------------------------
-- SC 碰
-------------------------------------------------------------------------------
function mahjongGame:onOpDoPeng(acId, cards, beAcId, beCard)
--    log("mahjongGame:onOpDoPeng, acId = " .. tostring(acId))
    local player = self:getPlayerByAcId(acId)
    local infos = player[mahjongGame.cardType.peng]
    table.insert(infos, {
        Op = opType.peng.id,
        Cs = {beCard, cards[1], cards[2]}
    })
    self.knownMahjong[beCard] = 1
    self.knownMahjong[cards[1]] = 1
    self.knownMahjong[cards[2]] = 1
    self.deskUI:onPlayerPeng(acId)
    self.operationUI:onOpDoPeng(acId, cards, beAcId, beCard)
end

-------------------------------------------------------------------------------
-- SC 杠
-------------------------------------------------------------------------------
function mahjongGame:onOpDoGang(acId, cards, beAcId, beCard, t)
    local player = self:getPlayerByAcId(acId)
    local infos = player[mahjongGame.cardType.peng]
    local detail = opType.gang.detail
    if t == detail.minggang then
        table.insert(infos, {
            Op = opType.gang.id,
            Cs = {beCard, cards[1], cards[2], cards[3]}
        })
        self.knownMahjong[beCard] = 1
        self.knownMahjong[cards[1]] = 1
        self.knownMahjong[cards[2]] = 1
        self.knownMahjong[cards[3]] = 1
    elseif t == detail.angang then
        table.insert(infos, {
            Op = opType.gang.id,
            Cs = {cards[1], cards[2], cards[3], cards[4]},
            D = detail.angang,
        })
        self.knownMahjong[cards[1]] = 1
        self.knownMahjong[cards[2]] = 1
        self.knownMahjong[cards[3]] = 1
        self.knownMahjong[cards[4]] = 1
    elseif t == detail.bagangwithmoney or t == detail.bagangwithoutmoney then
        local pinfo
        for _, info in pairs(infos) do
            if info.Op == opType.peng.id and mahjongType.getMahjongTypeId(info.Cs[1]) == mahjongType.getMahjongTypeId(cards[1]) then
                pinfo = info
                break
            end
        end
        pinfo.Op = opType.gang.id
        table.insert(pinfo.Cs, cards[1])
        self.knownMahjong[cards[1]] = 1
    end
    self.deskUI:onPlayerGang(acId)
    self.operationUI:onOpDoGang(acId, cards, beAcId, beCard, t)
end

-------------------------------------------------------------------------------
-- SC 胡
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHu(acId, cards, beAcId, beCard, t)
    self.knownMahjong[beCard] = 1
    local player = self:getPlayerByAcId(acId)
    player.isHu = true
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
-- 服务器通知定缺信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueHintHandler(msg)
--    log("ding que hint, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
        self.deskPlayStatus = mahjongGame.status.dingque

        self.operationUI:onDingQueHint(msg)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
end

function mahjongGame:onGameEndListener(specialData, datas, totalScores)
    for _, v in pairs(specialData.PlayerInfos) do
        local p = self:getPlayerByAcId(v.AcId)
        local d = { acId            = v.AcId, 
                    headerUrl       = self.players[p.acId].headerUrl,
                    nickname        = p.nickname, 
                    score           = v.Score,
                    totalScore      = totalScores[v.AcId], 
                    turn            = p.turn, 
                    seat            = self:getSeatTypeByAcId(p.acId),
                    inhand          = v.ShouPai,
                    hu              = v.Hu,
                    isCreator       = self:isCreator(v.AcId),
                    isWinner        = false,
                    isMarker        = self:isMarker(v.AcId),
                    que             = p.que,
                    seatType        = self:getSeatTypeByAcId(v.AcId),
        }

        for k, u in pairs(d.inhand) do 
            if u == d.hu then
                table.remove(d.inhand, k)
            end
        end

        local peng = v.ChiChe
        if not isNilOrNull(peng) then
            for _, u in pairs(peng) do
                if d[u.Op] == nil then
                    d[u.Op] = {}
                end

                table.insert(d[u.Op], u.Cs)
            end
        end

        --datas.players[p.acId] = d
        table.insert(datas.players, d)
    end
    table.sort(datas.players, function(t1, t2)
        return t1.seatType < t2.seatType
    end)
    self.deskUI:hideHuHintButton()
    datas.scoreChanges = specialData.ScoreChanges
    for _, v in pairs(self.players) do
        v.que = -1
        v.isHu = false
        self.deskUI:setScore(v.acId, v.score)
    end
    return datas
end

-------------------------------------------------------------------------------
-- 服务器通知定缺具体信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueDoHandler(msg)
--    log("ding que do, msg = " .. table.tostring(msg))
    -- local func = tweenFunction.new(function()
    local func = (function()
        for _, v in pairs(msg.Dos) do
            local player = self:getPlayerByAcId(v.AcId)
            player.que = v.Q
        end

        self.deskUI:onDingQueDo(msg)
        self.operationUI:onDingQueDo(msg)
    end)
    -- self.messageHandlers:add(func)
    self:pushMessage(func)
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
function mahjongGame:proposerQuicklyStart(callback)
    networkManager.proposerQuicklyStart(callback)
end

-------------------------------------------------------------------------------
--快开始投票
-------------------------------------------------------------------------------
function mahjongGame:quicklyStartChose(agree, callback)
    networkManager.quicklyStartChose(agree, callback)
end

function mahjongGame:hasHuPaiHint()
    return self.config.HuPaiHint and not self:isPlayback()
end

return mahjongGame

--endregion
