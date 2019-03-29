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
            [1] = { style = "radiobox", text = "可平胡",key = "CanPingHu", value = 1, },
            [2] = { style = "radiobox", text = "点炮不可平胡",key = "CanPingHu", value = 2, },
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
            [1] = { style = "checkbox", text = "幺九", key = "YaoJiu", value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "中张", key = "ZhongZhang", value = { selected = 1, unselected = 2 }, },
            [3] = { style = "checkbox", text = "将对", key = "JiangDui", value = { selected = 1, unselected = 2 }, },
            [4] = { style = "checkbox", text = "门清", key = "MenQing", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [10] = {
        title = string.empty,
        items = {
            [1] = { style = "checkbox", text = "对对胡2番", key = "DuiDuiHu2",  value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "夹心五", key = "JiaXinWu", value = { selected = 1, unselected = 2 }, },
            [3] = { style = "checkbox", text = "天地胡", key = "TianDiHu", value = { selected = 1, unselected = 2 }, },
        },
        group = { value = false, switchOff = false },
    },
    [11] = { 
        title = string.empty, 
        items = {
            [1] = { style = "checkbox", text = "大小雨", key = "DaXiaoYu", value = { selected = 1, unselected = 2 }, },
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
    [6] = {
        title = "",
        items = {
            [1] = { style = "checkbox", text = "古追", key = "GuZhui", value = { selected = 1, unselected = 2 }, },
        },
        group = { value = false, switchOff = false },
    }
}

local chengduDoushisiLayout      = table.clone(doushisiLayoutBase)
local jintangDoushisiLayout      = table.clone(doushisiLayoutBase)
local xichongDoushisiLayout      = table.clone(doushisiLayoutBase)
local yingjingDoushisiLayout     = table.clone(doushisiLayoutBase)
local nanchongDoushisiLayout     = table.clone(doushisiLayoutBase)
local wenjiangDoushisiLayout     = table.clone(doushisiLayoutBase)
local zhongjiangDoushisiLayout   = table.clone(doushisiLayoutBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local paodekuaiLayoutBase = {
    [1] = {
        title = "人数", 
        items = { 
            [1] = { style = "radiobox", text = "3人", key = "RenShu", value = 1, },
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
        title = "炸弹", 
        items = { 
            [1] = { style = "radiobox", text = "3炸", key = "ZhaDan", value = 1, },
        },
        group = { value = true, switchOff = false },
    },
    [4] = {
        title = "算翻", 
        items = { 
            [1] = { style = "radiobox", text = "梯翻", key = "SuanFan", value = 1, },
            [2] = { style = "radiobox", text = "滚翻", key = "SuanFan", value = 2, },
        }, 
        group = { value = true, switchOff = false },
    },
}

local chengduPaodekuaiLayout      = table.clone(paodekuaiLayoutBase)
local jintangPaodekuaiLayout      = table.clone(paodekuaiLayoutBase)
local xichongPaodekuaiLayout      = table.clone(paodekuaiLayoutBase)
local yingjingPaodekuaiLayout     = table.clone(paodekuaiLayoutBase)
local nanchongPaodekuaiLayout     = table.clone(paodekuaiLayoutBase)
local wenjiangPaodekuaiLayout     = table.clone(paodekuaiLayoutBase)
local zhongjiangPaodekuaiLayout   = table.clone(paodekuaiLayoutBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local yaotongrenyongLayoutBase = {
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
            [1] = { style = "radiobox", text = "可平胡",key = "CanPingHu", value = 1, },
            [2] = { style = "radiobox", text = "点炮不可平胡",key = "CanPingHu", value = 2, },
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
            [1] = { style = "checkbox", text = "幺九", key = "YaoJiu", value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "中张", key = "ZhongZhang", value = { selected = 1, unselected = 2 }, },
            [3] = { style = "checkbox", text = "将对", key = "JiangDui", value = { selected = 1, unselected = 2 }, },
            [4] = { style = "checkbox", text = "门清", key = "MenQing", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [10] = {
        title = string.empty,
        items = {
            [1] = { style = "checkbox", text = "天地胡", key = "TianDiHu", value = { selected = 1, unselected = 2 }, },
            [2] = { style = "checkbox", text = "比叫", key = "BiJiao", value = { selected = 1, unselected = 2 }, },
        }, 
        group = { value = false, switchOff = false },
    },
    [11] = { 
        title = string.empty, 
        items = { 
            [1] = { style = "checkbox", text = "杠上杠", key = "GangShangGang", value = { selected = 1, unselected = 2 }, disabled = false, },
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

local chengduYaotongrenyongLayout      = table.clone(yaotongrenyongLayoutBase)
local jintangYaotongrenyongLayout      = table.clone(yaotongrenyongLayoutBase)
local xichongYaotongrenyongLayout      = table.clone(yaotongrenyongLayoutBase)
local yingjingYaotongrenyongLayout     = table.clone(yaotongrenyongLayoutBase)
local nanchongYaotongrenyongLayout     = table.clone(yaotongrenyongLayoutBase)
local wenjiangYaotongrenyongLayout     = table.clone(yaotongrenyongLayoutBase)
local zhongjiangYaotongrenyongLayout   = table.clone(yaotongrenyongLayoutBase)

deskConfigLayout = {
    [cityType.chengdu] = {
        [gameType.mahjong]          = chengduMahjongLayout,
        [gameType.doushisi]         = chengduDoushisiLayout,
        [gameType.paodekuai]        = chengduPaodekuaiLayout,
        [gameType.yaotongrenyong]   = chengduYaotongrenyongLayout,
    },
    [cityType.jintang] = {
        [gameType.mahjong]          = jintangMahjongLayout,
        [gameType.doushisi]         = jintangDoushisiLayout,
        [gameType.paodekuai]        = jintangPaodekuaiLayout,
        [gameType.yaotongrenyong]   = jintangYaotongrenyongLayout,
    },
    [cityType.xichong] = {
        [gameType.mahjong]          = xichongMahjongLayout,
        [gameType.doushisi]         = xichongDoushisiLayout,
        [gameType.paodekuai]        = xichongPaodekuaiLayout,
        [gameType.yaotongrenyong]   = xichongYaotongrenyongLayout,
    },
    [cityType.yingjing] = {
        [gameType.mahjong]          = yingjingMahjongLayout,
        [gameType.doushisi]         = yingjingDoushisiLayout,
        [gameType.paodekuai]        = yingjingPaodekuaiLayout,
        [gameType.yaotongrenyong]   = yingjingYaotongrenyongLayout,
    },
    [cityType.nanchong] = {
        [gameType.mahjong]          = nanchongMahjongLayout,
        [gameType.doushisi]         = nanchongDoushisiLayout,
        [gameType.paodekuai]        = nanchongPaodekuaiLayout,
        [gameType.yaotongrenyong]   = nanchongYaotongrenyongLayout,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong]          = wenjiangMahjongLayout,
        [gameType.doushisi]         = wenjiangDoushisiLayout,
        [gameType.paodekuai]        = wenjiangPaodekuaiLayout,
        [gameType.yaotongrenyong]   = wenjiangYaotongrenyongLayout,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong]          = zhongjiangMahjongLayout,
        [gameType.doushisi]         = zhongjiangDoushisiLayout,
        [gameType.paodekuai]        = zhongjiangPaodekuaiLayout,
        [gameType.yaotongrenyong]   = zhongjiangYaotongrenyongLayout,
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
jintangDoushisiConfig["GuZhui"]  = 2
local xichongDoushisiConfig      = table.clone(doushisiConfigBase)
local yingjingDoushisiConfig     = table.clone(doushisiConfigBase)
local nanchongDoushisiConfig     = table.clone(doushisiConfigBase)
local wenjiangDoushisiConfig     = table.clone(doushisiConfigBase)
local zhongjiangDoushisiConfig   = table.clone(doushisiConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local paodekuaiConfigBase = {
    ["RenShu"]  = 1,
    ["JuShu"]   = 1,
    ["ZhaDan"]  = 1,
    ["SuanFan"] = 1,
}

local chengduPaodekuaiConfig      = table.clone(paodekuaiConfigBase)
local jintangPaodekuaiConfig      = table.clone(paodekuaiConfigBase)
local xichongPaodekuaiConfig      = table.clone(paodekuaiConfigBase)
local yingjingPaodekuaiConfig     = table.clone(paodekuaiConfigBase)
local nanchongPaodekuaiConfig     = table.clone(paodekuaiConfigBase)
local wenjiangPaodekuaiConfig     = table.clone(paodekuaiConfigBase)
local zhongjiangPaodekuaiConfig   = table.clone(paodekuaiConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local yaotongrenyongConfigBase = {
    ["RenShu"]         = 1,
    ["JuShu"]          = 1,
    ["FangShu"]        = 1,
    ["FengDing"]       = 1,
    ["GangShangGang"]  = 1,
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
    ["DaXiaoYu"]       = 2,
}

local chengduYaotongrenyongConfig      = table.clone(yaotongrenyongConfigBase)
local jintangYaotongrenyongConfig      = table.clone(yaotongrenyongConfigBase)
local xichongYaotongrenyongConfig      = table.clone(yaotongrenyongConfigBase)
local yingjingYaotongrenyongConfig     = table.clone(yaotongrenyongConfigBase)
local nanchongYaotongrenyongConfig     = table.clone(yaotongrenyongConfigBase)
local wenjiangYaotongrenyongConfig     = table.clone(yaotongrenyongConfigBase)
local zhongjiangYaotongrenyongConfig   = table.clone(yaotongrenyongConfigBase)

deskConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong]          = chengduMahjongConfig,
        [gameType.doushisi]         = chengduDoushisiConfig,
        [gameType.paodekuai]        = chengduPaodekuaiConfig,
        [gameType.yaotongrenyong]   = chengduYaotongrenyongConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong]          = jintangMahjongConfig,
        [gameType.doushisi]         = jintangDoushisiConfig,
        [gameType.paodekuai]        = jintangPaodekuaiConfig,
        [gameType.yaotongrenyong]   = jintangYaotongrenyongConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong]          = xichongMahjongConfig,
        [gameType.doushisi]         = xichongDoushisiConfig,
        [gameType.paodekuai]        = xichongPaodekuaiConfig,
        [gameType.yaotongrenyong]   = xichongYaotongrenyongConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong]          = yingjingMahjongConfig,
        [gameType.doushisi]         = yingjingDoushisiConfig,
        [gameType.paodekuai]        = yingjingPaodekuaiConfig,
        [gameType.yaotongrenyong]   = yingjingYaotongrenyongConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong]          = nanchongMahjongConfig,
        [gameType.doushisi]         = nanchongDoushisiConfig,
        [gameType.paodekuai]        = nanchongPaodekuaiConfig,
        [gameType.yaotongrenyong]   = nanchongYaotongrenyongConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong]          = wenjiangMahjongConfig,
        [gameType.doushisi]         = wenjiangDoushisiConfig,
        [gameType.paodekuai]        = wenjiangPaodekuaiConfig,
        [gameType.yaotongrenyong]   = wenjiangYaotongrenyongConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong]          = zhongjiangMahjongConfig,
        [gameType.doushisi]         = zhongjiangDoushisiConfig,
        [gameType.paodekuai]        = zhongjiangPaodekuaiConfig,
        [gameType.yaotongrenyong]   = zhongjiangYaotongrenyongConfig,
    },
}

----------------------------------------------------------------
--
----------------------------------------------------------------
local mahjongShiftConfigBase = {
    ["RenShu"]          = { [4] = 1, [3]  = 2, [2]  = 3 },
    ["JuShu"]           = { [8] = 1, [12] = 2, },
    ["FangShu"]         = { [3] = 1, [2]  = 2 },
    ["FengDing"]        = { [3] = 1, [4]  = 2, [5] = 3 },
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
jintangDoushisiShiftConfig["GuZhui"]   = { [true] = 1, [false]  = 2 }
jintangDoushisiShiftConfig["CaiShen"]  = { [8] = 1, [12] = 2 }
jintangDoushisiShiftConfig["DianShu"]  = { [80] = 1, [100] = 2, [120] = 3, [150] = 4 }
local xichongDoushisiShiftConfig     = table.clone(doushisiShiftConfigBase)
local yingjingDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local nanchongDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local wenjiangDoushisiShiftConfig    = table.clone(doushisiShiftConfigBase)
local zhongjiangDoushisiShiftConfig  = table.clone(doushisiShiftConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local paodekuaiShiftConfigBase = {
    ["RenShu"]  = { [3] = 1 },
    ["JuShu"]   = { [8] = 1, [12] = 2, [16] = 3 },
    ["ZhaDan"]  = { [1] = 1 },
    ["SuanFan"] = { [true] = 1, [false] = 2 },
}

local chengduPaodekuaiShiftConfig     = table.clone(paodekuaiShiftConfigBase)
local jintangPaodekuaiShiftConfig     = table.clone(paodekuaiShiftConfigBase)
local xichongPaodekuaiShiftConfig     = table.clone(paodekuaiShiftConfigBase)
local yingjingPaodekuaiShiftConfig    = table.clone(paodekuaiShiftConfigBase)
local nanchongPaodekuaiShiftConfig    = table.clone(paodekuaiShiftConfigBase)
local wenjiangPaodekuaiShiftConfig    = table.clone(paodekuaiShiftConfigBase)
local zhongjiangPaodekuaiShiftConfig  = table.clone(paodekuaiShiftConfigBase)

----------------------------------------------------------------
--
----------------------------------------------------------------
local yaotongrenyongShiftConfigBase = {
    ["RenShu"]          = { [4] = 1, [3]  = 2, [2] = 3 },
    ["JuShu"]           = { [8] = 1, [12] = 2, },
    ["FangShu"]         = { [3] = 1, [2]  = 2 },
    ["FengDing"]        = { [3] = 1, [4]  = 2, [5] = 3 },
    ["GangShangGang"]   = { [true] = 1, [false] = 2 },
    ["ZiMoJiaX"]        = { [0] = 1, [1]  = 2 },
    ["DianGangHuaX"]    = { [0] = 1, [1]  = 2 },
    ["HuanNZhang"]      = { [0] = 1, [3]  = 2, [4] = 3 },
    ["YaoJiu"]          = { [true] = 1, [false] = 2 },
    ["ZhongZhang"]      = { [true] = 1, [false] = 2 },
    ["BiJiao"]          = { [true] = 1, [false] = 2 },
    ["JiangDui"]        = { [true] = 1, [false] = 2 },
    ["MenQing"]         = { [true] = 1, [false] = 2 },
    ["TianDiHu"]        = { [true] = 1, [false] = 2 },
    ["HuPaiHint"]       = { [true] = 1, [false] = 2 },
    ["CanPingHu"]       = { [true] = 1, [false] = 2 },
    ["DaXiaoYu"]        = { [true] = 1, [false] = 2 },
}

local chengduYaotongrenyongShiftConfig     = table.clone(yaotongrenyongShiftConfigBase)
local jintangYaotongrenyongShiftConfig     = table.clone(yaotongrenyongShiftConfigBase)
local xichongYaotongrenyongShiftConfig     = table.clone(yaotongrenyongShiftConfigBase)
local yingjingYaotongrenyongShiftConfig    = table.clone(yaotongrenyongShiftConfigBase)
local nanchongYaotongrenyongShiftConfig    = table.clone(yaotongrenyongShiftConfigBase)
local wenjiangYaotongrenyongShiftConfig    = table.clone(yaotongrenyongShiftConfigBase)
local zhongjiangYaotongrenyongShiftConfig  = table.clone(yaotongrenyongShiftConfigBase)

deskShiftConfig = {
    [cityType.chengdu] = {
        [gameType.mahjong]          = chengduMahjongShiftConfig,
        [gameType.doushisi]         = chengduDoushisiShiftConfig,
        [gameType.paodekuai]        = chengduPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = chengduYaotongrenyongShiftConfig,
    },
    [cityType.jintang] = {
        [gameType.mahjong]          = jintangMahjongShiftConfig,
        [gameType.doushisi]         = jintangDoushisiShiftConfig,
        [gameType.paodekuai]        = jintangPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = jintangYaotongrenyongShiftConfig,
    },
    [cityType.xichong] = {
        [gameType.mahjong]          = xichongMahjongShiftConfig,
        [gameType.doushisi]         = xichongDoushisiShiftConfig,
        [gameType.paodekuai]        = xichongPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = xichongYaotongrenyongShiftConfig,
    },
    [cityType.yingjing] = {
        [gameType.mahjong]          = yingjingMahjongShiftConfig,
        [gameType.doushisi]         = yingjingDoushisiShiftConfig,
        [gameType.paodekuai]        = yingjingPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = yingjingYaotongrenyongShiftConfig,
    },
    [cityType.nanchong] = {
        [gameType.mahjong]          = nanchongMahjongShiftConfig,
        [gameType.doushisi]         = nanchongDoushisiShiftConfig,
        [gameType.paodekuai]        = nanchongPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = nanchongYaotongrenyongShiftConfig,
    },
    [cityType.wenjiang] = {
        [gameType.mahjong]          = wenjiangMahjongShiftConfig,
        [gameType.doushisi]         = wenjiangDoushisiShiftConfig,
        [gameType.paodekuai]        = wenjiangPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = wenjiangYaotongrenyongShiftConfig,
    },
    [cityType.zhongjiang] = {
        [gameType.mahjong]          = zhongjiangMahjongShiftConfig,
        [gameType.doushisi]         = zhongjiangDoushisiShiftConfig,
        [gameType.paodekuai]        = zhongjiangPaodekuaiShiftConfig,
        [gameType.yaotongrenyong]   = zhongjiangYaotongrenyongShiftConfig,
    },
}

function convertConfigToString(city, game, config, ignoreRenShu, ignoreJushu, splitChar)
    local text = string.empty
    splitChar = string.isNilOrEmpty(splitChar) and "，" or splitChar

    local function concat(t)
        if not string.isNilOrEmpty(text) then
            text = text .. splitChar
        end

        text = text .. t
    end

    local layout = deskConfigLayout[city][game]
    local shift = deskShiftConfig[city][game]

    for _, v in pairs(layout) do
        for _, u in pairs(v.items) do
            if ignoreRenShu and u.key == "RenShu" then
                --
            elseif ignoreJushu and u.key == "JuShu" then
                --
            else
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
