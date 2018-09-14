--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local image = class("image", base)

local UIRawImage = UnityEngine.UI.RawImage

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIRawImage))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:getWidth()
    return self.rectTransform.rect.width
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:getHeight()
    return self.rectTransform.rect.height
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:setTexture(texture)
    self.component.texture = texture
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:getTexture()
    return self.component.texture
end

return image

--endregion
