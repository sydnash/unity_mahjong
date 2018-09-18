--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = {
    tiao  = 0, 
    tong  = 1,
    wan   = 2,
    other = 3,
}

local mahjongClassName = {
    [mahjongClass.tiao]  = "tiao",
    [mahjongClass.tong]  = "tong",
    [mahjongClass.wan]   = "wan",
    [mahjongClass.other] = "other",
}

function getMahjongClassName(mahjongClass)
    return mahjongClassName[mahjongClass]
end

return mahjongClass

--endregion
