--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local chatConfig    = require("config.chatConfig")
local UIText        = UnityEngine.UI.Text

local base = require("ui.common.view")
local chat = class("", base)

_RES_(chat, "ChatUI", "ChatUI")

function chat:onInit()
    self.mEmojiTab:setSelected(true)
    self.mTextTab:setSelected(false)

    self.mEmojiPage:show()
    self.mTextPage:hide()

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mMask:addClickListener(self.onCloseClickedHandler, self)
    self.mEmojiTab:addChangedListener(self.onEmojiTabChangedHandler, self)
    self.mTextTab:addChangedListener(self.onTextTabChangedHandler, self)
    --表情
    local emojis = {
        self.mEmoji01,
        self.mEmoji02,
        self.mEmoji03,
        self.mEmoji04,
        self.mEmoji05,
        self.mEmoji06,
        self.mEmoji07,
        self.mEmoji08,
        self.mEmoji09,
        self.mEmoji10,
        self.mEmoji11,
        self.mEmoji12,
        self.mEmoji13,
        self.mEmoji14,
        self.mEmoji15,
        self.mEmoji16,
    }
    for k, v in pairs(emojis) do
        v.key = tostring(k)
        v:addClickListener(self.onEmojiClickedHandler, self)
    end
    --文字
    local texts = {
        self.mText01,
        self.mText02,
        self.mText03,
        self.mText04,
        self.mText05,
        self.mText06,
        self.mText07,
        self.mText08,
        self.mText09,
        self.mText10,
        self.mText11,
        self.mText12,
        self.mText13,
        self.mText14,
        self.mText15,
        self.mText16,
        self.mText17,
        self.mText18,
        self.mText19,
        self.mText20,
    }

    local min = math.min(#texts, #chatConfig.text)

    for k, v in pairs(texts) do
        if k > min then
            v:hide()
        else
            v.key = tostring(k)
            v:addClickListener(self.onTextClickedHandler, self)
            local c = getComponentU(v.gameObject, typeof(UIText))
            c.text = chatConfig.text[v.key].content
        end
    end
end

function chat:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function chat:onEmojiTabChangedHandler(selected)
    if selected then
        playButtonClickSound()

        self.mEmojiPage:show()
        self.mTextPage:hide()
    end
end

function chat:onTextTabChangedHandler(selected)
    if selected then
        playButtonClickSound()

        self.mEmojiPage:hide()
        self.mTextPage:show()
    end
end

function chat:onEmojiClickedHandler(sender)
    playButtonClickSound()

    networkManager.sendChatMessage(chatType.emoji, sender.key)
    signalManager.signal(signalType.chatEmoji, sender.key)

    self:close()
end

function chat:onTextClickedHandler(sender)
    playButtonClickSound()

    networkManager.sendChatMessage(chatType.text, sender.key)
    signalManager.signal(signalType.chatText, sender.key)

    self:close()
end

return chat
           
--endregion