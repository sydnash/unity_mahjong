--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetailMemberItem = class("friendsterDetailMemberItem", base)

_RES_(friendsterDetailMemberItem, "FriendsterUI", "FriendsterDetailMemberItem")

function friendsterDetailMemberItem:onInit()
    self.mHead:addClickListener(self.onHeadClickedHandler, self)

    self.mQZ:hide()
    self.mDL:hide()
    self.mState:setSprite("offline")
end

function friendsterDetailMemberItem:onHeadClickedHandler()
    local ui = require("ui.friendster.friendsterMemberInfo").new(self.friendsterId, self.managerId, self.data)
    ui:show()

    playButtonClickSound()
end

function friendsterDetailMemberItem:set(friendsterId, managerId, data)
    self.friendsterId = friendsterId
    self.managerId = managerId
    self.data = data

    self.mIcon:setTexture(data.headerUrl)
    self.mNickname:setText(cutoutString(data.nickname, gameConfig.nicknameMaxLength))
    self.mID:setText(string.format("账号:%d", data.acId))

    self:setStatus(data)

    if data.acId == managerId then
        self.mQZ:show()
    else
        self.mQZ:hide()

--        if data.isProxy then
--            self.mDL:show()
--        else
--            self.mDL:hide()
--        end
    end
end

function friendsterDetailMemberItem:setStatus(data)
    local online = data.online
    if online then
        if data.deskStatus ~= friendsterMemberDeskStatus.idle then
            self.mState:setSprite("indesk")
        else
            self.mState:setSprite("online")
        end
    else
        self.mState:setSprite("offline")
    end
end

return friendsterDetailMemberItem

--endregion
