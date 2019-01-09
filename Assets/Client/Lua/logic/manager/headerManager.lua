--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local http = require("network.http")
local DEFAULT_HEADER_RES = "js_tx_a"

local headerManager = {}
headerManager.downloadedHeaders = {}

local defaultIcon = nil
local rootPath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "wxicons")
local emptyTokenIdx = 0

local function downloaded(name)
    local path = LFS.CombinePath(rootPath, name)
    return LFS.FileExist(path)
end

local function downloadDefaultIcon()
    if defaultIcon == nil then
        defaultIcon = textureManager.load(string.empty, DEFAULT_HEADER_RES)
    end

    return defaultIcon
end

local function downloadOfflineIcon(path, callback)
    http.getTexture2D("file:///" .. path, function(tex, bytes)
        callback(tex)
    end)
end

local function downloadOnlineIcon(url, callback)
    http.getTexture2D(url, function(tex, bytes)
        callback(tex, bytes)
    end)
end

function headerManager.setup()
    downloadDefaultIcon()
end

function headerManager.token(url)
    if string.isNilOrEmpty(url) then
        emptyTokenIdx = emptyTokenIdx + 1
        return "ZsXQwa5mArMmI4A44uJgQyevo9VhePyUbv6MwhsWTzrqttXsUdzJL0LcT5I9reGA_" .. tostring(emptyTokenIdx)
    end

    return Hash.GetHash(url)
end

function headerManager.request(token, url)
--    url = "http://wx.qlogo.cn/mmopen/zhK3MN44IcibtzxZibicddSyp4qVX3rTtfMZsXQwa5mArMmI4A44uJgQyevo9VhePyUbv6MwhsWTzrqttXsUdzJL0LcT5I9reGA/0"

    if string.isNilOrEmpty(url) then
        local icon = downloadDefaultIcon()
        signalManager.signal(token, icon)
        return
    end

    local header = headerManager.downloadedHeaders[token]
    if header ~= nil then
        header.ref = header.ref + 1
        signalManager.signal(token, header.icon)
        return
    end
    
    local function callback(icon)
        if icon ~= nil then
            local h = headerManager.downloadedHeaders[token]
            if h ~= nil then
                h.ref = h.ref + 1
                icon = h.icon
            else
                headerManager.downloadedHeaders[token] = { icon = icon, ref = 1 }
            end

            signalManager.signal(token, icon)
        end
    end

    local tex = downloadDefaultIcon()
    signalManager.signal(token, tex)

    local path = LFS.CombinePath(rootPath, token .. ".jpg")

    if downloaded(path) then
        downloadOfflineIcon(path, callback)
    else
        downloadOnlineIcon(url, function(tex, bytes)
            if tex ~= nil then
                LFS.WriteBytes(path, bytes)
                callback(tex)
            end
        end)
    end
end

function headerManager.drop(token)
    if not string.isNilOrEmpty(token) then
        local header = headerManager.downloadedHeaders[token]
        if header ~= nil then
            header.ref = math.max(0, header.ref - 1)
        
            if header.ref == 0 then
                destroyTexture(header.icon)
                headerManager.downloadedHeaders[token] = nil
            end
        end
    end
end

return headerManager

--endregion
