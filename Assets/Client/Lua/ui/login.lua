--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local deviceConfig  = require("config.deviceConfig")

local base = require("ui.common.view")
local login = class("login", base)

_RES_(login, "LoginUI", "LoginUI")

function login:onInit()
    if deviceConfig.ismobile then
        self.mWechatLogin:show()
        self.mGuestLogin:hide()
    else
        self.mWechatLogin:hide()
        self.mGuestLogin:show()
    end

    self.mWechatLogin:addClickListener(self.onWechatLoginClickedHandler, self)
    self.mGuestLogin:addClickListener(self.onGuestLoginClickedHandler, self)
    self.mAgreement:addChangedListener(self.onAgreementChangedHandler, self)
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

function login:onAgreementChangedHandler(selected)
    self.mWechatLogin:setInteractabled(selected)
    self.mGuestLogin:setInteractabled(selected)
end

return login

--endregion
