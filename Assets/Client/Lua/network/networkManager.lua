--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkCallbackPool = class("networkCallbackPool")
local token = 100

networkCallbackPool.pool = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:push(token, callback, neverRemove)
    self.pool[token] = { c = callback, n = neverRemove }
    return token
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkCallbackPool:pop(token)
    local slot = self.pool[token]

    if slot then
        local callback = slot.c

        if not slot.n then
            self.pool[token] = nil
        end

        return callback
    end

    return nil
end











protoType           = require("network.protoType")
retc                = require("network.retc")

local http          = require("network.http")
local tcp           = require("network.tcp")
local proto         = require("network.proto")
local networkConfig = require("config.networkConfig")
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
    while networkManager.recvbuffer ~= nil do
        local msg, length = proto.parse(networkManager.recvbuffer)
        if length == 0 or msg == nil then 
            break 
        end

        --剔除已解析过的数据
        networkManager.recvbuffer = cvt.TrimBytes(networkManager.recvbuffer, length)
        --触发回调
        table.insert(networkManager.messageQueue, msg)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.setup(disconnectedCallback)
    networkManager.messageQueue = {}
    networkManager.messageDeadline = time.realtimeSinceStartup()
    networkManager.disconnectedCallback = disconnectedCallback
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.release()
    if networkManager.updateHandler ~= nil then
         unregisterUpdateListener(networkManager.updateHandler)
         networkManager.updateHandler = nil
    end

    networkManager.updateTick = 0
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.update()
    local now = time.realtimeSinceStartup()

    if now - networkManager.updateTick < 0.2 then
        return
    end

    local ping = networkConfig.ping
    local pong = math.max(ping + 0.5, networkConfig.pong)
    --发送心跳包
    if now - networkManager.pingTick > ping then
        send(protoType.hb, table.empty, function(msg)
            networkManager.pongTick = time.realtimeSinceStartup()
        end)
        networkManager.pingTick = time.realtimeSinceStartup()
    end
    --检查心跳是否超时
    if now - networkManager.pongTick > pong then
        networkManager.disconnect()

        if networkManager.disconnectedCallback ~= nil then
            networkManager.disconnectedCallback()
        end
    end
    --处理消息队列
    if now >= networkManager.messageDeadline and #networkManager.messageQueue > 0 then
        networkManager.messageDeadline = now 

        local msg = networkManager.messageQueue[1]
        table.remove(networkManager.messageQueue, 1)

        local callback = networkCallbackPool:pop(msg.RequestId)
        if callback == nil then
            callback = networkCallbackPool:pop(msg.Command)
        end

        if callback ~= nil then
            local duration = callback(table.fromjson(msg.Payload))
            if duration ~= nil and duration > 0 then
                networkManager.messageDeadline = now + duration
            end
        end
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.connect(host, port, callback)
    local timeout = networkConfig.tcpTimeout * 1000 -- 转为毫秒

    tcp.connect(host, port, timeout, function(connected)
        if connected then
            tcp.registerReceivedCallback(receive)

            local now = time.realtimeSinceStartup()
            networkManager.pingTick = now
            networkManager.pongTick = now

            if networkManager.updateHandler == nil then
                networkManager.updateTick = now
                networkManager.updateHandler = registerUpdateListener(networkManager.update, nil)
            end
        end

        if callback ~= nil then
            callback(connected)
        end
    end)
end

function networkManager.reconnect(host, port, callback)
    networkManager.connect(host, port, function(connected)
        if not connected then
            callback(false, -1, -1, -1)
        else
            local data = { Session = gamepref.session, AcId = gamepref.acId, Level = 1, }
            send(protoType.cs.reconnect, data, function(msg)
                log("reconnect, msg = " ..  table.tostring(msg))
                callback(msg.Ok, msg.CurCoin, msg.GameType, msg.DeskId)
            end)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.disconnect()
    networkManager.release()
    tcp.disconnect()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.registerCommandHandler(command, callback, neverRemove)
    networkCallbackPool:push(command, callback, neverRemove)
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
local function loginC(text, callback)
    local o = table.fromjson(text)
    --log("loginC, o = " .. table.tostring(o))

    if o.retcode ~= retc.Ok then
        callback(false, nil)
        return
    end

    local host       = o.ip
    local port       = o.port
    local acid       = o.acid
    local session    = o.session

    gamepref.acId    = acid
    gamepref.session = session
    gamepref.host    = host
    gamepref.port    = port

    networkManager.connect(host, port, function(connected)
        if not connected then
            callback(false, nil)
        else
            local loginType = 1
            local data = { AcId = acid, Session = session, LoginType = loginType }
            send(protoType.cs.loginHs, data, function(msg)
                if msg == nil then
                    callback(false, nil)
                else
                    gamepref.session    = msg.Session
                    gamepref.acId       = msg.AcId
                    gamepref.desk       = { cityType = msg.DeskInfo.GameType, deskId = msg.DeskInfo.DeskId, }
                    gamepref.player     = require("logic.player.gamePlayer").new(msg.AcId)
                            
                    gamepref.player.headerUrl  = msg.HeadUrl
                    gamepref.player:loadHeaderTex()
                    gamepref.player.nickname   = msg.Nickname
                    gamepref.player.ip         = msg.Ip
                    gamepref.player.sex        = Mathf.Clamp(msg.Sex, sexType.box, sexType.girl)
                    gamepref.player.laolai     = msg.IsLaoLai
                    gamepref.player.coin       = msg.Coin

                    callback(true, msg)
                end
            end)
        end
    end)
end 

-------------------------------------------------------------------
-- 游客登录
-------------------------------------------------------------------
function networkManager.login(callback)
    log("networkManager.login")

    local form = table.toUrlArgs({ mac = getDeviceId() })
    local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒

    http.getText(networkConfig.gameURL .. "?" .. form, timeout, function(ok, text)
        if not ok or string.isNilOrEmpty(text) then
            callback(false, nil)
            return
        end
        
        loginC(text, callback)
    end)
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function networkManager.loginWx(callback)  
    log("networkManager.loginWx")

    androidHelper.loginWx(function(json)
        if string.isNilOrEmpty(json) then
            callback(false, nil)
            return
        end

        local resp = table.fromjson(json)
        --log("networkManager.loginWx, resp = " .. table.tostring(resp))
        local accessUrl = string.format("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", resp.appid, resp.secret, resp.code)
        local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒

        http.getText(accessUrl, timeout, function(ok, text)
            if not ok or string.isNilOrEmpty(text) then
                callback(false, nil)
                return
            end

            local p = table.fromjson(text)
            local form = table.toUrlArgs({ wxtoken = p.refresh_token, appclass = "mj" })
            http.getText(networkConfig.gameURL .. "?" .. form, timeout, function(ok, text)
                loginC(text, callback)
            end)
        end)
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
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.chuPai(cards, callback)
    local data = { Op = opType.chu.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.chiPai(cards, callback)
    local data = { Op = opType.chi.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.pengPai(cards, callback)
    local data = { Op = opType.peng.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.gangPai(cards, callback)
    local data = { Op = opType.gang.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.huPai(cards, callback)
    local data = { Op = opType.hu.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.guoPai(callback)
    local data = { Op = opType.guo.id }
    send(protoType.cs.opChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.destroyDesk(callback)
    send(protoType.cs.exitDesk, table.empty, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.exitVote(agree, callback)
    local data = { Agree = agree }
    send(protoType.cs.exitVote, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.dingque(mahjongClass, callback)
    local data = { Q = mahjongClass }
    send(protoType.cs.dpChoose, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.sendChatMessage(chatType, chatContent, callback)
    local data = { Type = chatType, Data = chatContent }
    send(protoType.cs.chatMessage, data, function(msg)
        callback(false, nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterList(callback)
    send(protoType.cs.queryFriendsterList, table.empty, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.createFriendster(city, name, callback)
    local data = { ClubName = name, ClubDesc = string.empty, GameType = city, ClubIcon = string.empty }
    send(protoType.cs.createFriendster, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterMembers(friendserId, callback)
    local data = { ClubId = friendserId }
    send(protoType.cs.queryFriendserMembers, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterDesks(friendserId, callback)
    local data = { ClubId = friendserId }
    send(protoType.cs.queryFriendserDesks, data, function(msg)
        if msg == nil then
            callback(false, nil)
        else
            callback(true, msg)
        end
    end)
end

return networkManager

--endregion
