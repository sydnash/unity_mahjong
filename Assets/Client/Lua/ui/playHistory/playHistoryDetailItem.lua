--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local playHistoryDetailItem = class("playHistoryDetailItem", base)

_RES_(playHistoryDetailItem, "PlayHistoryUI", "PlayHistoryDetailItem")

local scoreColor = {
    win         = hexColorToColor("d2752aff"),
    failed      = hexColorToColor("3380caff"),
    draw        = hexColorToColor("a66742ff"),
}
local resultText = {
    [scoreColor.win]    = "赢",
    [scoreColor.failed] = "输",
    [scoreColor.draw]   = "平",
}

function playHistoryDetailItem:onInit()
    self.mScores = {
        self.mScore1,
        self.mScore2,
        self.mScore3,
        self.mScore4,
    }
    self.mPlay:addClickListener(self.onPlayClickHandler, self)
    self.mShare:addClickListener(self.onShareClickHandler, self)
end

function playHistoryDetailItem:onShareClickHandler()
    showWaitingUI("正在生成分享回放码")
    networkManager.sharePlayHistory(self.mHistoryId, self.mRound - 1, function(msg)
        closeWaitingUI()

        if not msg then
            showMessageUI("网络错误")
            return
        end

        if msg.RetCode ~= retc.ok or msg.ShareId == nil or msg.ShareId == 0 then
            showMessageUI("对战详情数据已经不存在")
            return
        end

        log("shareId = " .. tostring(msg.ShareId))

        local title = string.format("战绩回放查看码:%d", msg.ShareId)
        local desc = "打开主页战绩界面，点击查看他人回放，输入战绩查看码即可观看回放。"
        local url = appConfig.shareUrl
        
        local image = textureManager.load(string.empty, "appicon")
        if image ~= nil then
            platformHelper.shareUrlWx(title,
                                      desc,
                                      networkConfig.server.shareURL,
                                      image,
                                      false)
        end
    end)
end

function playHistoryDetailItem:onPlayClickHandler()
    showWaitingUI("正在拉取回放数据，请稍候...")
    self.historyContainer:getPlayDetail(self.mHistoryId, self.mRound, function(ok, msg)
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

        local data = {}
        local history = self.historyContainer:findHistoryById(self.mHistoryId)
        data.ClubId             = history.ClubId
        data.Config             = table.fromjson(history.DeskConfig)
        data.Creator            = 0
        data.DeskId             = history.DeskId
        data.ExitVoteProposer   = 0
        data.GameType           = history.GameType
        data.IsInExitVote       = false
        data.LeftTime           = data.Config.JuShu - self.mRound + 1
        data.LeftVoteTime       = 0
        data.Ready              = true
        data.Players            = history.Players
        data.Turn               = 0
        data.historyId          = self.mHistoryId

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

        local cityType = data.GameType
        local gameType = data.Config.Game

        local support, errText = checkGame(cityType, gameType)
        if not support then
            showMessageUI(errText)
        else
            closeAllUI()
        
            clientApp.currentDesk = getLogicGame(cityType, gameType).new(data, playback)
            clientApp.currentDesk:startLoop()
        end
    end)
end

function playHistoryDetailItem:set(data, round, historyId, historyContainer)
    for _, v in pairs(self.mScores) do
        v:hide()
    end
    self.mResult:hide()
    self.historyContainer = historyContainer
    self.mHistoryId = historyId
    self.mRound = round

    local data = table.fromjson(data)
    local selfResult = nil
    for i = 1, #data do
        local score = data[i].Score
        local ui = self.mScores[i]
        ui:show()

        local c = nil
        if score > 0 then
            ui:setText("+" .. tostring(score))
            c = scoreColor.win
        elseif score == 0 then
            ui:setText(tostring(score))
            c = scoreColor.draw
        else
            ui:setText(tostring(score))
            c = scoreColor.failed
        end
        if data[i].AcId == gamepref.player.acId then
            self.mResult:show()
            self.mResult:setColor(c)
            self.mResult:setText(resultText[c])
        end
        ui:setColor(c)
    end

    self.mIndex:setText(string.format("第%d局", self.mRound))
end

function playHistoryDetailItem:onDestroy()
    base.onDestroy(self)
end

return playHistoryDetailItem

--endregion
