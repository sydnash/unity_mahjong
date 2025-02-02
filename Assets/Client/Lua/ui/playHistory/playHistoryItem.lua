--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local playHistoryItem = class("playHistoryItem", base)

_RES_(playHistoryItem, "PlayHistoryUI", "PlayHistoryItem")

function playHistoryItem:onInit()
    self.players = { { root = self.mPlayerA, icon = self.mPlayerA_Icon, nickname = self.mPlayerA_Nickname, score = { p = self.mPlayerA_ScoreP, n = self.mPlayerA_ScoreN }, winner = self.mPlayerA_Winner },
                     { root = self.mPlayerB, icon = self.mPlayerB_Icon, nickname = self.mPlayerB_Nickname, score = { p = self.mPlayerB_ScoreP, n = self.mPlayerB_ScoreN }, winner = self.mPlayerB_Winner },
                     { root = self.mPlayerC, icon = self.mPlayerC_Icon, nickname = self.mPlayerC_Nickname, score = { p = self.mPlayerC_ScoreP, n = self.mPlayerC_ScoreN }, winner = self.mPlayerC_Winner },
                     { root = self.mPlayerD, icon = self.mPlayerD_Icon, nickname = self.mPlayerD_Nickname, score = { p = self.mPlayerD_ScoreP, n = self.mPlayerD_ScoreN }, winner = self.mPlayerD_Winner },
    }

    self.mThis:addClickListener(self.onThisClickHandler, self)
end

function playHistoryItem:onThisClickHandler()
    showWaitingUI("正在拉取对战详情")
    self.historyContainer:getScoreDetail(self.mHistoryId, function(ok, data)
        closeWaitingUI()
        if not ok then
            showMessageUI("同步战绩失败")
            return
        end
        local ui = require("ui.playHistory.playHistoryDetail").new()
        ui:setHistory(self.mHistoryId, self.historyContainer)
        ui:show()
    end)

    playButtonClickSound()
end

function playHistoryItem:set(data, historyContainer)
    for _, v in pairs(self.players) do
        v.root:hide()
        v.winner:hide()
    end

    self.historyContainer = historyContainer
    local config = table.fromjson(data.DeskConfig)

    self.mDeskId:setText(string.format("房号:%d", data.DeskId))

    local cityType = data.GameType
    local gameType = config.Game
    self.mGame:setText(string.format("%s%s", cityName[cityType], gameName[cityType].games[gameType]))

    if data.ClubId > 0 then
        self.mId:setText(string.format("账号:%d", data.ClubId))
        self.mId:show()
    else
        self.mId:hide()
    end
    
    self.mCount:setText(string.format("局数:%d/%d", data.PlayTimes, config.JuShu))
    self.mDatetime:setText(time.formatDateTimeWithoutSecond(data.EndTime))
    self.mHistoryId = data.Id

    local players = data.Players
    local scores = data.Scores

    local max = -10000000000
    for _, s in pairs(scores) do
        if s > max then 
            max = s
        end
    end

    for i=1, #players do
        local d = players[i]
        local s = scores[i]

        local g = gamePlayer.new(d.AcId)
        g.headerUrl = d.HeadUrl
        g.nickname = d.Nickname

        local p = self.players[i]
        p.root:show()
        p.icon:setTexture(g.headerUrl)
        p.nickname:setText(cutoutString(g.nickname, gameConfig.nicknameMaxLength))        
        p.winner:hide()

        if s >= 0 then
            p.score.p:show()
            p.score.n:hide()
            p.score.p:setText(string.format("+%d", s))
        else
            p.score.p:hide()
            p.score.n:show()
            p.score.n:setText(tostring(s))
        end

        if s == max and s > 0 then
            p.winner:show()
        end
    end
end

function playHistoryItem:onDestroy()
    for _, v in pairs(self.players) do
        v.icon:reset()
    end

    base.onDestroy(self)
end

return playHistoryItem

--endregion
