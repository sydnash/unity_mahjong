--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = require("const.mahjongClass")

local base = require("ui.common.panel")
local mahjongDeskHeader = class("mahjongDeskHeader", base)

local OnlineColor = Color.New(1, 1, 1, 1)
local OfflineColor = Color.New(0.3, 0.3, 0.3, 1)

function mahjongDeskHeader:onInit()
    self.mU:show()
    self.mP:hide()
    self.mFz:hide()
    self:reset()

    self:setOnline(true)
    self:show()
end

function mahjongDeskHeader:setPlayerInfo(player)
    if player == nil then
        self.mU:show()
        self.mP:hide()
    else
        self.mU:hide()
        self.mP:show()

        self.mIcon:setPlayer(player)

        self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
        self.mScore:setText(string.format("分数:%d", player.score or 0))
        self:setReady(player.ready)

        if player.que ~= nil and player.que >= 0 then
            self:showDingQue(player.que)
        else
            self.mQue:hide()
        end

        if player.hu ~= nil and player.hu[1].HuCard >= 0 then
            self:setHu(true)
        else
            self:setHu(false)
        end

        if player.isCreator then
            self.mFz:show()
        else
            self.mFz:hide()
        end

        if player.isMarker then
            self.mZhuang:show()
        else
            self.mZhuang:hide()
        end

        self:setOnline(player.connected)

        self.mEmoji:hide()
        self.mChat:hide()
        self.mVoice:hide()
    end
end

function mahjongDeskHeader:setMarker(marker)
    if marker then
        self.mZhuang:show()
    else
        self.mZhuang:hide()
    end
end

function mahjongDeskHeader:setOnline(online)
    if online then
        self.mOffline:hide()
        self.mIcon:setColor(OnlineColor)
    else
        self.mOffline:show()
        self.mIcon:setColor(OfflineColor)
    end
end

function mahjongDeskHeader:setReady(ready)
    if self.mReady ~= nil then
        if ready then
            self.mReady:show()
        else
            self.mReady:hide()
        end
    end
end

function mahjongDeskHeader:setHu(hu)
    if hu then
        self.mHu:show()
    else
        self.mHu:hide()
    end
end

function mahjongDeskHeader:playGfx(gfxName)
    self.mGfx:setSprite(gfxName)
    self.mGfx:show()
    self.mGfxAnim:play()
end

function mahjongDeskHeader:showDingQue(mjtype)
    self.mQue:setSprite(getMahjongClassName(mjtype))
    self.mQue:show()
end

function mahjongDeskHeader:showChatEmoji(emoji)
    self.mEmoji:setSprite(emoji)
    self.mEmoji:show()

    self.showEmojiTimestamp = time.realtimeSinceStartup()
end

function mahjongDeskHeader:hideChatEmoji()
    self.mEmoji:hide()
    self.showEmojiTimestamp = nil
end

function mahjongDeskHeader:showChatText(text)
    self.mChatText:setText(text)
    self.mChat:show()

    self.showChatTimestamp = time.realtimeSinceStartup()
end

function mahjongDeskHeader:hideChatText()
    self.mChat:hide()
    self.showChatTimestamp = nil
end

function mahjongDeskHeader:showChatVoice()
    self.mVoice:show()
    self.showVoiceTimestamp = time.realtimeSinceStartup()
end

function mahjongDeskHeader:hideChatVoice()
    self.mVoice:hide()
    self.showChatTimestamp = nil
end

function mahjongDeskHeader:update()
    if self.showEmojiTimestamp ~= nil then
        if time.realtimeSinceStartup() - self.showEmojiTimestamp > 2 then
            self:hideChatEmoji()
        end
    end

    if self.showChatTimestamp ~= nil then
        if time.realtimeSinceStartup() - self.showChatTimestamp > 2 then
            self:hideChatText()
        end
    end

    if self.showVoiceTimestamp ~= nil then
        if time.realtimeSinceStartup() - self.showVoiceTimestamp > 30 then
            self:hideChatVoice()
        end
    end
end

function mahjongDeskHeader:reset()
    self:setReady(false)
    self.mHu:hide()
    self.mGfx:hide()
    self.mQue:hide()
    self.mZhuang:hide()
    self:hideChatEmoji()
    self:hideChatText()
    self:hideChatVoice()
end

function mahjongDeskHeader:onDestroy()
    self.mIcon:reset()
    self.super.onDestroy(self)
end

return mahjongDeskHeader

--endregion
