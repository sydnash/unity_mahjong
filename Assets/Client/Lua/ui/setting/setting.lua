--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local setting = class("setting", base)

function setting:onInit()
    self.mBgmVolume:setValue(gamepref.getBGMVolume())
    self.mSfxVolume:setValue(gamepref.getSFXVolume())

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mBgmVolume:addChangedListener(self.onBGMVolumeChangedHandler, self)
    self.mSfxVolume:addChangedListener(self.onSFXVolumeChangedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function setting:onCloseClickedHandler()
    gamepref.save()
    self:close()
    playButtonClickSound()
end

function setting:onBGMVolumeChangedHandler(value)
    soundManager.setBGMVolume(value)
    gamepref.setBGMVolume(value)
end

function setting:onSFXVolumeChangedHandler(value)
    soundManager.setSFXVolume(value)
    gamepref.setSFXVolume(value)
end

function setting:onCloseAllUIHandler()
    self:close()
end

return setting

--endregion
