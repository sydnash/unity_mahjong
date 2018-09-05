--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local image = class("image", base)

local UIImage = UnityEngine.UI.Image

----------------------------------------------------------------
--
----------------------------------------------------------------
function image:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIImage))
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
function image:setFillAmount(amount)
    self.component.fillAmount = amount
end

return image

--endregion
