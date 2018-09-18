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

end

----------------------------------------------------------------
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback()
    showWaitingUI("正在尝试重连，请稍候...")

    networkManager.reconnect(gamepref.host, gamepref.port, function(connected, curCoin, cityType, deskId)
        if not connected then
            closeWaitingUI()
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
        else
            if deskId <= 0 then
                closeWaitingUI()
            else
                enterDesk(cityType, deskId, function(ok, errText, progress, msg)
                    if not ok then
                        closeWaitingUI()
                        showMessageUI(errText)
                        return
                    end

                    if msg ~= nil then
                        closeWaitingUI()

--                        if false then
--                            sceneManager.load("scene", "MahjongScene", function(completed, progress)
--                                loading:setProgress(0.4 + 0.6 * progress)

--                                if completed then
--                                    msg.Reenter = table.fromjson(msg.Reenter)
--                                    msg.Config = table.fromjson(msg.Config)

--                                    local desk = require("logic.mahjong.mahjongGame").new(msg)
--                                    loading:close()
--                                end
--                            end)
--                        end
                    end
                end)
            end
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
