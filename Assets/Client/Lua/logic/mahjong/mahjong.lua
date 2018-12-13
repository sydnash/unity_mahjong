--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("common.object")
local mahjong = class("mahjong", base)

mahjong.w = 0.034 --宽度
mahjong.h = 0.045 --高度
mahjong.z = 0.024 --厚度

local DEFAULT_LAYER         = 0
local INHAND_MAHJONG_LAYER  = 8

local d = 160 / 255
local DARK_COLOR  = Color.New(d, d, d, 1)
local LIGHT_COLOR = Color.New(1, 1, 1, 1)

local colorMode = {
    dark  = 1,
    light = 2,
}

mahjong.shadowMode = {
    noshadow = 0,
    pa       = 1,
    yang     = 2,
    li       = 3
}

function mahjong:ctor(id)
    self.id = id
    self.pickabled = false
    self.selected = false
    self.cmode = colorMode.light

    local mtype = getMahjongTypeById(id)
    local go = modelManager.load(mtype.folder, mtype.resource)
    self:init(go)
    self:show()

    local c = self:findChild(go.name .. "_0")
    local r = getComponentU(c.gameObject, typeof(UnityEngine.MeshRenderer))
    self.mat = r.material

    self.shadows = {
        [mahjong.shadowMode.pa]     = self:findChild("mj_shadow_pa"),
        [mahjong.shadowMode.yang]   = self:findChild("mj_shadow_yang"),
        [mahjong.shadowMode.li]     = self:findChild("mj_shadow_li"),
    }
    self.shadowMode = mahjong.shadowMode.noshadow
    for _, v in pairs(self.shadows) do
        v:hide()
    end

    self.name  = mtype.name
    self.class = mtype.class

    self:reset()
end

function mahjong:dark()
    if self.mat ~= nil and self.cmode == colorMode.light then
        self.cmode = colorMode.dark
        self.mat.color = DARK_COLOR
    end
end

function mahjong:light()
    if self.mat ~= nil and self.cmode == colorMode.dark then
        self.cmode = colorMode.light
        self.mat.color = LIGHT_COLOR
    end
end

function mahjong:setPickabled(pickabled)
    if self.pickabled ~= pickabled then
        self.pickabled = pickabled

        local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
        self:setLayer(layer, true)
    end
end

function mahjong:setSelected(selected)
    if self.selected ~= selected then
        self.selected = selected

        local pos = self:getLocalPosition()
        pos:Set(pos.x, pos.y + mahjong.h * (selected and 0.3 or -0.3), pos.z)
        self:setLocalPosition(pos)
    end
end

function mahjong:setShadowMode(shadowMode)
    if self.shadowMode ~= shadowMode then
        for _, v in pairs(self.shadows) do
            v:hide()
        end

        if shadowMode ~= mahjong.shadowMode.noshadow then
            self.shadows[shadowMode]:show()
        end

        self.shadowMode = shadowMode
    end
end

function mahjong:getShadowMode()
    return self.shadowMode
end

function mahjong:reset()
    self:light()
    self:setPickabled(false)
    self:setSelected(false)
    self:setShadowMode(mahjong.shadowMode.noshadow)
end

function mahjong:onDestroy()
    self:reset()
    self:hide()

    modelManager.unload(self)
end

return mahjong

--endregion
