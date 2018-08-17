--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local touch = require("logic.touch")
local camera = UnityEngine.Camera

local majiangRoomBase = class("majiangRoomBase")

function majiangRoomBase:ctor()
    self.updateHandler = registerUpdateListener(self.update, self)
end

function majiangRoomBase:update()
    touch.update()
    
    local pos = touch.position()
    if pos ~= nil then
        local ray = camera.main:ScreenPointToRay(pos)
    end
end

function majiangRoomBase:destroy()
    unregisterUpdateListener(self.updateHandler)
end

return majiangRoomBase

--endregion
