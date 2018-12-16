--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local pointerToggle = class("pointerToggle", base)

local UIPointerToggle = UnityEngine.UI.PointerToggle

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIPointerToggle))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:setSelected(selected)
    self.component.isOn = selected
    self.component.graphic.gameObject:SetActive(selected)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:getSelected()
    return self.component.isOn
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pointerToggle:addChangedListener(handler, target)
    self.component.onValueChanged:AddListener(function()
        self.component.graphic.gameObject:SetActive(self.component.isOn)
        handler(target, self, self.component.isOn, self.component.clicked) 
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:setInteractable(interactable)
    self.component.interactable = interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:getInteractable()
    return self.component.interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:setGroup(group)
    self.component.group = (group ~= nil) and group.component or nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerToggle:onDestroy()
    self.component.onValueChanged:RemoveAllListeners()
end

return pointerToggle

--endregion


--endregion
