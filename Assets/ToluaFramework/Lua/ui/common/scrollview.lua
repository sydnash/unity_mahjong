--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local scrollview = class("scrollview", base)

local UIScrollView = StingyScrollRect

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollview:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIScrollView))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollview:set(capacity, itemInstantiateCallback, itemRefreshCallback)
    self.component:Init(capacity, itemInstantiateCallback, itemRefreshCallback)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollview:reset()
    self.component:Reset()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function scrollview:getItems()
    return self.component.items
end

return scrollview

--endregion
