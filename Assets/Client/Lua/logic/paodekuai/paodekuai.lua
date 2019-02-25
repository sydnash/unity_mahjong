--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local paodekuai = class("paodekuai", base)

local DEFAULT_LAYER         = 0
local INHAND_MAHJONG_LAYER  = 8

function paodekuai:ctor(id)
    self.id = id

    local go = modelManager.load("paodekuai", "paodekuai")
    self:init(go)
    self:show()

    self.render   = getComponentU(go, typeof(SpriteRenderer))
    self.collider = getComponentU(go, typeof(BoxCollider))
    self.selected = false
end

function paodekuai:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.style][self.ctype]
    self.render.sprite = convertTextureToSprite(textureManager.load(folder, resource .. suffix), pivot)
end

function paodekuai:resetRender()
    local sprite = self.render.sprite

    if sprite ~= nil then
        local tex = sprite.texture
        textureManager.unload(tex)
        GameObject.Destroy(sprite)
        self.render.sprite = nil
    end
end

function paodekuai:setColliderEnabled(enabled)
    self.collider.enabled = enabled
end

function paodekuai:setPickabled(pickabled)
    if self.pickabled ~= pickabled then
        self.pickabled = pickabled

        local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
        self:setLayer(layer, true)
    end
end

function paodekuai:setSelected(selected)
    if self.selected ~= selected then
        self.selected = selected

        local pos = self:getLocalPosition()
        pos:Set(pos.x, pos.y + (selected and 0.3 or -0.3), pos.z)
        self:setLocalPosition(pos)
    end
end

function paodekuai:reset()
    self.id = nil
    self.style = nil
    self.ctype = nil

    self:resetRender()
    self:setColliderEnabled(false)
end

function paodekuai:onDestroy()
    self:reset()
end

return paodekuai

--endregion
