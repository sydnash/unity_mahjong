--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local view = class("view", base)

view.level = {
    low     = 1,
    normal  = 2,
    top     = 3,
}

local levelName = {
    [view.level.low]    = "Low",
    [view.level.normal] = "Normal",
    [view.level.top]    = "Top",
}

local levelNode = {
    [view.level.low]    = nil,
    [view.level.normal] = nil,
    [view.level.top]    = nil,
} 

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function view:ctor()
    local gameObject = viewManager.load(self._folder, self._resource)

    self:bind(gameObject)
    self:init(gameObject)
    self:setLevel(view.level.low)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function view:setLevel(level)
    local node = levelNode[level]

    if node == nil then
        local name = levelName[level]
        node = findChild(viewManager.canvas.transform, name)
        levelNode[level] = node
    end

    if node ~= nil then
        self:setParent(node)
    else
        self:setParent(viewManager.canvas)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function view:setAsLastSibling()
    self.transform:SetAsLastSibling()
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
