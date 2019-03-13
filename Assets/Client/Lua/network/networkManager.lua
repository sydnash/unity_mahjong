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
    end, true)
    networkManager.registerCommandHandler(protoType.sc.exitDesk, function(msg)
        signalManager.signal(signalType.deskDestroy, msg)
        gamepref.player.currentDesk = nil
    end, true)
end






protoType               = reload("network.protoType")

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
    if not deviceConfig.isMobile then
        return deviceConfig.deviceId
    end
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

local function processMessageQueue()
    while #networkManager.messageQueue > 0 do
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
        local msg, length = proto.parse(receiveBuffer, receiveBufferLenght)
        if length == 0 or msg == nil then 
            break 
        end

        --剔除已解析过的数据
        receiveBuffer = cvt.TrimBytes(receiveBuffer, length)
        receiveBufferLenght = receiveBufferLenght - length
        --触发回调
        table.insert(networkManager.messageQueue, msg)
    end

    processMessageQueue()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.setup(disconnectedCallback)
    networkManager.messageQueue = {}
    networkManager.messageDeadline = time.realtimeSinceStartup()
    networkManager.disconnectedCallback_ = disconnectedCallback

    networkHandler.setup()

    networkManager.delays = 128
end

function networkManager.disconnectedCallback()
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
    networkManager.pingTick = 0
    networkManager.pongTick = time.realtimeSinceStartup()
end
-------------------------------------------------------------------
--update 管理
-------------------------------------------------------------------
function networkManager.startUpdateHandler()
    local now = time.realtimeSinceStartup()
    networkManager.pingTick = now
    networkManager.pongTick = now

    if networkManager.updateHandler == nil then
        networkManager.updateHandler = registerUpdateListener(networkManager.update, nil)
    end
end

function networkManager.stopUpdateHandler()
    if networkManager.updateHandler ~= nil then
         unregisterUpdateListener(networkManager.updateHandler)
         networkManager.updateHandler = nil
    end

    networkManager.hasPingPong = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.update()
    local now = time.realtimeSinceStartup()

    if networkManager.hasPingPong then
        local ping = networkConfig.ping
        local pong = math.max(ping + 5, networkConfig.pong)
        --发送心跳包
        if now - networkManager.pingTick > ping then
            local lastPingTick = now
            send(protoType.hb, table.empty, function(msg)
                networkManager.pongTick = time.realtimeSinceStartup()
                networkManager.delays = (networkManager.pongTick - lastPingTick) * 0.5 * 1000 --毫秒
            end)
            networkManager.pingTick = now
        end
        --检查心跳是否超时
        if now - networkManager.pongTick > pong then
            log(string.format("[test for reconnect] pingpng time out . reconnect.now:%f pongtick:%f pong:%f pingtick:%f ping:%f", now, networkManager.pongTick, pong, networkManager.pingTick, ping))
            networkManager.disconnect()

            if networkManager.disconnectedCallback ~= nil then
                networkManager.disconnectedCallback()
            end
        end
    end
    --处理消息队列
    processMessageQueue()
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
            log("[test for reconnect] reconnect, msg = " ..  table.tostring(msg))
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
        closeWaitingUI()
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
        local loginType = 1
        local data = { AcId = acid, Session = session, LoginType = loginType }
        send(protoType.cs.loginHs, data, function(msg)
            closeWaitingUI()

            if msg == nil or msg.RetCode ~= retc.ok then
                callback(nil)
                networkManager.disconnect()
            else
                gamepref.session    = msg.Session
                gamepref.acId       = msg.AcId
                gamepref.desk       = { cityType = msg.DeskInfo.GameType, deskId = msg.DeskInfo.DeskId, }
                gamepref.player     = require("logic.player.gamePlayer").new(msg.AcId)
                        
                gamepref.player.headerUrl       = msg.HeadUrl
                gamepref.player.nickname        = msg.Nickname
                gamepref.player.ip              = msg.Ip
                gamepref.player.sex             = Mathf.Clamp(msg.Sex, sexType.boy, sexType.girl)
                gamepref.player.laolai          = msg.IsLaoLai
                gamepref.player.cards           = msg.Coin
                gamepref.player.userType        = msg.UserType
                gamepref.player.shareFKTimes    = msg.ShareCnt
                gamepref.player.complainLevel   = msg.ComplainLevel
  
                msg.ShareConfig                 = json.decode(msg.ShareConfig)
                gamepref.player.shareConfig     = {}
                gamepref.player.shareConfig.jqReward        = msg.ShareConfig.JQReward
                gamepref.player.shareConfig.jqMaxCnt        = msg.ShareConfig.JQMaxCnt
                gamepref.player.shareConfig.jqLogin         = msg.ShareConfig.JQLogin
                gamepref.player.shareConfig.dayLoginMaxCnt  = msg.ShareConfig.DayLoginMaxCnt
                --每日分享参数 少于lowlimit可以得房卡，最多count次，一次领取count张房卡
                gamepref.player.shareConfig.lowLimit        = msg.ShareConfig.LowLimit
                gamepref.player.shareConfig.count           = msg.ShareConfig.Count
                gamepref.player.shareConfig.reward          = msg.ShareConfig.Reward

                --TODO: cityType需要使用服务器传来的数据
                -- gamepref.city = { City = msg.preferGameType }
                -- if msg.preferGameType > 0 then
                --     gamepref.city.Region = cityRegion[msg.preferGameType]
                -- end

                gamepref.player:setMails(msg.Mails)
                networkManager.startPingPong()

                callback(msg)
            end
        end)
    end, function()
        --connect timeout
        closeWaitingUI()
        callback(nil)
    end, function()
        closeWaitingUI()
        --disconnectd
        if networkManager.authored then
            networkManager.disconnectedCallback()
        else
            callback(nil)
        end
    end)
end 

local httpAsync = http.createAsync()
local HTTP_METHOD = "POST"

local function getTextWithHttp(url, callback)
    local timeout = networkConfig.httpTimeout * 1000 -- 转为毫秒
    httpAsync:addTextRequest(url, HTTP_METHOD, timeout, nil, callback)
    httpAsync:start()
end

-------------------------------------------------------------------
-- 游客登录
-------------------------------------------------------------------
function networkManager.loginGuest(callback)
    showWaitingUI("正在登录，请稍候")

    local form = table.toUrlArgs({ mac = getDeviceId() })

    local loginURL = networkConfig.server.guestURL
    getTextWithHttp(loginURL .. "?" .. form, function(text)
        if string.isNilOrEmpty(text) then
            closeWaitingUI()
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
    local function loginToServerWithToken(token)
        local form = table.toUrlArgs({ wxtoken = token, appclass = "mj" })
        gamepref.setWXRefreshToken(token)
        local loginURL = networkConfig.server.wechatURL
        getTextWithHttp(loginURL .. "?" .. form, function(text)
            if string.isNilOrEmpty(text) then
                closeWaitingUI()
                callback(nil)
                showMessageUI("微信登录失败")
            else
                loginC(text, callback)
            end
        end)
    end
    platformHelper.registerLoginWxCallback(function(jsn)
        if string.isNilOrEmpty(jsn) then
            callback(nil)
            return
        end

        local resp = table.fromjson(jsn)
            
        if resp.errCode ~= errCodeWx.ok then
            callback(nil)
            showMessageUI("微信登录失败：" .. errTextWx[resp.errCode])
            return
        end

        showWaitingUI("正在登录，请稍候")

        local accessUrl = string.format("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", resp.appid, resp.secret, resp.code)
        getTextWithHttp(accessUrl, function(text)
            if string.isNilOrEmpty(text) then
                closeWaitingUI()
                callback(nil)
                showMessageUI("微信登录失败")
                return
            end

            local p = table.fromjson(text)
            if not json.isNilOrNull(p.errcode) then
                closeWaitingUI()
                callback(nil)
                showMessageUI("微信登录失败：" .. tostring(p.errmsg))
                return
            end
            loginToServerWithToken(p.refresh_token)
        end)
    end)

    local cacheWXToken = gamepref.getWXRefreshToken()

    if string.isNilOrEmpty(cacheWXToken) then
        platformHelper.loginWx()
    else
        showWaitingUI("正在登录，请稍候")
        networkManager.checkRefreshToken(cacheWXToken, function(ok)
            if ok then
                loginToServerWithToken(cacheWXToken)
            else
                closeWaitingUI()
                platformHelper.loginWx()
            end
        end)
    end
end

function networkManager.checkRefreshToken(token, cb)
    local refreshUrl = string.format("https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%s&grant_type=refresh_token&refresh_token=%s", "wx2ca58653c3f50625", token)
    getTextWithHttp(refreshUrl, function(text)
        if string.isNilOrEmpty(text) then
            cb(false)
            return
        end
        local p = table.fromjson(text)
        if not json.isNilOrNull(p.errcode) then
            cb(false)
            return
        end
        cb(true)
    end)
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
function networkManager.claimShareReward(callback)
    local data = {}
    send(protoType.cs.claimShareReward, data, callback)
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
function networkManager.sendChatMessage(ct, chatContent, callback)
    local data = { Type = ct, Data = chatContent }
    local param 
    if ct == chatType.voice or ct == chatType.cmsg then
        param = tostring(ct)
    else
        param = string.format("%s_%s", tostring(ct), tostring(chatContent))
    end

    talkingData.event(talkingData.eventType.chat, {
        Type = param,
    })
    -- talkingData.onPurchase("item", 1, 1)
    send(protoType.cs.chatMessage, data, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.queryFriendsterList(callback)
    send(protoType.cs.queryFriendsterList, table.empty, callback)
end

function networkManager.friendsterGameSetting(friendsterId, typ, msg, callback)
    local data = {
        ClubId      = friendsterId,
        Type        = typ,
        Settings    = msg, 
    }
    log("send data : " .. table.tostring(data))
    send(protoType.cs.friendsterGameSetting, data, callback)
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

function networkManager.csDang(isDang)
    local data = { IsDang = isDang }
    send(protoType.cs.doushisi.dang, data)
end

function networkManager.csAnPai(data)
    send(protoType.cs.doushisi.anPai, data)
end

function networkManager.csOpChose(data)
    send(protoType.cs.doushisi.opChose, data)
end

function networkManager.csBdChose(data)
    send(protoType.cs.doushisi.bdChose, data)
end

function networkManager.csPiao(data)
    send(protoType.cs.doushisi.piao, data)
end
-------------------------------------------------------------------
--
-------------------------------------------------------------------
function networkManager.huanNZhang(cards, callback)
    local data = { Cs = cards }
    send(protoType.cs.huanNZhangChoose, data, callback)
end

function networkManager.choseCity(cityType, callback)
    local data = { GameType = cityType }
    send(protoType.cs.cityType, callback)
end

return networkManager

--endregion
