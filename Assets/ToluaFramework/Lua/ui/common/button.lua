--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local button = class("button", base)

local UIButton = UnityEngine.UI.Button

----------------------------------------------------------------
--
----------------------------------------------------------------
function button:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIButton))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function button:addClickListener(handler, target)
    self.component.onClick:AddListener(function() 
        handler(target) 
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function button:setEnabled(enabled)
    self.component.enabled = enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function button:getEnabled()
    return self.component.enabled
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function button:onDestroy()
    self.component.onClick:RemoveAllListeners()
end

return button

--endregion
