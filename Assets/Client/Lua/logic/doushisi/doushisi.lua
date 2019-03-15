--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local doushisiType = require("logic.doushisi.doushisiType")

local base = require("common.object")
local doushisi = class("doushisi", base)

local resourceSuffix = {
    [doushisiStyle.traditional] = {
        [doushisiType.cardType.shou]    = "m",
        [doushisiType.cardType.chu]     = "s",
        [doushisiType.cardType.peng]    = "s",
        [doushisiType.cardType.perfect] = "",
    },
    [doushisiStyle.modern] = {
        [doushisiType.cardType.shou]    = "l",
        [doushisiType.cardType.chu]     = "_ns",
        [doushisiType.cardType.peng]    = "_ns",
        [doushisiType.cardType.perfect] = "xl",
    }
}

local DEFAULT_LAYER         = 0
local INHAND_MAHJONG_LAYER  = 8
local pivot = Vector2.New(0.5, 0.5)

local SpriteRenderer = UnityEngine.SpriteRenderer
local BoxCollider = UnityEngine.BoxCollider
local GameObject = UnityEngine.GameObject

local d = 160 / 255
local DARK_COLOR  = Color.New(d, d, d, 1)
local l = 255 / 255
local LIGHT_COLOR = Color.New(l, l, l, 1)

function doushisi:setCanChu(can)
    if can == self.canChu then
        return
    end
    self.canChu = can
    if self.render ~= nil then
        if can then
            self.render.color = LIGHT_COLOR
        else
            self.render.color = DARK_COLOR
        end
    end
end

function doushisi:ctor(id)
    self.id = id
    self.canChu = true

    local go = modelManager.load("doushisi", "doushisi")
    self:init(go)
    self:show()

    self.render = getComponentU(go, typeof(SpriteRenderer))
    self.collider = getComponentU(go, typeof(BoxCollider))
    self.selected = false

    local typ  = doushisiType.getDoushisiTypeById(id)
    self.name  = typ.name
    self.color = typ.color
    self.value = typ.value

    self.style = doushisiStyle.traditional
    self.ctype = doushisiType.cardType.shou
    self.dirty = true
    self:fix()
end

function doushisi:setId(id)
    if self.id ~= id then
        self.id = id
        self.dirty = true
    end
end

function doushisi:setStyle(style)
    if self.style ~= style then
        self.style = style
        self.dirty = true
    end
end

function doushisi:setType(ctype)
    if self.ctype ~= ctype then
        self.ctype = ctype
        self.dirty = true
    end
end

function doushisi:setColliderEnabled(enabled)
    self.collider.enabled = enabled
end

function doushisi:fix()
    if self.dirty then
        self.dirty = false

        local typ = doushisiType.getDoushisiTypeById(self.id)
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

function doushisi:setSortingOrder(order)
    self.render.sortingOrder = order
end

function doushisi:getSortingOrder()
    return self.render.sortingOrder
end

function doushisi:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.style][self.ctype]
    self.render.sprite = convertTextureToSprite(textureManager.load(folder, resource .. suffix), pivot)
end

function doushisi:resetRender()
    local sprite = self.render.sprite
    if sprite ~= nil then
        local tex = sprite.texture
        textureManager.unload(tex)
        GameObject.Destroy(sprite)
        self.render.sprite = nil
    end
end

function doushisi:reset()
    self.id = nil
    self.style = nil
    self.ctype = nil

    self:resetRender()
    self:setColliderEnabled(false)
end

function doushisi.typeId(id)
    return doushisiType.getDoushisiTypeId(id)
end

function doushisi:onDestroy()
    self:reset()
end

function doushisi:setPickabled(pickabled)
    if self.pickabled ~= pickabled then
        self.pickabled = pickabled

        local layer = pickabled and INHAND_MAHJONG_LAYER or DEFAULT_LAYER
        self:setLayer(layer, true)
    end
end

function doushisi:setSelected(selected)
    if self.selected ~= selected then
        self.selected = selected

        local pos = self:getLocalPosition()
        pos:Set(pos.x, pos.y + (selected and 0.3 or -0.3), pos.z)
        self:setLocalPosition(pos)
    end
end

return doushisi

--endregion
