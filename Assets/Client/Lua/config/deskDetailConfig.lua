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

local chengduMahjongLayout = table.clone(mahjongLayoutBase)
local jintangMahjongLayout = table.clone(mahjongLayoutBase)

deskDetailLayout = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongLayout,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongLayout,
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

local chengduMahjongConfig = table.clone(mahjongConfigBase)
local jintangMahjongConfig = table.clone(mahjongConfigBase)

deskDetailConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongConfig,
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

local chengduMahjongShiftConfig = table.clone(mahjongShiftConfigBase)
local jintangMahjongShiftConfig = table.clone(mahjongShiftConfigBase)

deskDetailShiftConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong] = chengduMahjongShiftConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong] = jintangMahjongShiftConfig,
    }
}

--endregion
