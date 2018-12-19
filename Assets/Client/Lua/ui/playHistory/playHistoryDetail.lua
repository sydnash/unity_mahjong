--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playHistoryDetail = class("playHistoryDetail", base)

_RES_(playHistoryDetail, "PlayHistoryUI", "PlayHistoryDetailUI")

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

    self.mResult:hide()
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playHistoryDetail:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function playHistoryDetail:setHistory(historyId, historyContainer)
    self.historyContainer = historyContainer
    self.mList:reset()
    self.mHistoryId = historyId
    local history = self.historyContainer:findHistoryById(historyId)

    if history.ScoreDetail == nil or #history.ScoreDetail == 0 then
        return
    end

    local players = history.Players
    for i = 1, #players do
        self.mNicknames[i]:show()
        self.mNicknames[i]:setText(players[i].Nickname)
        if players[i].AcId == gamepref.player.acId then
            self.mResult:show()
        end
    end

    local details = history.ScoreDetail
    local count = #details

    local createItem = function()
        return require("ui.playHistory.playHistoryDetailItem").new()
    end

    local refreshItem = function(item, index)
        item:set(details[index + 1], index + 1, historyId, self.historyContainer)
    end

    self.mList:set(count, createItem, refreshItem)
end

function playHistoryDetail:onCloseAllUIHandler()
    self:close()
end

function playHistoryDetail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.mList:reset()
    base.onDestroy(self)
end

return playHistoryDetail

--endregion
