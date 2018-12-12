--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local mahjongSetting = class("mahjongSetting", base)

_RES_(mahjongSetting, "SettingUI", "MahjongSettingUI")

function mahjongSetting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function mahjongSetting:onInit()
    self.super.onInit(self)
    local lan = gamepref.getLanguage()

    if lan == language.sichuan then
        self.mMandarin:setSelected(false)
        self.mSichuan:setSelected(true)
    else
        self.mMandarin:setSelected(true)
        self.mSichuan:setSelected(false)
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
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mBack:addClickListener(self.onBackClickedHandler, self)
end

function mahjongSetting:onMandarinChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(language.mandarin)
        end

        playButtonClickSound()
    end
end

function mahjongSetting:onSichuanChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(language.sichuan)
        end

        playButtonClickSound()
    end
end

function mahjongSetting:onDissolveClickedHandler()
    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end

    playButtonClickSound()
end

function mahjongSetting:onBackClickedHandler()
    if self.game ~= nil then
        self.game:exitGame()
    end

    self:close()
    playButtonClickSound()
end

function mahjongSetting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return mahjongSetting

--endregion
