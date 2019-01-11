local base = require("ui.common.panel")

local lockSettingChosedItem = class("lockSettingChosedItem", base)

function lockSettingChosedItem:onInit()
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)
end

function lockSettingChosedItem:setGameType(gameType, name, callback)
    self.gameType = gameType
    self.mName:setText(name)
    self.mStatus:hide()
    self.callback = callback
end

function lockSettingChosedItem:onDeleteClickedHandler()
    self.callback(self.gameType)
end

return lockSettingChosedItem
