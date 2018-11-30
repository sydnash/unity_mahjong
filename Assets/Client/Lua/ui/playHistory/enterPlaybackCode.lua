--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local enterPlaybackCode = class("enterPlaybackCode", base)

_RES_(enterPlaybackCode, "PlayHistoryUI", "EnterPlaybackCodeUI")

function enterPlaybackCode:ctor(callback)
    self.super.ctor(self)
    self.callback = callback

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function enterPlaybackCode:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mZero:addClickListener(self.onNum0ClickedHandler, self)
    self.mOne:addClickListener(self.onNum1ClickedHandler, self)
    self.mTwo:addClickListener(self.onNum2ClickedHandler, self)
    self.mThree:addClickListener(self.onNum3ClickedHandler, self)
    self.mFour:addClickListener(self.onNum4ClickedHandler, self)
    self.mFive:addClickListener(self.onNum5ClickedHandler, self)
    self.mSix:addClickListener(self.onNum6ClickedHandler, self)
    self.mSeven:addClickListener(self.onNum7ClickedHandler, self)
    self.mEight:addClickListener(self.onNum8ClickedHandler, self)
    self.mNine:addClickListener(self.onNum9ClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)
    self.mReset:addClickListener(self.onResetClickedHandler, self)

    self.mDisplayerSlots = { self.mDisplayerA,
                             self.mDisplayerB,
                             self.mDisplayerC,
                             self.mDisplayerD,
                             self.mDisplayerE,
                             self.mDisplayerF,
    }

    self:reset()
end

function enterPlaybackCode:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function enterPlaybackCode:onNum0ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(0)
end

function enterPlaybackCode:onNum1ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(1)
end

function enterPlaybackCode:onNum2ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(2)
end

function enterPlaybackCode:onNum3ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(3)
end

function enterPlaybackCode:onNum4ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(4)
end

function enterPlaybackCode:onNum5ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(5)
end

function enterPlaybackCode:onNum6ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(6)
end

function enterPlaybackCode:onNum7ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(7)
end

function enterPlaybackCode:onNum8ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(8)
end

function enterPlaybackCode:onNum9ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(9)
end

function enterPlaybackCode:onNumberClickedHandler(num)
    local slotIndex = #self.numbers

    if slotIndex < 6 then
        table.insert(self.numbers, num)
        self.mDisplayerSlots[slotIndex + 1]:setText(tostring(num))

        if slotIndex + 1 == 6 then
            self:enter()
        end
    end
end

function enterPlaybackCode:onDeleteClickedHandler()
    playButtonClickSound()

    local length = #self.numbers
    if length <= 0 then
        return
    end
    self.mDisplayerSlots[length]:setText("")

    table.remove(self.numbers)
end

function enterPlaybackCode:onResetClickedHandler()
    playButtonClickSound()
    self:reset()
end

function enterPlaybackCode:enter()
    local shareId = 0
    for _, v in pairs(self.numbers) do
        shareId = shareId * 10 + tonumber(v)
    end

    self:reset()
    --拉取回放数据并回放
    showWaitingUI("正在拉取回放数据")
    networkManager.getSharePlayHistory(shareId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        local history = msg.History
        if msg.RetCode ~= 0 or history.PlayDetail == nil or history.PlayDetail[1] == nil or history.PlayDetail[1] == "" then
            showMessageUI(string.format("分享码[%d]已经失效", shareId))
            return
        end
        
        local playback = table.fromjson(history.PlayDetail[1])
        for k, v in pairs(playback) do
            playback[k] = table.fromjson(v)
            playback[k].Payload = table.fromjson(playback[k].Payload)
        end
        local round = msg.Round + 1

        history.PlaybackMsg = {}
        history.PlaybackMsg[round] = playback
        history.PlayDetail = nil

        local loading = require("ui.loading").new()
        loading:show()

        sceneManager.load("scene", "mahjongscene", function(completed, progress)
            loading:setProgress(progress)

            if completed then
                local data = {}
                data.ClubId             = history.ClubId
                data.Config             = table.fromjson(history.DeskConfig)
                data.Creator            = 0
                data.DeskId             = history.DeskId
                data.ExitVoteProposer   = 0
                data.GameType           = history.GameType
                data.IsInExitVote       = false
                data.LeftTime           = data.Config.JuShu - round
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
                game:startLoop()

                loading:close()
            end
        end)

        self:close()
    end)
end

function enterPlaybackCode:reset()
    self.numbers = {}

    for _, v in pairs(self.mDisplayerSlots) do
        v:setText("")
    end
end

function enterPlaybackCode:onCloseAllUIHandler()
    self:close()
end

function enterPlaybackCode:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return enterPlaybackCode

--endregion
