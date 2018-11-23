--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playHistory = class("playHistory", base)

_RES_(playHistory, "PlayHistory", "PlayHistory")

function playHistory:onInit()
    self:refreshUI()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playHistory:onCloseClickedHandler()
    playButtonClickSound()

    self:close()
    signalManager.signal(signalType.mail)
end

function playHistory:refreshUI()
    local histories = gamepref.player.playHistory:getData()
    local count = #histories

    if count <= 0 then
        self.mEmpty:show()
    else
        self.mEmpty:hide()

        local createItem = function()
            return require("ui.playHistory.playHistoryItem").new()
        end

        local refreshItem = function(item, index)
            item:set(histories[index + 1])
        end

        self.mList:reset()
        self.mList:set(count, createItem, refreshItem)
    end
end

function playHistory:onCloseAllUIHandler()
    self:close()
end

function playHistory:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return playHistory

--endregion
