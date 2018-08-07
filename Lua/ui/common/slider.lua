--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local slider = class("slider", base)

local UISlider = UnityEngine.UI.Slider

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UISlider))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:setValue(value)
    self.component.value = value
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:getValue(value)
    return self.component.value
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:addChangedListener(handler, target)
    self.component.onValueChanged:AddListener(function()
        handler(target, self:getValue())
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:setEnabled(enabled)
    self.component.enabled = enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:getEnabled()
    return self.component.enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function slider:onDestroy()
    self.component.onValueChanged:RemoveAllListeners()
end

return slider

--endregion
