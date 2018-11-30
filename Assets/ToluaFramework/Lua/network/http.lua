--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local http = class("http")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getText(url, timeout, callback)
    Http.instance:RequestBytes(url, "GET", timeout * 1000, function(bytes)
        if bytes == nil then
            callback(string.empty)
        else
            local text = Utils.BytesToString(bytes, 0, bytes.Length)
            callback(text)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getBytes(url, timeout, callback)
    Http.instance:RequestBytes(url, "GET", timeout * 1000, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getTexture2D(url, callback)
    Http.instance:RequestTexture(url, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getFile(url, callback)
    Http.instance:RequestFile(url, callback)
end

return http

--endregion
