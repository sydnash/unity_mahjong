--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local horizontal = class("horizontal", base)

local UIHorizontalLayoutGroup = UnityEngine.UI.HorizontalLayoutGroup

----------------------------------------------------------------
--
----------------------------------------------------------------
function horizontal:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIHorizontalLayoutGroup))
end

function horizontal:setSpacing(spacing)
    self.component.spacing = spacing
end

return horizontal

--endregion
