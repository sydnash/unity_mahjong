--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local playbackSetting = class("playbackSetting", base)

_RES_(playbackSetting, "SettingUI", "PlaybackSettingUI")

function playbackSetting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function playbackSetting:onInit()
    self.super.onInit(self)
    self.mOver:addClickListener(self.onOverClickedHandler, self)
end

function playbackSetting:onOverClickedHandler()
    self.game:exitPlayback()
    playButtonClickSound()
end

function playbackSetting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return playbackSetting

--endregion
