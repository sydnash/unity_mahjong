--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkCallbackPool = {}

networkCallbackPool.token = 1
networkCallbackPool.pool = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:generateToken()
    self.token = self.token + 1
    return self.token
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:push(callback)
    local token = self:generateToken()
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













local http      = require("network.http")
local tcp       = require("network.tcp")
local proto     = require("network.proto")
local protoType = require("network.protoType")
local gamepref  = require("logic.gamepref")
local cvt       = ByteUtils

local networkManager = class("networkManager")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function send(command, data, callback)
    local token = networkCallbackPool:push(callback)
    local msg = proto.build(command, token, gamepref.acId, gamepref.session, data)

    tcp.send(msg)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function receive(bytes, size)
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
    tcp.disconnect()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.login(callback)
    local form = table.toUrlArgs({ mac = getDeviceId() })
    http.getText(appConfig.guestURL .. "?" .. form, function(ok, text)
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
                        app.gamePlayer.acId = msg.AcId
                        app.gamePlayer.nickname = msg.Nickname

                        callback(true, msg)
                    end)
                end
            end)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.createRoom(gameType, choose, clubId)
    local data = { GameType = gameType, ConfigChoose = table.tojson(choose), ClubId = clubId }
    network.send(protoType.cs.createDesk, data, function(msg)
        callback(true, msg)
    end)
end

return networkManager

--endregion
