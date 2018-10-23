--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local friendsterStatisticsHistoryItem = class("friendsterStatisticsHistoryItem", base)

_RES_(friendsterStatisticsHistoryItem, "FriendsterUI", "FriendsterStatisticsHistoryItem")

function friendsterStatisticsHistoryItem:onInit()
    self.players = { { root = self.mPlayerA, icon = self.mPlayerA_Icon, nickname = self.mPlayerA_Nickname, score = { p = self.mPlayerA_ScoreP, n = self.mPlayerA_ScoreN }, winner = self.mPlayerA_Winner },
                     { root = self.mPlayerB, icon = self.mPlayerB_Icon, nickname = self.mPlayerB_Nickname, score = { p = self.mPlayerB_ScoreP, n = self.mPlayerB_ScoreN }, winner = self.mPlayerB_Winner },
                     { root = self.mPlayerC, icon = self.mPlayerC_Icon, nickname = self.mPlayerC_Nickname, score = { p = self.mPlayerC_ScoreP, n = self.mPlayerC_ScoreN }, winner = self.mPlayerC_Winner },
                     { root = self.mPlayerD, icon = self.mPlayerD_Icon, nickname = self.mPlayerD_Nickname, score = { p = self.mPlayerD_ScoreP, n = self.mPlayerD_ScoreN }, winner = self.mPlayerD_Winner },
    }

    for _, v in pairs(self.players) do
        v.root:hide()
        v.winner:hide()
    end
end

function friendsterStatisticsHistoryItem:set(data)
    local config = table.fromjson(data.DeskConfig)

    self.mDeskId:setText(string.format("房号:%d", data.DeskId))
    self.mId:setText(string.format("账号:%d", data.ClubId))
    self.mCount:setText(string.format("局数:%d/%d", data.PlayTimes, config.JuShu))
    self.mDatetime:setText(time.formatDateTime(data.EndTime))

    if data.Payed then
        self.mSettle:hide()
        self.mSettleOver:show()
    else
        self.mSettle:show()
        self.mSettleOver:hide()
    end

    local players = data.Players
    local scores = data.Scores

    local max = -10000000000
    for _, s in pairs(scores) do
        if s > max then 
            max = s
        end
    end

    for i=1, config.RenShu do
        local d = players[i]
        local s = scores[i]

        local g = gamePlayer.new(d.AcId)
        g.headerUrl = d.HeadUrl
        g:loadHeaderTex()
        g.nickname = d.Nickname

        local p = self.players[i]
        p.root:show()
        p.icon:setTexture(g.headerTex)
        p.nickname:setText(g.nickname)

        if s >= 0 then
            p.score.p:show()
            p.score.n:hide()
            p.score.p:setText(string.format("+%d", s))
        else
            p.score.p:hide()
            p.score.n:show()
            p.score.n:setText(tostring(s))
        end

        if s == max then
            p.winner:show()
        end
    end
end

function friendsterStatisticsHistoryItem:onDestroy()
    for _, v in pairs(self.players) do
        local tex = v.icon:getTexture()
        if tex ~= nil then
            textureManager.unload(tex, true)
            v.icon:setTexture(nil)
        end
    end

    self.super.onDestroy(self)
end

return friendsterStatisticsHistoryItem

--endregion
