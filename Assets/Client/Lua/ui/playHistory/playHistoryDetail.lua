--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playHistoryDetail = class("playHistoryDetail", base)

_RES_(playHistoryDetail, "PlayHistory", "PlayHistoryDetail")

function playHistoryDetail:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)

    self.mNicknames = {
        self.mNickname1,
        self.mNickname2,
        self.mNickname3,
        self.mNickname4,
    }
    for _, v in pairs(self.mNicknames) do
        v:hide()
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playHistoryDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function playHistoryDetail:setHistory(historyId)
    self.mList:reset()
    self.mHistoryId = historyId
    local history = gamepref.player.playHistory:findHistoryById(historyId)

    if history.ScoreDetail == nil or #history.ScoreDetail == 0 then
        return
    end

    local players = history.Players
    for i = 1, #players do
        self.mNicknames[i]:show()
        self.mNicknames[i]:setText(players[i].Nickname)
    end

    local details = history.ScoreDetail
    local count = #details

    local createItem = function()
        return require("ui.playHistory.playHistoryDetailItem").new()
    end

    local refreshItem = function(item, index)
        item:set(details[index + 1], index + 1, historyId)
    end

    self.mList:set(count, createItem, refreshItem)
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
