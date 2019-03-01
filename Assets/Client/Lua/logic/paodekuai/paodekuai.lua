--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")

local base = require("common.object")
local paodekuai = class("paodekuai", base)

local DEFAULT_LAYER         = 0
local INHAND_MAHJONG_LAYER  = 8

local resourceSuffix = {
    [pokerType.cardType.shou]    = string.empty,
    [pokerType.cardType.chu]     = "_s",
}

local pivot = Vector2.New(0.5, 0.5)

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:ctor(id)
    self.id = id

    local go = modelManager.load("paodekuai", "paodekuai")
    self:init(go)
    self:show()

    self.render   = getComponentU(go, typeof(UnityEngine.SpriteRenderer))
    self.collider = getComponentU(go, typeof(UnityEngine.BoxCollider))
    self.selected = false

    self.ctype = pokerType.cardType.shou
    self.dirty = true
    self:fix()

    self:setColliderEnabled(true)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setType(ctype)
    if self.ctype ~= ctype then
        self.ctype = ctype
        self.dirty = true
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:fix()
    if self.dirty then
        self.dirty = false

        local typ = pokerType.getPokerTypeById(self.id)
        self:setSprite(typ.folder, typ.resource)

        if self.render.sprite ~= nil then
            local rect = self.render.sprite.rect
            local pixelsPerUnit = self.render.sprite.pixelsPerUnit
            local size = Vector2.New(rect.width / pixelsPerUnit, rect.height / pixelsPerUnit)
            self.collider.center = Vector2.zero
            self.collider.size = size
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setSortingOrder(order)
    self.render.sortingOrder = order
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.ctype]
    self.render.sprite = convertTextureToSprite(textureManager.load(folder, resource .. suffix), pivot)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:resetRender()
    local sprite = self.render.sprite

    if sprite ~= nil then
        local tex = sprite.texture
        textureManager.unload(tex)
        UnityEngine.GameObject.Destroy(sprite)
        self.render.sprite = nil
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setColliderEnabled(enabled)
    self.collider.enabled = enabled
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setPickabled(pickabled)
    if self.pickabled ~= pickabled then
        self.pickabled = pickabled

        local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
        self:setLayer(layer, true)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:setSelected(selected)
    if self.selected ~= selected then
        self.selected = selected

        local pos = self:getLocalPosition()
        pos:Set(pos.x, pos.y + (selected and 0.3 or -0.3), pos.z)
        self:setLocalPosition(pos)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:reset()
    self.id = nil
    self.ctype = nil

    self:resetRender()
    self:setColliderEnabled(false)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuai:onDestroy()
    self:reset()
    modelManager.unload(self)
end

return paodekuai

--endregion
