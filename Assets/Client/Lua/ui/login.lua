--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local login = class("login", base)

login.folder = "LoginUI"
login.resource = "LoginUI"

function login:onInit()
    self.mWechatLogin:hide()
    self.mGuestLogin:addClickListener(self.onGuestLoginClickedHandler, self)
end

function login:onGuestLoginClickedHandler()
    soundManager.playButtonClickedSound()

    local waiting = require("ui.waiting").new()
    waiting:show()

    networkManager.login(function(ok, msg)
        waiting:close()

        if not ok then
            log("login failed")
            return
        end

        if msg.RetCode ~= retc.Ok then
            log(retText[msg.RetCode])
            return
        end

        log("login succssfully, acid = " .. tostring(msg.AcId) .. ", nickname = " .. msg.Nickname)

        local loading = require("ui.loading").new()
        loading:show()

        sceneManager.load("LobbyScene", function(completed, progress)
            loading:setProgress(progress)

            if completed then
                local lobby = require("ui.lobby").new()
                lobby:show()

                loading:close()
            end
        end)

        self:close()
    end)
end

return login

--endregion
