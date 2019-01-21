--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

local patchManager      = require("logic.manager.patchManager")
local input             = UnityEngine.Input
local keycode           = UnityEngine.KeyCode

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

local errorMessageUI = nil

----------------------------------------------------------------
--
----------------------------------------------------------------
local function tracebackHandler(errorMessage, debug)
    logError(errorMessage)

    if errorMessageUI == nil then
        errorMessageUI = require("ui.errorMessage").new()
        errorMessageUI:show()
    end
    errorMessageUI:appendErrorMessage(errorMessage)
    errorMessageUI:setDebug(debug)

    --断开网络，主要是中断消息接收和处理的过程
    if not debug then
        networkManager.disconnect()
    end
end














----------------------------------------------------------------
--
----------------------------------------------------------------
clientApp = {}

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    registerTracebackCallback(tracebackHandler)
    Application.targetFrameRate = gameConfig.fps

    soundManager.setBGMVolume(gamepref.getBGMVolume())
    soundManager.setSFXVolume(gamepref.getSFXVolume())
    soundManager.playBGM(string.empty, "bgm")

    platformHelper.changeWindowTitle(deviceConfig.deviceId)
    registerUpdateListener(self.update, self)
    
    if not gameConfig.patchEnabled then
        initClientApp()
        DISABLE_GLOBAL_VARIABLE_DECLARATION()

        local login = require("ui.login").new()
        login:show()
    else
        patchManager.patch(function(forceReload)
            if forceReload then--重新加载已被加载过的lua文件
                reload("std")
                reload("globals")
            end

            initClientApp()
            DISABLE_GLOBAL_VARIABLE_DECLARATION()
        end)
    end
end

local escape = false

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:update()
    -- 检测返回键状态
    if input.GetKeyDown(keycode.Escape) and not escape then
        showMessageUI("确定要退出游戏吗？", 
                      function()
                          escape = false
                          Application.Quit()
                      end,
                      function()
                          escape = false
                      end)
        escape = true
    end
    --测试用，响应键盘按键执行特定指令
    if appConfig.debug and not deviceConfig.isMobile then
        if input.GetKeyDown(keycode.C) then
            
        end
    end
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:quit()
    closeAllUI()

    locationManager.stop()
    talkingData.stop()
end

return clientApp

--endregion
