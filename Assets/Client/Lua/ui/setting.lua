--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local setting = class("setting", base)

setting.folder = "SettingUI"
setting.resource = "SettingUI"

function setting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function setting:onInit()
    self.mBgmVolume:setValue(soundManager.getBGMVolume())
    self.mSfxVolume:setValue(soundManager.getSfxVolume())

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mBgmVolume:addChangedListener(self.onBGMVolumeChangedHandler, self)
    self.mSfxVolume:addChangedListener(self.onSFXVolumeChangedHandler, self)

    if self.game == nil then
        self:setLocalPosition(Vector3.New(0, -90, 0))
        self.mLobby:show()
        self.mDesk:hide()
        self.mExit:addClickListener(self.onExitClickedHandler, self)
    else
        self:setLocalPosition(Vector3.New(0, -8, 0))
        self.mLobby:hide()
        self.mDesk:show()

        self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    end
end

function setting:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function setting:onBGMVolumeChangedHandler(value)
    soundManager.setBGMVolume(value)
end

function setting:onSFXVolumeChangedHandler(value)
    soundManager.setSfxVolume(value)
end

function setting:onExitClickedHandler()
    playButtonClickSound()
end

function setting:onDissolveClickedHandler()
    playButtonClickSound()

    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end
end

return setting

--endregion
