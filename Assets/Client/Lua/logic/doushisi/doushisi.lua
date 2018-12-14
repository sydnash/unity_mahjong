--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local doushisiType = require("logic.doushisi.doushisiType")

local base = require("common.object")
local doushisi = class("doushisi", base)

local cardType = {
    shou    = 1,
    chu     = 2,
    cpg     = 3,
    perfect = 4,
    back    = 5,
}

local resourceSuffix = {
    [doushisiStyle.traditional] = {
        shou    = "m",
        chu     = "s",
        cpg     = "s",
        perfect = "",
    },
    [doushisiStyle.modern] = {
        shou    = "l",
        chu     = "_ns",
        cpg     = "s",
        perfect = "xl",
    }
}

function doushisi:ctor(id)
    self.id = id

    local go = modelManager.load("doushisi", "doushisi")
    self:init(go)
    self:show()

    self.render = getComponentU(go, typeof(UnityEngine.SpriteRenderer))
    self.collider = getComponentU(go, typeof(UnityEngine.BoxCollider))

    local typ  = doushisiType[id]
    self.name  = typ.name
    self.color = typ.color
    self.value = typ.value
end

function doushisi:setStyle(style)
    if self.style ~= style then
        self.style = style

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:changeToShou()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.shou
        self.collider.enabled = true

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:changeToChu()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.chu
        self.collider.enabled = false

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:changeToCPG()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.cpg
        self.collider.enabled = false

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:changeToPerfct()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.perfect
        self.collider.enabled = false

        local typ = getDoushisiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:changeToBack()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.back
        self.collider.enabled = false

        local typ = getDoushisiBackType()
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function doushisi:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.style][self.ctype]
    self.render.sprite = textureManager.load(folder, resource .. suffix)
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
    self.collider.enabled = false
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
