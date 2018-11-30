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
function networkCallbackPool:pop(token, force)
    local slot = self.pool[token]

    if slot then
        local callback = slot.c

        if force or not slot.n then
            self.pool[token] = nil
        end

        return callback
    end

    return nil
end






local networkHandler = class("networkHandler")

----------------------------------------------------------------
--
----------------------------------------------------------------
function networkHandler.setup()
    networkManager.registerCommandHandler(protoType.sc.mail, function(msg)
        gamepref.player:addMail(msg)
        signalManager.signal(signalType.mail)
    end, true)
    networkManager.registerCommandHandler(protoType.sc.notifyPropertyChange, function(data)
        if data["coin"] then
            gamepref.player.cards = data["coin"]
            signalManager.signal(signalType.cardsChanged)
        elseif data["gold"] then
            gamepref.player.cards = data["gold"]
            signalManager.signal(signalType.cardsChanged)
        end
    end, true)
    networkManager.registerCommandHandler(protoType.sc.authorErrorNotify, function()
        --直接显示登录失效，重新登录，并且关闭网络连接
        closeWaitingUI()
        if clientApp.currentDesk ~= nil then
            clientApp.currentDesk:destroy()
            clientApp.currentDesk = nil
        end
        closeAllUI()
        networkManager.disconnect()

        showMessageUI("登录失效，请重新登录",
                        function()--确定：回到登录界面
                            local ui = require("ui.login").new()
                            ui:show()
                        end)
    end)
end






protoType               = require("network.protoType")

local http              = require("network.http")
local tcpClass          = require("network.tcp")
local proto             = require("network.proto")
local networkConfig     = require("config.networkConfig")
local cvt               = Utils

local networkManager    = class("networkManager")

local tcp = tcpClass.new()
-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function getDeviceId()
    if appConfig.debug and (not deviceConfig.isMobile) then
        return deviceConfig.deviceId
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function send(command, data, callback)
    token = networkCallbackPool:push(token + 1, callback)
--    log("send msg, command = " .. command)
    local msg, length = proto.build(command, token, gamepref.acId, gamepref.session, data)

    tcp:send(msg, length, function()
        networkCallbackPool:pop(token, false)
        callback(nil)
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local receiveBuffer = nil
local receiveBufferLenght = 0
local function receive(bytes, size)
    if bytes == nil and size < 0 then
        return
    end
    
    --缓存收到的数据
    if receiveBuffer == nil then
        receiveBuffer = cvt.NewByteArray(bytes, 0, size)
        receiveBufferLenght = size
    else
        receiveBuffer = cvt.ConcatBytes(receiveBuffer, receiveBuffer, receiveBufferLenght, bytes, size)
        receiveBufferLenght = receiveBufferLenght + size
    end

    --解析数据
    while receiveBuffer ~= nil and receiveBufferLenght > 0 do
        local msg, length = proto.parse(receiveBuffer)
        if length == 0 or msg == nil then 
            break 
        end

        --剔除已解析过的数据
        receiveBuffer = cvt.TrimBytes(receiveBuffer, length)
        receiveBufferLenght = receiveBufferLenght - length
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
    networkManager.disconnectedCallback_ = disconnectedCallback

    networkHandler.setup()
end

function networkManager.disconnectedCallback()
    printError("dis connect callback. ")
    networkManager.authored = false
    networkManager.stopUpdateHandler()
    networkManager.disconnectedCallback_()
end
-------------------------------------------------------------------
--心跳 管理
-------------------------------------------------------------------
function networkManager.startPingPong()
    networkManager.hasPingPong = true
    networkManager.authored = true
end
-------------------------------------------------------------------
--update 管理
-------------------------------------------------------------------
function networkManager.startUpdateHandler()
    local now = time.realtimeSinceStartup()
    networkManager.pingTick = now
    networkManager.pongTick = now

    if networkManager.updateHandler == nil then
        networkManager.updateTick = now
        networkManager.updateHandler = registerUpdateListener(networkManager.update, nil)
    end
end

function networkManager.stopUpdateHandler()
    if networkManager.updateHandler ~= nil then
         unregisterUpdateListener(networkManager.updateHandler)
         networkManager.updateHandler = nil
    end

    networkManager.hasPingPong = false
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

    if networkManager.hasPingPong then
        local ping = networkConfig.ping
        local pong = math.max(ping + 5, networkConfig.pong)
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
    end
    --处理消息队列
    if #networkManager.messageQueue > 0 then
        local msg = networkManager.messageQueue[1]
        table.remove(networkManager.messageQueue, 1)

        local callback = networkCallbackPool:pop(msg.RequestId, true)
        if callback == nil then
            callback = networkCallbackPool:pop(msg.Command, false)
        end

        if callback ~= nil then
            callback(table.fromjson(msg.Payload))
        end
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.author(host, port, connectedCallback, connecttimeoutCallback, disconnectedCallback)
    networkManager.authored = false
    receiveBufferLenght = 0
    local timeout = networkConfig.tcpTimeout * 1000 -- 转为毫秒
    tcp:connect(host, port, timeout, function()
        tcp:registerReceivedCallback(receive)
        networkManager.startUpdateHandler()
        connectedCallback()
    end, function()
        connecttimeoutCallback()
    end, function()
        disconnectedCallback()
    end)
end

function networkManager.reconnect(host, port, callback)
    networkManager.author(host, port, function(connected)
        networkManager.startUpdateHandler()
        --connected
        local data = { Session = gamepref.session, AcId = gamepref.acId, Level = 1, }
        send(protoType.cs.reconnect, data, function(msg)
            log("reconnect, msg = " ..  table.tostring(msg))
            callback(msg.Ok, msg.CurCoin, msg.GameType, msg.DeskId)
        end)
    end, function()
        --timeout
        callback(false, -1, -1, -1)
    end, function()
        --disconenct
        if networkManager.authored then
            networkManager.disconnectedCallback()
        else
            callback(false, -1, -1, -1)
        end
    end)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.disconnect()
    networkManager.stopUpdateHandler()
    receiveBufferLenght = 0
    tcp:disconnect()
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
    networkCallbackPool:pop(command, true)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function loginC(text, callback)
    local o = table.fromjson(text)

    if o.retcode ~= retc.ok then
        callback(nil)
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

    networkManager.author(host, port, function(connected)
        --connected
        local loginType = 1
        local data = { AcId = acid, Session = session, LoginType = loginType }
        send(protoType.cs.loginHs, data, function(msg)
            if msg == nil then
                callback(nil)
            else
                gamepref.session    = msg.Session
                gamepref.acId       = msg.AcId
                gamepref.desk       = { cityType = msg.DeskInfo.GameType, deskId = msg.DeskInfo.DeskId, }
                gamepref.player     = require("logic.player.gamePlayer").new(msg.AcId)
                        
                gamepref.player.headerUrl  = msg.HeadUrl
                gamepref.player:loadHeaderTex()
                gamepref.player.nickname   = msg.Nickname
                gamepref.player.ip         = msg.Ip
                gamepref.player.sex        = Mathf.Clamp(msg.Sex, sexType.boy, sexType.girl)
                gamepref.player.laolai     = msg.IsLaoLai
                gamepref.player.cards      = msg.Coin
                gamepref.player.userType   = msg.UserType
                gamepref.player:setMails(msg.Mails)
                networkManager.startPingPong()

                callback(msg)
            end
        end)
    end, function()
        --connect timeout
        callback(nil)
    end, function()
        --disconnectd
        if networkManager.authored then
            networkManager.disconnectedCallback()
        else
            callback(nil)
        end
    end)
end 

-------------------------------------------------------------------
-- 游客登录
-------------------------------------------------------------------
function networkManager.loginGuest(callback)
    log("networkManager.login")

    local form = table.toUrlArgs({ mac = getDeviceId() })
    local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒

    local loginURL = networkConfig.server.guestURL
    http.getText(loginURL .. "?" .. form, timeout, function(ok, text)
        if (not ok) or string.isNilOrEmpty(text) then
            callback(nil)
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

    platformHelper.registerLoginWxCallback(function(json)
        if string.isNilOrEmpty(json) then
            callback(nil)
            return
        end

        local resp = table.fromjson(json)
            
        if resp.errCode ~= errCodeWx.ok then
            showMessageUI("微信登录失败：" .. errTextWx[resp.errCode])
        else
            local accessUrl = string.format("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", resp.appid, resp.secret, resp.code)
            local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒

            http.getText(accessUrl, timeout, function(ok, text)
                if (not ok) or string.isNilOrEmpty(text) then
                    callback(nil)
                    return
                end

                local p = table.fromjson(text)
                local form = table.toUrlArgs({ wxtoken = p.refresh_token, appclass = "mj" })
                local loginURL = networkConfig.server.wechatURL
                http.getText(loginURL .. "?" .. form, timeout, function(ok, text)
                    loginC(text, callback)
                end)
            end)
        end
    end)

    platformHelper.loginWx()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.createDesk(cityType, choose, clubId, callback)
    local data = { GameType = cityType, ConfigChoose = table.tojson(choose), ClubId = clubId }
    send(protoType.cs.createDesk, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.checkDesk(cityType, deskId, callback)
    local data = { GameType = cityType, DeskId = deskId }
    send(protoType.cs.checkDesk, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.enterDesk(cityType, deskId, location, callback)
    local data = { GameType     = cityType, 
                   DeskId       = deskId, 
                   Latitude     = location.latitude, 
                   Longitude    = location.longitude, 
                   HasPosition  = location.status 
    }
    send(protoType.cs.enterGSDesk, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.ready(ready, callback)
    local data = {IsReady = ready}
    send(protoType.cs.ready, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.chuPai(cards, callback)
    local data = { Op = opType.chu.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.chiPai(cards, callback)
    local data = { Op = opType.chi.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.pengPai(cards, callback)
    local data = { Op = opType.peng.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.gangPai(cards, callback)
    local data = { Op = opType.gang.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.huPai(cards, callback)
    local data = { Op = opType.hu.id, Chose = { Cs = cards } }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.guoPai(callback)
    local data = { Op = opType.guo.id }
    send(protoType.cs.opChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.destroyDesk(callback)
    send(protoType.cs.exitDesk, table.empty, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.exitVote(agree, callback)
    local data = { Agree = agree }
    send(protoType.cs.exitVote, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.quicklyStartChose(agree, callback)
    local data = { Agree = agree }
    send(protoType.cs.quicklyStartChose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.proposerQuicklyStart(callback)
    send(protoType.cs.proposerQuicklyStart, table.empty, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.dingque(mahjongClass, callback)
    local data = { Q = mahjongClass }
    send(protoType.cs.dpChoose, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.sendChatMessage(chatType, chatContent, callback)
    local data = { Type = chatType, Data = chatContent }
    send(protoType.cs.chatMessage, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterList(callback)
    send(protoType.cs.queryFriendsterList, table.empty, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.createFriendster(city, name, callback)
    local data = { ClubName = name, ClubDesc = string.empty, GameType = city, ClubIcon = string.empty }
    send(protoType.cs.createFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.dissolveFriendster(friendsterId, callback)
    local data = { ClubId = friendsterId }
    send(protoType.cs.dissolveFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.joinFriendster(friendsterId, verificationCode, callback)
    local data = { ClubId = friendsterId, Code = verificationCode }
    send(protoType.cs.joinFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.exitFriendster(friendsterId, callback)
    local data = { ClubId = friendsterId }
    send(protoType.cs.exitFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterMembers(friendserId, callback)
    local data = { ClubId = friendserId }
    send(protoType.cs.queryFriendsterMembers, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterDesks(friendserId, callback)
    local data = { ClubId = friendserId }
    send(protoType.cs.queryFriendsterDesks, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterInfo(friendserId, verificationCode, callback)
    local data = { ClubId = friendserId, Code = verificationCode }
    send(protoType.cs.queryFriendsterInfo, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.modifyFriendsterDesc(friendsterId, desc, callback)
    local data = {ClubId = friendsterId, Desc = desc}
    send(protoType.cs.modifyFriendsterDesc, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.transferCards(id, count, callback)
    local data = {Target = id, Value = count}
    send(protoType.cs.transferCards, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryAcId(acId, callback)
    local data = { AcId = acId }
    send(protoType.cs.queryAcId, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.addAcIdToFriendster(friendserId, acId, callback)
    local data = { ClubId = friendserId, AcId = acId }
    send(protoType.cs.addAcIdToFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.deleteAcIdFromFriendster(friendserId, acId, callback)
    local data = { ClubId = friendserId, AcId = acId }
    send(protoType.cs.deleteAcIdFromFriendster, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.depositToFriendsterBank(friendsterId, value, callback)
    local data = { ClubId = friendsterId, Count = value }
    send(protoType.cs.depositToFriendsterBank, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.takeoutFromFriendsterBank(friendsterId, value, callback)
    local data = { ClubId = friendsterId, Count = value }
    send(protoType.cs.takeoutFromFriendsterBank, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterStatistics(friendsterId, startTime, callback)
    local data = { ClubId = friendsterId, StartTime = startTime }
    send(protoType.cs.queryFriendsterStatistics, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.replyFriendsterRequest(friendsterId, acId, agree, callback)
    local data = { ClubId = friendsterId, AcId = acId, Agree = agree }
    send(protoType.cs.replyFriendsterRequest, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.dissolveFriendsterDesk(friendsterId, cityType, deskId, callback)
    local data = { ClubId = friendsterId, GameType = cityType, DeskId = deskId, }
    send(protoType.cs.dissolveFriendsterDesk, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.deleteMail(mailId, callback)
    local data = { mailId = mailId, Op = 1 }
    send(protoType.cs.mailOp, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.openMail(mailId, callback)
    local data = { mailId = mailId, Op = 2 }
    send(protoType.cs.mailOp, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.getRewardsFromMail(mailId, callback)
    local data = { mailId = mailId, Op = 3 }
    send(protoType.cs.mailOp, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.syncLocation(location, callback)
    local data = { Latitude = location.latitude, Longitude = location.longitude, Has = location.status }
    send(protoType.cs.syncLocation, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.getPlayHistory(time, callback)
    local data =  {StartTime = time}
    send(protoType.cs.getPlayHistory, data, callback)
end

-------------------------------------------------------------------
--typ 0 表示拉取所有详细积分数据  round没有意义
--typ 2 表示拉取单场的对局详情  round从0开始
-------------------------------------------------------------------
function networkManager.getPlayHistoryDetail(typ, id, round, callback)
    local data = { Type = typ, Id = id, Round = round, }
    send(protoType.cs.getPlayHistoryDetail, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.getClubPlayHistoryDetail(clubId, typ, id, round, callback)
    local data = { ClubId = clubId, Type = typ, Id = id, Round = round, }
    send(protoType.cs.getClubPlayHistoryDetail, data, callback)
end

-------------------------------------------------------------------
--round 从0开始
-------------------------------------------------------------------
function networkManager.sharePlayHistory(id, round, callback)
    local data = { Id = id, Round = round }
    send(protoType.cs.sharePlayHistory, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.getSharePlayHistory(shareId, callback)
    local data = { ShareId = shareId }
    send(protoType.cs.getSharePlayHistory, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.setClubDeskPayed(clubId, historyId, callback)
    local data = { ClubId = clubId, Id = historyId, }
    send(protoType.cs.setClubDeskPayed, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.huanNZhang(cards, callback)
    local data = { Cs = cards }
    send(protoType.cs.huanNZhangChoose, data, callback)
end

return networkManager

--endregion
