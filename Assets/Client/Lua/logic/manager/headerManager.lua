--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local http = require("network.http")
local DEFAULT_HEADER_RES = "js_tx_a"

local headerManager = {}
headerManager.downloadedHeaders = {}

local function download(url, callback)
    if string.isNilOrEmpty(url) then
        return
    end

    local hash = Hash.GetHash(url)
    local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "wxicons", hash .. ".jpg")

    --先本地查找，没找到再从网上下载
    http.getTexture2D("file:///" .. path, function(tex, bytes)
        if tex ~= nil then
            callback(tex)
        else
            http.getTexture2D(url, function(tex, bytes)
                if tex ~= nil then
                    LFS.WriteBytes(path, bytes)
                    callback(tex)
                end
            end)
        end
    end)
end

function headerManager.request(url)
--    url = "http://wx.qlogo.cn/mmopen/zhK3MN44IcibtzxZibicddSyp4qVX3rTtfMZsXQwa5mArMmI4A44uJgQyevo9VhePyUbv6MwhsWTzrqttXsUdzJL0LcT5I9reGA/0"
    local token = Hash.GetHash(url)

    local header = headerManager.downloadedHeaders[token]
    if header ~= nil then
        header.ref = header.ref + 1
        return token, header.icon
    end

    local tex = textureManager.load(string.empty, DEFAULT_HEADER_RES)
    
    download(url, function(icon)
        if icon ~= nil then
            textureManager.unload(tex)
            headerManager.downloadedHeaders[token] = { icon = icon, ref = 1 }
            signalManager.signal(token, icon)
        end
    end)

    return token, tex 
end

function headerManager.drop(token, tex)
    if string.isNilOrEmpty(token) or tex == nil then 
        return 
    end

    local header = headerManager.downloadedHeaders[token]
    if header == nil then
        textureManager.unload(tex)
    else
        header.ref = math.max(0, header.ref - 1)
        
        if header.ref == 0 then
            destroyTexture(header.icon)
            headerManager.downloadedHeaders[token] = nil
        end
    end
end

return headerManager

--endregion
