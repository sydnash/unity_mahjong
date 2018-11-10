--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("globals")

local soundConfig   = require("config.soundConfig")
local patchManager  = require("logic.manager.patchManager")
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
        showMessageUI("确定要退出游戏吗？", 
                      function()
                          Application.Quit()
                      end,
                      function()
                          --
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
    platformHelper.clearSGInviteParam()
end

local function downloadPatches(patchlist, size, plistText, downloadui)
    local totalCount        = #patchlist
    local successfulCount   = 0

    local function downloadC(files, callback)
        local failedList = {}
        patchManager.downloadPatches(files, function(url, name, ok, bytes)
            if not ok then
                table.insert(failedList, { name = name })
            else
                successfulCount = successfulCount + 1

                local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, name)
                LFS.WriteBytes(path, bytes)
            end

            downloadui:setProgress(math.min(1, successfulCount / totalCount))

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
                local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, patchManager.PATCHLIST_FILE_NAME)
                LFS.WriteText(path, plistText, LFS.UTF8_WITHOUT_BOM)

                local login = require("ui.login").new()
                login:show()

                downloadui:close()
            end
        end)
    end

    download(patchlist)
end

local function checkPatches(downloadui)
    showWaitingUI()

    patchManager.checkPatches(function(ok, plist, plistText)
        closeWaitingUI()

        if not ok then
            showMessageUI("更新检测失败")
            return
        end

        if plist == nil or #plist == 0 then
            local login = require("ui.login").new()
            login:show()

            downloadui:close()
        else
            local size = 0
            for _, v in pairs(plist) do
                size = size + v.size
            end

            showMessageUI("检测到" .. BKMGT(size) .."新资源，是否立即更新？",
                          function()
                              downloadPatches(plist, size, plistText, downloadui)
                          end,
                          function()
                              Application.Quit()
                          end)
        end
    end)
end

local function patch()
    if deviceConfig.isMobile then
        local loading = require("ui.loading").new()
        loading:show()

        checkPatches(loading)
    else
        local login = require("ui.login").new()
        login:show()
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

    soundManager.setBGMVolume(soundConfig.defaultBgmVolume)
    soundManager.playBGM(string.empty, "bgm")
    platformHelper.changeWindowTitle(deviceConfig.deviceId)

    registerUpdateListener(checkEscapeState, nil)
    registerTracebackCallback(tracebackHandler)
    platformHelper.registerInviteSgCallback(inviteSgCallback)

    DISABLE_GLOBAL_VARIABLE_DECLARATION()

    patch()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientApp:onDestroy()

end

return clientApp

--endregion
