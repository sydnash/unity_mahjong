--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

local Input             = UnityEngine.Input
local KeyCode           = UnityEngine.KeyCode

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
local function tracebackHandler(errorMessage)
    logError(errorMessage)

    if not appConfig.debug then
        commitError(errorMessage)
    end

    if errorMessageUI == nil then
        errorMessageUI = require("ui.errorMessage").new()
        errorMessageUI:show()
    end
    errorMessageUI:appendErrorMessage(errorMessage)
    errorMessageUI:setDebug(debug)

    --断开网络，主要是中断消息接收和处理的过程
    networkManager.disconnect()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
clientApp = {}
local Application = UnityEngine.Application
clientApp.activityShown = false

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    registerTracebackCallback(tracebackHandler)
    Application.targetFrameRate = gameConfig.fps

    clientAppSetup()

    soundManager.setBGMVolume(gamepref.getBGMVolume())
    soundManager.setSFXVolume(gamepref.getSFXVolume())
    soundManager.playBGM(string.empty, "bgm")

    platformHelper.changeWindowTitle(deviceConfig.deviceId)
    registerUpdateListener(self.update, self)

    clientApp.currentDesk = nil

    if queryFromCSV("luatask") ~= nil then
        computeTask = task.new()
        if computeTask:dofile("task/init.lua") then
        else
            computeTask = nil
        end
    end

    DISABLE_GLOBAL_VARIABLE_DECLARATION()

    
    local login = require("ui.login").new()
    login:show()
end

local escape = false

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:update()
    -- 检测返回键状态
    if Input.GetKeyDown(KeyCode.Escape) and not escape then
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
        if Input.GetKeyDown(KeyCode.C) then
            
        end
    end
end

function clientApp:pause()
    if self.currentDesk ~= nil then
        self.currentDesk:cancelVoice()
    end

    gvoiceManager.pause()
end

function clientApp:resume()
    gvoiceManager.resume()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:quit()
    closeAllUI()
    networkManager.disconnect()
    locationManager.stop()
    talkingData.stop()
end

return clientApp

--endregion
