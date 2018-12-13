--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local changpaiType = require("logic.mahjong.changpaiType")

local base = require("common.object")
local changpai = class("changpai", base)

local cardType = {
    shou    = 1,
    chu     = 2,
    cpg     = 3,
    perfect = 4,
    back    = 5,
}

local resourceSuffix = {
    [changpaiStyle.traditional] = {
        shou    = "m",
        chu     = "s",
        cpg     = "s",
        perfect = "",
    },
    [changpaiStyle.modern] = {
        shou    = "l",
        chu     = "_ns",
        cpg     = "s",
        perfect = "xl",
    }
}

function changpai:ctor(id)
    self.id = id

    local go = modelManager.load("changpai", "changpai")
    self:init(go)
    self:show()

    self.render = getComponentU(go, typeof(UnityEngine.SpriteRenderer))
    self.collider = getComponentU(go, typeof(UnityEngine.BoxCollider))

    local typ  = changpaiType[id]
    self.name  = typ.name
    self.color = typ.color
    self.value = typ.value
end

function changpai:setStyle(style)
    if self.style ~= style then
        self.style = style

        local typ = getChangpaiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:changeToShou()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.shou
        self.collider.enabled = true

        local typ = getChangpaiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:changeToChu()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.chu
        self.collider.enabled = false

        local typ = getChangpaiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:changeToCPG()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.cpg
        self.collider.enabled = false

        local typ = getChangpaiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:changeToPerfct()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.perfect
        self.collider.enabled = false

        local typ = getChangpaiTypeById(self.id)
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:changeToBack()
    if self.ctype ~= cardType.shou then
        self.ctype = cardType.back
        self.collider.enabled = false

        local typ = getChangpaiBackType()
        self:setSprite(typ.folder, typ.resource .. suffix)
    end
end

function changpai:setSprite(folder, resource)
    self:resetRender()

    local suffix = resourceSuffix[self.style][self.ctype]
    self.render.sprite = textureManager.load(folder, resource .. suffix)
end

function changpai:resetRender()
    if self.render.sprite ~= nil then
        textureManager.unload(self.render.sprite)
        self.render.sprite = nil
    end
end

function changpai:reset()
    self.id = nil
    self.style = nil
    self.ctype = nil

    self:resetRender()
    self.collider.enabled = false
end

function changpai:onDestroy()
    self:reset()
    self.super.onDestroy(self)
end

return changpai

--endregion
