--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local sprite = class("sprite", base)

local UIImage = UnityEngine.UI.Image

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIImage))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function sprite:setFillAmount(amount)
    assert(self.component ~= nil, "")
    self.component.fillAmount = amount
end

return sprite

--endregion
