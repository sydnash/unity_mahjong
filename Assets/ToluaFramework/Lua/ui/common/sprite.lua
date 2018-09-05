--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local sprite = class("sprite", base)

local UISprite = UnityEngine.UI.Sprite

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UISprite))
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

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:setSprite(spriteName)
    self.component.spriteName = spriteName
end

return sprite

--endregion
