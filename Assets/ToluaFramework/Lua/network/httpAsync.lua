--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local httpAsync = class("httpAsync")

function httpAsync:ctor(async)
    self.async = async
end

function httpAsync:addTextRequest(url, method, timeout, args, callback)
    if self.async ~= nil then
        local buffer = nil
        local bufferOffset = 0

        method = method or "GET"
        local function onResponsed(bytes, totalSize, completed)
            if bytes == nil then
                callback(string.empty)
            else
                if buffer == nil then
                    buffer = Utils.NewEmptyByteArray(totalSize)
                end

                Utils.CopyBytes(bytes, 0, buffer, bufferOffset, bytes.Length)
                bufferOffset = bufferOffset + bytes.Length

                if completed then
                    local text = Utils.BytesToString(buffer, 0, totalSize)
                    callback(text)
                end
            end
        end

        if CSV == nil or CSV.instance:Query("http") == nil then
            self.async:AddRequest(url, timeout, onResponsed)
        else
            self.async:AddRequest(url, method, timeout, args, onResponsed)
        end
    end
end

function httpAsync:addBytesRequest(url, method, timeout, args, callback)
    if self.async ~= nil then
        method = method or "GET"
        local function onResponsed(bytes, totalSize, completed)
            if callback ~= nil then
                callback(bytes, size, completed)
            end
        end

        if CSV == nil or CSV.instance:Query("http") == nil then
            self.async:AddRequest(url, timeout, onResponsed)
        else
            self.async:AddRequest(url, method, timeout, args, onResponsed)
        end
    end
end

function httpAsync:addTextureRequest(url, method, timeout, args, callback)
    if self.async ~= nil then
        local buffer = nil
        local bufferOffset = 0

        method = method or "GET"
        local function onResponsed(bytes, totalSize, completed)
            if bytes == nil then
                callback(nil, nil)
            else
                if buffer == nil then
                    buffer = Utils.NewEmptyByteArray(totalSize)
                end

                Utils.CopyBytes(bytes, 0, buffer, bufferOffset, bytes.Length)
                bufferOffset = bufferOffset + bytes.Length

                if completed then
                    local tex = Utils.BytesToTexture2D(640, 640, buffer)
                    callback(tex, buffer)
                end
            end
        end

        if CSV == nil or CSV.instance:Query("http") == nil then
            self.async:AddRequest(url, timeout, onResponsed)
        else
            self.async:AddRequest(url, method, timeout, args, onResponsed)
        end
    end
end

function httpAsync:start()
    if self.async ~= nil then
        self.async:Start()
    end
end

function httpAsync:stop()
    if self.async ~= nil then
        self.async:Stop()
    end
end

return httpAsync

--endregion
