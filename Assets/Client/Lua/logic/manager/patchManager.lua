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
    http.getText(url, 20 * 1000, function(text)
        callback(text)
    end)
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
    http.getText(url, 20 * 1000, function(text)
        callback(text)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function filterPatchList(offlinePatchlistText, onlinePatchlistText, ignores)
    local retb = {}
    
    local oftb = loadstring(offlinePatchlistText)()
    local ontb = loadstring(onlinePatchlistText)()

    for k, v in pairs(ontb) do
        if not ignores[k] then
            local u = oftb[k]

            if u == nil or v.hash ~= u.hash or v.size ~= u.size then
                table.insert(retb, { name = k, size = v.size })
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
        callback(-1, nil, nil, nil)
        return
    end

    downloadOnlineVersionFile(networkConfig.patchURL, function(onvt)
        local onlineVersionText = onvt

        if string.isNilOrEmpty(onlineVersionText) then
            callback(-1, nil, nil, nil)
            return
        end

        local offlineVersion = loadstring(offlineVersionText)()
        local onlineVersion = loadstring(onlineVersionText)()

        if onlineVersion.num <= offlineVersion.num then
            callback(offlineVersion.num, {}, true, true)
            return
        end

        local cachedVersionNum = LFS.ReadText(CACHE_VER_FILE_NAME, LFS.UTF8_WITHOUT_BOM)
        if cachedVersionNum ~= nil and cachedVersionNum ~= tostring(onlineVersion.num) then
            LFS.RemoveDir(CACHE_PATH)
        end
        LFS.WriteText(CACHE_VER_FILE_NAME, tostring(onlineVersion.num), LFS.UTF8_WITHOUT_BOM)

        local offlinePatchlistText = downloadOfflinePatchlistFile()

        if string.isNilOrEmpty(offlinePatchlistText) then
            callback(-1, nil, nil, nil)
            return
        end

        local url = onlineVersion.url .. LFS.OS_PATH .. "/"

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
            callback(plist, onlineVersionText, onlinePatchlistText, url)
        end)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadPatches(url, files, callback)
    for _, v in pairs(files) do
        local www = url .. v.name

        http.getBytes(www, networkConfig.patchTimeout * 1000, function(bytes)
            if bytes == nil then
                callback(false, v.name)
            else
                local path = LFS.CombinePath(CACHE_PATH, v.name)
                LFS.WriteBytes(path, bytes)
                LFS.AppendLine(CACHE_FILES_FILE_NAME, v.name, LFS.UTF8_WITHOUT_BOM)

                callback(true, v.name)
            end
        end)
    end
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

        for _, v in pairs(plist) do
            downloadBytes = downloadBytes + v.size
        end
        local downloadBytesTxt = BKMGT(downloadBytes)

        local function download(files)
            local failedList    = {}
            
            downloadPatches(url, files, function(success, filename)
                if success then
                    successCount = successCount + 1
                else
                    table.insert(failedList, { name = filename })
                end

                local progress = math.min(1, successCount / totalCount)

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
