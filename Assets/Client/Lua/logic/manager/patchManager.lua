--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkConfig = require("config.networkConfig")
local http          = require("network.http")

local localizedVerPath  = LFS.LOCALIZED_DATA_PATH
local downloadedDataPath = LFS.DOWNLOAD_DATA_PATH
local patchUrl = networkConfig.patchURL .. "patchlist.txt"

local patchManager = {}
patchManager.PATCHLIST_FILE_NAME = "patchlist.txt"

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadAnyText(urls, callback)
    local index = 1

    local function onDownloaded(ok, text)
        if not ok then
            index = index + 1
            if index <= #urls then
                http.getText(urls[index], 20 * 1000, onDownloaded)
            else
                callback(nil)
            end
        else
            callback(text)
        end
    end

    http.getText(urls[index], 20 * 1000, onDownloaded)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOfflineVersionFile(callback)
    local urls = {
        LFS.CombinePath("file:///" .. LFS.DOWNLOAD_DATA_PATH,  LFS.OS_PATH, patchManager.PATCHLIST_FILE_NAME),
        LFS.CombinePath("file:///" .. LFS.LOCALIZED_DATA_PATH, patchManager.PATCHLIST_FILE_NAME),
    }

    downloadAnyText(urls, callback)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
local function downloadOnlineVersionFile(callback)
    http.getText(patchUrl, 20 * 1000, function(ok, text)
        if not ok then
            callback(nil)
        else
            callback(text)
        end
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
    downloadOfflineVersionFile(function(ofvt)
        local offlineVersionText = ofvt

        if string.isNilOrEmpty(offlineVersionText) then
            callback(false, nil)
            return
        end

        downloadOnlineVersionFile(function(onvt)
            local onlineVersionText = onvt

            if string.isNilOrEmpty(offlineVersionText) then
                callback(false, nil)
                return
            end

            local plist = filterPatchList(offlineVersionText, onlineVersionText)
            callback(true, plist, onlineVersionText)
        end)
    end)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function patchManager.downloadPatches(files, callback)
    log(files)
    for _, v in pairs(files) do
        local url = networkConfig.patchURL .. v.name
        http.getBytes(url, networkConfig.patchTimeout * 1000, function(ok, bytes)
            if callback ~= nil then
                callback(url, v.name, ok, bytes)
            end
        end)
    end
end

return patchManager

--endregion
