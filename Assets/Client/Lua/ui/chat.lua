--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

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
    self.mEmoji01:addClickListener(self.onEmoji01ClickedHandler, self)
    self.mEmoji02:addClickListener(self.onEmoji02ClickedHandler, self)
    self.mEmoji03:addClickListener(self.onEmoji03ClickedHandler, self)
    self.mEmoji04:addClickListener(self.onEmoji04ClickedHandler, self)
    self.mEmoji05:addClickListener(self.onEmoji05ClickedHandler, self)
    self.mEmoji06:addClickListener(self.onEmoji06ClickedHandler, self)
    self.mEmoji07:addClickListener(self.onEmoji07ClickedHandler, self)
    self.mEmoji08:addClickListener(self.onEmoji08ClickedHandler, self)
    self.mEmoji09:addClickListener(self.onEmoji09ClickedHandler, self)
    self.mEmoji10:addClickListener(self.onEmoji10ClickedHandler, self)
    self.mEmoji11:addClickListener(self.onEmoji11ClickedHandler, self)
    self.mEmoji12:addClickListener(self.onEmoji12ClickedHandler, self)
    self.mEmoji13:addClickListener(self.onEmoji13ClickedHandler, self)
    self.mEmoji14:addClickListener(self.onEmoji14ClickedHandler, self)
    self.mEmoji15:addClickListener(self.onEmoji15ClickedHandler, self)
    self.mEmoji16:addClickListener(self.onEmoji16ClickedHandler, self)
    --文字
    self.mText01:addClickListener(self.onText01ClickedHandler, self)
    self.mText02:addClickListener(self.onText02ClickedHandler, self)
    self.mText03:addClickListener(self.onText03ClickedHandler, self)
    self.mText04:addClickListener(self.onText04ClickedHandler, self)
    self.mText05:addClickListener(self.onText05ClickedHandler, self)
    self.mText06:addClickListener(self.onText06ClickedHandler, self)
    self.mText07:addClickListener(self.onText07ClickedHandler, self)
    self.mText08:addClickListener(self.onText08ClickedHandler, self)
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

function chat:onEmoji01ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(1)
end

function chat:onEmoji02ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(2)
end

function chat:onEmoji03ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(3)
end

function chat:onEmoji04ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(4)
end

function chat:onEmoji05ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(5)
end

function chat:onEmoji06ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(6)
end

function chat:onEmoji07ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(7)
end

function chat:onEmoji08ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(8)
end

function chat:onEmoji09ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(9)
end

function chat:onEmoji10ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(10)
end

function chat:onEmoji11ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(11)
end

function chat:onEmoji12ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(12)
end

function chat:onEmoji13ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(13)
end

function chat:onEmoji14ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(14)
end

function chat:onEmoji15ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(15)
end

function chat:onEmoji16ClickedHandler()
    playButtonClickSound()
    self:sendEmoji(16)
end

function chat:sendEmoji(index)

end

function chat:onText01ClickedHandler()
    playButtonClickSound()
    self:sendText(1)
end

function chat:onText02ClickedHandler()
    playButtonClickSound()
    self:sendText(2)
end

function chat:onText03ClickedHandler()
    playButtonClickSound()
    self:sendText(3)
end

function chat:onText04ClickedHandler()
    playButtonClickSound()
    self:sendText(4)
end

function chat:onText05ClickedHandler()
    playButtonClickSound()
    self:sendText(5)
end

function chat:onText06ClickedHandler()
    playButtonClickSound()
    self:sendText(6)
end

function chat:onText07ClickedHandler()
    playButtonClickSound()
    self:sendText(7)
end

function chat:onText08ClickedHandler()
    playButtonClickSound()
    self:sendText(8)
end

function chat:sendText(index)

end

return chat
           
--endregion