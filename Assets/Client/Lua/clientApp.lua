--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

gamepref       = require("logic.gamepref")
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
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback()
    local waiting = require("ui.waiting").new("正在尝试重连，请稍候...")
    waiting:show()

    networkManager.connect(gamepref.host, gamepref.port, function(connected)
        log("networkDisconnectedCallback, c = " .. tostring(connected))
        waiting:close()

        if not connected then
            local ui = require("ui.messageBox").new("与服务器失去连接，是否重新登录？", 
                                                    function()--确定：重新登录
                                                        loginServer(function(ok)
                                                            if not ok then
                                                                local ui = require("ui.login").new()
                                                                ui:show()
                                                            end
                                                        end)
                                                    end,
                                                    function()--取消：回到登录界面
                                                        local ui = require("ui.login").new()
                                                        ui:show()
                                                    end)

            ui:show()
        end
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    networkManager.setup(networkDisconnectedCallback)

    local ui = require("ui.login").new()
    ui:show()

    soundManager.setBGMVolume(soundConfig.defaultBgmVolume)
    soundManager.playBGM(string.empty, "bgm")
end

return clientApp

--endregion
