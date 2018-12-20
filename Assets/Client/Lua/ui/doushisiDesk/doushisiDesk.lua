--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.doushisiDesk.doushisiDeskHeader")
local doushisiGame = require("logic.doushisi.doushisiGame")

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

function doushisiDesk:setDang(acId, dang)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if dang then
        header:showDang()
    else
        header:hideDang()
    end
end

function doushisiDesk:setPiao(acId, piao)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if piao then
        header:showPiao()
    else
        header:hidePiao()
    end
end

function doushisiDesk:setZhuang(acId, zhuang)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if zhuang then
        header:showZhuang()
    else
        header:hideZhuang()
    end
end

function doushisiDesk:setBao(acId, bao)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if bao then
        header:showBao()
    else
        header:hideBao()
    end
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

function doushisiDesk:onGameStart()
    base.onGameStart(self)
    self:syncHeadInfo()
end

function doushisiDesk:onGameSync()
    base.onGameSync(self)
    local reenter = self.game.data.Reenter
    self:syncHeadInfo()
end

function doushisiDesk:syncHeadInfo()
    for _, p in pairs(self.game.players) do
        self:setDang(p.acId, p.isDang)
        self:setBao(p.acId, p.isBao)
        self:setPiao(p.acId, p.isPiao)
        self:setZhuang(p.acId, p.isMarker)
        local st = self.game:getSeatTypeByAcId(p.acId)
        local header = self.headers[st]
        header:setFuShu(p.fuShu)
        header:setCount(p.zhangShu)
    end
end

function doushisiDesk:updateInhandCardCount(acId)
    local p = self.game:getPlayerByAcId(acId)
    local st = self.game:getSeatTypeByAcId(p.acId)
    local header = self.headers[st]
    header:setCount(p.zhangShu)
end

function doushisiDesk:onDangNotifyHandler(acId, dang)
    if not dang then
        return
    end
    self:setDang(acId, dang)
end

return doushisiDesk

--endregion
