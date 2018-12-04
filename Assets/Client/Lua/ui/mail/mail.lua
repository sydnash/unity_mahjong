--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local mail = class("mail", base)

_RES_(mail, "MailUI", "MailUI")

function mail:onInit()
    self.items = {
        { root = self.mItemA, icon = self.mItemA_Icon, count = self.mItemA_Count },
        { root = self.mItemB, icon = self.mItemB_Icon, count = self.mItemB_Count },
        { root = self.mItemC, icon = self.mItemC_Icon, count = self.mItemC_Count },
    }

    self:refreshMails(gamepref.player.mails)

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)
    self.mGet:addClickListener(self.onGetClickedHandler, self)

    signalManager.registerSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function mail:onCloseClickedHandler()
    self:close()
    signalManager.signal(signalType.mail)
    playButtonClickSound()
end

function mail:onDeleteClickedHandler()
    if self.curMail ~= nil then
        networkManager.deleteMail(self.curMail.id, function(msg)
            if msg == nil then
                showMessageUI(NETWORK_IS_BUSY)
                return
            end

--            log("delete a mail, msg = " .. table.tostring(msg))

            if not msg.Ok then
                showMessageUI("邮件删除失败，请稍后重试")
                return 
            end

            gamepref.player:removeMail(msg.MailId)
            self:refreshMails(gamepref.player.mails)
        end)
    end

    playButtonClickSound()
end

function mail:onGetClickedHandler()
    if self.curMail ~= nil then
        networkManager.getRewardsFromMail(self.curMail.id, function(msg)
            if msg == nil then
                showMessageUI(NETWORK_IS_BUSY)
                return
            end

--            log("get rewards from mail, msg = " .. table.tostring(msg))

            if not msg.Ok then
                showMessageUI("领取失败，请稍后重试\n如有疑问请咨询代理")
                return 
            end

            local text = "恭喜您成功领取"
            for k, v in pairs(msg.MailGifts) do 
                if k > 1 then
                    text = text .. "、"
                end

                text = text .. string.format("【%s x%d】", mailGiftName[v.Type], v.AddValue)
            end
            showMessageUI(text)

            local mail = gamepref.player:getMail(msg.MailId)
            mail.status = mailStatus.claimed

            self:refreshContent(mail)
        end)
    end

    playButtonClickSound()
end

function mail:onMailHandler()
    self:refreshMails(gamepref.player.mails)
end

function mail:refreshMails(mails)
    self:sortMails(mails)
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

        self.mList:reset()
        self.mList:set(count, createItem, refreshItem)

        self:openMail(mails[1], 0)
    end
end

function mail:sortMails(mails)
    table.sort(mails, function(a, b)
        if a.status == mailStatus.notRead and b.status ~= mailStatus.notRead then
            return true
        elseif a.status ~= mailStatus.notRead and b.status == mailStatus.notRead then
            return false
        end

        if a.status ~= mailStatus.claimed and b.status == mailStatus.claimed then
            return true
        elseif a.status == mailStatus.claimed and b.status ~= mailStatus.claimed then
            return false
        end

        return a.time > b.time
    end)
end

function mail:openMail(mail, index)
    self.curMail = mail

    local items = self.mList:getItems()
    for i=0, items.Count - 1 do
        items[i]:setSelection(false)
    end

    local item = items[index]
    item:setSelection(true)

    self:refreshContent(mail)

    if mail.status == mailStatus.notRead then
        networkManager.openMail(mail.id, function(msg)
--            log("open a mail, msg = " .. table.tostring(msg))
            if msg ~= nil then
                local mail = gamepref.player:getMail(msg.MailId)
                mail.status = mailStatus.read
            end

            item:refreshRP()
        end)
    end
end

function mail:refreshContent(mail)
    self.mTitle:setText(mail.title)
    self.mContent:setText(mail.content)

    if mail.extra ~= nil and mail.extra.gift ~= nil and #mail.extra.gift > 0 then
        self.mAttaches:show()

        for _, v in pairs(self.items) do
            v.root:hide()
        end

        for k, v in pairs(mail.extra.gift) do
            local item = self.items[k]
            item.icon:setSprite(v.type)
            item.count:setText(string.format("x%d", v.value))
            item.root:show()
        end

        if mail.status == mailStatus.claimed then
            self.mGot:show()
            self.mGet:hide()
            self.mDelete:show()
            self.mDelete:setLocalPosition(Vector3.New(240, -196, 0))
        else
            self.mGot:hide()
            self.mGet:show()
            self.mDelete:hide()
        end
    else
        self.mDelete:show()
        self.mDelete:setLocalPosition(Vector3.New(0, -196, 0))
        self.mAttaches:hide()
    end
end

function mail:onCloseAllUIHandler()
    self:close()
end

function mail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self.mList:reset()
    self.super.onDestroy(self)
end

return mail

--endregion
