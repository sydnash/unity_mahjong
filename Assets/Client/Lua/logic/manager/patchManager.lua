--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkConfig = require("config.networkConfig")
local http          = require("network.http")

local patchManager = {}

local VERSION_FILE_NAME     = "version.txt"
local PATCHLIST_FILE_NAME   = "patchlist.txt"
local CACHE_PATH            = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "patchCaches")
local CACHE_VER_FILE_NAME   = LFS.CombinePath(CACHE_PATH, "cver.txt")
local CACHE_FILES_FILE_NAME = LFS.CombinePath(CACHE_PATH, "cfiles.txt")

local downloadTextAsync = http.createAsync()

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflineVersionFile()
    local filename = LFS.CombinePath(LFS.PATCH_PATH, VERSION_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        text = LFS.ReadTextFromResources("version")
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlineVersionFile(url, callback)
    url = LFS.CombinePath(url, VERSION_FILE_NAME)

    downloadTextAsync:addTextRequest(url, networkConfig.httpTimeout * 1000, callback)
    downloadTextAsync:start()
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflinePatchlistFile()
    local filename = LFS.CombinePath(LFS.PATCH_PATH, PATCHLIST_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        text = LFS.ReadTextFromResources("patchlist")
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlinePatchlistFile(url, callback)
    url = LFS.CombinePath(url, PATCHLIST_FILE_NAME)

    downloadTextAsync:addTextRequest(url, networkConfig.httpTimeout * 1000, callback)
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

    if string.isNilOrEmpty(offlineVersionText) then
        callback(nil, nil, nil)
        return
    end

    downloadOnlineVersionFile(networkConfig.patchURL, function(onvt)
        local onlineVersionText = onvt

        if string.isNilOrEmpty(onlineVersionText) then
            callback(nil, nil, nil)
            return
        end

        local offlineVersion = loadstring(offlineVersionText)()
        local onlineVersion = loadstring(onlineVersionText)()

        if onlineVersion.num == offlineVersion.num then
            callback({}, true, true)
            return
        end

        local cachedVersionNum = LFS.ReadText(CACHE_VER_FILE_NAME, LFS.UTF8_WITHOUT_BOM)
        if cachedVersionNum ~= nil and cachedVersionNum ~= tostring(onlineVersion.num) then
            LFS.RemoveDir(CACHE_PATH)
        end
        LFS.WriteText(CACHE_VER_FILE_NAME, tostring(onlineVersion.num), LFS.UTF8_WITHOUT_BOM)

        local offlinePatchlistText = downloadOfflinePatchlistFile()

        if string.isNilOrEmpty(offlinePatchlistText) then
            callback(nil, nil, nil)
            return
        end

        local url = onlineVersion.url

        downloadOnlinePatchlistFile(url, function(onpt)
            local onlinePatchlistText = onpt
            local cachedPatchList = {}

            local lines = LFS.ReadLines(CACHE_FILES_FILE_NAME, LFS.UTF8_WITHOUT_BOM)
            if lines ~= nil then
                for i=0, lines.Length - 1 do
                    cachedPatchList[lines[i]] = true
                end
            end

            local plist = filterPatchList(offlinePatchlistText, onlinePatchlistText, cachedPatchList)
            local size = 0
            for _, v in pairs(plist) do
                size = size + v.size
            end

            http.destroyAsync(downloadTextAsync)
            downloadTextAsync = nil

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
        local www = url .. v.name

        downloadPatchAsync:addBytesRequest(www, networkConfig.patchTimeout * 1000, function(bytes, size, completed)
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








----------------------------------------------------------------
--
----------------------------------------------------------------
function patchManager.patch()
    LFS.MakeDir(CACHE_PATH)

    local loading = require("ui.loading").new()
    loading:show()

    showWaitingUI("正在检测更新，请稍候")
    checkPatches(function(plist, versText, plistText, url)
        closeWaitingUI()

        if plist == nil then
            showMessageUI("更新检测失败", function()
                Application.Quit()
            end)
            return
        end
      
        if #plist == 0 then--未检测到更新
            local login = require("ui.login").new()
            login:show()
            loading:close()
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
                    log("download failed, " .. filename)
                else
                    if status == DOWNLOAD_COMPLETED then
                        successCount = successCount + 1
                    end

                    downloadedBytes = downloadedBytes + size
                end

                local progress = math.min(1, downloadedBytes / downloadBytes)

                if successCount + #failedList < totalCount then
                    loading:setProgress(progress)
                    loading:setText(string.format("检测到%s更新资源，已下载%.1f%%", downloadBytesTxt, progress * 100))
                else    
                    if #failedList > 0 then
                        showMessageUI("部分更新资源下载失败，是否重新下载？", 
                                        function()
                                            download(failedList)
                                        end,
                                        function()
                                            Application.Quit()
                                        end)
                    else
                        http.destroyAsync(downloadPatchAsync)
                        downloadPatchAsync = nil

                        LFS.MoveDir(CACHE_PATH, LFS.PATCH_PATH)

                        local vpath = LFS.CombinePath(LFS.PATCH_PATH, VERSION_FILE_NAME)
                        LFS.WriteText(vpath, versText, LFS.UTF8_WITHOUT_BOM)

                        local ppath = LFS.CombinePath(LFS.PATCH_PATH, PATCHLIST_FILE_NAME)
                        LFS.WriteText(ppath, plistText, LFS.UTF8_WITHOUT_BOM)

                        local login = require("ui.login").new()
                        login:show()

                        loading:close()
                    end
                end
            end)
        end

        download(plist)
    end)
end

return patchManager

--endregion
