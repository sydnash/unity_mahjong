local mjlib = require ("task.yaotongmahjong.mjlib")

local TYRealId = 10
local function isTY(id)
    if id == TYRealId then
        return true
    end
    return false
end
local que = -1
local chiChe = {}
local config = {}

local function initVec(cnt)
    local ret = {}
    for i = 1,cnt do
        ret[i] = 0
    end
    return ret
end

local function getFanShuByFx(fx, duiduiHu2)
    local fan = 0
    if fx == mjlib.fanXingType.su then
        fan = 0
    elseif fx == mjlib.fanXingType.qingYiSe then
        fan = 2
    elseif fx == mjlib.fanXingType.daDuiZi then
        if duiduiHu2 then
            fan = 2
        else
            fan = 1
        end
    elseif fx == mjlib.fanXingType.qiDui then
        fan = 2
    elseif fx == mjlib.fanXingType.yaoJiu then
        fan = 3
    elseif fx == mjlib.fanXingType.jiangDui then
        if duiduiHu2 then
            fan = 5
        else
            fan = 4
        end
    elseif fx == mjlib.fanXingType.jinGouDiao then
        fan = 1
    elseif fx == mjlib.fanXingType.menQing then
        fan = 1
    elseif fx == mjlib.fanXingType.zhongZhang then
        fan = 1
    elseif fx == mjlib.fanXingType.jiangQiDui then
        fan = 5
    elseif fx == mjlib.fanXingType.jiaXinWu then
        fan = 1
    end
    return fan
end

local function computeFanXing(huC, chiChe, beCard)
    local ret = {}
    local function addFx(fx)
        table.insert(ret, fx)
    end

    local isQiDui = false
    if #huC == 7 then
        isQiDui = true
    end
    if #huC == 1 then
        addFx(mjlib.fanXingType.jinGouDiao)
    end

    local chiCnt = 0
    local duiCnt = 0
    local hasMenQing = true
    local zhongZhang = true
    local yaoJiu = true
    local jiangDui = true
    local jiaXinWu = false
    local hsCnt = {0, 0, 0}
    local vec = initVec(30)

    local huhs, huvalue, _ = mjlib.parseMJId(beCard)
    local pureTYCnt = 0

    local function checkC(c)
        if c.Cs[1] ~= mjlib.TYReplaceId then
            local hs, value = mjlib.parseMJId(c.Cs[1])
            hsCnt[hs] = hsCnt[hs] + #c.Cs
        end

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
                local _, value, tid = mjlib.parseMJId(c.Cs[1])
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
        if c.D ~= mjlib.opType.gang.detail.angang then
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
        addFx(mjlib.fanXingType.qingYiSe)
    end
    ------

    if hasMenQing then
        addFx(mjlib.fanXingType.menQing)
    end
    if yaoJiu then
        addFx(mjlib.fanXingType.yaoJiu)
    end
    if zhongZhang then
        addFx(mjlib.fanXingType.zhongZhang)
    end
    if jiaXinWu then
        addFx(mjlib.fanXingType.jiaXinWu)
    end
    if duiCnt == 1 and chiCnt == 0 then
        if jiangDui then
            addFx(mjlib.fanXingType.jiangDui)
        else
            addFx(mjlib.fanXingType.daDuiZi)
        end
    end
    if isQiDui then
        if jiangDui then
            addFx(mjlib.fanXingType.jiangQiDui)
        else
            addFx(mjlib.fanXingType.qiDui)
        end
    end
    if #ret == 0 then
        addFx(mjlib.fanXingType.su)
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

local function isSupportFx(fx, config)
    if fx == mjlib.fanXingType.menQing then
        return config.MenQing
    elseif fx == mjlib.fanXingType.yaoJiu then
        return config.YaoJiu
    elseif fx == mjlib.fanXingType.zhongZhang then
        return config.ZhongZhang
    elseif fx == mjlib.fanXingType.jiangDui then
        return config.JiangDui
    elseif fx == mjlib.fanXingType.jiangQiDui then
        return config.JiangDui
    elseif fx == mjlib.fanXingType.jiaXinWu then
        return config.JiaXinWu
    end
    return true
end

local function getFanShu(fxs, gen, config)
    local fan = 0
    fan = fan + gen
    local duiduiHu2 = config.DuiDuiHu2
    for _, fx in pairs(fxs) do
        if isSupportFx(fx, config) then
            fan = fan + getFanShuByFx(fx, duiduiHu2)
        end
    end
    return fan
end


local function isHu(cards, tyCnt, chiChe, config, beCard)
    local maxFan = -1
    local ret = mjlib.findHuComponent(cards, tyCnt)
    if ret == nil or #ret == 0 then
        -- printInfo("find hu component failed. can't hu.")
        return maxFan
    end
    -- printInfo("find hu componnet success. len: %d", #ret)
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
        local fxs, gen = computeFanXing(hu.c, chiChe, beCard)
        local fan = getFanShu(fxs, gen, config)
        if fan > maxFan then
            maxFan = fan
        end
    end
    return maxFan
end

local function checkHu(cards, tyCnt)
    --有缺 不行
    for id, cnt in pairs(cards) do
        if id ~= TYRealId and cnt > 0 and math.floor((id-1) / 9) == que then
            return {}
        end
    end
    local max = 27
    if config.FangShu == 2 then
        max = 18
    end
    local hus = {}
    local maxFan = 0
    for tid = 1, max do
        if not isTY(tid) then
            if math.floor((tid - 1) / 9) ~= que then
                cards[tid] = cards[tid] + 1

                local fan = isHu(cards, tyCnt, chiChe, config, (tid - 1) * 4)
                if fan >= 0 then
                    table.insert(hus, {Hu = tid - 1, Fan = fan})
                    if fan > maxFan then
                        maxFan = fan
                    end
                end

                cards[tid] = cards[tid] - 1
            end
        end
    end
    if #hus > 0 then
        table.insert(hus, {Hu = TYRealId -1, Fan = maxFan})
    end
    return hus
end
function computeChuHint(xxx)
    -- local cards = {1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    -- local tyCnt = 4
    local ret = {}
    local param = table.fromjson(xxx)
    if not param.config.HuPaiHint then
        return table.tojson(ret)
    end
    que = param.que
    chiChe = param.chiChe or {}
    config = param.config or {}

    local cards = param.cards

    local chus = {}
    local tyCnt = cards[TYRealId]
    cards[TYRealId] = 0

    -- printInfo("compute chu :  input:%s ", table.tojson(cards))
    for tid = 1, 27 do
        local cnt = cards[tid]
        if cnt > 0 and not isTY(tid) then
            cards[tid] = cards[tid] - 1
            local hus = checkHu(cards, tyCnt)
            if #hus > 0 then
                table.insert(chus, {Chu = tid - 1, Hus = hus})
            end
            cards[tid] = cards[tid] + 1
        end
    end
    local ret = table.tojson(chus)
    -- printInfo("my compute: %s", ret)
    -- printInfo("server given: %s", table.tojson(param.chus))
    return ret
end

function computeHuHint(xxx)
    -- local cards = {1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    -- local tyCnt = 4
    local ret = {}
    local param = table.fromjson(xxx)
    if not param.config.HuPaiHint then
        return table.tojson(ret)
    end
    que = param.que
    chiChe = param.chiChe or {}
    config = param.config or {}

    local cards = param.cards

    local chus = {}
    local tyCnt = cards[TYRealId]
    cards[TYRealId] = 0

   
    local hus = checkHu(cards, tyCnt)

    local ret = table.tojson(hus)
    return ret
end
