--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchViewManager  = require("ui.patch.patchViewManager")
local patchWaiting      = require("ui.patch.patchWaiting")
local patchDownload     = require("ui.patch.patchDownload")
local patchMessageBox   = require("ui.patch.patchMessageBox")

local waiting = nil
 
local function showWaitingUI(text)
    if waiting == nil then
        waiting = patchWaiting.new(text)
    end

    waiting:show()
end

local function closeWaitingUI()
    if waiting ~= nil then
        waiting:close()
    end

    waiting = nil
end










local appConfig     = require("config.appConfig")
local networkConfig = require("config.networkConfig")
local http          = require("network.http")

local Application       = UnityEngine.Application
local RuntimePlatform   = UnityEngine.RuntimePlatform

local downloadUrl = "http://www.cdbshy.com/mahjong"
if appConfig.debug then
    if Application.platform == RuntimePlatform.Android then
        downloadUrl = "https://fir.im/ea8c"
    elseif Application.platform == RuntimePlatform.IPhonePlayer then
        downloadUrl = "https://fir.im/w3de"
    end
end

local patchURL      = appConfig.debug and "http://test.cdbshy.com/mahjong_hotfix/" or "http://www.cdbshy.com/mahjong_hotfix/"
local patchTimeout  = 30  --秒

local VERSION_FILE_NAME     = "version.txt"
local PATCHLIST_FILE_NAME   = "patchlist.txt"
local CACHE_PATH            = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "patchCaches")
local CACHE_VER_FILE_NAME   = LFS.CombinePath(CACHE_PATH, "cver.txt")
local CACHE_FILES_FILE_NAME = LFS.CombinePath(CACHE_PATH, "cfiles.txt")

local downloadTextAsync = http.createAsync()
local HTTP_METHOD = "GET"

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflineVersionFile()
    local filename = LFS.CombinePath(LFS.PATCH_PATH, VERSION_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if text == nil or text == "" then
        text = LFS.ReadTextFromResources("version")
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlineVersionFile(url, callback)
    url = LFS.CombinePath(url, VERSION_FILE_NAME)

    downloadTextAsync:addTextRequest(url, HTTP_METHOD, patchTimeout * 1000, nil, callback)
    downloadTextAsync:start()
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflinePatchlistFile()
    local filename = LFS.CombinePath(LFS.PATCH_PATH, PATCHLIST_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if text == nil or text == "" then
        text = LFS.ReadTextFromResources("patchlist")
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlinePatchlistFile(url, callback)
    url = LFS.CombinePath(url, PATCHLIST_FILE_NAME)

    downloadTextAsync:addTextRequest(url, HTTP_METHOD, patchTimeout * 1000, nil, callback)
    downloadTextAsync:start()
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function filterPatchList(offlinePatchlistText, onlinePatchlistText, ignores)
    local retb = {}
    
    local oftb = loadstring(offlinePatchlistText)()
    local ontb = loadstring(onlinePatchlistText)()

    if ontb ~= nil then
        for k, v in pairs(ontb) do
            if not ignores[k] then
                local u = oftb[k]

                if u == nil or v.hash ~= u.hash or v.size ~= u.size then
                    table.insert(retb, { name = k, size = v.size })
                end
            end
        end
    end

    return retb
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function checkPatches(callback)
    local offlineVersionText = downloadOfflineVersionFile()

    if offlineVersionText == nil or offlineVersionText == "" then
        callback(nil, nil, nil)
        return
    end

    local offlineVersion = loadstring(offlineVersionText)()
    local offlineVersionNum = offlineVersion.num
    G_Current_Version = offlineVersionNum

    downloadOnlineVersionFile(patchURL, function(onvt)
        if not appConfig.patchEnabled then
            callback({}, true, true)
            return
        end

        local onlineVersionText = onvt

        if onlineVersionText == nil or onlineVersionText == "" then
            callback(nil, nil, nil)
            return
        end

        
        local onlineVersion = loadstring(onlineVersionText)()
        local onlineVersionNum = onlineVersion.num

        local offlineVersionNumArray = string.split(offlineVersionNum, ".")
        local onlineVersionNumArray = string.split(onlineVersionNum, ".")
        
        if tonumber(offlineVersionNumArray[2]) < tonumber(onlineVersionNumArray[2]) then
            closeWaitingUI()
            local message = patchMessageBox.new("您的版本太旧，是否下载并安装最新版？", 
                                                function()
                                                    if Application.platform == RuntimePlatform.Android then
                                                        AndroidHelper.instance:OpenExplore(downloadUrl)
                                                    elseif Application.platform == RuntimePlatform.IPhonePlayer then
                                                        IOSHelper.instance:OpenExplore(downloadUrl)
                                                    end
                                                    return true --keep the message ui alived
                                                end,
                                                function()
                                                    Application.Quit()
                                                end)
            message:show()
            return
        end

        if onlineVersionNum == offlineVersionNum then
            callback({}, true, true)
            return
        end
        G_Current_Version = onlineVersionNum

        local cachedVersionNum = LFS.ReadText(CACHE_VER_FILE_NAME, LFS.UTF8_WITHOUT_BOM)

        if cachedVersionNum ~= nil and cachedVersionNum ~= onlineVersionNum then
            LFS.RemoveDir(CACHE_PATH)
        end
        LFS.WriteText(CACHE_VER_FILE_NAME, onlineVersionNum, LFS.UTF8_WITHOUT_BOM)

        local offlinePatchlistText = downloadOfflinePatchlistFile()

        if offlinePatchlistText == nil or offlinePatchlistText == "" then
            callback(nil, nil, nil)
            return
        end

        local url = string.format("%s/%s/%s", onlineVersion.url, LFS.OS_PATH, onlineVersionNum)

        downloadOnlinePatchlistFile(url, function(onpt)
            local onlinePatchlistText = onpt

            if onlinePatchlistText == nil or onlinePatchlistText == "" then
                callback(nil, nil, nil)
                return
            end

            local cachedPatchList = {}

            local lines = LFS.ReadLines(CACHE_FILES_FILE_NAME, LFS.UTF8_WITHOUT_BOM)
            if lines ~= nil then
                for i=0, lines.Length - 1 do
                    cachedPatchList[lines[i]] = true
                end
            end

            http.destroyAsync(downloadTextAsync)
            downloadTextAsync = nil

            local plist = filterPatchList(offlinePatchlistText, onlinePatchlistText, cachedPatchList)
            callback(plist, onlineVersionText, onlinePatchlistText, url)
        end)
    end)
end

local downloadPatchAsync = http.createAsync(5)

local DOWNLOAD_FAILED       = -1 --下载失败
local DOWNLOAD_COMPLETED    = 0  --下载完成
local DOWNLOAD_WORKING      = 1  --正在下载

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadPatches(url, files, callback)
    for _, v in pairs(files) do
        local www = url .. "/" .. v.name

        downloadPatchAsync:addBytesRequest(www, HTTP_METHOD, patchTimeout * 1000, nil, function(bytes, size, completed)
            if bytes == nil then
                callback(DOWNLOAD_FAILED, v.name, 0)
            else
                local path = LFS.CombinePath(CACHE_PATH, v.name)
                LFS.AppendBytes(path, bytes)

                if completed then
                    LFS.AppendLine(CACHE_FILES_FILE_NAME, v.name, LFS.UTF8_WITHOUT_BOM)
                    callback(DOWNLOAD_COMPLETED, v.name, bytes.Length)
                else
                    callback(DOWNLOAD_WORKING, v.name, bytes.Length)
                end
            end
        end)
    end

    downloadPatchAsync:start()
end

local K = 1024
local M = K * K
local G = K * M
local T = G * K

----------------------------------------------------------------
--
----------------------------------------------------------------
function BKMGT(bytes)
    assert(type(bytes) == "number")

    if bytes == nil then bytes = 0 end
    if bytes < K then return string.format("%dB",   bytes) end
    if bytes < M then return string.format("%.1fKB", bytes / K) end
    if bytes < G then return string.format("%.1fMB", bytes / M) end
    if bytes < T then return string.format("%.1fGB", bytes / G) end

    return string.format("%.1fT", bytes / T)
end















local patchManager = {}

----------------------------------------------------------------
--
----------------------------------------------------------------
function patchManager.patch(callback)
    patchViewManager.setup()

    local downloading = patchDownload.new()
    downloading:show()

    showWaitingUI("正在检测更新，请稍候")
    checkPatches(function(plist, versText, plistText, url)
        closeWaitingUI()

        if plist == nil then
            local message = patchMessageBox.new("更新检测失败", 
                                                function()
                                                    Application.Quit()
                                                end)
            message:show()
            return
        end

        local function invokeCallback()
            if callback ~= nil then
                callback()
            end
        end
      
        if #plist == 0 then--未检测到更新
            print("patchManager: plsit is empty")
            invokeCallback()
            downloading:close()
            return
        end

        local totalCount    = #plist
        local successCount  = 0
        local downloadBytes = 0
        local downloadedBytes = 0
        local failedList = {}

        for _, v in pairs(plist) do
            downloadBytes = downloadBytes + v.size
        end
        local downloadBytesTxt = BKMGT(downloadBytes)

        local function download(files)
            failedList = {}

            downloadPatches(url, files, function(status, filename, size)
                if status == DOWNLOAD_FAILED then 
                    table.insert(failedList, { name = filename })
                    print("download failed, filename = " .. filename)
                else
                    if status == DOWNLOAD_COMPLETED then
                        successCount = successCount + 1
                    end

                    downloadedBytes = downloadedBytes + size
                end

                local progress = math.min(1, downloadedBytes / downloadBytes)

                if successCount + #failedList < totalCount then
                    downloading:setProgress(progress)
                    downloading:setText(string.format("检测到%s更新资源，已下载%.1f%%", downloadBytesTxt, progress * 100))
                else    
                    if #failedList > 0 then
                        local message = patchMessageBox.new("部分更新资源下载失败，是否重新下载？", 
                                                            function()
                                                                download(failedList)
                                                            end,
                                                            function()
                                                                Application.Quit()
                                                            end)
                        message:show()
                    else
                        http.destroyAsync(downloadPatchAsync)
                        downloadPatchAsync = nil

                        LFS.RemoveFile(LFS.CombinePath(CACHE_PATH, "cver.txt"))
                        LFS.RemoveFile(LFS.CombinePath(CACHE_PATH, "cfiles.txt"))
                        LFS.MoveDir(CACHE_PATH, LFS.PATCH_PATH)
                        LFS.WriteText(LFS.CombinePath(LFS.PATCH_PATH, VERSION_FILE_NAME), versText, LFS.UTF8_WITHOUT_BOM)
                        LFS.WriteText(LFS.CombinePath(LFS.PATCH_PATH, PATCHLIST_FILE_NAME), plistText, LFS.UTF8_WITHOUT_BOM)
                        
                        invokeCallback()
                        downloading:close()
                    end
                end
            end)
        end

        download(plist)
    end)
end

return patchManager

--endregion
