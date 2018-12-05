--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local setting = class("setting", base)

_RES_(setting, "SettingUI", "SettingUI")

function setting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function setting:onInit()
    self.mBgmVolume:setValue(gamepref.getBGMVolume())
    self.mSfxVolume:setValue(gamepref.getSFXVolume())

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mBgmVolume:addChangedListener(self.onBGMVolumeChangedHandler, self)
    self.mSfxVolume:addChangedListener(self.onSFXVolumeChangedHandler, self)

    if self.game == nil then
        self:setLocalPosition(Vector3.New(0, -90, 0))
        self.mLobby:show()
        self.mDesk:hide()
        self.mPlayback:hide()

        self.mExit:addClickListener(self.onExitClickedHandler, self)
    elseif self.game.mode == gameMode.playback then
        self:setLocalPosition(Vector3.New(0, -90, 0))
        self.mLobby:hide()
        self.mDesk:hide()
        self.mPlayback:show()

        self.mOver:addClickListener(self.onOverClickedHandler, self)
    else
        self:setLocalPosition(Vector3.New(0, -8, 0))
        self.mLobby:hide()
        self.mDesk:show()
        self.mPlayback:hide()

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

        if self.game:isCreator(gamepref.player.acId) or self.game:isPlaying() then
            self.mDissolveText:setSprite("js")
        else
            self.mDissolveText:setSprite("tc")
        end

        if self.game:canBackToLobby() then
            self.mBack:setInteractabled(true)
            self.mBackText:setSprite("enable")
        else
            self.mBack:setInteractabled(false)
            self.mBackText:setSprite("disable")
        end

        self.mMandarin:addChangedListener(self.onMandarinChangedHandler, self)
        self.mSichuan:addChangedListener(self.onSichuanChangedHandler, self)
        self.m3DModel:addChangedListener(self.on3DModelChangedHandler, self)
        self.mWechatHeader:addChangedListener(self.onWechatHeaderChangedHandler, self)
        self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
        self.mBack:addClickListener(self.onBackClickedHandler, self)
    end

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

function setting:onExitClickedHandler()
    networkManager.disconnect()
    closeAllUI()

    local ui = require("ui.login").new()
    ui:show()

    playButtonClickSound()
end

function setting:onOverClickedHandler()
    self.game:exitPlayback()
    playButtonClickSound()
end

function setting:onMandarinChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(language.mandarin)
        end

        playButtonClickSound()
    end
end

function setting:onSichuanChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(language.sichuan)
        end

        playButtonClickSound()
    end
end

function setting:on3DModelChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            --
        end

        playButtonClickSound()
    end
end

function setting:onWechatHeaderChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            --
        end

        playButtonClickSound()
    end
end


function setting:onDissolveClickedHandler()
    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end

    playButtonClickSound()
end

function setting:onBackClickedHandler()
    if self.game ~= nil then
        self.game:exitGame()
    end

    self:close()
    playButtonClickSound()
end

function setting:onCloseAllUIHandler()
    self:close()
end

function setting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return setting

--endregion
