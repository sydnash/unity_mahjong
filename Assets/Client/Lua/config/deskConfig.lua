--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

----------------------------------------------------------------
--
----------------------------------------------------------------
local mahjongLayoutBase = {
    [1] = {
        title = "人数", 
        items = { 
            [1] = { style = "radiobox", text = "4人", key = "RenShu", value = 1, },
            [2] = { style = "radiobox", text = "3人", key = "RenShu", value = 2, },
            [3] = { style = "radiobox", text = "2人", key = "RenShu", value = 3, },
        },
        group = { value = true, switchOff = false },
    },
    [2] = {
        title = "局数", 
        items = { 
            [1] = { style = "radiobox", text = "8局",  key = "JuShu", value = 1, },
            [2] = { style = "radiobox", text = "12局", key = "JuShu", value = 2, },
            [3] = { style = "radiobox", text = "16局", key = "JuShu", value = 3, },
        }, 
        group = { value = true, switchOff = false },
    },
    [3] = { 
        title = "房数", 
        items = { 
            [1] = { style = "radiobox", text = "3房", key = "FangShu", value = 1, },
            [2] = { style = "radiobox", text = "2房", key = "FangShu", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
    [4] = { 
        title = "封顶", 
        items = { 
            [1] = { style = "radiobox", text = "3番", key = "FengDing", value = 1, },
            [2] = { style = "radiobox", text = "4番", key = "FengDing", value = 2, },
            [3] = { style = "radiobox", text = "5番", key = "FengDing", value = 3, },
        }, 
        group = { value = true, switchOff = false },
    },
    [5] = { 
        title = "玩法", 
        items = { 
            [1] = { style = "radiobox", text = "自摸加底", key = "ZiMoJiaX", value = 1, },
            [2] = { style = "radiobox", text = "自摸加番", key = "ZiMoJiaX", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
    [6] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "radiobox", text = "点杠花炮", key = "DianGangHuaX", value = 1, },
            [2] = { style = "radiobox", text = "点杠花摸", key = "DianGangHuaX", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
    [7] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "换三张", key = "HuanNZhang", value = { selected = 2, unselected = 1 }, },
            [2] = { style = "checkbox", text = "换四张", key = "HuanNZhang", value = { selected = 3, unselected = 1 }, },
        }, 
        group = { value = true, switchOff = true },
    },
    [8] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "幺九", key = "YaoJiu",     value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "中张", key = "ZhongZhang", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [9] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "将对", key = "JiangDui", value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "门清", key = "MenQing",  value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [10] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "天地胡", key = "TianDiHu", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
}

local chengduMahjongLayout      = table.clone(mahjongLayoutBase)
local jintangMahjongLayout      = table.clone(mahjongLayoutBase)
local xichongMahjongLayout      = table.clone(mahjongLayoutBase)
local yingjingMahjongLayout     = table.clone(mahjongLayoutBase)
local nanchongMahjongLayout     = table.clone(mahjongLayoutBase)
local wenjiangMahjongLayout     = table.clone(mahjongLayoutBase)
local zhongjiangMahjongLayout   = table.clone(mahjongLayoutBase)

deskConfigLayout = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongLayout,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongLayout,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongLayout,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongLayout,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongLayout,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongLayout,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongLayout,
    },
}

----------------------------------------------------------------
--
----------------------------------------------------------------
local mahjongConfigBase = {
    ["RenShu"]         = 1,
    ["JuShu"]          = 1,
    ["FangShu"]        = 1,
    ["FengDing"]       = 1,
    ["ZiMoJiaX"]       = 1,
    ["DianGangHuaX"]   = 1,
    ["HuanNZhang"]     = 1,
    ["YaoJiu"]         = 2,
    ["ZhongZhang"]     = 2,
    ["JiangDui"]       = 2,
    ["MenQing"]        = 2,
    ["TianDiHu"]       = 2,
}

local chengduMahjongConfig      = table.clone(mahjongConfigBase)
local jintangMahjongConfig      = table.clone(mahjongConfigBase)
local xichongMahjongConfig      = table.clone(mahjongConfigBase)
local yingjingMahjongConfig     = table.clone(mahjongConfigBase)
local nanchongMahjongConfig     = table.clone(mahjongConfigBase)
local wenjiangMahjongConfig     = table.clone(mahjongConfigBase)
local zhongjiangMahjongConfig   = table.clone(mahjongConfigBase)

deskConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongConfig,
    },
}

----------------------------------------------------------------
--
----------------------------------------------------------------
local mahjongShiftConfigBase = {
    ["RenShu"]         = { [4] = 1, [3]  = 2, [2]  = 3 },
    ["JuShu"]          = { [8] = 1, [12] = 2, [16] = 3 },
    ["FangShu"]        = { [3] = 1, [2]  = 2 },
    ["FengDing"]       = { [3] = 1, [4]  = 2, [5]  = 3 },
    ["ZiMoJiaX"]       = { [0] = 1, [1]  = 2 },
    ["DianGangHuaX"]   = { [0] = 1, [1]  = 2 },
    ["HuanNZhang"]     = { [0] = 1, [3]  = 2, [4]  = 3 },
    ["YaoJiu"]         = { [true] = 1, [false] = 2 },
    ["ZhongZhang"]     = { [true] = 1, [false] = 2 },
    ["JiangDui"]       = { [true] = 1, [false] = 2 },
    ["MenQing"]        = { [true] = 1, [false] = 2 },
    ["TianDiHu"]       = { [true] = 1, [false] = 2 },
}

local chengduMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local jintangMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local xichongMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local yingjingMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local nanchongMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local wenjiangMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local zhongjiangMahjongShiftConfig  = table.clone(mahjongShiftConfigBase)

deskShiftConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongShiftConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongShiftConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongShiftConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongShiftConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongShiftConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongShiftConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongShiftConfig,
    },
}

function getMahjongConfigText(cityType, config, ignoreJushu)
    local text = string.empty

    local function concat(t)
        if not string.isNilOrEmpty(text) then
            text = text .. "，"
        end

        text = text .. t
    end

    local layout = deskConfigLayout[cityType][gameType.mahjong]
    local shift = deskShiftConfig[cityType][gameType.mahjong]

    for _, v in pairs(layout) do
        for _, u in pairs(v.items) do
            if (not ignoreJushu) or u.key ~= "JuShu" then
                local sc = shift[u.key]
                if sc ~= nil then
                    local scv = sc[config[u.key]]
                
                    if u.style == "radiobox" then
                        if scv == u.value then
                            concat(u.text)
                        end
                    else
                        if scv == u.value.selected then
                            concat(u.text)
                        end
                    end
                end
            end
        end
    end

    return text
end

--endregion
