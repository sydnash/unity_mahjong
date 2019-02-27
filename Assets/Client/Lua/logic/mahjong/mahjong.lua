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
local l = 234 / 255
local LIGHT_COLOR = Color.New(l, l, l, 1)
local BLUE_COLOR = Color.New(165/255, 176/255, 249/255, 1)

local colorMode = {
    dark  = 1,
    light = 2,
    blue  = 3,
}

mahjong.shadowMode = {
    noshadow = 0,
    pa       = 1,
    yang     = 2,
    li       = 3
}

function mahjong:ctor(id)
    self.id = id
    self.tid = mahjongType.getMahjongTypeId(id)
    self.selected = false
    self.cmode = colorMode.light

    local mtype = mahjongType.getMahjongTypeById(id)
    local go = modelManager.load(mtype.folder, mtype.resource)
    self:init(go)
    self:show()

    local c = self:findChild(mtype.resource .. "_0")
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
    self.mahjongTex = {
        normal = {
            samp = nil,
            mask = nil,
        },
        inhand = {
            samp = nil,
            mask = nil,
        },
    }

    self:loadTex()
    self:setPickabled(false)
    self:reset()
end

function mahjong:loadTex()
    local mahjongTex = self.mahjongTex
    if mahjongTex.normal.samp == nil then 
        mahjongTex.normal.samp = textureManager.load("mahjong", "mj_dif_u")
    end
    if mahjongTex.normal.mask == nil then
        mahjongTex.normal.mask  = textureManager.load("mahjong", "mj_dif_mask_u")
    end

    if mahjongTex.inhand.samp == nil then 
        mahjongTex.inhand.samp = textureManager.load("mahjong", "mj_dif")
    end
    if mahjongTex.inhand.mask == nil then
        mahjongTex.inhand.mask  = textureManager.load("mahjong", "mj_dif_mask")
    end
end

function mahjong:unloadTex()
    local mahjongTex = self.mahjongTex
    if mahjongTex.normal.samp ~= nil then 
        textureManager.unload(mahjongTex.normal.samp)
        mahjongTex.normal.samp = nil
    end
    if mahjongTex.normal.mask ~= nil then 
        textureManager.unload(mahjongTex.normal.mask)
        mahjongTex.normal.mask = nil
    end

    if mahjongTex.inhand.samp ~= nil then 
        textureManager.unload(mahjongTex.inhand.samp)
        mahjongTex.inhand.samp = nil
    end
    if mahjongTex.inhand.mask ~= nil then 
        textureManager.unload(mahjongTex.inhand.mask)
        mahjongTex.inhand.mask = nil
    end
end

function mahjong:dark()
    if self.mat ~= nil and self.cmode ~= colorMode.dark then
        self.cmode = colorMode.dark
        self.mat.color = DARK_COLOR
    end
end

function mahjong:light()
    if self.mat ~= nil and self.cmode ~= colorMode.light then
        self.cmode = colorMode.light
        self.mat.color = LIGHT_COLOR
    end
end

function mahjong:blue(enable)
    if self.mat ~= nil then
        if enable then
            if self.cmode == colorMode.light then
                self.cmode = colorMode.blue
                self.mat.color = BLUE_COLOR
            end
        else
            if self.cmode == colorMode.blue then
                self.cmode = colorMode.light
                self.mat.color = LIGHT_COLOR
            end
        end
    end
end

function mahjong:setPickabled(pickabled)
    if self.pickabled ~= pickabled then
        self.pickabled = pickabled

        local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
        self:setLayer(layer, true)

        local mahjongTex = self.mahjongTex
        local tex = pickabled and mahjongTex.inhand or mahjongTex.normal
        self.mat:SetTexture("_Diffuse", tex.samp)
        self.mat:SetTexture("_DiffuseMask", tex.mask)
    end
end

function mahjong:setSelected(selected)
    if self.selected ~= selected then
        self.selected = selected

        local pos = self:getLocalPosition()
        pos:Set(pos.x, pos.y + mahjong.h * (selected and 0.2 or -0.2), pos.z)
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

    self.mat:SetTexture("_Diffuse", nil)
    self.mat:SetTexture("_DiffuseMask", nil)
    self:unloadTex()

    modelManager.unload(self)
end

return mahjong

--endregion
