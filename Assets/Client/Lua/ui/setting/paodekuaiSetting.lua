--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local paodekuaiSetting = class("paodekuaiSetting", base)

_RES_(paodekuaiSetting, "SettingUI", "PaodekuaiSettingUI")

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


function paodekuaiSetting:ctor(game)
    self.game = game
    base.ctor(self)
end

function paodekuaiSetting:onInit()
    base.onInit(self)

    local lan = gamepref.getLanguage(gameType.paodekuai)

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

    local tbl = gamepref.getTablecloth(gameType.paodekuai)

    initLable(self.mGreen)
    initLable(self.mBlue)
    setTextColor(self.mGreen, false)
    setTextColor(self.mBlue, false)

    if tbl == tablecloth.paodekuai.qsl then
        self.mBlue:setSelected(false)
        self.mGreen:setSelected(true)
        setTextColor(self.mGreen, true)
    else
        self.mGreen:setSelected(false)
        self.mBlue:setSelected(true)
        setTextColor(self.mBlue, true)
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
    self.mGreen:addChangedListener(self.onGreenChangedHandler, self)
    self.mBlue:addChangedListener(self.onBlueChangedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mBack:addClickListener(self.onBackClickedHandler, self)
end

function paodekuaiSetting:onMandarinChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(gameType.paodekuai, language.mandarin)
            setTextColor(self.mMandarin, true)
            setTextColor(self.mSichuan, false)
        end

        playButtonClickSound()
    end
end

function paodekuaiSetting:onSichuanChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(gameType.paodekuai, language.sichuan)
            setTextColor(self.mMandarin, false)
            setTextColor(self.mSichuan, true)
        end

        playButtonClickSound()
    end
end

function paodekuaiSetting:onBlueChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
           self.game.operationUI:changeBG(tablecloth.paodekuai.bsl)
           gamepref.setTablecloth(gameType.paodekuai, tablecloth.paodekuai.bsl)
        end

        setTextColor(self.mGreen, false)
        setTextColor(self.mBlue, true)

        playButtonClickSound()
    end
end

function paodekuaiSetting:onGreenChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
           self.game.operationUI:changeBG(tablecloth.paodekuai.qsl)
           gamepref.setTablecloth(gameType.paodekuai, tablecloth.paodekuai.qsl)
        end

        setTextColor(self.mGreen, true)
        setTextColor(self.mBlue, false)

        playButtonClickSound()
    end
end

function paodekuaiSetting:onDissolveClickedHandler()
    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end

    playButtonClickSound()
end

function paodekuaiSetting:onBackClickedHandler()
    if self.game ~= nil then
        self.game:exitGame()
    end

    self:close()
    playButtonClickSound()
end

function paodekuaiSetting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return paodekuaiSetting

--endregion
