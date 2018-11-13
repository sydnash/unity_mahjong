--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local scrollrect = class("scrollrect", base)

local UIScrollRect = UnityEngine.UI.ScrollRect

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollrect:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIScrollRect))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollrect:reset()
    self.component.content.anchoredPosition = Vector2.zero;
end

return scrollrect

--endregion
