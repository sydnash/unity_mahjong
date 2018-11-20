--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local pointerButton = class("pointerButton", base)

local UIPointerButton = UnityEngine.UI.PointerButton

----------------------------------------------------------------
--
----------------------------------------------------------------
function pointerButton:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIPointerButton))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pointerButton:addDownListener(handler, target)
    self.component.onDown:AddListener(function(pos) 
        handler(target, self, pos) 
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pointerButton:addMoveListener(handler, target)
    self.component.onMove:AddListener(function(pos) 
        handler(target, self, pos) 
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pointerButton:addUpListener(handler, target)
    self.component.onUp:AddListener(function(pos) 
        handler(target, self, pos) 
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerButton:setInteractabled(interactable)
    self.component.interactable = interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerButton:getInteractabled()
    return self.component.interactable
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pointerButton:onDestroy()
    self.component.onDown:RemoveAllListeners()
    self.component.onMove:RemoveAllListeners()
    self.component.onUp:RemoveAllListeners()
end

return pointerButton

--endregion
