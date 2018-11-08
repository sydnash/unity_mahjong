--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

local soundConfig   = require("config.soundConfig")
local input         = UnityEngine.Input
local keycode       = UnityEngine.KeyCode

-------------------------------------------------------------------
-- 禁止定义全局变量
-------------------------------------------------------------------
local function DISABLE_GLOBAL_VARIABLE_DECLARATION()
    setmetatable(_G, {
        __newindex = function(_, name, value)
            local msg = "Can't declare global variable: %s"
            error(string.format(msg, name), 0)
        end
    })
end

----------------------------------------------------------------
-- 检测返回键状态
----------------------------------------------------------------
local function checkEscapeState()
    if input.GetKeyDown(keycode.Escape) then
        showMessageUI("确定要退出游戏吗？", function()
            Application.Quit()
        end)
    end
end

----------------------------------------------------------------
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback()
    showWaitingUI("正在尝试重连，请稍候...")

    networkManager.reconnect(gamepref.host, gamepref.port, function(connected, curCoin, cityType, deskId)
        if not connected then
            closeWaitingUI()

            if clientApp.currentDesk ~= nil then
                clientApp.currentDesk:destroy()
                clientApp.currentDesk = nil
            end

            local ui = showMessageUI("与服务器失去连接，是否重新登录？", 
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
            return
        end

        if deskId <= 0 then
            closeWaitingUI()
            return
        end

        enterDesk(cityType, deskId, function(ok, errText, preload, progress, msg)
            if not ok then
                closeWaitingUI()
                showMessageUI(errText, function()
                    --销毁当前游戏对象
                    if clientApp.currentDesk ~= nil then
                        clientApp.currentDesk:destroy()
                        clientApp.currentDesk = nil
                    end
                    --返回登录界面
                    local ui = require("ui.login").new()
                    ui:show()
                end)
                return
            end

            if msg ~= nil then
                closeWaitingUI()

                msg.Config  = table.fromjson(msg.Config)
                msg.Reenter = table.fromjson(msg.Reenter)
                        
                if clientApp.currentDesk ~= nil then
                    clientApp.currentDesk:onEnter(msg)
                    return
                end

                local loading = require("ui.loading").new()
                loading:show()

                sceneManager.load("scene", "mahjongscene", function(completed, progress)
                    loading:setProgress(progress)

                    if completed then
                        if preload ~= nil then
                            preload:stop()
                        end

                        clientApp.currentDesk = require("logic.mahjong.mahjongGame").new(msg)
                        loading:close()
                    end
                end)
            end
        end)
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
local function tracebackHandler(errorMessage)
    logError(errorMessage)

    local ui = require("ui.errorMessage").new()
    ui:show()

    if appConfig.debug and not deviceConfig.isMobile then
        ui:setErrorMessage(errorMessage)
    end

    --断开网络，主要是中断消息接收和处理的过程
    networkManager.disconnect()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
local function inviteSgCallback(params)
    if clientApp.currentDesk == nil then
        local t = table.fromjson(params)

        local cityType = t.cityType
        local deskId = t.deskId

        local loading = require("ui.loading").new()
        loading:show()

        enterDesk(cityType, deskId, function(ok, errText, preload, progress, msg)
            if not ok then
                loading:close()
                showMessageUI(errText)
            else
                if msg == nil then
                    loading:setProgress(progress * 0.4)
                else
                    loading:setProgress(0.4)

                    sceneManager.load("scene", "mahjongscene", function(completed, progress)
                        loading:setProgress(0.4 + 0.6 * progress)

                        if completed then
                            if preload ~= nil then
                                preload:stop()
                            end

                            msg.Reenter = table.fromjson(msg.Reenter)
                            msg.Config = table.fromjson(msg.Config)

                            local desk = require("logic.mahjong.mahjongGame").new(msg)
                            loading:close()
                        end
                    end)

                    --finish
                end
            end
        end)
    end
end

clientApp = class("clientApp")

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:ctor()
    self.currentDesk = nil
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

    registerUpdateListener(checkEscapeState, nil)
    registerTracebackCallback(tracebackHandler)
    platformHelper.registerInviteSgCallback(inviteSgCallback)

    DISABLE_GLOBAL_VARIABLE_DECLARATION()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:onDestroy()

end

return clientApp

--endregion
