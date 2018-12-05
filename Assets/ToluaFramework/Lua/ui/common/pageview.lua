--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local pageview = class("pageview", base)

local UIPageView = PageView

----------------------------------------------------------------
--
----------------------------------------------------------------
function pageview:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(UIPageView))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pageview:addChangedListener(handler, target)
    self.component:AddListener(function(pageIndex)
        handler(target, pageIndex)
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function pageview:reset()
    self.component:Reset()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function pageview:onDestroy()
    self.component:RemoveAllListeners()
end

return pageview

--endregion
