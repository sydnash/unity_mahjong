--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local input = class("input", base)

local UIInput = UnityEngine.UI.InputField

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function input:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIInput))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function input:setText(text)
    self.component.text = text
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function input:getText()
    return self.component.text
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function input:addChangedListener(handler, target)
    self.component.onValueChanged:AddListener(function()
        handler(target, self:getText())
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function input:onDestroy()
    self.component.onValueChanged:RemoveAllListeners()
end

return input

--endregion
