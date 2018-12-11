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

----------------------------------------------------------------
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback(idx)
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
local function downloadPatches(url, patchlist, size, versText, plistText, loading)
    log("downloadPatches, url = " .. url)
    local totalCount        = #patchlist
    local successfulCount   = 0

    local function downloadC(files, callback)
        local failedList = {}
        patchManager.downloadPatches(url, files, function(url, name, bytes)
            if bytes == nil then
                table.insert(failedList, { name = name })
            else
                successfulCount = successfulCount + 1

                local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, name)
                LFS.WriteBytes(path, bytes)
            end

            loading:setProgress(math.min(1, successfulCount / totalCount))

            if successfulCount + #failedList == totalCount then
                callback(failedList)
            end
        end)
    end

    local function download(files)
        downloadC(files, function(failedList)
            if #failedList > 0 then
                showMessageUI("有部分更新资源下载失败，是否重新下载？", 
                              function()
                                  download(failedList)
                              end,
                              function()
                                  Application.Quit()
                              end)
            else
                local vpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, patchManager.VERSION_FILE_NAME)
                LFS.WriteText(vpath, versText, LFS.UTF8_WITHOUT_BOM)

                local ppath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, patchManager.PATCHLIST_FILE_NAME)
                LFS.WriteText(ppath, plistText, LFS.UTF8_WITHOUT_BOM)

                local login = require("ui.login").new()
                login:show()

                loading:close()
            end
        end)
    end

    download(patchlist)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
local function checkPatches()
    local loading = require("ui.loading").new()
    loading:show()

    showWaitingUI("正在检测可更新资源，请稍候")

    patchManager.checkPatches(function(plist, versText, plistText, url)
        closeWaitingUI()

        if plist == nil then
            showMessageUI("更新检测失败")
            return
        end
        log("checkPatches   1")
        if #plist == 0 then--未检测到更新
            log("checkPatches   2")
            local login = require("ui.login").new()
            login:show()

            loading:close()
        else
            log("checkPatches   3")
            local size = 0
            for _, v in pairs(plist) do
                size = size + v.size
            end

            showMessageUI("检测到" .. BKMGT(size) .."新资源，是否立即下载更新？",
                          function()
                              downloadPatches(url, plist, size, versText, plistText, loading)
                          end,
                          function()
                              Application.Quit()
                          end)
        end
    end)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
local function patch()
    if gameConfig.patchEnabled then
        checkPatches(loading)
    else
        local login = require("ui.login").new()
        login:show()
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

    gamepref.city = readCityConfig()
    patch()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:update()
    -- 检测返回键状态
    if input.GetKeyDown(keycode.Escape) then
        showMessageUI("确定要退出游戏吗？", 
                      function()
                          Application.Quit()
                      end,
                      function()
                          --
                      end)
    end
    --测试用
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
end

return clientApp

--endregion
