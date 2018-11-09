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

local d = 150 / 255
local DARK_COLOR  = Color.New(d, d, d, 1)
local LIGHT_COLOR = Color.New(1, 1, 1, 1)

function mahjong:ctor(id)
    self.id = id

    local mtype = mahjongType[id]
    local go = modelManager.load(mtype.folder, mtype.resource)
    self:init(go)
    self:show()

    local c = self:findChild(go.name .. "_0")
    local r = getComponentU(c.gameObject, typeof(UnityEngine.MeshRenderer))
    self.mat = r.material

    self.name  = mtype.name
    self.class = mtype.class

    self:reset()
end

function mahjong:dark()
    if self.mat ~= nil then
        self.mat.color = DARK_COLOR
    end
end

function mahjong:light()
    if self.mat ~= nil then
        self.mat.color = LIGHT_COLOR
    end
end

function mahjong:setPickabled(pickabled)
    local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
    self:setLayer(layer, true)
end

function mahjong:reset()
    self:light()
    self:setPickabled(false)
end

function mahjong:onDestroy()
    self:reset()
    self:hide()

    modelManager.unload(self)
end

return mahjong

--endregion
