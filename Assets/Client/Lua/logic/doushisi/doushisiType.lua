--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local c = {
    [0]  = { folder = "doushisi/cards", resource = "R1R1", color = doushisiColor.red,   value = 2,  },--地牌
    [1]  = { folder = "doushisi/cards", resource = "R1B2", color = doushisiColor.red,   value = 3,  },--丁丁
    [2]  = { folder = "doushisi/cards", resource = "R1B3", color = doushisiColor.red,   value = 4,  },--和牌
    [3]  = { folder = "doushisi/cards", resource = "B2B2", color = doushisiColor.black, value = 4,  },--长二
    [4]  = { folder = "doushisi/cards", resource = "R1R4", color = doushisiColor.red,   value = 5,  },--幺四
    [5]  = { folder = "doushisi/cards", resource = "B2B3", color = doushisiColor.black, value = 5,  },--拐子
    [6]  = { folder = "doushisi/cards", resource = "R1B5", color = doushisiColor.red,   value = 6,  },--珠珠
    [7]  = { folder = "doushisi/cards", resource = "B2R4", color = doushisiColor.red,   value = 6,  },--二红
    [8]  = { folder = "doushisi/cards", resource = "B3B3", color = doushisiColor.black, value = 6,  },--长三
    [9]  = { folder = "doushisi/cards", resource = "R1B6", color = doushisiColor.red,   value = 7,  },--幺六
    [10] = { folder = "doushisi/cards", resource = "B2B5", color = doushisiColor.black, value = 7,  },--二五
    [11] = { folder = "doushisi/cards", resource = "B3R4", color = doushisiColor.red,   value = 7,  },--三四
    [12] = { folder = "doushisi/cards", resource = "B2B6", color = doushisiColor.black, value = 8,  },--二六
    [13] = { folder = "doushisi/cards", resource = "B3B5", color = doushisiColor.black, value = 8,  },--三五
    [14] = { folder = "doushisi/cards", resource = "R4R4", color = doushisiColor.red,   value = 8,  },--人牌
    [15] = { folder = "doushisi/cards", resource = "B3B6", color = doushisiColor.black, value = 9,  },--黑九
    [16] = { folder = "doushisi/cards", resource = "R4B5", color = doushisiColor.red,   value = 9,  },--红九
    [17] = { folder = "doushisi/cards", resource = "R4B6", color = doushisiColor.red,   value = 10, },--四六
    [18] = { folder = "doushisi/cards", resource = "B5B5", color = doushisiColor.black, value = 10, },--煤子
    [19] = { folder = "doushisi/cards", resource = "B5B6", color = doushisiColor.black, value = 11, },--斧头
    [20] = { folder = "doushisi/cards", resource = "R6R6", color = doushisiColor.red,   value = 12, },--天牌
    [21] = { folder = "doushisi/cards", resource = "CS",   color = doushisiColor.none,  value = 0,  },--财神
    [22] = { folder = "doushisi/cards", resource = "TY",   color = doushisiColor.none,  value = 0,  },--听用
    [23] = { folder = "doushisi/cards", resource = "BACK", color = doushisiColor.none,  value = 0,  },--背面
}

local function getDoushisiTypeId(cid)
    return math.floor(cid / 4)
end

local function getDoushisiTypeById(cid)
    cid = getDoushisiId(cid)
    return c[cid]
end

local function getDoushisiBackType()
    return c[23]
end

return {
    c = c,
    getDoushisiTypeId = getDoushisiTypeId,
    getDoushisiTypeById = getDoushisiTypeById,
    getDoushisiBackType = getDoushisiBackType,
}

--endregion
