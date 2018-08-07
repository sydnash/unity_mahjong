--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local login = class("login", base)

login.folder = "LoginUI"
login.resource = "LoginUI"

function login:onInit()
    self.mWechatLogin:hide()
    self.mCustomLogin:addClickListener(self.onCustomLoginClickedHandler, self)
end

function login:onCustomLoginClickedHandler()
    local loading = require("ui.loading").new()
    loading:show()

    sceneManager.load("LobbyScene", function()
        loading:hide()
    end)

    self:close()
end

return login

--endregion
