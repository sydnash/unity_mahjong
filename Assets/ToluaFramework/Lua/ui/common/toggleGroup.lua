--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local toggleGroup = class("toggleGroup", base)

local UIToggleGroup = UnityEngine.UI.ToggleGroup

----------------------------------------------------------------
--
----------------------------------------------------------------
function toggleGroup:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIToggleGroup))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function toggleGroup:allowSwitchOff(switchOff)
    self.component.allowSwitchOff = switchOff
end

return toggleGroup

--endregion
