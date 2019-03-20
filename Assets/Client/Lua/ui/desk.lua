--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local chatConfig    = require("config.chatConfig")

local base = require("ui.common.view")
local desk = class("desk", base)

function desk:onInit()
    self.voiceDownPos = Vector2.zero

    if self.game.mode == gameMode.normal then
        self.mInvite:show()
        self.mReady:show()
        self.mCancel:hide()
        self.mPosition:show()
        self.mChat:show()
        self.mVoice:show()
    else
        self.mInvite:hide()
        self.mReady:hide()
        self.mCancel:hide()
        self.mPosition:hide()
        self.mChat:hide()
        self.mVoice:hide()
    end

    self.mInvitePanel:hide()
    self.mVoiceTips:hide()

    self.mSetting:addClickListener(self.onSettingClickedHandler, self)

    if self.game.mode == gameMode.normal then
        self.mInvite:addClickListener(self.onInviteClickedHandler, self)
        self.mInvitePanel:addClickListener(self.onInvitePanelClickedHandler, self)
        self.mInviteWX:addClickListener(self.onInviteWXClickedHandler, self)
        self.mInviteXL:addClickListener(self.onInviteXLClickedHandler, self)
        self.mInviteCN:addClickListener(self.onInviteCNClickedHandler, self)
        self.mReady:addClickListener(self.onReadyClickedHandler, self)
        self.mCancel:addClickListener(self.onCancelClickedHandler, self)
        self.mPosition:addClickListener(self.onPositionClickedHandler, self)
        self.mChat:addClickListener(self.onChatClickedHandler, self)
        self.mVoice:addDownListener(self.onVoiceDownClickedHandler, self)
        self.mVoice:addMoveListener(self.onVoiceMoveClickedHandler, self)
        self.mVoice:addUpListener(self.onVoiceUpClickedHandler, self)
    end

    self:registerHandlers()
    self:refreshUI()

    self.curtimeTimestamp = time.realtimeSinceStartup()
    self.batteryTimestamp = time.realtimeSinceStartup()
    self.networkTimestamp = time.realtimeSinceStartup()

    self.gvoiceRecordfileId = 1
end

function desk:registerHandlers()
    if self.game.mode == gameMode.normal then
        -- networkManager.registerCommandHandler(protoType.sc.chatMessage, function(msg)
        --     self:onChatMessageHandler(msg)
        -- end, true)

        gvoiceManager.registerRecordFinishedHandler(function(filename)
            self:onGVoiceRecordFinishedHandler(filename)
        end)
        gvoiceManager.registerPlayStartedHandler(function(filename, acId)
            self:onGVoicePlayStartedHandler(filename, acId)
        end)
        gvoiceManager.registerPlayFinishedHandler(function(filename, acId)
            self:onGVoicePlayFinishedHandler(filename, acId)
        end)

        signalManager.registerSignalHandler(signalType.chatText,  self.onChatTextSignalHandler,  self)
        signalManager.registerSignalHandler(signalType.chatEmoji, self.onChatEmojiSignalHandler, self)
        signalManager.registerSignalHandler(signalType.chatCMsg,  self.onChatCMsgSignalHandler, self)
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function desk:unregisterHandlers()
    if self.game.mode == gameMode.normal then
        -- networkManager.unregisterCommandHandler(protoType.sc.chatMessage)

        gvoiceManager.unregisterRecordFinishedHandler()
        gvoiceManager.unregisterPlayStartedHandler()
        gvoiceManager.unregisterPlayFinishedHandler()

        signalManager.unregisterSignalHandler(signalType.chatText,  self.onChatTextSignalHandler,  self)
        signalManager.unregisterSignalHandler(signalType.chatEmoji, self.onChatEmojiSignalHandler, self)
        signalManager.unregisterSignalHandler(signalType.chatCMsg,  self.onChatCMsgSignalHandler, self)
    end

    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function desk:update()
    local now = time.realtimeSinceStartup()

    if now - self.curtimeTimestamp > 0.999 then
        --刷新时间
        self.mTime:setText(time.formatTimeWithoutSecond())
        self.curtimeTimestamp = now
        --刷新网络延时
        self:updateNetworkDelays()
    end

    if now - self.batteryTimestamp > 59.9 then
        --刷新电池状态
        self:updateBatteryInfo()
        self.batteryTimestamp = now
    end

    if now - self.networkTimestamp > 59.9 then
        --刷新网络状态
        self:updateNetworkInfo()
        self.networkTimestamp = now
    end

    if self.game.mode == gameMode.normal then
        gvoiceManager.update()
    end
end

function desk:updateBatteryInfo()
    local level = self:getBatteryLevel()
    if level == -1 then
        self.mBattery:hide()
    else
        self.mBattery:show()

        local status = self:getBatteryStatus()
        if status == 1 or status == 4 then --充电中
            self.mBatteryCharging:show()
        else
            self.mBatteryCharging:hide()
        end

        if level < 0.2 then
            self.mBatteryLevel:setSprite("r")
        else
            self.mBatteryLevel:setSprite("g")
        end

        self.mBatteryLevel:setFillAmount(level)
    end
end

function desk:updateNetworkInfo()
    self.networkType = self:getNetworkType()
    if self.networkType == 0 then
        self.mNet:hide()
    else
        self.mNet:show()
        self:updateNetworkDelays()
    end
end

function desk:updateNetworkDelays()
    if self.networkType == 0 then
        return 
    end

    local delays = math.floor(networkManager.delays)
    
    if delays < 200 then
        if self.networkType == 1 then
            self.mNetType:setSprite("net_g")
        else
            self.mNetType:setSprite("wifi_g")
        end
    else
        if self.networkType == 1 then
            self.mNetType:setSprite("net_r")
        else
            self.mNetType:setSprite("wifi_r")
        end
    end

    self.mNetDelays:setText(string.format("%dms", delays))
end

function desk:getInvitationInfo()
    local friendsterText = (self.game.friendsterId == nil or self.game.friendsterId <= 0) and string.empty or string.format("亲友圈：%d，", self.game.friendsterId)
    local configText = self.game:convertConfigToString(false, false, "，")
    return string.format("%s%s", friendsterText, configText)
end

function desk:onCloseAllUIHandler()
    self:close()
end

function desk:refreshUI()
    local totalCount = self.game:getTotalPlayerCount()
    if totalCount == 3 then
        if self.headers[seatType.top] ~= nil then
            self.headers[seatType.top]:hide()
        end
    elseif totalCount == 2 then
        self.headers[seatType.left]:hide()
        self.headers[seatType.right]:hide()
    end

    self.mDeskID:setText(string.format("%s%s:%d", cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.game.deskId))
    self:updateCurrentGameIndex()
    self.mTime:setText(time.formatTimeWithoutSecond())
    self:updateBatteryInfo()
    self:updateNetworkInfo()
    self:updateNetworkDelays()

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatTypeByAcId(v.acId)
        local p = self.headers[s]
        p:setPlayerInfo(v)

        if self.game.mode == gameMode.playback or self.game:isPlaying() then
            p:setReady(false)
        end
    end

    if self.game.mode == gameMode.normal then
        self:refreshInvitationButtonState()
    end
end

function desk:refreshInvitationButtonState()
    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if playerCount == playerTotalCount then
        self.mInvite:setInteractabled(false)
        self.mInviteText:setSprite("disable")

        self.mInvitePanel:hide()
    else
        self.mInvite:setInteractabled(true)
        self.mInviteText:setSprite("enable")
    end
end

function desk:onInviteClickedHandler()
    playButtonClickSound()
    self.mInvitePanel:show()
end

function desk:onInvitePanelClickedHandler()
    playButtonClickSound()
    self.mInvitePanel:hide()
end

function desk:onInviteWXClickedHandler()
    playButtonClickSound()

    local image = textureManager.load(string.empty, "appicon")
    if image ~= nil then
        platformHelper.shareUrlWx(string.format("%s%s：%d", cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.game.deskId), 
                                  self:getInvitationInfo(), 
                                  networkConfig.server.shareURL,
                                  image,
                                  false)
        textureManager.unload(image)
    end

    self.mInvitePanel:hide()
end

function desk:onInviteXLClickedHandler()
    playButtonClickSound()

    local image = textureManager.load(string.empty, "appicon")
    if image ~= nil then
        local params = { cityType = self.game.cityType, deskId = self.game.deskId, }

        platformHelper.shareInvitationSg(string.format("%s%s：%d", cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.game.deskId), 
                                         self:getInvitationInfo(), 
                                         image,
                                         table.tojson(params),
                                         networkConfig.server.shareURL,
                                         networkConfig.server.shareURL)
        textureManager.unload(image)
    end

    self.mInvitePanel:hide()
end

function desk:onInviteCNClickedHandler()
    playButtonClickSound()

    local thumbpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "appicon.jpg")
    if not LFS.FileExist(thumbpath) then
        local image = textureManager.load(string.empty, "appicon")
        if image ~= nil then
            saveTextureToJPG(thumbpath, image)
            textureManager.unload(image)
        end
    end

    platformHelper.shareUrlWx(string.format("%s%s：%d", cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.game.deskId), 
                              self:getInvitationInfo(), 
                              networkConfig.server.shareURL,
                              thumbpath)
        

    self.mInvitePanel:hide()
end

function desk:onReadyClickedHandler()
    self.game:ready(true)
    playButtonClickSound()
end

function desk:onCancelClickedHandler()
    self.game:ready(false)
    playButtonClickSound()
end

function desk:onPositionClickedHandler()
    local location = locationManager.getData()
    talkingData.event(talkingData.eventType.clicklocation, {
    })
    if not location.status then
        local ui = require("ui.location").new(self.game)
        ui:show()
    else
        showWaitingUI("正在定位各玩家位置，请稍候...")

        local function onLocation(msg)
            closeWaitingUI()

            if msg ~= nil and msg.Locations ~= nil then
                for _, v in pairs(msg.Locations) do
                    local player = self.game:getPlayerByAcId(v.AcId)
                    player.location.status    = v.Has
                    player.location.latitude  = v.Latitude
                    player.location.longitude = v.Longitude
                end
            end

            local ui = require("ui.location").new(self.game)
            ui:show()
        end

        networkManager.syncLocation(location, function(msg)
            self.game:pushMessage(onLocation, 0, msg)
        end)
    end

    playButtonClickSound()
end

function desk:onSettingClickedHandler()
    if self.game.mode == gameMode.playback then
        local ui = require("ui.setting.playbackSetting").new(self.game)
        ui:show()
    else
        local ui = self:createSettingUI()
        ui:show()
    end

    playButtonClickSound()
end

function desk:onChatClickedHandler()
    local ui = require("ui.chat").new()
    ui:show()

    playButtonClickSound()
end

function desk:onVoiceDownClickedHandler(sender, pos)
    playButtonClickSound()

    self.mVoiceTips:show()
    self.mVoiceTipsOk:show()
    self.mVoiceTipsCancel:hide()

    self.voiceDownPos = pos

    local filename = LFS.CombinePath(gvoiceManager.path, tostring(self.game.mainAcId) .. tostring(self.gvoiceRecordfileId) .. ".gcv")
    self.gvoiceRecordfileId = self.gvoiceRecordfileId + 1
    gvoiceManager.startRecord(filename)
end

function desk:onVoiceMoveClickedHandler(sender, pos)
    if self.voiceDownPos == nil then
        self.voiceDownPos = pos
    end

    if pos.y - self.voiceDownPos.y > 150 then
        self.mVoiceTipsOk:hide()
        self.mVoiceTipsCancel:show()
    else
        self.mVoiceTipsOk:show()
        self.mVoiceTipsCancel:hide()
    end
end

function desk:onVoiceUpClickedHandler(sender, pos)
    self.mVoiceTips:hide()

    if self.voiceDownPos == nil then
        gvoiceManager.stopRecord(true)
        return
    end

    if pos.y - self.voiceDownPos.y > 150 then
        gvoiceManager.stopRecord(true)
    else 
        gvoiceManager.stopRecord(false)
    end

    self.voiceDownPos = Vector2.zero
end

function desk:cancelVoice()
    gvoiceManager.stopRecord(true)
    self.mVoiceTips:hide()
    self.voiceDownPos = Vector2.zero
end

function desk:setScore(acId, score)
    local seat = self.game:getSeatTypeByAcId(acId)
    self.headers[seat]:setScore(score)
end

function desk:setReady(acId, ready)
    if acId == self.game.mainAcId then
        if ready then
            self.mReady:hide()
            self.mCancel:show()
        else
            self.mReady:show()
            self.mCancel:hide()
        end
    else
        local seat = self.game:getSeatTypeByAcId(acId)
        self.headers[seat]:setReady(ready)
    end
end

function desk:onGameStart()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    for _, v in pairs(self.game.players) do 
        local st = self.game:getSeatTypeByAcId(v.acId)
        local hd = self.headers[st]

        hd:setPlayerInfo(v)
        hd:setReady(false)
    end

    self:updateCurrentGameIndex()
end

function desk:onGameSync()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    self:syncPlayerInfo()
    self:refreshInvitationButtonState()
    self:updateCurrentGameIndex()
end

function desk:reReloacateHeader()
    for _, v in pairs(self.headers) do 
        v:reset()
        v:hide()
    end
    for _, v in pairs(self.game.players) do 
        local st = self.game:getSeatTypeByAcId(v.acId)
        local hd = self.headers[st]

        hd:show()
        hd:setPlayerInfo(v)
    end
end

function desk:syncPlayerInfo()
    for _, v in pairs(self.game.players) do 
        local st = self.game:getSeatTypeByAcId(v.acId)
        local hd = self.headers[st]

        hd:setPlayerInfo(v)
    end
end

function desk:reset()
    if self.game.mode == gameMode.normal then
        self.mInvite:show()
        self.mReady:show()
    else
        self.mInvite:hide()
        self.mReady:hide()
    end
    self.mCancel:hide()
    self:refreshInvitationButtonState()

    for _, v in pairs(self.headers) do
        v:reset()
    end
end

function desk:updateCurrentGameIndex()
    local totalGameCount = self.game:getTotalGameCount()
    local leftGameCount = self.game:getLeftGameCount()
    local currentGameIndex = totalGameCount - leftGameCount + 1

    self.mGameCount:setText(string.format("第%d/%d局", currentGameIndex, totalGameCount))
end

function desk:onPlayerEnter(player)
    self:refreshInvitationButtonState()

    local s = self.game:getSeatTypeByAcId(player.acId)
    local p = self.headers[s]

    p:setPlayerInfo(player)
end

function desk:onPlayerConnectStatusChanged(player)
    local s = self.game:getSeatTypeByAcId(player.acId)
    local p = self.headers[s]
    p:setOnline(player.connected)
end

function desk:onPlayerExit(seatType, msg)
    self:refreshInvitationButtonState()

    local p = self.headers[seatType]

    p:setPlayerInfo(nil)
end

function desk:onChatMessageHandler(msg)
--    log("chat message, msg = " .. table.tostring(msg))
    local seat = self.game:getSeatTypeByAcId(msg.AcId)
    local header = self.headers[seat]

    if msg.Type == chatType.text then
        local k = tonumber(msg.Data)

        local content = chatConfig.text[k].content
        local audio = chatConfig.text[k].audio

        header:showChatText(content)

        local player = self.game:getPlayerByAcId(msg.AcId)
        playChatTextSound(self.game.gameType, k, player.sex)
    elseif msg.Type == chatType.emoji then
        local info = chatConfig.emoji[msg.Data]
        if not info then
            return
        end
        local content = chatConfig.emoji[msg.Data].content
        local audio = chatConfig.emoji[msg.Data].audio

        header:showChatEmoji(content)
    elseif msg.Type == chatType.cmsg then
        header:showChatText(msg.Data)
    elseif msg.Type == chatType.voice then
        local fileid = msg.Data
        local filename = LFS.CombinePath(gvoiceManager.path, Hash.GetHash(fileid) .. ".gcv")

        gvoiceManager.startPlay(filename, fileid, msg.AcId)
    end
end

function desk:onChatTextSignalHandler(key)
    local content = chatConfig.text[key].content

    local header = self.headers[seatType.mine]
    header:showChatText(content)

    playChatTextSound(self.game.gameType, key, gamepref.player.sex)
end

function desk:onChatEmojiSignalHandler(key)
    local content = chatConfig.emoji[key].content
    local audio = chatConfig.emoji[key].audio

    local header = self.headers[seatType.mine]
    header:showChatEmoji(content)
end

function desk:onChatCMsgSignalHandler(text)
    local header = self.headers[seatType.mine]
    header:showChatText(text)
end

function desk:onGVoiceRecordFinishedHandler(filename)
    local header = self.headers[seatType.mine]
    gvoiceManager.startPlay(filename, nil, gamepref.player.acId)
end

function desk:onGVoicePlayStartedHandler(filename, acId)
--    log("gvoice started handler " .. tostring(acId))
    for _, v in pairs(self.headers) do
        if v.acId == acId then
            v:showChatVoice()
            break
        end
    end
end

function desk:onGVoicePlayFinishedHandler(filename, acId)
--    log("gvoice stoped handler " .. tostring(acId))
    for _, v in pairs(self.headers) do
        if v.acId == acId then
            v:hideChatVoice()
            break
        end
    end
end

function desk:getBatteryLevel()
    if queryFromCSV("deviceinfo") == nil then
        return -1
    end

    return DeviceInfo.GetBatteryLevel()
end

function desk:getBatteryStatus()
    if queryFromCSV("deviceinfo") == nil then
        return 0
    end

    return DeviceInfo.GetBatteryStatus()
end

function desk:getNetworkType()
    if queryFromCSV("deviceinfo") == nil then
        return 0
    end

    return DeviceInfo.GetNetworkType()
end

return desk

--endregion
