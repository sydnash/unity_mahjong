--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local c = {
    [0]  = { folder = "doushisi/cards", resource = "R1R1", audio = "pai_dipai",     color = doushisiColor.red,   value = 2,  },--地牌
    [1]  = { folder = "doushisi/cards", resource = "R1B2", audio = "pai_dingding",  color = doushisiColor.red,   value = 3,  },--丁丁
    [2]  = { folder = "doushisi/cards", resource = "R1B3", audio = "pai_hepai",     color = doushisiColor.red,   value = 4,  },--和牌
    [3]  = { folder = "doushisi/cards", resource = "B2B2", audio = "pai_changer",   color = doushisiColor.black, value = 4,  },--长二
    [4]  = { folder = "doushisi/cards", resource = "R1R4", audio = "pai_yaosi",     color = doushisiColor.red,   value = 5,  },--幺四
    [5]  = { folder = "doushisi/cards", resource = "B2B3", audio = "pai_guaizi",    color = doushisiColor.black, value = 5,  },--拐子
    [6]  = { folder = "doushisi/cards", resource = "R1B5", audio = "pai_zhuzhu",    color = doushisiColor.red,   value = 6,  },--珠珠
    [7]  = { folder = "doushisi/cards", resource = "B2R4", audio = "pai_erhong",    color = doushisiColor.red,   value = 6,  },--二红
    [8]  = { folder = "doushisi/cards", resource = "B3B3", audio = "pai_changsan",  color = doushisiColor.black, value = 6,  },--长三
    [9]  = { folder = "doushisi/cards", resource = "R1B6", audio = "pai_yaoliu",    color = doushisiColor.red,   value = 7,  },--幺六
    [10] = { folder = "doushisi/cards", resource = "B2B5", audio = "pai_erwu",      color = doushisiColor.black, value = 7,  },--二五
    [11] = { folder = "doushisi/cards", resource = "B3R4", audio = "pai_sansi",     color = doushisiColor.red,   value = 7,  },--三四
    [12] = { folder = "doushisi/cards", resource = "B2B6", audio = "pai_erliu",     color = doushisiColor.black, value = 8,  },--二六
    [13] = { folder = "doushisi/cards", resource = "B3B5", audio = "pai_sanwu",     color = doushisiColor.black, value = 8,  },--三五
    [14] = { folder = "doushisi/cards", resource = "R4R4", audio = "pai_renpai",    color = doushisiColor.red,   value = 8,  },--人牌
    [15] = { folder = "doushisi/cards", resource = "B3B6", audio = "pai_choujiu",   color = doushisiColor.black, value = 9,  },--黑九
    [16] = { folder = "doushisi/cards", resource = "R4B5", audio = "pai_hongjiu",   color = doushisiColor.red,   value = 9,  },--红九
    [17] = { folder = "doushisi/cards", resource = "R4B6", audio = "pai_hongshi",   color = doushisiColor.red,   value = 10, },--四六
    [18] = { folder = "doushisi/cards", resource = "B5B5", audio = "pai_meizi",     color = doushisiColor.black, value = 10, },--煤子
    [19] = { folder = "doushisi/cards", resource = "B5B6", audio = "pai_futou",     color = doushisiColor.black, value = 11, },--斧头
    [20] = { folder = "doushisi/cards", resource = "R6R6", audio = "pai_tianpai",   color = doushisiColor.red,   value = 12, },--天牌
    [21] = { folder = "doushisi/cards", resource = "CS",   audio = "pai_cs",        color = doushisiColor.none,  value = 0,  },--财神
    [22] = { folder = "doushisi/cards", resource = "TY",   audio = "pai_ty",        color = doushisiColor.none,  value = 0,  },--听用
    [23] = { folder = "doushisi/cards", resource = "BACK", audio = string.empty,    color = doushisiColor.none,  value = 0,  },--背面
}

local function getDoushisiTypeId(cid)
    if cid < 0 then
        return 23
    end
    return math.floor(cid / 4)
end

local function getDoushisiTypeById(cid)
    cid = getDoushisiTypeId(cid)
    return c[cid]
end

local function getDoushisiTypeByTypeId(t)
    return c[t]
end

local function getDoushisiBackType()
    return c[23]
end

return {
    c = c,
    getDoushisiTypeId = getDoushisiTypeId,
    getDoushisiTypeById = getDoushisiTypeById,
    getDoushisiBackType = getDoushisiBackType,
    getDoushisiTypeByTypeId = getDoushisiTypeByTypeId,
    cardType = {
        shou    = 1,
        peng    = 2,
        chu     = 3,
        hu      = 4,
        perfect = 5,
        back    = 6,
    }
}

--endregion
