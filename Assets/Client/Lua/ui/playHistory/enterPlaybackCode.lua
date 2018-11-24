--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local enterPlaybackCode = class("enterPlaybackCode", base)

_RES_(enterPlaybackCode, "PlayHistory", "EnterPlaybackCodeUI")

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

    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
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
        if not msg then
            showMessageUI("网络错误")
            return
        end
        local history = msg.History
        if msg.RetCode ~= 0 or history.PlayDetail == nil or history.PlayDetail[1] == nil or history.PlayDetail[1] == "" then
            showMessageUI(string.format("分享码:%d已经失效", shareId))
            return
        end
        history.PlaybackMsg = {}
        local round = msg.Round + 1
        history.PlaybackMsg[round] = history.PlayDetail[1]
        history.PlayDetail = nil

        --history  round 然后进入回放
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
