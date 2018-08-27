--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType   = require("logic.mahjong.mahjongType")

local base = require("common.object")
local mahjong = class("mahjong", base)

mahjong.w = 0.034 --宽度
mahjong.h = 0.045 --高度
mahjong.z = 0.024 --厚度

function mahjong:ctor(id)
    self.id = id

    local mtype = mahjongType[id]
    local go = modelManager.load(mtype.folder, mtype.resource)
    self:init(go)
    self.collider = getComponentU(go, typeof(UnityEngine.BoxCollider))
end

function mahjong:setPickabled(pickabled)
    self.collider.enabled = pickabled
end

function mahjong:onDestroy()
    self:hide()
    modelManager.unload(self)
end

return mahjong

--endregion
