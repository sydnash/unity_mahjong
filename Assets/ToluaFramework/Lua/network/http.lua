--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local http = class("http")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getText(url, callback)
    Http.instance:RequestText(url, "Get", callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.getBytes(url, callback)
    Http.instance:RequestBytes(url, "Get", callback)
end

return http

--endregion
