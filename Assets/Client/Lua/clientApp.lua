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
    local ui = require("ui.login").new()
    ui:show()

    soundManager.playBGM()
end

return clientApp

--endregion
