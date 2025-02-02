--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tcp = class("tcp")
local cvt               = Utils

local tcpStatus = {
    disconnected    = 1,
    connecting      = 2,
    connected       = 3,
}

function tcp:ctor()
    self.receiveBuffer = cvt.NewEmptyByteArray(2 * 1024 * 1024)
    self.sendBuffer = cvt.NewEmptyByteArray(2 * 1024)
    self:disconnect()
    self.lastConnectStamp = 0
end

function tcp:disconnect()
    if self.tcp then
        self.tcp:Disconnect()
    end
    self.status = tcpStatus.disconnected
    self.sendBufferSize = 0
    if self.updateHandler then
        unregisterUpdateListener(updateHandler)
        self.updateHandler = nil
    end
end
-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp:connect(host, port, timeout, connectedCallback, connectTimeoutCallback, disconnectCallback)
    self:disconnect()
    self.tcp = Tcp.New()

    self.host                       = host
    self.port                       = port
    self.connectTimeout             = timeout / 1000
    self.startConnectTime           = time.realtimeSinceStartup()
    self.connectedCallback          = connectedCallback
    self.connectTimeoutCallback     = connectTimeoutCallback
    self.disconnectedCallback       = disconnectCallback
    self.status                     = tcpStatus.connecting
    self.lastConnectStamp           = -10000
    if not self.updateHandler then
        self.updateHandler = registerUpdateListener(tcp.update, self)
    end
end
function tcp:checkConnected()
    return self.tcp:Connect(self.host, self.port)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp:send(data, length, callback)
    self.sendBuffer = cvt.ConcatBytes(self.sendBuffer, self.sendBuffer, self.sendBufferSize, data, length)
    self.sendBufferSize = self.sendBufferSize + length
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp:registerReceivedCallback(callback)
    self.receiveCallback = callback
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tcp:unregisterReceivedCallback()
    self.receiveCallback = nil
end

function tcp:update()
    if self.status == tcpStatus.disconnected then
        return
    elseif self.status == tcpStatus.connecting then
        local now = time.realtimeSinceStartup()
        if now - self.lastConnectStamp < 5.0 then
            return
        end
        self.lastConnectStamp = now
        if self:checkConnected() == 0 then
            self.status = tcpStatus.connected
            self:onConnected()
        end
        if self.status ~= tcpStatus.connected then
            if now - self.startConnectTime > self.connectTimeout then
                self:disconnect()
                self:onConnectTimeout()
            end
        end
    elseif self.status == tcpStatus.connected then
        if self.sendBufferSize > 0 then
            self.tcp:Send(self.sendBuffer, self.sendBufferSize)
            self.sendBufferSize = 0
        end

        local receiveSize = self.tcp:Receive(self.receiveBuffer)
        if receiveSize > 0 then
            self.receiveCallback(self.receiveBuffer, receiveSize)
        elseif receiveSize < 0 then
            log("[test for reconnect] disconnected receive xxxx: " .. receiveSize)
            self:disconnect()
            self:onDisconnected()
        end
    end
end

function tcp:onConnected()
    if self.connectedCallback then
        self.connectedCallback()
    end
end
function tcp:onConnectTimeout()
    if self.connectTimeoutCallback then
        self.connectTimeoutCallback()
    end
end
function tcp:onDisconnected()
    if self.disconnectedCallback then
        self.disconnectedCallback()
    end
end

return tcp

--endregion
