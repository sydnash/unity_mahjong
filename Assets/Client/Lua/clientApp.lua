--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

local patchManager      = require("logic.manager.patchManager")
local headerManager     = require("logic.manager.headerManager")
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

----------------------------------------------------------------
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback(idx)
    log("[test for reconnect] networkDisconnectedCallback : " .. tostring(idx))
    if idx ~= nil and idx > 5 then
        closeWaitingUI()

        if clientApp.currentDesk ~= nil then
            clientApp.currentDesk:destroy()
            clientApp.currentDesk = nil
        end
        gamepref.player.currentDesk = nil

        closeAllUI()
        networkManager.disconnect()

        showMessageUI("与服务器失去连接，请重新登录。", 
                      function()--确定：回到登录界面
                          local ui = require("ui.login").new()
                          ui:show()
                      end)
        return
    end

    local idx = idx or 1
    showWaitingUI(string.format("正在尝试重连(%d/5)，请稍候...", idx))

    networkManager.reconnect(gamepref.host, gamepref.port, function(connected, curCoin, cityType, deskId)
        if not connected then
            networkDisconnectedCallback(idx + 1)
            return
        end

        closeWaitingUI()

        networkManager.startPingPong()
        signalManager.signal(signalType.refreshFriendsterDetailInfo)

        if deskId <= 0 then
            gamepref.player.currentDesk = nil
            if clientApp.currentDesk and not clientApp.currentDesk:isPlayback() and not clientApp.currentDesk.isGameOverUIShow then
                showMessageUI("牌局已经结束，请点击确定并去战绩查看详情", function()
                    clientApp.currentDesk:exitGame()
                end)
            end
            return
        end

        if clientApp.currentDesk and clientApp.currentDesk:isPlayback() then
            return
        end

        enterDesk(cityType, deskId, function(ok)
            if not ok then
                local ui = require("ui.lobby").new()
                ui:show()
            end
        end)
    end)
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
-- 闲聊邀请的回调
----------------------------------------------------------------
local function inviteSgCallback(params)
    if clientApp.currentDesk == nil then
        closeAllUI()

        local t = table.fromjson(params)

        local cityType = t.cityType
        local deskId = t.deskId

        if clientApp.currentDesk and clientApp.currentDesk:isPlayback() then
            return
        end
        enterDesk(cityType, deskId, function(ok)
            if not ok then
                local ui = require("ui.lobby").new()
                ui:show()
            end
        end)
    end
    platformHelper.clearSGInviteParam()
end












----------------------------------------------------------------
--
----------------------------------------------------------------
clientApp = {}

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:start()
    Application.targetFrameRate = gameConfig.fps
    networkManager.setup(networkDisconnectedCallback)

    soundManager.setBGMVolume(gamepref.getBGMVolume())
    soundManager.setSFXVolume(gamepref.getSFXVolume())
    soundManager.playBGM(string.empty, "bgm")

    platformHelper.changeWindowTitle(deviceConfig.deviceId)

    registerTracebackCallback(tracebackHandler)
    platformHelper.registerInviteSgCallback(inviteSgCallback)

    DISABLE_GLOBAL_VARIABLE_DECLARATION()

    self.currentDesk = nil
    registerUpdateListener(self.update, self)

    locationManager.checkEnabled()
    locationManager.start()

    talkingData.start()

    gamepref.city = readCityConfig()
    headerManager.setup()
    
    if gameConfig.patchEnabled then
        patchManager.patch()
    else
        local login = require("ui.login").new()
        login:show()
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
function clientApp:onDestroy()
    locationManager.stop()
    talkingData.stop()
end

return clientApp

--endregion
