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
            [1] = { style = "radiobox", text = "1番起胡",key = "CanPingHu",  value = 1, },
            [2] = { style = "radiobox", text = "2番起胡",key = "CanPingHu",  value = 2, },
        },
        group = { value = true, switchOff = false },
    },
    [8] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "换三张", key = "HuanNZhang", value = { selected = 2, unselected = 1 }, },
            [2] = { style = "checkbox", text = "换四张", key = "HuanNZhang", value = { selected = 3, unselected = 1 }, },
        }, 
        group = { value = true, switchOff = true },
    },
    [9] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "幺九", key = "YaoJiu",     value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "中张", key = "ZhongZhang", value = { selected = 1, unselected = 2 }, },
            [3] = { style = "checkbox", text = "将对", key = "JiangDui",   value = { selected = 1, unselected = 2 }, },
            [4] = { style = "checkbox", text = "门清", key = "MenQing",    value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [10] = {
        title = string.empty,
        items = {
            [1] = { style = "checkbox", text = "对对胡2番", key = "DuiDuiHu2",  value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "夹心五",    key = "JiaXinWu", value = { selected = 1, unselected = 2 }, },
            [3] = { style = "checkbox", text = "天地胡", key = "TianDiHu", value = { selected = 1, unselected = 2 }, },
        },
        group = { value = false, switchOff = false },
    },
    [11] = { 
        title = string.empty, 
        items = {
            [1] = {style = "checkbox", text = "大小雨", key = "DaXiaoYu", value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "比叫", key = "BiJiao", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [12] = {
        title = "胡牌",
        items = {
            [1] = { style = "radiobox", text = "开启提示", key = "HuPaiHint", value = 1 },
            [2] = { style = "radiobox", text = "关闭提示", key = "HuPaiHint", value = 2 },
        },
        group = {value = true, switchOff = false},
    }
}

local chengduMahjongLayout      = table.clone(mahjongLayoutBase)
local jintangMahjongLayout      = table.clone(mahjongLayoutBase)
local xichongMahjongLayout      = table.clone(mahjongLayoutBase)
local yingjingMahjongLayout     = table.clone(mahjongLayoutBase)
local nanchongMahjongLayout     = table.clone(mahjongLayoutBase)
local wenjiangMahjongLayout     = table.clone(mahjongLayoutBase)
local zhongjiangMahjongLayout   = table.clone(mahjongLayoutBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local doushisiLayoutBase = {
    [1] = {
        title = "人数", 
        items = { 
            [1] = { style = "radiobox", text = "3人", key = "RenShu", value = 1, },
            [2] = { style = "radiobox", text = "4人", key = "RenShu", value = 2, },
        },
        group = { value = true, switchOff = false },
    },
    [2] = {
        title = "局数", 
        items = { 
            [1] = { style = "radiobox", text = "4局",  key = "JuShu", value = 1, },
            [2] = { style = "radiobox", text = "8局",  key = "JuShu", value = 2, },
            [3] = { style = "radiobox", text = "12局", key = "JuShu", value = 3, },
        }, 
        group = { value = true, switchOff = false },
    },
    [3] = { 
        title = "玩法", 
        items = { 
            [1] = { style = "radiobox", text = "硬打", key = "YingDa", value = 1, },
            [2] = { style = "radiobox", text = "软打", key = "YingDa", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
    [4] = { 
        title = "财神", 
        items = { 
            [1] = { style = "radiobox", text = "8张", key = "CaiShen", value = 1, },
            [2] = { style = "radiobox", text = "12张(25做财神)", key = "CaiShen", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
    [5] = { 
        title = "封顶", 
        items = { 
            [1] = { style = "radiobox", text = "3番(80)", key = "FengDing", value = 1, },
            [2] = { style = "radiobox", text = "4番(120)", key = "FengDing", value = 2, },
            [3] = { style = "radiobox", text = "3番", key = "FengDing", value = 3, },
            [4] = { style = "radiobox", text = "4番", key = "FengDing", value = 4, },
        }, 
        group = { value = true, switchOff = false },
    },
}

local chengduDoushisiLayout      = table.clone(doushisiLayoutBase)
local jintangDoushisiLayout      = table.clone(doushisiLayoutBase)
local xichongDoushisiLayout      = table.clone(doushisiLayoutBase)
local yingjingDoushisiLayout     = table.clone(doushisiLayoutBase)
local nanchongDoushisiLayout     = table.clone(doushisiLayoutBase)
local wenjiangDoushisiLayout     = table.clone(doushisiLayoutBase)
local zhongjiangDoushisiLayout   = table.clone(doushisiLayoutBase)

deskConfigLayout = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongLayout,
        [gameType.doushisi] = chengduDoushisiLayout,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongLayout,
        [gameType.doushisi] = jintangDoushisiLayout,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongLayout,
        [gameType.doushisi] = xichongDoushisiLayout,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongLayout,
        [gameType.doushisi] = yingjingDoushisiLayout,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongLayout,
        [gameType.doushisi] = nanchongDoushisiLayout,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongLayout,
        [gameType.doushisi] = wenjiangDoushisiLayout,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongLayout,
        [gameType.doushisi] = zhongjiangDoushisiLayout,
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
    ["BiJiao"]         = 2,
    ["JiangDui"]       = 2,
    ["MenQing"]        = 2,
    ["TianDiHu"]       = 2,
    ["HuPaiHint"]      = 1,
    ["CanPingHu"]      = 1,
    ["JiaXinWu"]       = 2,
    ["DuiDuiHu2"]      = 2,
    ["DaXiaoYu"]       = 2,
}

local chengduMahjongConfig      = table.clone(mahjongConfigBase)
local jintangMahjongConfig      = table.clone(mahjongConfigBase)
local xichongMahjongConfig      = table.clone(mahjongConfigBase)
local yingjingMahjongConfig     = table.clone(mahjongConfigBase)
local nanchongMahjongConfig     = table.clone(mahjongConfigBase)
local wenjiangMahjongConfig     = table.clone(mahjongConfigBase)
local zhongjiangMahjongConfig   = table.clone(mahjongConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local doushisiConfigBase = {
    ["RenShu"]      = 1,
    ["JuShu"]       = 1,
    ["FengDing"]    = 1,
}

local chengduDoushisiConfig      = table.clone(doushisiConfigBase)
local jintangDoushisiConfig      = table.clone(doushisiConfigBase)
jintangDoushisiConfig["YingDa"]  = 1
jintangDoushisiConfig["CaiShen"] = 1
jintangDoushisiConfig["DianShu"] = 1
local xichongDoushisiConfig      = table.clone(doushisiConfigBase)
local yingjingDoushisiConfig     = table.clone(doushisiConfigBase)
local nanchongDoushisiConfig     = table.clone(doushisiConfigBase)
local wenjiangDoushisiConfig     = table.clone(doushisiConfigBase)
local zhongjiangDoushisiConfig   = table.clone(doushisiConfigBase)

deskConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongConfig,
        [gameType.doushisi] = chengduDoushisiConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongConfig,
        [gameType.doushisi] = jintangDoushisiConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongConfig,
        [gameType.doushisi] = xichongDoushisiConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongConfig,
        [gameType.doushisi] = yingjingDoushisiConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongConfig,
        [gameType.doushisi] = nanchongDoushisiConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongConfig,
        [gameType.doushisi] = wenjiangDoushisiConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongConfig,
        [gameType.doushisi] = zhongjiangDoushisiConfig,
    },
}

----------------------------------------------------------------
--
----------------------------------------------------------------
local mahjongShiftConfigBase = {
    ["RenShu"]          = { [4] = 1, [3]  = 2, [2]  = 3 },
    ["JuShu"]           = { [8] = 1, [12] = 2, [16] = 3 },
    ["FangShu"]         = { [3] = 1, [2]  = 2 },
    ["FengDing"]        = { [3] = 1, [4]  = 2, [5]  = 3 },
    ["ZiMoJiaX"]        = { [0] = 1, [1]  = 2 },
    ["DianGangHuaX"]    = { [0] = 1, [1]  = 2 },
    ["HuanNZhang"]      = { [0] = 1, [3]  = 2, [4]  = 3 },
    ["YaoJiu"]          = { [true] = 1, [false] = 2 },
    ["ZhongZhang"]      = { [true] = 1, [false] = 2 },
    ["BiJiao"]          = { [true] = 1, [false] = 2 },
    ["JiangDui"]        = { [true] = 1, [false] = 2 },
    ["MenQing"]         = { [true] = 1, [false] = 2 },
    ["TianDiHu"]        = { [true] = 1, [false] = 2 },
    ["HuPaiHint"]       = { [true] = 1, [false] = 2 },
    ["CanPingHu"]       = { [true] = 1, [false] = 2 },
    ["DuiDuiHu2"]       = { [true] = 1, [false] = 2 },
    ["JiaXinWu"]        = { [true] = 1, [false] = 2 },
    ["DaXiaoYu"]        = { [true] = 1, [false] = 2 },
}

local chengduMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local jintangMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local xichongMahjongShiftConfig     = table.clone(mahjongShiftConfigBase)
local yingjingMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local nanchongMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local wenjiangMahjongShiftConfig    = table.clone(mahjongShiftConfigBase)
local zhongjiangMahjongShiftConfig  = table.clone(mahjongShiftConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local doushisiShiftConfigBase = {
    ["RenShu"]   = { [3] = 1, [4]  = 2 },
    ["JuShu"]    = { [4] = 1, [8] = 2, [12] = 3 },
    ["FengDing"] = { [1] = 1, [2] = 2, [3]  = 3, [4]  = 4 },
}

local chengduDoushisiShiftConfig     = table.clone(doushisiShiftConfigBase)
local jintangDoushisiShiftConfig     = table.clone(doushisiShiftConfigBase)
jintangDoushisiShiftConfig["YingDa"]   = { [true] = 1, [false]  = 2 }
jintangDoushisiShiftConfig["CaiShen"]  = { [8] = 1, [12] = 2 }
jintangDoushisiShiftConfig["DianShu"]  = { [80] = 1, [100] = 2, [120] = 3, [150] = 4 }
local xichongDoushisiShiftConfig     = table.clone(doushisiShiftConfigBase)
local yingjingDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local nanchongDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local wenjiangDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local zhongjiangDoushisiShiftConfig  = table.clone(doushisiShiftConfigBase)

deskShiftConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongShiftConfig,
        [gameType.doushisi] = chengduDoushisiShiftConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongShiftConfig,
        [gameType.doushisi] = jintangDoushisiShiftConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong] = xichongMahjongShiftConfig,
        [gameType.doushisi] = xichongDoushisiShiftConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong] = yingjingMahjongShiftConfig,
        [gameType.doushisi] = yingjingDoushisiShiftConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong] = nanchongMahjongShiftConfig,
        [gameType.doushisi] = nanchongDoushisiShiftConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong] = wenjiangMahjongShiftConfig,
        [gameType.doushisi] = wenjiangDoushisiShiftConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong] = zhongjiangMahjongShiftConfig,
        [gameType.doushisi] = zhongjiangDoushisiShiftConfig,
    },
}

function convertConfigToString(city, game, config, ignoreJushu)
    local text = string.empty

    local function concat(t)
        if not string.isNilOrEmpty(text) then
            text = text .. "，"
        end

        text = text .. t
    end

    local layout = deskConfigLayout[city][game]
    local shift = deskShiftConfig[city][game]

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

    if city == cityType.jintang and game == gameType.doushisi then 
        local text = string.format("%d点", config.DianShu)
        concat(text)
    end

    return text
end

--endregion
