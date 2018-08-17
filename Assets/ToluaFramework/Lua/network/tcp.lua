--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tcp = class("tcp")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.connect(host, port, callback)
    Tcp.instance:Connect(host, port, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.disconnect()
    Tcp.instance:Disconnect()
    Tcp.instance:UnregisterReceivedHandler()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.send(data)
    Tcp.instance:Send(data)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp.registerReceivedCallback(callback)
    Tcp.instance:RegisterReceivedHandler(callback)
end

return tcp

--endregion
