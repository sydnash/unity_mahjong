--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local text = class("text", base)

local UIText = UnityEngine.UI.Text

----------------------------------------------------------------
--
----------------------------------------------------------------
function text:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIText))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function text:setText(text)
    assert(self.component ~= nil, "")
    self.component.text = text
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function text:setColor(color)
    assert(self.component ~= nil, "")
    self.component.color = color
end

return text

--endregion
