local base = require("ui.common.panel")

local lockSettingNotChosedItem = class("lockSettingNotChosedItem", base)

function lockSettingNotChosedItem:onInit()
    self.mChose:addClickListener(self.onDeleteClickedHandler, self)
end

function lockSettingNotChosedItem:setGameType(gameType, name, callback)
    self.gameType = gameType
    self.mName:setText(name)
    self.callback = callback
end

function lockSettingNotChosedItem:onDeleteClickedHandler()
    self.callback(self.gameType)
end

return lockSettingNotChosedItem
