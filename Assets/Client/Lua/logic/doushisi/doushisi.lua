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
        [doushisiType.cardType.peng]    = "s",
        [doushisiType.cardType.perfect] = "xl",
    }
}

function doushisi:ctor(id)
    self.id = id

    local go = modelManager.load("doushisi", "doushisi")
    self:init(go)
    self:show()

    self.render = getComponentU(go, typeof(UnityEngine.SpriteRenderer))
    self.collider = getComponentU(go, typeof(UnityEngine.BoxCollider))

    local typ  = doushisiType.getDoushisiTypeById(id)
    self.name  = typ.name
    self.color = typ.color
    self.value = typ.value

    self.style = doushisiStyle.traditional
    self.ctype = doushisiType.cardType.shou
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

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource)

        local bounds = self.render.bounds
        self.collider.bounds = bounds
    end
end

function doushisi:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.style][self.ctype]
    self.render.sprite = convertTextureToSprite(textureManager.load(folder, resource .. suffix))
end

function doushisi:resetRender()
    if self.render.sprite ~= nil then
        textureManager.unload(self.render.sprite)
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
    self.super.onDestroy(self)
end

return doushisi

--endregion
