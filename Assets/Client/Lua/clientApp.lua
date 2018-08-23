--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

networkManager = require("network.networkManager")

local soundConfig = require("config.soundConfig")

local clientApp = class("clientApp")

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:ctor()
    self.gamePlayer = require("logic.player.gamePlayer").new()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    networkManager.setup()

    local ui = require("ui.login").new()
    ui:show()

    soundManager.setBGMVolume(soundConfig.defaultBgmVolume)
    soundManager.playBGM()
end

return clientApp

--endregion
