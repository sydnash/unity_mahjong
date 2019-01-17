--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local httpAsync     = require("network.httpAsync")

local http = class("http")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function http.createAsync(threadCount)
    if threadCount == nil then
        threadCount = 1
    end

    local t = httpAsync.new(HttpDispatcher.instance:CreateHttpAsync(threadCount))
    return t
end

function http.destroyAsync(async)
    if async ~= nil then
        HttpDispatcher.instance:DestroyHttpAsync(async.async)
        async.async = nil
    end
end

return http

--endregion
