--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkCallbackPool = class("networkCallbackPool")
local token = 100

networkCallbackPool.pool = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:push(token, callback)
    self.pool[token] = callback
    return token
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:pop(token)
    local callback = self.pool[token]
    self.pool[token] = nil

    return callback
end











protoType           = require("network.protoType")
retc                = require("network.retc")
retcText            = require("const.retcText")

local http          = require("network.http")
local tcp           = require("network.tcp")
local proto         = require("network.proto")
local networkConfig = require("config.networkConfig")
local deviceConfig  = require("config.deviceConfig")
local gamepref      = require("logic.gamepref")
local cvt           = ByteUtils

local networkManager = class("networkManager")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function getDeviceId()
    if appConfig.debug and deviceConfig.deviceId ~= nil then
        return deviceConfig.deviceId
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function send(command, data, callback)
    token = networkCallbackPool:push(token + 1, callback)
    local msg = proto.build(command, token, gamepref.acId, gamepref.session, data)

    tcp.send(msg, function()
        networkCallbackPool:pop(token)
        callback(nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function receive(bytes, size)
    if bytes == nil and size < 0 then
        return
    end

    --缓存收到的数据
    if networkManager.recvbuffer == nil then
        networkManager.recvbuffer = cvt.NewByteArray(bytes, 0, size)
    else
        networkManager.recvbuffer = cvt.ConcatBytes(networkManager.recvbuffer, networkManager.recvbuffer.Length, bytes, size)
    end

    --解析数据
    local msg, length = proto.parse(networkManager.recvbuffer)

    if length > 0 then
        --剔除已解析过的数据
        networkManager.recvbuffer = cvt.TrimBytes(networkManager.recvbuffer, length)

        if msg ~= nil then
            local callback = networkCallbackPool:pop(msg.RequestId)
            if callback == nil then
                callback = networkCallbackPool:pop(msg.Command)
            end

            if callback ~= nil then
                callback(table.fromjson(msg.Payload))
            end
        end
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.setup()
    tcp.registerReceivedCallback(receive)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.disconnect()
    log("network disconnect begin: " .. time.now())
    tcp.disconnect()
    log("network disconnect end: " .. time.now())
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.registerCommandHandler(command, callback)
    networkCallbackPool:push(command, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.unregisterCommandHandler(command)
    networkCallbackPool:pop(command)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.login(callback)
    local form = table.toUrlArgs({ mac = getDeviceId() })
    http.getText(networkConfig.guestURL .. "?" .. form, networkConfig.httpTimeout * 1000, function(ok, text)
        if not ok or string.isNilOrEmpty(text) then
            log("http response: error")
            callback(false, nil)
        else
            log("http response: ok! text = " .. text)
            local o = table.fromjson(text)

            local host = o.ip
            local port = o.port
            local acid = o.acid
            local session = o.session

            gamepref.acId = acid
            gamepref.session = session

            tcp.connect(host, port, function(connected)
                if not connected then
                    callback(false, nil)
                else
                    local loginType = 1
                    local data = { AcId = acid, Session = session, LoginType = loginType }
                    send(protoType.cs.loginHs, data, function(msg)
                        if msg == nil then
                            callback(false, nil)
                        else
                            log("login msg = " .. table.tostring(msg))

                            gamepref.session = msg.Session
                            app.gamePlayer.acId = msg.AcId
                            app.gamePlayer.nickname = msg.Nickname

                            callback(true, msg)
                        end
                    end)
                end
            end)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.createDesk(cityType, choose, clubId, callback)
    local data = { GameType = cityType, ConfigChoose = table.tojson(choose), ClubId = clubId }
    send(protoType.cs.createDesk, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            log("create desk msg = " .. table.tostring(msg))
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.checkDesk(cityType, deskId, callback)
    local data = { GameType = cityType, DeskId = deskId }
    send(protoType.cs.checkDesk, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            log("check desk msg = " .. table.tostring(msg))
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.enterDesk(cityType, deskId, callback)
    local latitude = 0
    local longitude = 0
    local hasPosition = false

    local data = { GameType = cityType, DeskId = deskId, Latitude = latitude, Longitude = longitude, HasPosition = has}
    send(protoType.cs.enterGSDesk, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            log("enter desk msg = " .. table.tostring(msg))
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.ready(ready, callback)
    local data = {IsReady = ready}
    send(protoType.cs.ready, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            log("ready msg = " .. table.tostring(msg))
            callback(true, msg)
        end
    end)
end

return networkManager

--endregion
