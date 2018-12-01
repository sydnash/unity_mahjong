--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkConfig = require("config.networkConfig")
local http          = require("network.http")

local patchManager = {}

patchManager.VERSION_FILE_NAME   = "version.txt"
patchManager.PATCHLIST_FILE_NAME = "patchlist.txt"

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflineVersionFile()
    local filename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  LFS.OS_PATH, patchManager.VERSION_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        filename = LFS.CombinePath(patchManager.VERSION_FILE_NAME)
        text = LFS.ReadTextFromResources(filename)
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlineVersionFile(url, callback)
    url = LFS.CombinePath(url, patchManager.VERSION_FILE_NAME)
    http.getText(url, 20 * 1000, function(text)
        callback(text)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflinePatchlistFile()
    local filename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, LFS.OS_PATH, patchManager.PATCHLIST_FILE_NAME)
    local text = LFS.ReadText(filename, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        filename = LFS.CombinePath(patchManager.PATCHLIST_FILE_NAME)
        text = LFS.ReadTextFromResources(filename)
    end

    return text
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlinePatchlistFile(url, callback)
    url = LFS.CombinePath(url, patchManager.PATCHLIST_FILE_NAME)
    http.getText(url, 20 * 1000, function(text)
        callback(text)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function filterPatchList(offlineVersionText, onlineVersionText)
    local retb = nil
    
    local oftb = loadstring(offlineVersionText)()
    local ontb = loadstring(onlineVersionText)()

    for k, v in pairs(ontb) do
        local u = oftb[k]

        if v.hash ~= u.hash or v.size ~= u.size then
            if retb == nil then retb = {} end
            table.insert(retb, { name = k, size = v.size })
        end
    end

    return retb
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function patchManager.checkPatches(callback)
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

        if onlineVersion.num <= offlineVersion.num then
            return
        end

        local offlinePatchlistText = downloadOfflinePatchlistFile()

        if string.isNilOrEmpty(offlinePatchlistText) then
            callback(nil, nil, nil)
            return
        end

        downloadOnlinePatchlistFile(onlineVersion.url, function(onpt)
            local onlinePatchlistText = onpt

            local plist = filterPatchList(offlinePatchlistText, onlinePatchlistText)
            callback(plist, onlineVersionText, onlinePatchlistText)
        end)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function patchManager.downloadPatches(files, callback)
    for _, v in pairs(files) do
        local url = networkConfig.patchURL .. files[1]

        http.getBytes(url, networkConfig.patchTimeout * 1000, function(bytes)
            if callback ~= nil then
                callback(url, v.name, bytes)
            end
            
            if #files > 0 then
                download(files)
            end
        end)
    end
end

return patchManager

--endregion
