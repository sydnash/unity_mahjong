--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")
local mahjongType = require ("logic.mahjong.mahjongType")

local base = require("logic.game")
local mahjongGame = class("mahjongGame", base)

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

--------------------------------------------------------------
--
--------------------------------------------------------------
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
    self.totalCardsCount = self:getTotalCountByConfig(data.Config)
    base.ctor(self, data, playback)
end

-------------------------------------------------------------------------------
-- 通过配置获取麻将总数
-------------------------------------------------------------------------------
function mahjongGame:getTotalCountByConfig(config)
    if config.FangShu == 2 then
        return 72
    end

    return 108
end

----------------------------------------------------------------
--
----------------------------------------------------------------
-- local lastTime 
-- local idx = 1
-- local function UUID()
--     local t = os.time()
--     if t == lastTime then
--         idx = idx + 1
--     else
--         lastTime = t
--         idx = 1
--     end
--     return tostring(t) .. tostring(idx)
-- end

-- Id        string
-- Vec       []int
-- ChiChes   []ChiChe
-- Fxs       []base.HuFanXing
-- Que       int
-- DuiDuiHu2 bool
-- seatCards *base.SeatCards


-- function mahjongGame:initVec(cnt)
--     local ret = {}
--     for i = 1, cnt + 1 do
--         ret[i] = 0
--     end
--     return ret
-- end

-- function mahjongGame:statisticCount()
--     local opui = self.operationUI
--     local inhandMjs = opui.inhandMahjongs[self.mainAcId]
--     local handCntVec = self:initVec(27)
--     for _, mj in pairs(inhandMjs) do
--         local id = mahjongType.getMahjongTypeId(mj.id)
--         handCntVec[id + 1] = handCntVec[id + 1] + 1
--     end
--     if opui.mo ~= nil then
--         local id = mahjongType.getMahjongTypeId(opui.mo.id)
--         handCntVec[id + 1] = handCntVec[id + 1] + 1
--     end
--     return handCntVec
-- end

-- function mahjongGame:computeInputParam()
--     local input = {}
--     input.Id = UUID()
--     local handCntVec = self:statisticCount()
--     input.Vec = handCntVec
--     local player = self:getPlayerByAcId(self.mainAcId)
--     input.ChiChes = player[mahjongGame.cardType.peng] 
--     if #input.ChiChes == 0 then
--         input.ChiChes = nil
--     end
--     input.Fxs = self.fxs
--     input.Que = player.que
--     input.DuiDuiHu2 = self.config.DuiDuiHu2

--     return input
-- end
-- local http = require("network.http")
-- function mahjongGame:checkHuHint(errorText)
--     local input = self:computeInputParam()
--     self.curHuPaiParam = input
--     self.curHuPaiHint = nil
--     local web = http.createAsync()
--     web:addTextRequest("http://127.0.0.1:17776/mjhuhint", "POST", 10 * 1000, table.tojson(input), function(text)
--         if self.curHuPaiParam and self.curHuPaiHint.Id == input.Id then
--             self.curHuPaiHint = table.fromjson(text)
--         end
--     end)
--     web:start()

--     talkingData.event(talkingData.eventType.errmsg, { err = errorText })
-- end
-- function mahjongGame:clearHuHint()
--     self.curHuPaiParam = nil
--     self.curHuPaiHint = nil
-- end
-- function mahjongGame:checkChuHint()
--     local input = self:computeInputParam()
--     self.curChuPaiParam = input
--     self.curChuPaiHint = nil
--     local web = http.createAsync()
--     web:addTextRequest("http://127.0.0.1:17776/mjchuhint", "POST", 10 * 1000, table.tojson(input), function(text)
--         if self.curChuPaiParam and self.curChuPaiParam.Id == input.Id then
--             self.curChuPaiHint = table.fromjson(text)
--         end
--     end)
--     web:start()
-- end
-- function mahjongGame:clearChuHint()
--     self.curChuPaiParam = nil
--     self.curChuPaiHint = nil
-- end

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

        player.hus = v.Hus
        if json.isNilOrNull(player.hus) then
            player.hus = {}
        end
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

        if not json.isNilOrNull(player.hu) then
            player.isHu = true
            local shou = player[mahjongGame.cardType.shou]
            local huInfo = player.hu[1]
            local detail = opType.hu.detail
            self.knownMahjong[player.hu[1].HuCard] = 1
            player.huType = huInfo.HuType
--            if huInfo.HuType == detail.zimo or huInfo.HuType == detail.gangshanghua or huInfo.HuType == detail.haidilao then --自摸
            if (#shou - 2) % 3 == 0 then --自摸
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

-- fanXingType = {
--     su                  = 0,
--     qingYiSe            = 1,
--     qiDui               = 2,
--     daDuiZi             = 3,
--     jinGouDiao          = 4,
--     hunYiSe             = 5,
--     jiangDui            = 6,
--     yaoJiu              = 7,
--     menQing             = 8,
--     zhongZhang          = 9,
--     jiangQiDui          = 10,
--     jiaXinWu            = 11,
-- }

function mahjongGame:createChuHintComputeHlper()
    if self.deskPlayStatus == mahjongGame.status.playing then
        self.fxs = {}
        table.insert(self.fxs, fanXingType.su)
        table.insert(self.fxs, fanXingType.qingYiSe)
        table.insert(self.fxs, fanXingType.qiDui)
        table.insert(self.fxs, fanXingType.daDuiZi)
        table.insert(self.fxs, fanXingType.jinGouDiao)
        local config = self.config

		if config.MenQing then
            table.insert(self.fxs, fanXingType.menQing)
        end
		if config.ZhongZhang then
            table.insert(self.fxs, fanXingType.zhongZhang)
        end
		if config.YaoJiu then
            table.insert(self.fxs, fanXingType.yaoJiu)
        end
		if config.JiangDui then
            table.insert(self.fxs, fanXingType.jiangDui)
            table.insert(self.fxs, fanXingType.jiangQiDui)
        end
		if config.JiaXinWu then
            table.insert(self.fxs, fanXingType.jiaXinWu)
        end

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
    self:pushMessage(func)

    if self.mode == gameMode.normal then
        self:addDelay(1.0)
    end
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function mahjongGame:onFaPaiHandler(msg)
--    log("fapai, msg = " .. table.tostring(msg))
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
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 提示换N张
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangHintHandler(msg)
    local func = (function()
--        log("mahjongGame:onHuanNZhangHintHandler, msg = " .. table.tostring(msg))
        self.deskPlayStatus = mahjongGame.status.hsz
        self.operationUI:onHuanNZhangHint(msg)
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:onHuanNZhangChooseHandler(msg)
    local func = (function()
--        log("mahjongGame:onHuanNZhangChooseHandler, msg = " .. table.tostring(msg))
        self.operationUI:onHnzChoose(msg)
    end)
    self:pushMessage(func)
end
  
-------------------------------------------------------------------------------
-- 确定换N张
-------------------------------------------------------------------------------                
function mahjongGame:onHuanNZhangDoHandler(msg)
    if self.mode == gameMode.normal then
        local func = (function()
-- log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            if msg.AcId == self.mainAcId then
                for _, c in pairs(msg.D) do
                    self.knownMahjong[c] = nil
                end
                for _, c in pairs(msg.A) do
                    self.knownMahjong[c] = 1
                end
            end
            self.operationUI:onHuanNZhangDo(msg)
        end)
        self:pushMessage(func)
    else
        local func = (function()
--            log("mahjongGame:onHuanNZhangDoHandler, msg = " .. table.tostring(msg))
            self.operationUI:onHuanNZhangDoPlayback(msg)
        end)
        self:pushMessage(func)
    end
    --延时，等待交互动画完成
    self:addDelay(2.5)
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongGame:onMoPaiHandler(msg)
--    log("mopai, msg = " .. table.tostring(msg))
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
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 操作
-------------------------------------------------------------------------------
function mahjongGame:onOpListHandler(msg)
--    log("oplist, msg = " .. table.tostring(msg))
    local func = (function()
        self.deskPlayStatus = mahjongGame.status.playing
        self.operationUI:onOpList(msg)
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器验证的操作结果
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHandler(msg)
--    log("opdo, msg = " .. table.tostring(msg))
    local func = (function()
        local time
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
                time = self:onOpDoGang(acId, cards, beAcId, beCard, t)
            elseif optype == opType.hu.id then
                local t = v.Do.T
                time = self:onOpDoHu(acId, cards, beAcId, beCard, t, v.FT)
            elseif optype == opType.guo.id then
                self:onOpDoGuo(acId)
            else
                log("unknown optype: " .. tostring(optype))
            end
        end
        return time
    end)
    self:pushMessage(func, nil, msg)
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function mahjongGame:onClearHandler(msg)
    local func = (function()
        self.operationUI:onClear()
    end)
    self:pushMessage(func)
end

function mahjongGame:endChuPai()
    if self.operationUI then
        self.operationUI:endChuPai()
    end
end
function mahjongGame:clearCountdownTick()
    if self.operationUI then
        self.operationUI:clearCountdownTick()
    end
end
-------------------------------------------------------------------------------
-- CS 过
-------------------------------------------------------------------------------
function mahjongGame:guo()
    self:endChuPai()
    self:clearCountdownTick()
    networkManager.guoPai(function(msg)
    end, self.curOpListIdx)
end

-------------------------------------------------------------------------------
-- CS 吃
-------------------------------------------------------------------------------
function mahjongGame:chi(cards)
    self:endChuPai()
    self:clearCountdownTick()
    networkManager.chiPai(cards, function(msg)
    end, self.curOpListIdx)
end

-------------------------------------------------------------------------------
-- CS 碰
-------------------------------------------------------------------------------
function mahjongGame:peng(cards)
    self:endChuPai()
    self:clearCountdownTick()
    networkManager.pengPai(cards, function(msg)
    end, self.curOpListIdx)
end

-------------------------------------------------------------------------------
-- CS 杠
-------------------------------------------------------------------------------
function mahjongGame:gang(cards)
--    log("mahjongGame.gang, cards = " .. table.tostring(cards))
    self:endChuPai()
    self:clearCountdownTick()
    networkManager.gangPai(cards, function(msg)
    end, self.curOpListIdx)
end

-------------------------------------------------------------------------------
-- CS 胡
-------------------------------------------------------------------------------
function mahjongGame:hu(cards)
    self:endChuPai()
    self:clearCountdownTick()
    networkManager.huPai(cards, function(msg)
    end, self.curOpListIdx)
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
            Cs = {beCard, cards[1], cards[2], cards[3]},
            D = detail.minggang,
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
        local pinfo = nil
        for _, info in pairs(infos) do
            local yaotongId = 9 --幺筒
            local iid = mahjongType.getMahjongTypeId(info.Cs[1])
            local cid = mahjongType.getMahjongTypeId(cards[1])
            local bagangid = mahjongType.getMahjongTypeId(beCard)

            if info.Op == opType.peng.id then
                if self:isLaizi(cards[1]) and bagangid == iid then --幺筒
                    pinfo = info
                    break
                end

                if iid == cid then
                    pinfo = info
                    break
                end
            end

            if info.Op == opType.gang.id and self.gameType == gameType.yaotongrenyong and self.config.GangShangGang then
                if cid == yaotongId and bagangid == iid then --幺筒
                    pinfo = info
                    break
                end

                if iid == cid then
                    pinfo = info
                    break
                end
            end
        end

        pinfo.Op = opType.gang.id
        pinfo.D = t
        table.insert(pinfo.Cs, cards[1])
--        log("mahjongGame:onOpDoGang, pinfo = " .. table.tostring(pinfo))
        self.knownMahjong[cards[1]] = 1
    end

    self.deskUI:onPlayerGang(acId, t)
    self.operationUI:onOpDoGang(acId, cards, beAcId, beCard, t)
end

-------------------------------------------------------------------------------
-- SC 胡
-------------------------------------------------------------------------------
function mahjongGame:onOpDoHu(acId, cards, beAcId, beCard, t, ft)
    self.knownMahjong[beCard] = 1
    local player = self:getPlayerByAcId(acId)
    player.isHu = true
    player.huType = t 
    self.deskUI:onPlayerHu(acId, t)
    self.operationUI:onOpDoHu(acId, cards, beAcId, beCard, t, ft)
    local huCnt = 0
    for _, p in pairs(self.players) do
        if p.isHu then
            huCnt = huCnt + 1
        end
    end
    if self:getTotalPlayerCount() - huCnt <= 1 then
        return 0.9
    end
    return 0
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
    local func = (function()
        self.deskPlayStatus = mahjongGame.status.dingque

        self.operationUI:onDingQueHint(msg)
    end)
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
                    huType          = p.huType,
        }

        for k, u in pairs(d.inhand) do 
            if u == d.hu then
                table.remove(d.inhand, k)
            end
        end

        local peng = v.ChiChe
        if not json.isNilOrNull(peng) then
            for _, u in pairs(peng) do
                if d[u.Op] == nil then
                    d[u.Op] = {}
                end

                local op = d[u.Op]
                if u.Op == opType.gang.id then --存放杠牌的类型
                    table.insert(op, { cards = u.Cs, detial = u.D })
                else
                    table.insert(op, { cards = u.Cs })
                end
            end
        end

        --datas.players[p.acId] = d
        table.insert(datas.players, d)
    end
    table.sort(datas.players, function(t1, t2)
        return t1.seatType < t2.seatType
    end)
    
    datas.scoreChanges = specialData.ScoreChanges
    for _, v in pairs(self.players) do
        v.que = -1
        v.isHu = false
        v.hu = nil
        self.deskUI:setScore(v.acId, v.score)
    end

    return datas
end

-------------------------------------------------------------------------------
-- 服务器通知定缺具体信息
-------------------------------------------------------------------------------
function mahjongGame:onDingQueDoHandler(msg)
--    log("ding que do, msg = " .. table.tostring(msg))
    local func = (function()
        for _, v in pairs(msg.Dos) do
            local player = self:getPlayerByAcId(v.AcId)
            player.que = v.Q
        end

        self.deskUI:onDingQueDo(msg)
        self.operationUI:onDingQueDo(msg)
    end)
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知有玩家发起快速开始投票
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartNotify(msg)
--    log("mahjongGame:onQuicklyStartNotify " .. table.tostring(msg))
    local func = (function()
        if not self.quicklyStartUI then
            self.quicklyStartVoteSeconds = msg.LeftTime
            self.quicklyStartVoteProposer = msg.Proposer

            for _, p in pairs(self.players) do
                p.quicklyStartVoteState = quicklyStartStatus.waiting
                if p.acId == msg.Proposer then
                    p.quicklyStartVoteState = quicklyStartStatus.proposer
                end
            end

            self.quicklyStartUI = require("ui.quicklyStart").new(self)
            self.quicklyStartUI:show()
        end
    end)
    
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知快速开始投票结果
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartEndNotify(msg)
--    log("mahjongGame:onQuicklyStartEndNotify" .. table.tostring(msg))
    local func = (function()
        if self.quicklyStartUI then
            if msg.Result == 0 then --快速开始成功
                self.quicklyStartPlayerCount = msg.PlayerCnt
                self.quicklyStartSuccess = true
                self:computeRealTurn()
            elseif msg.Result == 1 then --有人拒绝
                local player = self.players[msg.Rejecter]
                showMessageUI(string.format("玩家 %s 拒绝了快速开局申请", cutoutString(player.nickname,gameConfig.nicknameMaxLength)))
            elseif msg.Result == 2 then --有人进入或者离开
                showMessageUI(string.format("当前桌子人员发生变化，快速开局申请失败"))
            elseif msg.Result == 3 then --有人进入或者离开
                showMessageUI(string.format("当前桌子人员发生变化，快速开局申请失败"))
            elseif msg.Result == 4 then --超时
                showMessageUI(string.format("快速开局申请超时，请重新发起申请"))
            end

            self.quicklyStartUI:close()
            self.quicklyStartUI = nil
        end
    end)
    
    self:pushMessage(func)
end

-------------------------------------------------------------------------------
-- 服务器通知有玩家选择快速开始投票
-------------------------------------------------------------------------------
function mahjongGame:onQuicklyStartChose(msg)
--    log("mahjongGame:onQuicklyStartChose" .. table.tostring(msg))
    local func = (function()
        if self.quicklyStartUI ~= nil then
            local player = self:getPlayerByAcId(msg.AcId)
            if msg.Agree then
                player.quicklyStartVoteState = exitDeskStatus.agree
            else
                player.quicklyStartVoteState = exitDeskStatus.reject
            end
            self.quicklyStartUI:setPlayerState(player)
        end
    end)
    self:pushMessage(func)
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

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
function mahjongGame:hasHuPaiHint()
    return self.config.HuPaiHint and not self:isPlayback()
end

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
function mahjongGame:isLaizi(mid)
    if self.gameType == gameType.yaotongrenyong then
        local tid = mahjongType.getMahjongTypeId(mid)
        return tid == 9 --幺筒作癞子
    end

    return false
end

return mahjongGame

--endregion
