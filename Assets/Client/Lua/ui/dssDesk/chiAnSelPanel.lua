local dssType = require("logic.dss.dssType")

local base = require("ui.common.view")

local chiAnSelItem = class("chiAnSelItem", base)
_RES_(chiAnSelItem, "DssDeskUI", "ChiAnSelItem")

function chiAnSelItem:ctor(cards, info)
    self.cards = cards
    self.info = info
    self.icons = {self.mA, self.mB, self.mC, self.mD}
    self.mBtn:addClickListener(self.onBtnClickedHandler, self)
    self.super.ctor(self)
end

function chiAnSelItem:onBtnClickedHandler()
end

function chiAnSelItem:onInit()
end

local chiAnSelPanel = class("chiAnSelPanel", base)
_RES_(chiAnSelPanel, "DssDeskUI", "ChiAnSelPanelUI")

function chiAnSelPanel:ctor(opInfo)
    self.super.ctor(self)
end

return chiAnSelPanel
