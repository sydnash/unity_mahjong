--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local vertical = class("vertical", base)

local UIVerticalLayoutGroup = UnityEngine.UI.VerticalLayoutGroup

----------------------------------------------------------------
--
----------------------------------------------------------------
function vertical:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIVerticalLayoutGroup))
end

function vertical:setSpacing(spacing)
    self.component.spacing = spacing
end

return vertical

--endregion
