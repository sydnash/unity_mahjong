--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local mahjongSetting = class("mahjongSetting", base)

_RES_(mahjongSetting, "SettingUI", "MahjongSettingUI")

local LABEL_S_COLOR = Color.New(12  / 255, 138 / 255, 33 / 255, 1)
local LABEL_U_COLOR = Color.New(146 / 255, 84  / 255, 46 / 255, 1)

local function setTextColor(node, selection)
    if node.label then
        node.label:setColor(selection and LABEL_S_COLOR or LABEL_U_COLOR)
    end
end

local function initLable(node)
    node.label = findText(node.transform, "Label")
end


function mahjongSetting:ctor(game)
    self.game = game
    base.ctor(self)
end

function mahjongSetting:onInit()
    base.onInit(self)
    local lan = gamepref.getLanguage()

    initLable(self.mMandarin)
    initLable(self.mSichuan)
    setTextColor(self.mSichuan, false)
    setTextColor(self.mMandarin, false)
    if lan == language.sichuan then
        self.mMandarin:setSelected(false)
        self.mSichuan:setSelected(true)
        setTextColor(self.mSichuan, true)
    else
        self.mMandarin:setSelected(true)
        self.mSichuan:setSelected(false)
        setTextColor(self.mMandarin, true)
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
            setTextColor(self.mMandarin, true)
            setTextColor(self.mSichuan, false)
        end

        playButtonClickSound()
    end
end

function mahjongSetting:onSichuanChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(language.sichuan)
            setTextColor(self.mMandarin, false)
            setTextColor(self.mSichuan, true)
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
    base.onDestroy(self)
end

return mahjongSetting

--endregion
