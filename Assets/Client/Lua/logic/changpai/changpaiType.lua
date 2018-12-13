--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local changpaiType = {
    [0]  = { folder = "changpai/cards", resource = "R1R1", color = changpaiColor.red,   value = 2,  },--地牌
    [1]  = { folder = "changpai/cards", resource = "R1B2", color = changpaiColor.red,   value = 3,  },--丁丁
    [2]  = { folder = "changpai/cards", resource = "R1B3", color = changpaiColor.red,   value = 4,  },--和牌
    [3]  = { folder = "changpai/cards", resource = "B2B2", color = changpaiColor.black, value = 4,  },--长二
    [4]  = { folder = "changpai/cards", resource = "R1R4", color = changpaiColor.red,   value = 5,  },--幺四
    [5]  = { folder = "changpai/cards", resource = "B2B3", color = changpaiColor.black, value = 5,  },--拐子
    [6]  = { folder = "changpai/cards", resource = "R1B5", color = changpaiColor.red,   value = 6,  },--珠珠
    [7]  = { folder = "changpai/cards", resource = "B2R4", color = changpaiColor.red,   value = 6,  },--二红
    [8]  = { folder = "changpai/cards", resource = "B3B3", color = changpaiColor.black, value = 6,  },--长三
    [9]  = { folder = "changpai/cards", resource = "R1B6", color = changpaiColor.red,   value = 7,  },--幺六
    [10] = { folder = "changpai/cards", resource = "B2B5", color = changpaiColor.black, value = 7,  },--二五
    [11] = { folder = "changpai/cards", resource = "B3R4", color = changpaiColor.red,   value = 7,  },--三四
    [12] = { folder = "changpai/cards", resource = "B2B6", color = changpaiColor.black, value = 8,  },--二六
    [13] = { folder = "changpai/cards", resource = "B3B5", color = changpaiColor.black, value = 8,  },--三五
    [14] = { folder = "changpai/cards", resource = "R4R4", color = changpaiColor.red,   value = 8,  },--人牌
    [15] = { folder = "changpai/cards", resource = "B3B6", color = changpaiColor.black, value = 9,  },--黑九
    [16] = { folder = "changpai/cards", resource = "R4B5", color = changpaiColor.red,   value = 9,  },--红九
    [17] = { folder = "changpai/cards", resource = "R4B6", color = changpaiColor.red,   value = 10, },--四六
    [18] = { folder = "changpai/cards", resource = "B5B5", color = changpaiColor.black, value = 10, },--煤子
    [19] = { folder = "changpai/cards", resource = "B5B6", color = changpaiColor.black, value = 11, },--斧头
    [20] = { folder = "changpai/cards", resource = "R6R6", color = changpaiColor.red,   value = 12, },--天牌
    [21] = { folder = "changpai/cards", resource = "CS",   color = changpaiColor.none,  value = 0,  },--财神
    [22] = { folder = "changpai/cards", resource = "TY",   color = changpaiColor.none,  value = 0,  },--听用
    [23] = { folder = "changpai/cards", resource = "BACK", color = changpaiColor.none,  value = 0,  },--背面
}

function getChangpaiTypeById(cid)
    cid = math.floor(cid / 4)
    return changpaiType[cid]
end

function getChangpaiBackType()
    return changpaiType[23]
end

return changpaiType

--endregion
