--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playHistoryDetail = class("playHistoryDetail", base)

_RES_(playHistoryDetail, "PlayHistory", "PlayHistoryDetail")

function playHistoryDetail:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playHistoryDetail:onCloseClickedHandler()
    playButtonClickSound()

    self:close()
end

function playHistoryDetail:setHistory(historyId)
    self.mHistoryId = historyId
    local history = gamepref.player.playHistory:findHistoryById(historyId)

    local count = #histories

    if count <= 0 then
        self.mEmpty:show()
    else
        self.mEmpty:hide()

        local createItem = function()
            return require("ui.playHistoryDetail.playHistoryDetailItem").new()
        end

        local refreshItem = function(item, index)
            item:set(histories[index + 1])
        end

        self.mList:reset()
        self.mList:set(count, createItem, refreshItem)
    end
end

function playHistoryDetail:onCloseAllUIHandler()
    self:close()
end

function playHistoryDetail:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return playHistoryDetail

--endregion
