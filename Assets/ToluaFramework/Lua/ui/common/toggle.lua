--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local toggle = class("toggle", base)

local UIToggle = UnityEngine.UI.Toggle

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIToggle))
    self.soundName = "click"
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
function toggle:setSoundName(soundName)
    self.soundName = soundName
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function toggle:addChangedListener(handler, target)
    self.component.onValueChanged:AddListener(function()
        handler(target, self:getSelected()) 
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:setEnabled(enabled)
    self.component.enabled = enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:getEnabled()
    return self.component.enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function toggle:onDestroy()
    self.component.onValueChanged:RemoveAllListeners()
end

return toggle

--endregion
