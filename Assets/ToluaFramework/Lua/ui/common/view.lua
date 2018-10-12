--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local view = class("view", base)

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function view:ctor()
    local gameObject = viewManager.load(self._folder, self._resource)

    self:bind(gameObject)
    self:init(gameObject)
    self:setParent(viewManager.canvas)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function view:close()
    viewManager.unload(self)
    self:destroy()
end

return view

--endregion
