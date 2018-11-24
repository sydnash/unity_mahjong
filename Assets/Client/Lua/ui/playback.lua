--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playback = class("playback", base)

_RES_(playback, "PlaybackUI", "PlaybackUI")

function playback:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function playback:onInit()
    self.mPlay:hide()
    self.mPause:show()

    self.mPlay:addClickListener(self.onPlayClickedHandler, self)
    self.mPause:addClickListener(self.onPauseClickedHandler, self)
    self.mPlay:addClickListener(self.onPlayClickedHandler, self)
    self.mPlay:addClickListener(self.onPlayClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playback:onPlayClickedHandler()
    playButtonClickSound()
    self.game:startPlayback()

    self.mPlay:hide()
    self.mPause:show()
end

function playback:onPauseClickedHandler()
    playButtonClickSound()
    self.game:stopPlayback()

    self.mPlay:show()
    self.mPause:hide()
end

function playback:onCloseAllUIHandler()
    self:close()
end

function playback:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end 

return playback

--endregion
