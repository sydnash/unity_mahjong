local mjlib = require ("task.yaotongmahjong.mjlib")

local function isHu(cards, tyCnt, chiChe, config, beCard)
    local maxFan = -1
    local ret = mjlib.findHuComponent(cards, tyCnt)
    if ret == nil then
        printInfo("find hu component failed. can't hu.")
        return maxFan
    end
    printInfo("find hu componnet success. len: %d", #ret)
    for _, hu in pairs(ret) do
        if hu.tyLeft > 0 then
            if hu.is7D then
                for i = 1, math.floor(hu.tyLeft/2) do
                    table.insert(hu.c, {Op = mjlib.opType.dui.id, Cs = {mjlib.TYReplaceId, mjlib.TYReplaceId}})
                end
            else
                for i = 1, math.floor(hu.tyLeft/3) do
                    table.insert(hu.c, {Op = mjlib.opType.dui.id, Cs = {mjlib.TYReplaceId, mjlib.TYReplaceId, mjlib.TYReplaceId}})
                end
            end
        end
        local fxs, gen = computeFanXing(hu, chiChe, beCard)
        local fan = getFanShu(fxs, gen)
        if fan > maxFan then
            maxFan = fan
        end
    end
    return maxFan
end


local function initVec(cnt)
    local ret = {}
    for i = 1,cnt do
        ret[i] = 0
    end
    return ret
end


local function isSupportFx(fx, config)
    if fx == fanXingType.menQing then
        return config.MenQing
    elseif fx == fanXingType.yaoJiu then
        return config.YaoJiu
    elseif fx == fanXingType.zhongZhang then
        return config.ZhongZhang
    elseif fx == fanXingType.jiangDui then
        return config.JiangDui
    elseif fx == fanXingType.jiangQiDui then
        return config.JiangDui
    elseif fx == fanXingType.jiaXinWu then
        return config.JiaXinWu
    end
    return true
end

local function getFanShu(fxs, gen)
    local fan = 0
    fan = fan + gen
    local duiduiHu2 = self.game.config.DuiDuiHu2
    for _, fx in pairs(fxs) do
        if self:isSupportFx(fx) then
            fan = fan + self:getFanShuByFx(fx, duiduiHu2)
        end
    end
    return fan
end

local function getFanShuByFx(fx, duiduiHu2)
    local fan = 0
    if fx == fanXingType.su then
        fan = 0
    elseif fx == fanXingType.qingYiSe then
        fan = 2
    elseif fx == fanXingType.daDuiZi then
        if duiduiHu2 then
            fan = 2
        else
            fan = 1
        end
    elseif fx == fanXingType.qiDui then
        fan = 2
    elseif fx == fanXingType.yaoJiu then
        fan = 3
    elseif fx == fanXingType.jiangDui then
        if duiduiHu2 then
            fan = 5
        else
            fan = 4
        end
    elseif fx == fanXingType.jinGouDiao then
        fan = 1
    elseif fx == fanXingType.menQing then
        fan = 1
    elseif fx == fanXingType.zhongZhang then
        fan = 1
    elseif fx == fanXingType.jiangQiDui then
        fan = 5
    elseif fx == fanXingType.jiaXinWu then
        fan = 1
    end
    return fan
end

function computeFanXing(huC, chiChe, beCard)
    local ret = {}
    local function addFx(fx)
        table.insert(ret, fx)
    end

    local isQiDui = false
    if #huC == 7 then
        isQiDui = true
    end
    if #huC == 1 then
        addFx(fanXingType.jinGouDiao)
    end

    local chiCnt = 0
    local duiCnt = 0
    local hasMenQing = true
    local zhongZhang = true
    local yaoJiu = true
    local jiangDui = true
    local jiaXinWu = false
    local hsCnt = {0, 0, 0}
    local vec = {}

    local huhs, huvalue, _ = mjlib.parseMJId(beCard)
    local pureTYCnt = 0

    local function checkC(c)
        local hs, value = mjlib.parseMJId(c.Cs[1])
        hsCnt[hs] = hsCnt[hs] + #c.Cs

        if c.Op == mjlib.opType.chi.id then
            chiCnt = chiCnt + 1
            local middleV = 0
            for _, c in pairs(c.Cs) do
                local _, value, tid = mjlib.parseMJId(c)
                if value == 9 or value == 1 then
                    zhongZhang = false
                elseif value > 3 and value < 7 then
                    yaoJiu = false
                end
                vec[tid] = vec[tid] + 1
                middleV = middleV + value
            end
            if huhs == hs then
                middleV = math.floor(middleV / 3)
                if middleV == 5 and huvalue == 5 then
                    jiaXinWu = true
                end
            end
        else
            if c.Op == mjlib.opType.dui.id then
                duiCnt = duiCnt + 1
            end
            if c.Cs[1] ~= mjlib.TYReplaceId then
                local _, value, tid = mahjongType.getMahjongTypeById(c.Cs[1])
                if value == 9 or value == 1 then
                    zhongZhang = false
                else
                    yaoJiu = false
                end
                if value ~= 2 and value ~= 5 and value ~= 8 then
                    jiangDui = false
                end
                vec[tid] = vec[tid] + #c.Cs
            else
                pureTYCnt = pureTYCnt + #c.Cs
            end
        end
    end

    for _, c in pairs(huC) do
        checkC(c)
    end
    for _, c in pairs(chiChe) do
        checkC(c)
        if c.D ~= opType.gang.detail.angang then
            hasMenQing = false
        end
    end

    --清一色
    local t = 0
    for _, c in pairs(hsCnt) do
        if c > 0 then
            t = t + 1
        end
    end
    if t == 1 then
        addFx(fanXingType.qingYiSe)
    end
    ------

    if hasMenQing then
        addFx(fanXingType.menQing)
    end
    if yaoJiu then
        addFx(fanXingType.yaoJiu)
    end
    if zhongZhang then
        addFx(fanXingType.zhongZhang)
    end
    if jiaXinWu then
        addFx(fanXingType.jiaXinWu)
    end
    if duiCnt == 1 and chiCnt == 0 then
        if jiangDui then
            addFx(fanXingType.jiangDui)
        else
            addFx(fanXingType.daDuiZi)
        end
    end
    if isQiDui then
        if jiangDui then
            addFx(fanXingType.jiangQiDui)
        else
            addFx(fanXingType.qiDui)
        end
    end
    if #ret == 0 then
        addFx(fanXingType.su)
    end

    local gen = 0
    local maxCnt = 0
    for _, cnt in pairs(vec) do
        if cnt > maxCnt then
            maxCnt = cnt
        end
        if cnt >= 4 then
            gen = gen + (cnt - 3)
        end
    end
    
    if maxCnt+pureTYCnt >= 4 then
        local add = math.min(pureTYCnt, pureTYCnt + maxCnt - 3)
        gen = gen + add
    end

    return ret, gen
end

function Test(xxx)
    local cards = {1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    local tyCnt = 4
    local fan = isHu(cards, tyCnt)
    if fan >= 0 then
    end
    return xxx
end

