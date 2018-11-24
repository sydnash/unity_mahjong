--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tcp = class("tcp")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.connect(host, port, timeout, callback)
    Tcp.instance:Connect(host, port, timeout, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.disconnect()
    Tcp.instance:Disconnect()
    tcp.unregisterReceivedCallback()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function local_empty_callback()

end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.send(data, length, callback)
    if callback == nil then
        callback = local_empty_callback
    end

    Tcp.instance:Send(data, length, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.registerReceivedCallback(callback)
    Tcp.instance:RegisterReceivedCallback(callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.unregisterReceivedCallback()
    Tcp.instance:UnregisterReceivedCallback()
end

return tcp

--endregion
