--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local toggle = class("toggle", base)

local UIToggle = UnityEngine.UI.CxToggle

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIToggle))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:setSelected(selected)
    self.component.isOn = selected
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:getSelected()
    return self.component.isOn
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function toggle:addChangedListener(handler, target)
    self.component.onValueChanged:AddListener(function()
        handler(target, self, self.component.isOn, self.component.clicked) 
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:setInteractable(interactable)
    self.component.interactable = interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:getInteractable()
    return self.component.interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:onDestroy()
    self.component.onValueChanged:RemoveAllListeners()
end

return toggle

--endregion
