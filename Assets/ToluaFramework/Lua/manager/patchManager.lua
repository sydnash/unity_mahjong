--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local appConfig = require("config.appConfig")
local http = require("network.http")
local persistentDataPath  = Application.persistentDataPath
local streamingAssetsPath = Application.streamingAssetsPath

local patchManager = class("patchManager")

local versionFilename = string.empty
local versionCallback = nil

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

local function downloadRemoteVersion()
    local url = appConfig .. versionFilename
    http.getText(url, 20 * 1000, onRemoteVersionDownloaded)
end

local function onRemoteVersionDownloaded(ok, remoteText)
    if not ok then
        log("download remote version failed")
        if versionCallback ~= nil then
            versionCallback(nil, nil)
        end
    else
        log("download remote version successfully, and text = " .. text)
        
        local urls = { persistentDataPath .. "/" .. versionFilename,
                       streamingAssetsPath .. "/" .. versionFilename,
        }

        downloadAnyText(urls, function(localText)
            if text == nil then
                versionCallback(nil, nil)
            else
                versionCallback(remoteText, localText)
            end
        end)
    end
end






-------------------------------------------------------------------
--
-------------------------------------------------------------------
function patchManager.checkversion(filename, callback)
    versionFilename = filename
    versionCallback = callback

    downloadRemoteVersion()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function patchManager.download()

end

return patchManager

--endregion
