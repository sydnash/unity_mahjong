--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local deskHeader = class("deskHeader", base)

local ONLINE_COLOR  = Color.New(1, 1, 1, 1)
local OFFLINE_COLOR = Color.New(0.3, 0.3, 0.3, 1)

function deskHeader:onInit()
    self.mNobody:show()
    self.mSomebody:hide()
    self.mFz:hide()
    self:reset()

    self:setOnline(true)
    self:show()

    self.mIconClick:addClickListener(self.onIconClickedHandler, self)
end

function deskHeader:setPlayerInfo(player)
    self.player = player

    if player == nil then
        self.mNobody:show()
        self.mSomebody:hide()
        self.acId = nil
    else
        self.acId = player.acId
        self.mNobody:hide()
        self.mSomebody:show()

        self.mIcon:setTexture(player.headerUrl)

        self:setScore(player.score)
        self:setReady(player.ready)

        if player.isCreator then
            self.mFz:show()
        else
            self.mFz:hide()
        end

        self:setOnline(player.connected)

        self.mEmoji:hide()
        self.mChat:hide()
        self.mVoice:hide()
    end
end

function deskHeader:onIconClickedHandler()
    playButtonClickSound()
    local ui = require("ui.playerInfo").new(self.player, true)
    ui:show()
end

function deskHeader:setScore(score)
    self.mScore:setText(string.format("分数:%d", score or 0))
end

function deskHeader:setOnline(online)
    if online then
        self.mOffline:hide()
        self.mIcon:setColor(ONLINE_COLOR)
    else
        self.mOffline:show()
        self.mIcon:setColor(OFFLINE_COLOR)
    end
end

function deskHeader:setReady(ready)
    if self.mReady ~= nil then
        if ready then
            self.mReady:show()
        else
            self.mReady:hide()
        end
    end
end

function deskHeader:playGfx(gfxName)
    self.mGfx:setSprite(gfxName)
    self.mGfx:show()
    self.mGfxAnim:play()
end

function deskHeader:showChatEmoji(emoji)
    self.mEmoji:setSprite(emoji)
    self.mEmoji:show()

    self.showEmojiTimestamp = time.realtimeSinceStartup()
end

function deskHeader:hideChatEmoji()
    self.mEmoji:hide()
    self.showEmojiTimestamp = nil
end

function deskHeader:showChatText(text)
    self.mChatText:setText(text)
    self.mChat:show()

    self.showChatTimestamp = time.realtimeSinceStartup()
end

function deskHeader:hideChatText()
    self.mChat:hide()
    self.showChatTimestamp = nil
end

function deskHeader:showChatVoice()
    self.mVoice:show()
    self.showVoiceTimestamp = time.realtimeSinceStartup()
end

function deskHeader:hideChatVoice()
    self.mVoice:hide()
    self.showVoiceTimestamp = nil
end

function deskHeader:update()
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

function deskHeader:reset()
    self:setReady(false)
    self.mGfx:hide()
    self.mZhuang:hide()
    self:hideChatEmoji()
    self:hideChatText()
    self:hideChatVoice()
end

return deskHeader

--endregion
