--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local clientApp = class("clientApp")

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:ctor()
    
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    log("clientApp:start")

    soundManager.setup()
    viewManager.setup()
    eventManager.setup()
    sceneManager.setup()

    local ui = require("ui.patch").new()
    ui:show()

    soundManager.playBGM()
end

return clientApp

--endregion
