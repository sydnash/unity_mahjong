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

    self.mIcon:setTexture(data.acId, data.headerTex)
    self.mNickname:setText(cutoutString(data.nickname, gameConfig.nicknameMaxLength))
    self.mID:setText(string.format("账号:%d", data.acId))

    self:setOnline(data.online)

    if data.acId == managerId then
        self.mQZ:show()
    else
        self.mQZ:hide()

        if data.isProxy then
            self.mDL:show()
        else
            self.mDL:hide()
        end
    end
end

function friendsterDetailMemberItem:setOnline(online)
    if online then
        self.mState:setSprite("online")
    else
        self.mState:setSprite("offline")
    end
end

function friendsterDetailMemberItem:onDestroy()
    self.mIcon:reset()
    self.super.onDestroy(self)
end

return friendsterDetailMemberItem

--endregion
