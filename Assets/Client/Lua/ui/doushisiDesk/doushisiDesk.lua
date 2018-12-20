--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.doushisiDesk.doushisiDeskHeader")

local base = require("ui.desk")
local doushisiDesk = class("doushisiDesk", base)

_RES_(doushisiDesk, "DoushisiDeskUI", "DeskUI")

local gfxConfig = {
    [opType.doushisi.an] = {
        default = "an",
    },
    [opType.doushisi.baGang] = {
        default = "gang",
    },
    [opType.doushisi.bao] = {
        default = "bao",
    },
    [opType.doushisi.baoJiao] = {
        default = "baojiao",
    },
    [opType.doushisi.caiShen] = {
        default = "caishen",
    },
    [opType.doushisi.che] = {
        default = "che",
    },
    [opType.doushisi.chi] = {
        default = "chi",
    },
    [opType.doushisi.chiChengSan] = {
        default = "chichengsan",
    },
    [opType.doushisi.dang] = {
        default = "dang",
    },
    [opType.doushisi.gang] = {
        default = "gang",
    },
    [opType.doushisi.gen] = {
        default = "gen",
    },
    [opType.doushisi.hu] = {
        default = "hu",
    },
    [opType.doushisi.hua] = {
        default = "hua",
    },
    [opType.doushisi.shou] = {
        default = "shou",
    },
    [opType.doushisi.weiGui] = {
        default = "weigui",
    },
    [opType.doushisi.zhao] = {
        default = "zhao",
    },
}

function doushisiDesk:ctor(game)
    base.game = game
    base.ctor(self)
end

function doushisiDesk:onInit()
    local parents = {
        [seatType.mine]  = self.mPlayerM, 
        [seatType.right] = self.mPlayerR, 
        [seatType.top]   = self.mPlayerT, 
        [seatType.left]  = self.mPlayerL, 
    }

    self.headers = {}

    for k, v in pairs(parents) do
        self.headers[k] = header.new(k)
        self.headers[k]:setParent(v)
        self.headers[k]:show()
    end

    base.onInit(self)
end

function doushisiDesk:onPlayerGfx(acId, opid)
    local st = self.game:getSeatTypeByAcId(acId)
    local hd = self.headers[st]

    local opc = gfxConfig[opid]
    local gfx = opc[self.game.cityType] or opc.default

    hd:playGfx(gfx)
end

function doushisiDesk:onOpDoChu(acId, cards)
    
end

function doushisiDesk:createSettingUI()
    return require("ui.setting.doushisiSetting").new(self.game)
end

function doushisiDesk:onDestroy()
    self:unregisterHandlers()

    for _, v in pairs(self.headers) do
        v:close()
    end
    self.headers = {}

    base.onDestroy(self)
end

return doushisiDesk

--endregion
