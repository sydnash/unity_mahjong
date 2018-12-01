--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local enterDesk = class("enterDesk", base)

_RES_(enterDesk, "EnterDeskUI", "EnterDeskUI")

function enterDesk:ctor(callback)
    self.super.ctor(self)
    self.callback = callback
end

function enterDesk:onInit()
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

function enterDesk:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function enterDesk:onNum0ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(0)
end

function enterDesk:onNum1ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(1)
end

function enterDesk:onNum2ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(2)
end

function enterDesk:onNum3ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(3)
end

function enterDesk:onNum4ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(4)
end

function enterDesk:onNum5ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(5)
end

function enterDesk:onNum6ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(6)
end

function enterDesk:onNum7ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(7)
end

function enterDesk:onNum8ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(8)
end

function enterDesk:onNum9ClickedHandler()
    playButtonClickSound()
    self:onNumberClickedHandler(9)
end

function enterDesk:onNumberClickedHandler(num)
    local slotIndex = #self.numbers

    if slotIndex < 6 then
        table.insert(self.numbers, num)
        self.mDisplayerSlots[slotIndex + 1]:setText(tostring(num))

        if slotIndex + 1 == 6 then
            self:enter()
        end
    end
end

function enterDesk:onDeleteClickedHandler()
    playButtonClickSound()

    local length = #self.numbers
    if length > 0 then
        self.mDisplayerSlots[length]:setText(string.empty)
        table.remove(self.numbers)
    end
end

function enterDesk:onResetClickedHandler()
    playButtonClickSound()
    self:reset()
end

function enterDesk:enter()
    local deskId = 0
    for _, v in pairs(self.numbers) do
        deskId = deskId * 10 + tonumber(v)
    end

    self:close()

    if self.callback ~= nil then
        self.callback(deskId)
    end
end

function enterDesk:reset()
    self.numbers = {}

    for _, v in pairs(self.mDisplayerSlots) do
        v:setText(string.empty)
    end
end

function enterDesk:onCloseAllUIHandler()
    self:close()
end

function enterDesk:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return enterDesk

--endregion
