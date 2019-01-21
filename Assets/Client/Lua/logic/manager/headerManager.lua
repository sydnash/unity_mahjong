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

local function fileExist(path)
    if LFS.FileExist == nil then
        local f = io.open(path,"r")
    
        if f ~= nil then
            io.close(f)
            return true
        end

        return false
    end

    return LFS.FileExist(path)
end

local function downloaded(name)
    local path = LFS.CombinePath(rootPath, name)
    return fileExist(path)
end

local function downloadDefaultIcon()
    if defaultIcon == nil then
        defaultIcon = textureManager.load(string.empty, DEFAULT_HEADER_RES)
    end

    return defaultIcon
end

local function downloadOfflineIcon(path, callback)
    local bytes = LFS.ReadBytes(path)
    local icon = Utils.BytesToTexture2D(640, 640, bytes)

    callback(icon)
end

local httpAsync = http.createAsync()

local function downloadOnlineIcon(url, callback)
    local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒
    httpAsync:addTextureRequest(url, timeout, function(tex, bytes)
        callback(tex, bytes)
    end)
    httpAsync:start()
end

function headerManager.setup()
    downloadDefaultIcon()
end

local UNKNOWN_TOKEN_PREFIX = "ZsXQwa5mArMmI4A44uJgQyevo9VhePyUbv6MwhsWTzrqttXsUdzJL0LcT5I9reGA_"

function headerManager.token(url)
    if string.isNilOrEmpty(url) then
        emptyTokenIdx = emptyTokenIdx + 1
        return UNKNOWN_TOKEN_PREFIX .. tostring(emptyTokenIdx)
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
log("headerManager loaded")
return headerManager

--endregion
