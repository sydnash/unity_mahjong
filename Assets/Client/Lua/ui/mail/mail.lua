--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local mail = class("mail", base)

_RES_(mail, "MailUI", "MailUI")

function mail:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)
end

function mail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function mail:onDeleteClickedHandler()
    playButtonClickSound()
end

function mail:set(mails)
    local count = #mails

    if mails == nil or count <= 0 then
        self.mMails:hide()
        self.mEmpty:show()
    else
        self.mMails:show()
        self.mEmpty:hide()

        local createItem = function()
            return require("ui.mail.mailItem").new(function(mail, index)
                playButtonClickSound()
                self:openMail(mail, index)
            end)
        end

        local refreshItem = function(item, index)
            item:set(mails[index + 1], index)
        end

        self.mList:set(count, createItem, refreshItem)
        self:openMail(mails[1], 0)
    end
end

function mail:openMail(mail, index)
    local items = self.mList:getItems()
    for i=0, items.Count - 1 do
        items[i]:setSelection(false)
    end
    items[index]:setSelection(true)

    self.mTitle:setText(mail.title)
    self.mContent:setText(mail.content)

    if mail.extra ~= nil and mail.extra.gift ~= nil and #mail.extra.gift > 0 then
        self.mDelete:hide()
        self.mAttaches:show()
    else
        self.mDelete:show()
        self.mAttaches:hide()
    end
end

function mail:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return mail

--endregion
