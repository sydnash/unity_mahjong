--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local language = require("const.language")
local headerType = require("const.headerType")

local base = require("ui.common.view")
local setting = class("setting", base)

_RES_(setting, "SettingUI", "SettingUI")

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

        local lan = gamepref.getLanguage()

        if lan == language.sichuan then
            self.mMandarin:setSelected(false)
            self.mSichuan:setSelected(true)
        else
            self.mMandarin:setSelected(true)
            self.mSichuan:setSelected(false)
        end

        local ht = gamepref.getHeaderType()

        if ht == headerType.td then
            self.mWechatHeader:setSelected(false)
            self.m3DModel:setSelected(true)
        else
            self.mWechatHeader:setSelected(true)
            self.m3DModel:setSelected(false)
        end

        self.mMandarin:addChangedListener(self.onMandarinChangedHandler, self)
        self.mSichuan:addChangedListener(self.onSichuanChangedHandler, self)
        self.m3DModel:addChangedListener(self.on3DModelChangedHandler, self)
        self.mWechatHeader:addChangedListener(self.onWechatHeaderChangedHandler, self)
        self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
        self.mBack:addClickListener(self.onBackClickedHandler, self)
    end
end

function setting:onCloseClickedHandler()
    playButtonClickSound()

    gamepref.save()
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

    local ui = require("ui.login").new()
    ui:show()

    networkManager.disconnect()
end

function setting:onMandarinChangedHandler(selected)
    playButtonClickSound()

    if selected then
        gamepref.setLanguage(language.mandarin)
    end
end

function setting:onSichuanChangedHandler(selected)
    playButtonClickSound()

    if selected then
        gamepref.setLanguage(language.sichuan)
    end
end

function setting:on3DModelChangedHandler(selected)
    playButtonClickSound()
end

function setting:onWechatHeaderChangedHandler(selected)
    playButtonClickSound()
end


function setting:onDissolveClickedHandler()
    playButtonClickSound()

    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end
end

function setting:onBackClickedHandler()

end

return setting

--endregion
