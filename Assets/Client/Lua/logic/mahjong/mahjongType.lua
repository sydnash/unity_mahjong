--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = require("const.mahjongClass")

local c = {
    [0]  = { folder = "mahjong", resource = "mjpai01", audio = "1tiao",     name = "1tiao",     class = mahjongClass.tiao,  value = 1},
    [1]  = { folder = "mahjong", resource = "mjpai02", audio = "2tiao",     name = "2tiao",     class = mahjongClass.tiao,  value = 2},
    [2]  = { folder = "mahjong", resource = "mjpai03", audio = "3tiao",     name = "3tiao",     class = mahjongClass.tiao,  value = 3},
    [3]  = { folder = "mahjong", resource = "mjpai04", audio = "4tiao",     name = "4tiao",     class = mahjongClass.tiao,  value = 4 },
    [4]  = { folder = "mahjong", resource = "mjpai05", audio = "5tiao",     name = "5tiao",     class = mahjongClass.tiao,  value = 5},
    [5]  = { folder = "mahjong", resource = "mjpai06", audio = "6tiao",     name = "6tiao",     class = mahjongClass.tiao,  value = 6},
    [6]  = { folder = "mahjong", resource = "mjpai07", audio = "7tiao",     name = "7tiao",     class = mahjongClass.tiao,  value = 7},
    [7]  = { folder = "mahjong", resource = "mjpai08", audio = "8tiao",     name = "8tiao",     class = mahjongClass.tiao,  value = 8},
    [8]  = { folder = "mahjong", resource = "mjpai09", audio = "9tiao",     name = "9tiao",     class = mahjongClass.tiao,  value = 9},
    [9]  = { folder = "mahjong", resource = "mjpai19", audio = "1tong",     name = "1tong",     class = mahjongClass.tong,  value = 1},
    [10] = { folder = "mahjong", resource = "mjpai20", audio = "2tong",     name = "2tong",     class = mahjongClass.tong,  value = 2 },
    [11] = { folder = "mahjong", resource = "mjpai21", audio = "3tong",     name = "3tong",     class = mahjongClass.tong,  value = 3},
    [12] = { folder = "mahjong", resource = "mjpai22", audio = "4tong",     name = "4tong",     class = mahjongClass.tong,  value = 4},
    [13] = { folder = "mahjong", resource = "mjpai23", audio = "5tong",     name = "5tong",     class = mahjongClass.tong,  value = 5},
    [14] = { folder = "mahjong", resource = "mjpai24", audio = "6tong",     name = "6tong",     class = mahjongClass.tong,  value = 6},
    [15] = { folder = "mahjong", resource = "mjpai25", audio = "7tong",     name = "7tong",     class = mahjongClass.tong,  value = 7},
    [16] = { folder = "mahjong", resource = "mjpai26", audio = "8tong",     name = "8tong",     class = mahjongClass.tong,  value = 8},
    [17] = { folder = "mahjong", resource = "mjpai27", audio = "9tong",     name = "9tong",     class = mahjongClass.tong,  value = 9},
    [18] = { folder = "mahjong", resource = "mjpai10", audio = "1wan",      name = "1wan",      class = mahjongClass.wan,   value = 1},
    [19] = { folder = "mahjong", resource = "mjpai11", audio = "2wan",      name = "2wan",      class = mahjongClass.wan,   value = 2},
    [20] = { folder = "mahjong", resource = "mjpai12", audio = "3wan",      name = "3wan",      class = mahjongClass.wan,   value = 3},
    [21] = { folder = "mahjong", resource = "mjpai13", audio = "4wan",      name = "4wan",      class = mahjongClass.wan,   value = 4},
    [22] = { folder = "mahjong", resource = "mjpai14", audio = "5wan",      name = "5wan",      class = mahjongClass.wan,   value = 5},
    [23] = { folder = "mahjong", resource = "mjpai15", audio = "6wan",      name = "6wan",      class = mahjongClass.wan,   value = 6},
    [24] = { folder = "mahjong", resource = "mjpai16", audio = "7wan",      name = "7wan",      class = mahjongClass.wan,   value = 7},
    [25] = { folder = "mahjong", resource = "mjpai17", audio = "8wan",      name = "8wan",      class = mahjongClass.wan,   value = 8},
    [26] = { folder = "mahjong", resource = "mjpai18", audio = "9wan",      name = "9wan",      class = mahjongClass.wan,   value = 9},
    [27] = { folder = "mahjong", resource = "mjpai32", audio = "hongzhong", name = "hongzhong", class = mahjongClass.other, value = 0},
    [28] = { folder = "mahjong", resource = "mjpai33", audio = "fa",        name = "facai",     class = mahjongClass.other, value = 0},
    [29] = { folder = "mahjong", resource = "mjpai34", audio = "bai",       name = "baiban",    class = mahjongClass.other, value = 0},
}

local function getMahjongTypeId(mid)
    return math.floor(mid * 0.25)
end

local function getMahjongTypeById(mid)
    mid = getMahjongTypeId(mid)
    return c[mid]
end

local function getMahjongTypeByTypeId(tid)
    return c[tid]
end

return {
    c = c,
    getMahjongTypeId = getMahjongTypeId,
    getMahjongTypeById = getMahjongTypeById,
    getMahjongTypeByTypeId = getMahjongTypeByTypeId,
}

--endregion
