local helper        = class("helper")
local mahjongType   = require ("logic.mahjong.mahjongType")
local mahjongGame   = require ("logic.mahjong.mahjongGame")

function helper:ctor(que, game)
    self.acId = gamepref.player.acId
    self.que = que
    self.game = game
    self.cache = {}
end

------------
-- 每种牌的个数的数组（2个1条， 就是{[0] = 2}
-- 返回：空table表示没有叫 如果有叫  { {jiao = id, fan = 5, c = { { Cs = {1,2,3}, Op = 1}, { Cs = {4,5,6}, Op = 1} } }, {jiao = id, fan = 2}  }
------------
function helper:checkJiao(cntVec, totalCntVec)
    for id, v in pairs(cntVec) do
        if v > 0 then
            local desc = mahjongType.getMahjongTypeByTypeId(id)
            if desc.class == self.que then
                return {}
            end
        end
    end

    local duiCnt, singleIdx = self:computeDuiCnt(cntVec)
    --测试每一个牌是否可以胡
    local ret = {}
    for i = 0, 26 do
        local ok, c = self:isHu(cntVec, i, duiCnt, singleIdx)
        if ok then
            local fxs, gen = self:computeFanXing(c)
            local fan = self:getFanShu(fxs, gen)
            table.insert(ret, {
                jiaoTid = i,
                fan     = fan,
                c       = c,
                left    = 4 - totalCntVec[i]
            })
        end
    end
    return ret
end

function helper:isHu(cntVec, tid, duiCnt, singleIdx)
    local desc = mahjongType.getMahjongTypeByTypeId(tid)
    if desc.class == self.que then
        return false, nil
    end
    self:addTypeCnt(cntVec, tid, 1)

    if duiCnt == 6 and singleIdx == tid then
        local ok, ret = self:check7Dui(cntVec)
        if ok then
            return ok, ret
        end
    end

    for idx, cnt in pairs(cntVec) do
        if cnt >= 2 then
            local vec = setmetatable({}, {__index = cntVec})
            self:addTypeCnt(vec, idx, -2)
            local ret = {}
            table.insert(ret, { Cs = {idx * 4, idx * 4}, Op = opType.dui.id } )
            local ok, c = self:checkForAllNine(vec)
            if ok then
                self:addTypeCnt(cntVec, tid, -1)
                return true, self:appVec(ret, c)
            end
        end
    end
    self:addTypeCnt(cntVec, tid, -1)
    return false, nil
end

function helper:appVec(t1, t2)
    for _, v in pairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

function helper:computeDuiCnt(cntVec)
    local total = 0
    local singleIdx = -1
    for idx, cnt in pairs(cntVec) do
        total = total + math.floor( cnt / 2 )
        if cnt == 1 or cnt == 3 then
            singleIdx = idx
        end
    end
    return total, singleIdx
end

function helper:check7Dui(cntVec)
    local total = 0
    for idx, cnt in pairs(cntVec) do
        if cnt ~= 2 and cnt ~= 4 and cnt ~= 0 then
            return false, nil
        end
        total = total + cnt
    end
    if cnt ~= 14 then
        return false, nil
    end
    local ret = {}
    for idx, cnt in pairs(cntVec) do
        for i = 1, 4, 2 do
            table.insert(ret, { Cs = {idx * 4, idx * 4}, Op = opType.dui.id })
        end
    end
    return true, ret
end

function helper:checkForAllNine(cntVec)
    local ret = {}
    local k = 0
    for i = 0, 26, 9 do
        local ok, c = self:checkForNine(cntVec, i, k)
        if not ok then
            return false, nil
        end
        ret = self:appVec(ret, c)
        k = k + 1
    end
    return true, ret
end

function helper:checkForNine(cntVec, sidx, k)
    local cacheId = self:computeCacheId(cntVec, sidx, k)
    local t = self.cache[cacheId]
    if self.cache[cacheId] then
        return t.ok, t.c
    end

    local ret = {}
    local computeId = function(t)
        return t * 4
    end

    for i = 1, 9 do
        local idx = sidx + i - 1
        if cntVec[idx] >= 3 then
            table.insert(ret,  { Cs = {computeId(idx), computeId(idx), computeId(idx)}, Op = opType.peng.id } )
            self:addTypeCnt(cntVec, idx, -3)
        end
        if cntVec[idx] > 0 then
            if i > 7 then
                self.cache[cacheId] = {ok = false, c = nil}
                return false, nil
            end
            local cnt = math.min(cntVec[idx], cntVec[idx + 1])
            cnt = math.min(cnt, cntVec[idx + 2])
            if cnt < cntVec[idx] then
                self.cache[cacheId] = {ok = false, c = nil}
                return false, nil
            end
            self:addTypeCnt(cntVec, idx, -cnt)
            self:addTypeCnt(cntVec, idx + 1, -cnt)
            self:addTypeCnt(cntVec, idx + 2, -cnt)
            while cnt > 0 do
                table.insert(ret,  { Cs = {computeId(idx), computeId(idx + 1), computeId(idx + 2)}, Op = opType.chi.id } )
                cnt = cnt - 1
            end
        end
    end
    self.cache[cacheId] = {ok = true, c = ret}
    return true, ret
end

function helper:computeCacheId(cntVec, sidx, k)
    local ret = 0
    for i = 1, 9 do
        local idx = sidx + i - 1
        local t1 = cntVec[idx]
        ret = ret * 10 + t1
    end
    return string.format( "%d%d", ret, k )
end

function helper:initVec(cnt)
    local ret = {}
    for i = 0, cnt do
        ret[i] = 0
    end
    return ret
end
--return {id = 1, hu = {} }
function helper:checkChuPaiHint()
            local now = tolua.gettime()
    local opui = self.game.operationUI
    local inhandMjs = opui.inhandMahjongs[self.acId]
    local handCntVec = self:initVec(27)
    local totalCntVec = self:initVec(27)
    for _, mj in pairs(inhandMjs) do
        local id = mahjongType.getMahjongTypeId(mj.id)
        self:addTypeCnt(handCntVec, id, 1)
    end
    if opui.mo ~= nil then
        local id = mahjongType.getMahjongTypeId(opui.mo.id)
        self:addTypeCnt(handCntVec, id, 1)
    end
    for id, _ in pairs(self.game.knownMahjong) do
        if id >= 0 then
            self:addTypeCnt(totalCntVec, mahjongType.getMahjongTypeId(id), 1)
        end
    end
    for _, seat in pairs(opui.pengMahjongs) do
        for _, vec in pairs(seat) do
            for _, mj in pairs(vec) do
                local id = mahjongType.getMahjongTypeId(mj.id)
                self:addTypeCnt(totalCntVec, id, 1)
            end
        end
    end
    for _, vec in pairs(opui.chuMahjongs) do
        for _, mj in pairs(vec) do
            local id = mahjongType.getMahjongTypeId(mj.id)
            self:addTypeCnt(totalCntVec, id, 1)
        end
    end

    local cntVec = handCntVec
    local ret = {}
    for id, cnt in pairs(cntVec) do
        if cnt > 0 then
            self:addTypeCnt(cntVec, id, -1)

            local c = self:checkJiao(cntVec, totalCntVec)
            if #c > 0 then
                table.insert(ret, { tid = id, hu = c} )
            end

            self:addTypeCnt(cntVec, id, 1)
        end
    end
            local t2 = tolua.gettime()
            log("check jiao : used time: " .. tostring(ok) .. "   " .. t2 - now)
    return ret
end

function helper:computeFanXing(huC)
    local player = self.game:getPlayerByAcId(self.acId)

    local ret = {}
    local function addFx(fx)
        table.insert(ret, fx)
    end
    if huC == 7 then
        addFx(fanXingType.qiDui)
    end
    if huC == 1 then
        addFx(fanXingType.jinGouDiao)
    end
    local inhandCnt = 0
    local hsCnt = {[0] = 0,[1] =  0, [2] =  0}
    for _, c in pairs(huC) do
        inhandCnt = inhandCnt + #c.Cs
        local desc = mahjongType.getMahjongTypeById(c.Cs[1])
        local class = desc.class
        hsCnt[class] = hsCnt[class] + 1 
    end 
    local t = 0
    for _, c in pairs(hsCnt) do
        if c > 0 then
            t = t + 1
        end
    end
    if t == 1 then
        addFx(fanXingType.qingYiSe)
    end

    local chiCnt = 0
    local duiCnt = 0
    local hasMenQing = true
    local zhongZhang = true
    local yaoJiu = true
    local jiangDui = true

    local vec = {}
    local function checkC(c)
        if c.Op == opType.chi.id then
            chiCnt = chiCnt + 1
            for _, c in pairs(c.Cs) do
                local desc = mahjongType.getMahjongTypeById(c)
                if desc.value == 9 or desc.value == 1 then
                    zhongZhang = false
                elseif desc.value > 3 and desc.value < 7 then
                    yaoJiu = false
                end
                self:addTypeCnt(vec, mahjongType.getMahjongTypeId(c), 1)
            end
        else
            if c.Op == opType.dui.id then
                duiCnt = duiCnt + 1
            end
            local desc = mahjongType.getMahjongTypeById(c.Cs[1])
            if desc.value == 9 or desc.value == 1 then
                zhongZhang = false
            else
                yaoJiu = false
            end
            if desc.value ~= 2 and desc.value ~= 5 and desc.value ~= 8 then
                jiangDui = false
            end
            self:addTypeCnt(vec, mahjongType.getMahjongTypeId(c.Cs[1]), #c.Cs)
        end
    end

    local chiChe = player[mahjongGame.cardType.peng]
    for _, c in pairs(huC) do
        checkC(c)
    end
    for _, c in pairs(chiChe) do
        checkC(c)
        if c.D ~= opType.gang.detail.angang then
            hasMenQing = false
        end
    end

    if hasMenQing then
        addFx(fanXingType.menQing)
    end
    if yaoJiu then
        addFx(fanXingType.yaoJiu)
    end
    if zhongZhang then
        addFx(fanXingType.zhongZhang)
    end
    if duiCnt == 1 and chiCnt == 0 then
        if jiangDui then
            addFx(fanXingType.jiangDui)
        else
            addFx(fanXingType.daDuiZi)
        end
    end
    if #ret == 0 then
        addFx(fanXingType.su)
    end

    local gen = 0
    for _, cnt in pairs(vec) do
        if cnt == 4 then
            gen = gen + 1
        end
    end
    return ret, gen
end

function helper:isSupportFx(fx)
    local config = self.game.config
    if fx == fanXingType.menQing then
        return config.MenQing
    elseif fx == fanXingType.yaoJiu then
        return config.YaoJiu
    elseif fx == fanXingType.zhongZhang then
        return config.ZhongZhang
    elseif fx == fanXingType.jiangDui then
        return config.JiangDui
    end
    return true
end

function helper:getFanShu(fxs, gen)
    local fan = 0
    fan = fan + gen
    for _, fx in pairs(fxs) do
        if self:isSupportFx(fx) then
            fan = fan + self:getFanShuByFx(fx)
        end
    end
    return fan
end

function helper:getFanShuByFx(fx)
    local fan = 0
    if fx == fanXingType.su then
        fan = 0
    elseif fx == fanXingType.qingYiSe then
        fan = 2
    elseif fx == fanXingType.daDuiZi then
        fan = 1
    elseif fx == fanXingType.qiDui then
        fan = 2
    elseif fx == fanXingType.yaoJiu then
        fan = 3
    elseif fx == fanXingType.jiangDui then
        fan = 3
    elseif fx == fanXingType.jinGouDiao then
        fan = 1
    elseif fx == fanXingType.menQing then
        fan = 1
    elseif fx == fanXingType.zhongZhang then
        fan = 1
    end
    return fan
end

function helper:addTypeCnt(vec, tid, cnt)
    if vec[tid] == nil then
        vec[tid] = cnt
    else
        vec[tid] = cnt + vec[tid]
    end
end

return helper
