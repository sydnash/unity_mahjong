--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local mailItem = class("mailItem", base)

_RES_(mailItem, "MailUI", "MailItem")

function mailItem:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function mailItem:onInit()
    self.mClick:addClickListener(self.onClickedHandler, self)

    self.mS:hide()
    self.mU:show()
end

function mailItem:onClickedHandler()
    if self.callback ~= nil then
        self.callback(self.mail, self.index)
    end 
end

function mailItem:set(mail, index)
    self.mail = mail
    self.index = index

    self.mTitle:setText(mail.title)
    self.mTitleU:setText(mail.title)

    local t = time.formatDate(mail.time)

    self.mTime:setText(t)
    self.mTimeU:setText(t)

    self:refreshRP()
end

function mailItem:refreshRP()
    if self.mail.status == mailStatus.notRead then
        self.mRP:show()
    else
        self.mRP:hide()
    end
end

function mailItem:setSelection(selected)
    if selected then
        self.mS:show()
        self.mU:hide()
    else
        self.mS:hide()
        self.mU:show()
    end
end

return mailItem

--endregion
