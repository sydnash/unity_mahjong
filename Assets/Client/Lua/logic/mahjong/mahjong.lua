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

function mahjong:ctor(id)
    self.id = id

    local mtype = mahjongType[id]
    local go = modelManager.load(mtype.folder, mtype.resource)
    self:init(go)
    self.collider = getComponentU(go, typeof(BoxCollider))

    self:show()
end

function mahjong:setPickabled(pickabled)
    local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
    self:setLayer(layer, true)
end

function mahjong:onDestroy()
    self:hide()
    modelManager.unload(self)
end

return mahjong

--endregion
