--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local sprite = class("sprite", base)

local UIImage  = UnityEngine.UI.Image
local UISprite = UnityEngine.UI.Sprite

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIImage))
    self.sprite = getComponentU(gameObject, typeof(UISprite))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:getWidth()
    return self.rectTransform.rect.width
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:getHeight()
    return self.rectTransform.rect.height
end

function sprite:setSize(size)
    self.sprite:SetSize(size)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:setSprite(spriteName)
    self.sprite.spriteName = spriteName
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:setColor(color)
    self.component.color = color
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:setFillAmount(amount)
    self.component.fillAmount = amount
end

return sprite

--endregion
