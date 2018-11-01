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
    self.players = { self.mPlayerM, self.mPlayerR, self.mPlayerT, self.mPlayerL, }
    self:refreshUI()

    if deviceConfig.isMobile then
        self.mInvite:show()
        self.mInvite:addClickListener(self.onInviteClickedHandler, self)
    else
        self.mInvite:hide()
    end

    self.mGameDesc:hide()
    self.mGameInfoS:show()
    self.mGameInfoH:hide()

    self.mReady:addClickListener(self.onReadyClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
    self.mChat:addClickListener(self.onChatClickedHandler, self)
    self.mVoice:addClickListener(self.onVoiceClickedHandler, self)
    self.mGameInfoS:addClickListener(self.onGameInfoSClickedHandler, self)
    self.mGameInfoH:addClickListener(self.onGameInfoHClickedHandler, self)

    networkManager.registerCommandHandler(protoType.sc.chatMessage, function(msg)
        self:onChatMessageHandler(msg)
    end, true)

    signalManager.registerSignalHandler(signalType.chatText,  self.onChatTextSignalHandler,  self)
    signalManager.registerSignalHandler(signalType.chatEmoji, self.onChatEmojiSignalHandler, self)
end

function mahjongDesk:update()
    for _, v in pairs(self.players) do
        v:update()
    end
end

function mahjongDesk:onDestroy()
    networkManager.unregisterCommandHandler(protoType.sc.chatMessage)

    signalManager.unregisterSignalHandler(signalType.chatText,  self.onChatTextSignalHandler,  self)
    signalManager.unregisterSignalHandler(signalType.chatEmoji, self.onChatEmojiSignalHandler, self)

    if self.settingUI ~= nil then
        self.settingUI:close()
        self.settingUI = nil
    end

    if self.chatUI ~= nil then
        self.chatUI:close()
        self.chatUI = nil
    end

    self.super.onDestroy(self)
end

function mahjongDesk:refreshUI()
    for _, p in pairs(self.players) do
        
    end

    self.mDeskID:setText(string.format("房号:%d", self.game.deskId))
    self:updateCurrentGameIndex()
    self.mTime:setText(time.formatTime())
    self:updateLeftMahjongCount()

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatType(v.turn)
        local p = self.players[s + 1]
        p:setPlayerInfo(v)

        if self.game.status == gameStatus.playing then
            p:setReady(false)
        end
    end

    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if deviceConfig.isMobile then
        if playerCount == playerTotalCount then
            self.mInvite:setInteractabled(false)
        else
            self.mInvite:setInteractabled(true)
        end
    end
end

function mahjongDesk:onInviteClickedHandler()
    playButtonClickSound()

    if deviceConfig.isAndroid then
        androidHelper.shareUrlWx("好友邀请", self:getInvitationInfo(), "http://www.cdbshy.com/", false)
    end
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

function mahjongDesk:onSettingClickedHandler()
    playButtonClickSound()

    self.settingUI = require("ui.setting").new(self.game)
    self.settingUI:show()
end

function mahjongDesk:onChatClickedHandler()
    playButtonClickSound()

    self.chatUI = require("ui.chat").new()
    self.chatUI:show()
end

function mahjongDesk:onVoiceClickedHandler()
    playButtonClickSound()
end

function mahjongDesk:setReady(acId, ready)
    if acId == gamepref.acId then
        if ready then
            self.mReady:hide()
            self.mCancel:show()
        else
            self.mReady:show()
            self.mCancel:hide()
        end
    else
        local seat = self.game:getSeatTypeByAcId(acId) + 1
        self.players[seat]:setReady(ready)
    end
end

function mahjongDesk:onGameStart()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    for _, v in pairs(self.players) do
        v:reset()
    end

    self:updateCurrentGameIndex()
end

function mahjongDesk:onGameSync()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    self:updateCurrentGameIndex()
end

function mahjongDesk:reset()
    self.mInvite:hide()
    self.mReady:show()
    self.mCancel:hide()

    for _, v in pairs(self.players) do
        v:reset()
    end

    self.mGameDesc:hide()
    self.mGameInfoS:show()
    self.mGameInfoH:hide()
end

function mahjongDesk:update()
    self.mTime:setText(time.formatTime())
end

function mahjongDesk:updateCurrentGameIndex()
    local totalGameCount = self.game:getTotalGameCount()
    local leftGameCount = self.game:getLeftGameCount()
    local currentGameIndex = totalGameCount - leftGameCount + 1

    self.mGameCount:setText(string.format("第%d/%d局", currentGameIndex, totalGameCount))
end

function mahjongDesk:onPlayerEnter(player)
    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if deviceConfig.isMobile and playerCount == playerTotalCount then
        self.mInvite:setInteractabled(false)
    end

    local s = self.game:getSeatType(player.turn)
    local p = self.players[s + 1]

    p:setPlayerInfo(player)
end

function mahjongDesk:onPlayerExit(turn)
    if deviceConfig.isMobile then
        self.mInvite:setInteractabled(true)
    end

    local s = self.game:getSeatType(turn)
    local p = self.players[s + 1]

    p:setPlayerInfo(nil)
end

function mahjongDesk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]
    p:playGfx("peng")
end

function mahjongDesk:onPlayerGang(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]
    p:playGfx("gang")
end

function mahjongDesk:onPlayerHu(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]

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
        local seat = self.game:getSeatType(player.turn)
        self.players[seat + 1]:showDingQue(v.Q)
    end
end

function mahjongDesk:onGameInfoSClickedHandler()
    playButtonClickSound()

    self.mGameDesc:show()
    self.mGameInfoS:hide()
    self.mGameInfoH:show()
end

function mahjongDesk:onGameInfoHClickedHandler()
    playButtonClickSound()

    self.mGameDesc:hide()
    self.mGameInfoS:show()
    self.mGameInfoH:hide()
end

function mahjongDesk:onChatMessageHandler(msg)
    log("chat message, msg = " .. table.tostring(msg))
    
    local seat = self.game:getSeatTypeByAcId(msg.AcId)
    local player = self.players[seat]

    if msg.Type == chatType.text then
        local content = chatConfig.text[msg.Data].content
        local audio = chatConfig.text[msg.Data].audio

        player:showChatText(content)

        if not string.isNilOrEmpty(audio) then

        end
    elseif msg.Type == chatType.emoji then
        local content = chatConfig.emoji[msg.Data].content
        local audio = chatConfig.emoji[msg.Data].audio

        player:showChatEmoji(msg.Data)

        if not string.isNilOrEmpty(audio) then

        end
    end
end

function mahjongDesk:onChatTextSignalHandler(key)
    local content = chatConfig.text[key].content
    local audio = chatConfig.text[key].audio

    local player = self.players[mahjongGame.seatType.mine]
    player:showChatText(content)

    if not string.isNilOrEmpty(audio) then

    end
end

function mahjongDesk:onChatEmojiSignalHandler(key)
    local content = chatConfig.emoji[key].content
    local audio = chatConfig.emoji[key].audio

    local player = self.players[mahjongGame.seatType.mine]
    player:showChatEmoji(content)

    if not string.isNilOrEmpty(audio) then

    end
end

return mahjongDesk

--endregion
