--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local lobbySetting = class("lobbySetting", base)

_RES_(lobbySetting, "SettingUI", "LobbySettingUI")

function lobbySetting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function lobbySetting:onInit()
    self.super.onInit(self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
end

function lobbySetting:onExitClickedHandler()
    networkManager.disconnect()
    closeAllUI()

    local ui = require("ui.login").new()
    ui:show()

    playButtonClickSound()
end

function lobbySetting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return lobbySetting

--endregion
