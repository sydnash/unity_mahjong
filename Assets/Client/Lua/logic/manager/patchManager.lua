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
local function downloadOfflineVersionFile()
    local filename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  LFS.OS_PATH, patchManager.PATCHLIST_FILE_NAME)
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
local function downloadOnlineVersionFile(callback)
    http.getText(patchUrl, 20 * 1000, function(text)
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
        callback(nil, nil)
        return
    end

    downloadOnlineVersionFile(function(onvt)
        local onlineVersionText = onvt

        if string.isNilOrEmpty(offlineVersionText) then
            callback(nil, nil)
            return
        end

        local plist = filterPatchList(offlineVersionText, onlineVersionText)
        callback(plist, onlineVersionText)
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
