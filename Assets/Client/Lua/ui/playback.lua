--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playback = class("playback", base)

_RES_(playback, "PlaybackUI", "PlaybackUI")

function playback:ctor(game)
    self.game  = game
    self.speed = 1

    base.ctor(self)
end

function playback:onInit()
    self.mPlay:hide()
    self.mPause:show()

    self.game.messageHandlers:setSpeed(self.speed)

    self.mPlay:addClickListener(self.onPlayClickedHandler, self)
    self.mPause:addClickListener(self.onPauseClickedHandler, self)
    self.mSlow:addClickListener(self.onSlowClickedHandler, self)
    self.mQuick:addClickListener(self.onQuickClickedHandler, self)

    local speedText = tostring(self.speed) .. "倍速"
    self.mSpeedL:setText(speedText)
    self.mSpeedR:setText(speedText)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playback:onPlayClickedHandler()
    self.game:startPlayback()

    self.mPlay:hide()
    self.mPause:show()

    playButtonClickSound()
end

function playback:onPauseClickedHandler()
    self.game:stopPlayback()

    self.mPlay:show()
    self.mPause:hide()

    playButtonClickSound()
end

function playback:onSlowClickedHandler()
    self.speed = math.max(0.2, self.speed - 0.2)
    self.game:setMessageSpeed(self.speed)

    local speedText = tostring(self.speed) .. "倍速"
    self.mSpeedL:setText(speedText)
    self.mSpeedR:setText(speedText)

    playButtonClickSound()
end

function playback:onQuickClickedHandler()
    self.speed = math.min(2, self.speed + 0.2)
    self.game:setMessageSpeed(self.speed)

    local speedText = tostring(self.speed) .. "倍速"
    self.mSpeedL:setText(speedText)
    self.mSpeedR:setText(speedText)

    playButtonClickSound()
end

function playback:onCloseAllUIHandler()
    self:close()
end

function playback:onDestroy()
    self.speed = 1
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end 

return playback

--endregion
