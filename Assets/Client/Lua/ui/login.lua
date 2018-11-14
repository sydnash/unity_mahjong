--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local login = class("login", base)

_RES_(login, "LoginUI", "LoginUI")

function login:onInit()
    self.mCityText:setSprite(cityTypeSID[gamepref.city.City])

    if deviceConfig.isMobile then
        self.mWechatLogin:show()
        self.mGuestLogin:hide()
    else
        self.mWechatLogin:hide()
        self.mGuestLogin:show()
    end

    self.mSwitchCity:addClickListener(self.onSwitchCityClickedHandler, self)
    self.mWechatLogin:addClickListener(self.onWechatLoginClickedHandler, self)
    self.mGuestLogin:addClickListener(self.onGuestLoginClickedHandler, self)
    self.mAgreement:addChangedListener(self.onAgreementChangedHandler, self)

    signalManager.registerSignalHandler(signalType.city, self.onCityChangedHandler, self)
end

function login:onSwitchCityClickedHandler()
    playButtonClickSound()

    local ui = require("ui.city").new()
    ui:show()
end

function login:onWechatLoginClickedHandler()
    playButtonClickSound()

    self.mWechatLogin:setInteractabled(false)
    self.mGuestLogin:setInteractabled(false)

    --登录服务器
    loginServer(function(ok)
        self.mWechatLogin:setInteractabled(true)
        self.mGuestLogin:setInteractabled(true)

        if ok then
            self:close()
        end
    end)
end

function login:onGuestLoginClickedHandler()
    playButtonClickSound()

    self.mWechatLogin:setInteractabled(false)
    self.mGuestLogin:setInteractabled(false)
    --登录服务器
    loginServer(function(ok)
        self.mWechatLogin:setInteractabled(true)
        self.mGuestLogin:setInteractabled(true)

        if ok then
            self:close()
        end
    end)
end

function login:onAgreementChangedHandler(sender, selected, clicked)
    self.mWechatLogin:setInteractabled(selected)
    self.mGuestLogin:setInteractabled(selected)
end

function login:onCityChangedHandler(city)
    self.mCityText:setSprite(cityTypeSID[city])
end

function login:onDestroy()
    signalManager.unregisterSignalHandler(signalType.city, self.onCityChangedHandler, self)
    self.super.onDestroy(self)
end

return login

--endregion
