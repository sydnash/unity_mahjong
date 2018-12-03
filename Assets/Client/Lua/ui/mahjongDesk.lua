--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongGame   = require("logic.mahjong.mahjongGame")
local chatConfig    = require("config.chatConfig")

local base = require("ui.common.view")
local mahjongDesk = class("mahjongDesk", base)

_RES_(mahjongDesk, "DeskUI", "DeskUI")

function mahjongDesk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function mahjongDesk:onInit()
    self.headers = { 
        [mahjongGame.seatType.mine]  = self.mPlayerM, 
        [mahjongGame.seatType.right] = self.mPlayerR, 
        [mahjongGame.seatType.top]   = self.mPlayerT, 
        [mahjongGame.seatType.left]  = self.mPlayerL, 
    }
    
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
    self.mGameInfo:addClickListener(self.onGameInfoClickedHandler, self)

    if self.game.mode == gameMode.normal then
        self.mInvite:addClickListener(self.onInviteClickedHandler, self)
        self.mInvitePanel:addClickListener(self.onInvitePanelClickedHandler, self)
        self.mInviteWX:addClickListener(self.onInviteWXClickedHandler, self)
        self.mInviteXL:addClickListener(self.onInviteXLClickedHandler, self)
        self.mReady:addClickListener(self.onReadyClickedHandler, self)
        self.mCancel:addClickListener(self.onCancelClickedHandler, self)
        self.mPosition:addClickListener(self.onPositionClickedHandler, self)
        self.mChat:addClickListener(self.onChatClickedHandler, self)
        self.mVoice:addDownListener(self.onVoiceDownClickedHandler, self)
        self.mVoice:addMoveListener(self.onVoiceMoveClickedHandler, self)
        self.mVoice:addUpListener(self.onVoiceUpClickedHandler, self)

        networkManager.registerCommandHandler(protoType.sc.chatMessage, function(msg)
            self:onChatMessageHandler(msg)
        end, true)

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
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self:refreshUI()
end

function mahjongDesk:update()
    self.mTime:setText(time.formatTime())

    if self.game.mode == gameMode.normal then
        gvoiceManager.update()
    end
end

function mahjongDesk:onCloseAllUIHandler()
    self:close()
end

function mahjongDesk:onDestroy()
    if self.game.mode == gameMode.normal then
        networkManager.unregisterCommandHandler(protoType.sc.chatMessage)
        signalManager.unregisterSignalHandler(signalType.chatText,  self.onChatTextSignalHandler,  self)
        signalManager.unregisterSignalHandler(signalType.chatEmoji, self.onChatEmojiSignalHandler, self)
    end

    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

function mahjongDesk:refreshUI()
    for _, p in pairs(self.headers) do
        
    end

    local totalCount = self.game:getTotalPlayerCount()
    if totalCount == 3 then
        self.headers[mahjongGame.seatType.top]:hide()
    elseif totalCount == 2 then
        self.headers[mahjongGame.seatType.left]:hide()
        self.headers[mahjongGame.seatType.right]:hide()
    end

    self.mDeskID:setText(string.format("房号:%d", self.game.deskId))
    self:updateCurrentGameIndex()
    self.mTime:setText(time.formatTime())
    self:updateLeftMahjongCount()

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatTypeByAcId(v.acId)
        local p = self.headers[s]
        p:setPlayerInfo(v)

        if self.game.mode == gameMode.playback or self.game.status == gameStatus.playing then
            p:setReady(false)
        end
    end

    if self.game.mode == gameMode.normal then
        self:refreshInvitationButtonState()
    end
end

function mahjongDesk:refreshInvitationButtonState()
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

function mahjongDesk:onInviteClickedHandler()
    playButtonClickSound()
    self.mInvitePanel:show()
end

function mahjongDesk:onInvitePanelClickedHandler()
    playButtonClickSound()
    self.mInvitePanel:hide()
end

function mahjongDesk:onInviteWXClickedHandler()
    playButtonClickSound()

    local image = textureManager.load(string.empty, "appIcon")
    if image ~= nil then
        platformHelper.shareUrlWx("好友邀请", 
                                  self:getInvitationInfo(), 
                                  networkConfig.server.shareURL,
                                  image,
                                  false)
        textureManager.unload(image)
    end

    self.mInvitePanel:hide()
end

function mahjongDesk:onInviteXLClickedHandler()
    playButtonClickSound()

    local image = textureManager.load(string.empty, "appIcon")
    if image ~= nil then
        local params = { cityType = self.game.cityType, deskId = self.game.deskId, }

        platformHelper.shareInvitationSg("好友邀请", 
                                         self:getInvitationInfo(), 
                                         image,
                                         table.tojson(params),
                                         networkConfig.server.shareURL,
                                         networkConfig.server.shareURL)
        textureManager.unload(image)
    end

    self.mInvitePanel:hide()
end

function mahjongDesk:getInvitationInfo()
    return string.format("房号：%d，类型：血战到底，人数：%d/%d", 
                         self.game.deskId, 
                         self.game:getPlayerCount(),
                         self.game:getTotalPlayerCount())
end

function mahjongDesk:onReadyClickedHandler()
    playButtonClickSound()
    self.game:ready(true)
end

function mahjongDesk:onCancelClickedHandler()
    playButtonClickSound()
    self.game:ready(false)
end

function mahjongDesk:onPositionClickedHandler()
    playButtonClickSound()

    local location = locationManager.getData()
    if not location.status then
        local ui = require("ui.location").new(self.game)
        ui:show()
    else
        showWaitingUI("正在定位各玩家位置，请稍候...")

        networkManager.syncLocation(location, function(msg)
            closeWaitingUI()

            if msg ~= nil then
                for _, v in pairs(msg.Locations) do
                    local player = self.game:getPlayerByAcId(v.AcId)
                    player.location.status    = v.Has
                    player.location.latitude  = v.Latitude
                    player.location.longitude = v.Longitude
                end
            end

            local ui = require("ui.location").new(self.game)
            ui:show()
        end)
    end
end

function mahjongDesk:onSettingClickedHandler()
    playButtonClickSound()

    local ui = require("ui.setting").new(self.game)
    ui:show()

--    self.game:proposerQuicklyStart()
end

function mahjongDesk:onChatClickedHandler()
    playButtonClickSound()

    local ui = require("ui.chat").new()
    ui:show()

--    self.game:quicklyStartChose(true)
end

function mahjongDesk:onVoiceDownClickedHandler(sender, pos)
    playButtonClickSound()

    self.mVoiceTips:show()
    self.mVoiceTipsOk:show()
    self.mVoiceTipsCancel:hide()

    self.voiceDownPos = pos

    gvoiceManager.stopPlay()
    gvoiceManager.startRecord(LFS.CombinePath(gvoiceManager.path, tostring(self.game.mainAcId) .. ".gcv"))
end

function mahjongDesk:onVoiceMoveClickedHandler(sender, pos)
    if pos.y - self.voiceDownPos.y > 150 then
        self.mVoiceTipsOk:hide()
        self.mVoiceTipsCancel:show()
    else
        self.mVoiceTipsOk:show()
        self.mVoiceTipsCancel:hide()
    end
end

function mahjongDesk:onVoiceUpClickedHandler(sender, pos)
    if pos.y - self.voiceDownPos.y > 150 then
        gvoiceManager.stopRecord(true)
    else 
        gvoiceManager.stopRecord(false)
    end

    self.mVoiceTips:hide()
    self.voiceDownPos = Vector2.zero
end

function mahjongDesk:setScore(acId, score)
    local seat = self.game:getSeatTypeByAcId(acId)
    self.headers[seat]:setScore(score)
end
function mahjongDesk:setReady(acId, ready)
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

function mahjongDesk:onGameStart()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    for _, v in pairs(self.game.players) do 
        local st = self.game:getSeatTypeByAcId(v.acId)
        local hd = self.headers[st]

        hd:setReady(false)
        hd:setMarker(v.isMarker)
    end

    self:updateCurrentGameIndex()
end

function mahjongDesk:onGameSync()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    for _, v in pairs(self.game.players) do 
        local st = self.game:getSeatTypeByAcId(v.acId)
        local hd = self.headers[st]

        hd:setPlayerInfo(v)
    end

    self:updateCurrentGameIndex()
end

function mahjongDesk:reset()
    if self.game.mode == gameMode.normal then
        self.mInvite:show()
        self.mReady:show()
    else
        self.mInvite:hide()
        self.mReady:hide()
    end
    self.mCancel:hide()

    for _, v in pairs(self.headers) do
        v:reset()
    end
end

function mahjongDesk:updateCurrentGameIndex()
    local totalGameCount = self.game:getTotalGameCount()
    local leftGameCount = self.game:getLeftGameCount()
    local currentGameIndex = totalGameCount - leftGameCount + 1

    self.mGameCount:setText(string.format("第%d/%d局", currentGameIndex, totalGameCount))
end

function mahjongDesk:onPlayerEnter(player)
    self:refreshInvitationButtonState()

    local s = self.game:getSeatTypeByAcId(player.acId)
    local p = self.headers[s]

    p:setPlayerInfo(player)
end

function mahjongDesk:onPlayerConnectStatusChanged(player)
    local s = self.game:getSeatTypeByAcId(player.acId)
    local p = self.headers[s]
    p:setOnline(player.connected)
end

function mahjongDesk:onPlayerExit(seatType, msg)
    self:refreshInvitationButtonState()

    local p = self.headers[seatType]

    p:setPlayerInfo(nil)
end

function mahjongDesk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("peng")
end

function mahjongDesk:onPlayerGang(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("gang")
end

function mahjongDesk:onPlayerHu(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]

    local detail = opType.hu.detail

    if t == detail.zimo then
        p:playGfx("zimo")
    else
        p:playGfx("hu")
    end

    p:setHu(true)
end

function mahjongDesk:updateLeftMahjongCount(cnt)
    if cnt == nil then 
        cnt = self.game:getLeftMahjongCount()
    end

    self.mLeftCount:setText(tostring(cnt))
end

function mahjongDesk:onDingQueDo(msg)
    for _, v in pairs(msg.Dos) do
        local player = self.game:getPlayerByAcId(v.AcId)
        local seat = self.game:getSeatTypeByAcId(player.acId)
        self.headers[seat]:showDingQue(v.Q)
    end
end

function mahjongDesk:onGameInfoClickedHandler()
    playButtonClickSound()

    local ui = require("ui.deskDetail").new(self.game.cityType, 
                                            self.game.gameType, 
                                            nil,
                                            self.game.config,
                                            false,
                                            self.game.deskId,
                                            0)
    ui:show()
end

function mahjongDesk:onChatMessageHandler(msg)
--    log("chat message, msg = " .. table.tostring(msg))
    
    local seat = self.game:getSeatTypeByAcId(msg.AcId)
    local header = self.headers[seat]

    if msg.Type == chatType.text then
        local k = tonumber(msg.Data)

        local content = chatConfig.text[k].content
        local audio = chatConfig.text[k].audio

        header:showChatText(content)

        local player = self.game:getPlayerByAcId(msg.AcId)
        playChatTextSound(k, player.sex)
    elseif msg.Type == chatType.emoji then
        local content = chatConfig.emoji[msg.Data].content
        local audio = chatConfig.emoji[msg.Data].audio

        header:showChatEmoji(content)
    elseif msg.Type == chatType.voice then
        local fileid = msg.Data
        local filename = LFS.CombinePath(gvoiceManager.path, Hash.GetHash(fileid) .. ".gcv")

        --header.filename = filename
        gvoiceManager.startPlay(filename, fileid, msg.AcId)
    end
end

function mahjongDesk:onChatTextSignalHandler(key)
    local content = chatConfig.text[key].content

    local header = self.headers[mahjongGame.seatType.mine]
    header:showChatText(content)

    playChatTextSound(key, gamepref.player.sex)
end

function mahjongDesk:onChatEmojiSignalHandler(key)
    local content = chatConfig.emoji[key].content
    local audio = chatConfig.emoji[key].audio

    local header = self.headers[mahjongGame.seatType.mine]
    header:showChatEmoji(content)

    if not string.isNilOrEmpty(audio) then
        
    end
end

function mahjongDesk:onGVoiceRecordFinishedHandler(filename)
    local header = self.headers[mahjongGame.seatType.mine]
    --header.filename = filename

    local ret = gvoiceManager.play(filename, gamepref.player.acId)
--    log("on gvoice recode finishaed handler : " .. tostring(ret))
end

function mahjongDesk:onGVoicePlayStartedHandler(filename, acId)
    log("gvoice started handler " .. tostring(acId))
    for _, v in pairs(self.headers) do
        if v.acId == acId then
            v:showChatVoice()
            break
        end
    end
end

function mahjongDesk:onGVoicePlayFinishedHandler(filename, acId)
    log("gvoice stoped handler " .. tostring(acId))
    for _, v in pairs(self.headers) do
        if v.acId == acId then
            v:hideChatVoice()
            break
        end
    end
end

return mahjongDesk

--endregion
