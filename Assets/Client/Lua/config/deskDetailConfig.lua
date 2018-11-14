--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

----------------------------------------------------------------
--
----------------------------------------------------------------
deskDetailConfig = {
    [cityTypeSID[cityType.chengdu]] = {
        [gameTypeSID[gameType.mahjong]] = {
            ["RenShu"]          = 1,
            ["JuShu"]           = 1,
            ["FangShu"]         = 1,
            ["FengDing"]        = 1,
            ["ZiMoJiaX"]        = 1,
            ["DianGangHuaX"]    = 1,
            ["HuanNZhang"]      = 1,
            ["YaoJiu"]          = 2,
            ["ZhongZhang"]      = 2,
            ["JiangDui"]        = 2,
            ["MenQing"]         = 2,
            ["TianDiHu"]        = 2,
        },
    },
    [cityTypeSID[cityType.jintang]] = {
        [gameTypeSID[gameType.mahjong]] = {
            ["RenShu"]          = 1,
            ["JuShu"]           = 1,
            ["FangShu"]         = 1,
            ["FengDing"]        = 1,
            ["ZiMoJiaX"]        = 1,
            ["DianGangHuaX"]    = 1,
            ["HuanNZhang"]      = 1,
            ["YaoJiu"]          = 2,
            ["ZhongZhang"]      = 2,
            ["JiangDui"]        = 2,
            ["MenQing"]         = 2,
            ["TianDiHu"]        = 2,
        },
    },
}

----------------------------------------------------------------
--
----------------------------------------------------------------
deskDetailShiftConfig =  {
    [cityTypeSID[cityType.chengdu]] = {
        [gameTypeSID[gameType.mahjong]] = {
            ["RenShu"]          = { [4] = 1, [3] = 2, [2] = 1 },
            ["JuShu"]           = { [8] = 1, [12] = 2, [16] = 3 },
            ["FangShu"]         = { [3] = 1, [2] = 2 },
            ["FengDing"]        = { [3] = 1, [4] = 2, [5] = 3 },
            ["ZiMoJiaX"]        = { [0] = 1, [1] = 2 },
            ["DianGangHuaX"]    = { [0] = 1, [1] = 2 },
            ["HuanNZhang"]      = { [0] = 1, [3] = 2, [4] = 3 },
            ["YaoJiu"]          = { [true] = 1, [false] = 2 },
            ["ZhongZhang"]      = { [true] = 1, [false] = 2 },
            ["JiangDui"]        = { [true] = 1, [false] = 2 },
            ["MenQing"]         = { [true] = 1, [false] = 2 },
            ["TianDiHu"]        = { [true] = 1, [false] = 2 },
        },
    },
    [cityTypeSID[cityType.jintang]] = {
        [gameTypeSID[gameType.mahjong]] = {
            ["RenShu"]          = { [4] = 1, [3] = 2, [2] = 1 },
            ["JuShu"]           = { [8] = 1, [12] = 2, [16] = 3 },
            ["FangShu"]         = { [3] = 1, [2] = 2 },
            ["FengDing"]        = { [3] = 1, [4] = 2, [5] = 3 },
            ["ZiMoJiaX"]        = { [0] = 1, [1] = 2 },
            ["DianGangHuaX"]    = { [0] = 1, [1] = 2 },
            ["HuanNZhang"]      = { [0] = 1, [3] = 2, [4] = 3 },
            ["YaoJiu"]          = { [true] = 1, [false] = 2 },
            ["ZhongZhang"]      = { [true] = 1, [false] = 2 },
            ["JiangDui"]        = { [true] = 1, [false] = 2 },
            ["MenQing"]         = { [true] = 1, [false] = 2 },
            ["TianDiHu"]        = { [true] = 1, [false] = 2 },
        },
    }
}

--endregion
