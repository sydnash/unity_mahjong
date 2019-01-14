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
    self.listeners = {}
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
    if #self.listeners == 0 then
        self.component.onValueChanged:AddListener(function()
            self.component.graphic.gameObject:SetActive(self.component.isOn)
            local isClicked = self.component.clicked
            self.component.clicked = false
            for _, func in pairs(self.listeners) do
                func(self.component.isOn, isClicked)
            end
        end)
    end
    table.insert(self.listeners, function(isOn, isClicked)
        handler(target, self, isOn, isClicked)
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
    self:removeAllListeners()
end

function pointerToggle:removeAllListeners()
    self.component.onValueChanged:RemoveAllListeners()
    self.listeners = {}
end

return pointerToggle

--endregion


--endregion
