--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local http = class("http")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getText(url, timeout, callback)
    Http.instance:RequestText(url, "GET", timeout, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getBytes(url, timeout, callback)
    Http.instance:RequestBytes(url, "GET", timeout, callback)
end

return http

--endregion
