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

        log("playback = " .. table.tostring(playback))

        local loading = require("ui.loading").new()
        loading:show()

        sceneManager.load("scene", "mahjongscene", function(completed, progress)
            loading:setProgress(progress)

            if completed then
                local data = {}
                local history = gamepref.player.playHistory:findHistoryById(self.mHistoryId)
                history.PlaybackMsg = ""
                log("history = " .. table.tostring(history))
                data.ClubId             = history.ClubId
                data.Config             = table.fromjson(history.DeskConfig)
                data.Creator            = 0
                data.DeskId             = history.DeskId
                data.ExitVoteProposer   = 0
                data.GameType           = history.GameType
                data.IsInExitVote       = false
                data.LeftTime           = data.Config.JuShu - self.mRound
                data.LeftVoteTime       = 0
                data.Ready              = true
                data.Players            = history.Players
                data.Turn               = 0

                for k, v in pairs(data.Players) do
                    v.Turn          = k - 1
                    v.Sex           = k % 2 + 1
                    v.IsConnected   = true
                    v.Ready         = true
                    v.IsLaoLai      = false
                    v.Score         = 0

                    if v.AcId == gamepref.player.acId then
                        data.Turn = v.Turn
                    end
                end

                closeAllUI()

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
