local doushisiType = require("logic.doushisi.doushisiType")

local base = require("ui.common.view")

local chiAnSelItem = class("chiAnSelItem", base)
_RES_(chiAnSelItem, "DssDeskUI", "ChiAnSelItem")

function chiAnSelItem:ctor(cards, info, cb)
    self.cards = cards
    self.info = info
    self.cb = cb
    self.super.ctor(self)
end

function chiAnSelItem:onBtnClickedHandler()
    if self.cb then
        self.cb(info)
    end
end

function chiAnSelItem:onInit()
    self.icons = {self.mA, self.mB, self.mC, self.mD}
    self.mBtn:addClickListener(self.onBtnClickedHandler, self)
    for _, v in pairs(self.icons) do
        v:hide()
    end
    for i, c in pairs(self.cards) do
        local id = doushisiType.getDoushisiTypeId(c)
        local icon = self.icons[i]
        self.icons[i]:show()
        self.icons[i]:setSprite(tostring(id))
    end
end

local chiSelPanel = class("chiSelPanel", base)
_RES_(chiSelPanel, "DssDeskUI", "ChiAnSelPanelUI")

function chiSelPanel:ctor(opInfo, callback)
    self.opInfo = opInfo
    self.callback = callback
    self.super.ctor(self)
end

function chiSelPanel:onInit()
    local opInfo = self.opInfo
    local items = {}
    for i, c in pairs(self.opInfo.Cards) do
        local info = {c = c}
        if #opInfo.HasTy <= i then
            info.hasTy = opInfo.HasTy[i]
        end
        if #opInfo.HasWarning <= i then
            info.hasWarning = opInfo.HasWarning[i]
        end
        local item = chiAnSelItem.new({self.opInfo.Card, c}, info, function(info)
            self:onChosed(info)
        end)
        table.insert(items, item)
        item:setParent(self.mThis)
    end
    self.items = items
end

function chiSelPanel:onChosed(info)
    if self.callback then
        self.callback(info)
    end
end

function chiSelPanel:onDestroy()
    for _, item in pairs(self.items) do
        item:close()
    end
    self.super.onDestroy(self)
end

local anSelPanel = class("ANSelPanel", base)
_RES_(chiSelPanel, "DssDeskUI", "ChiAnSelPanelUI")

function anSelPanel:ctor(opInfo, callback)
    self.opInfo = opInfo
    self.callback = callback
    self.super.ctor(self)
end

function anSelPanel:onInit()
    local opInfo = self.opInfo
    local items = {}
    for i, c in pairs(self.opInfo.Cards) do
        local info = {c = c}
        if #opInfo.HasTy <= i then
            info.hasTy = opInfo.HasTy[i]
        end
        if #opInfo.HasWarning <= i then
            info.hasWarning = opInfo.HasWarning[i]
        end
        local cards = {c, c, c}
        if info.hasTy then
            table.insert(cards, c)
        end
        local item = chiAnSelItem.new(cards, info, function(info)
            self:onChosed(info)
        end)
        table.insert(items, item)
        item:setParent(self.mThis)
    end
    self.items = items
end

function anSelPanel:onChosed(info)
    if self.callback then
        self.callback(info)
    end
end

function anSelPanel:onDestroy()
    for _, item in pairs(self.items) do
        item:close()
    end
    self.super.onDestroy(self)
end


local baGangSelPanel = class("baGangSelPanel", base)
_RES_(chiSelPanel, "DssDeskUI", "ChiAnSelPanelUI")

function baGangSelPanel:ctor(opInfo, callback)
    self.opInfo = opInfo
    self.callback = callback
    self.super.ctor(self)
end

function baGangSelPanel:onInit()
    local opInfo = self.opInfo
    local items = {}
    for i, c in pairs(self.opInfo.Cards) do
        local info = {c = c}
        if #opInfo.HasTy <= i then
            info.hasTy = opInfo.HasTy[i]
        end
        if #opInfo.HasWarning <= i then
            info.hasWarning = opInfo.HasWarning[i]
        end
        local cards = {c}
        local item = chiAnSelItem.new(cards, info, function(info)
            self:onChosed(info)
        end)
        table.insert(items, item)
        item:setParent(self.mThis)
    end
    self.items = items
end

function baGangSelPanel:onChosed(info)
    if self.callback then
        self.callback(info)
    end
end

function baGangSelPanel:onDestroy()
    for _, item in pairs(self.items) do
        item:close()
    end
    self.super.onDestroy(self)
end


local chiAnSelPanel = {}
function chiAnSelPanel.newChiSelPanel(opInfo, callback)
    return chiSelPanel.new(opInfo, callback)
end
function chiAnSelPanel.newAnSelPanel(opInfo, callback)
    return anSelPanel.new(opInfo, callback)
end
function chiAnSelPanel.newBaGangSelPanel(opInfo, callback)
    return baGangSelPanel.new(opInfo, callback)
end

return chiAnSelPanel
