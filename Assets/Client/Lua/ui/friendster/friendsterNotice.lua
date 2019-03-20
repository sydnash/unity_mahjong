--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterNotice = class("friendsterNotice", base)

_RES_(friendsterNotice, "FriendsterUI", "FriendsterNoticeUI")

function friendsterNotice:ctor(friendster)
    self.friendster = friendster
    base.ctor(self)
end

function friendsterNotice:onInit()
    self.mText:setText(self.friendster.notice.text)
    self.mInput:hide()

    self.mEdit:hide()
    self.mCancel:hide()
    self.mModify:hide()

    if self.friendster:isCreator(gamepref.player.acId) or self.friendster:isManager(gamepref.player.acId) then
        self.mEdit:show()
    end

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mEdit:addClickListener(self.onEditClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
    self.mModify:addClickListener(self.onModifyClickedHandler, self)
end

function friendsterNotice:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterNotice:onEditClickedHandler()
    self.mInput:show()
    self.mText:hide()

    self.mEdit:hide()
    self.mClose:hide()
    self.mCancel:show()
    self.mModify:show()

    playButtonClickSound()
end

function friendsterNotice:onModifyClickedHandler()
    showWaitingUI("正在修改亲友圈公告，请稍候")
    networkManager.modifyFriendsterNotice(self.friendster.id, self.mInput:getText(), function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        self.friendster.notice.text = msg.Notice
        self.friendster.notice.time = time.now()

        self.mInput:hide()
        self.mText:setText(msg.Notice)
        self.mText:show()

        self.mEdit:show()
        self.mClose:show()
        self.mCancel:hide()
        self.mModify:hide()
    end)

    playButtonClickSound()
end

function friendsterNotice:onCancelClickedHandler()
    self.mInput:hide()
    self.mText:show()

    self.mEdit:show()
    self.mClose:show()
    self.mCancel:hide()
    self.mModify:hide()

    playButtonClickSound()
end

return friendsterNotice

--endregion
