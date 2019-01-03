--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local login = class("login", base)

_RES_(login, "LoginUI", "LoginUI")

-------------------------------------------------------------------------------------------
--测试服列表代码开始
-------------------------------------------------------------------------------------------
local networkConfig = require("config.networkConfig")
local saveFile = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "serverChose.txt")
local function readServerConfig()
    local text = LFS.ReadText(saveFile, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        return {
            ["chose"] = "testServer"
        }
    end

    return loadstring(text)()
end

local function writeServerConfig(config)
    local text = "return " .. table.tostring(config)
    LFS.WriteText(saveFile, text, LFS.UTF8_WITHOUT_BOM)
end

function login:onLocalServerChangedHandler(sender, selected)
    if selected then
        self:choseLoginServer(sender.serverName)
    end
end

function login:onTestServerChangedHandler(sender, selected)
    if selected then
        self:choseLoginServer(sender.serverName)
    end
end

function login:onReleaseServerChangedHandler(sender, selected)
    if selected then
        self:choseLoginServer(sender.serverName)
    end
end

function login:choseLoginServer(name)
    self.serverConfig.chose = name
    networkConfig.setServer(networkConfig[name])
    writeServerConfig(self.serverConfig)
end

----------------------------------------------------------------------------------------------
--测试服列表代码结束
----------------------------------------------------------------------------------------------

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
    self.mUser:addClickListener(self.onUserClickedHandler, self)

    if gameConfig.serverList ~= nil then
        self.mTestNode:show()
        self.mReleaseServer:addChangedListener(self.onReleaseServerChangedHandler, self)
        self.mTestServer:addChangedListener(self.onTestServerChangedHandler, self)
        self.mLocalServer:addChangedListener(self.onLocalServerChangedHandler, self)
        self.mReleaseServer.serverName = "releaseServer"
        self.mTestServer.serverName = "testServer"
        self.mLocalServer.serverName = "localServer"

        local tmp = {
            localServer     = self.mLocalServer,
            testServer      = self.mTestServer,
            releaseServer   = self.mReleaseServer,
        }
        for k , v in pairs(tmp) do
            v:hide()
            if gameConfig.serverList[k] then
                v:show()
            end
        end
        self.serverConfig = readServerConfig()
        tmp[self.serverConfig.chose]:setSelected(true)
    end
    if gameConfig.debug and deviceConfig.isMobile then
        self.mGuestLogin:show()
        self.mWechatLogin:show()
    end

    signalManager.registerSignalHandler(signalType.city, self.onCityChangedHandler, self)

    local cacheToken = gamepref.getWXRefreshToken
    if not string.isNilOrEmpty(cacheToken) then
        self:loginWithWx()
    end
end

function login:onSwitchCityClickedHandler()
    local ui = require("ui.city").new()
    ui:show()

    playButtonClickSound()
end

function login:onWechatLoginClickedHandler()
    self:loginWithWx()
    playButtonClickSound()
end

function login:loginWithWx()
    --登录服务器
    loginServer(function(ok)
        closeWaitingUI()
        if ok then
            self:close()
        end
    end, networkManager.loginWx)
end

function login:onGuestLoginClickedHandler()
    --登录服务器
    loginServer(function(ok)
        closeWaitingUI()
        if ok then
            self:close()
        end
    end, networkManager.loginGuest)

    playButtonClickSound()
end

function login:onAgreementChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()
    end

    self.mWechatLogin:setInteractabled(selected)
    self.mGuestLogin:setInteractabled(selected)
end

function login:onUserClickedHandler()
    local ui = require("ui.agreement").new()
    ui:show()

    playButtonClickSound();
end

function login:onCityChangedHandler(city)
    self.mCityText:setSprite(cityTypeSID[city])
end

function login:onDestroy()
    signalManager.unregisterSignalHandler(signalType.city, self.onCityChangedHandler, self)
    base.onDestroy(self)
end

return login

--endregion
