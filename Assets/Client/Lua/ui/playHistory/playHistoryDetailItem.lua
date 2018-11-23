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
    showWaitingUI("正在拉取回放数据，请稍候...")

    gamepref.player.playHistory:getPlayDetail(self.mHistoryId, self.mRound, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("拉取回放数据失败，请稍后重试")
            return
        end

        if msg == nil then
            showMessageUI("回放数据已经过期")
            return
        end

        local playback = table.fromjson(msg)
        for k, v in pairs(playback) do
            playback[k] = table.fromjson(v)
            playback[k].Payload = table.fromjson(playback[k].Payload)
        end

        log("playback data = " .. table.tostring(playback))

        local loading = require("ui.loading").new()
        loading:show()

        sceneManager.load("scene", "mahjongscene", function(completed, progress)
            loading:setProgress(progress)

            if completed then
                local data = {}

                local game = require("logic.mahjong.mahjongGame").new(data, playback)
                loading:close()
            end
        end)
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
