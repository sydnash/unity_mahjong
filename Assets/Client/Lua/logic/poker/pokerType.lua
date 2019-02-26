--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local poker = {}

local PokerColorTypeNone     = 0
local PokerColorTypeHeiTao   = 1
local PokerColorTypeHongTao  = 2
local PokerColorTypeMeiHua   = 3
local PokerColorTypeFangKuai = 4
      
local PokerTypeNormal        = 0
local PokerTypeXiaoWang      = 1
local PokerTypeDaWang        = 2
local PokerTypeHuaHua        = 3

poker.c = {
    [0]  = {id = 0,  value = 14, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "A_hh"},
	[1]  = {id = 1,  value = 14, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "A_ht"},
	[2]  = {id = 2,  value = 14, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "A_mh"},
	[3]  = {id = 3,  value = 14, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "A_fk"},
                                                                 
	[4]  = {id = 4,  value = 15, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "2_hh"},
	[5]  = {id = 5,  value = 15, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "2_ht"},
	[6]  = {id = 6,  value = 15, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "2_mh"},
	[7]  = {id = 7,  value = 15, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "2_fk"},
                                                                 
	[8]  = {id = 8,  value = 3,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "3_hh"},
	[9]  = {id = 9,  value = 3,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "3_ht"},
	[10] = {id = 10, value = 3,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "3_mh"},
	[11] = {id = 11, value = 3,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "3_fk"},
                                                                 
	[12] = {id = 12, value = 4,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "4_hh"},
	[13] = {id = 13, value = 4,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "4_ht"},
	[14] = {id = 14, value = 4,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "4_mh"},
	[15] = {id = 15, value = 4,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "4_fk",},
                                                                 
	[16] = {id = 16, value = 5,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "5_hh"},
	[17] = {id = 17, value = 5,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "5_ht"},
	[18] = {id = 18, value = 5,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "5_mh"},
	[19] = {id = 19, value = 5,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "5_fk"},
                                                                 
	[20] = {id = 20, value = 6,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "6_hh"},
	[21] = {id = 21, value = 6,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "6_ht"},
	[22] = {id = 22, value = 6,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "6_mh"},
	[23] = {id = 23, value = 6,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "6_fk"},
                                                                 
	[24] = {id = 24, value = 7,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "7_hh"},
	[25] = {id = 25, value = 7,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "7_ht"},
	[26] = {id = 26, value = 7,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "7_mh"},
	[27] = {id = 27, value = 7,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "7_fk"},
                                                                 
	[28] = {id = 28, value = 8,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "8_hh"},
	[29] = {id = 29, value = 8,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "8_ht"},
	[30] = {id = 30, value = 8,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "8_mh"},
	[31] = {id = 31, value = 8,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "8_fk"},
                                                                 
	[32] = {id = 32, value = 9,  color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "9_hh"},
	[33] = {id = 33, value = 9,  color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "9_ht"},
	[34] = {id = 34, value = 9,  color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "9_mh"},
	[35] = {id = 35, value = 9,  color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "9_fk"},
                                                                 
	[36] = {id = 36, value = 10, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "10_hh"},
	[37] = {id = 37, value = 10, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "10_ht"},
	[38] = {id = 38, value = 10, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "10_mh"},
	[39] = {id = 39, value = 10, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "10_fk"},
                                                                 
	[40] = {id = 40, value = 11, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "J_hh"},
	[41] = {id = 41, value = 11, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "J_ht"},
	[42] = {id = 42, value = 11, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "J_mh"},
	[43] = {id = 43, value = 11, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "J_fk",},
                                                                 
	[44] = {id = 44, value = 12, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "Q_hh"},
	[45] = {id = 45, value = 12, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "Q_ht"},
	[46] = {id = 46, value = 12, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "Q_mh"},
	[47] = {id = 47, value = 12, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "Q_fk"},
                                                                 
	[48] = {id = 48, value = 13, color = PokerColorTypeHeiTao,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "K_hh"},
	[49] = {id = 49, value = 13, color = PokerColorTypeHongTao,  typ = PokerTypeNormal,   folder = "poker/cards", resource = "K_ht"},
	[50] = {id = 50, value = 13, color = PokerColorTypeMeiHua,   typ = PokerTypeNormal,   folder = "poker/cards", resource = "K_mh"},
	[51] = {id = 51, value = 13, color = PokerColorTypeFangKuai, typ = PokerTypeNormal,   folder = "poker/cards", resource = "K_fk"},
                                                                 
	[52] = {id = 52, value = 16, color = PokerColorTypeNone,     typ = PokerTypeXiaoWang, folder = "poker/cards", resource = "Wxiao"},
	[53] = {id = 53, value = 17, color = PokerColorTypeNone,     typ = PokerTypeDaWang,   folder = "poker/cards", resource = "Wda"},
    [54] = {id = 54, value = 18, color = PokerColorTypeNone,     typ = PokerTypeHuaHua,   folder = "poker/cards", resource = "3_ht"},
               
    [60] = {id = -1, value = 0,  folder = "poker/cards", resource = "Pb" },
}

poker.cardType = {
    shou    = 1,
    chu     = 2,
}

function poker.getPokerTypeById(cid)
    if cid == -1 then 
        cid = 60
    end

    return poker.c[cid]
end

return poker

--endregion
