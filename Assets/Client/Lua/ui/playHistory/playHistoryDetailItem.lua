--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local playHistoryDetailItem = class("playHistoryDetailItem", base)

_RES_(playHistoryDetailItem, "PlayHistory", "PlayHistoryDetailItem")

function playHistoryDetailItem:onInit()
    self.mScores = {
        self.mScore1,
        self.mScore2,
        self.mScore3,
        self.mScore4,
    }
    for _, v in pairs(self.mScores) do
        v:hide()
    end
    self.mPlay:addClickListener(self.onThisClickHandler, self)
end


function playHistoryDetailItem:onThisClickHandler()
    showWaitingUI("正在拉取回放数据")
    gamepref.player.playHistory:getPlayDetail(self.mHistoryId, self.mRound, function(ok, data)
        closeWaitingUI()
        if not ok then
            showMessageUI("拉取回放数据失败")
            return
        end
        if data == nil then
            showMessageUI("回放数据已经过期")
            return
        end
        log("play back msg : " .. data)
        -- local ui = require("ui.playHistory.playHistoryDetail").new()
        -- ui:setHistory(self.mHistoryId)
        -- ui:show()
    end)
end

function playHistoryDetailItem:set(data, round, historyId)
    self.mHistoryId = historyId
    self.mRound = round
end

function playHistoryDetailItem:onDestroy()
    self.super.onDestroy(self)
end

return playHistoryDetailItem

--endregion
