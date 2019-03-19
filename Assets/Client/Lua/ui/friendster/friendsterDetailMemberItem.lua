--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetailMemberItem = class("friendsterDetailMemberItem", base)

_RES_(friendsterDetailMemberItem, "FriendsterUI", "FriendsterDetailMemberItem")

function friendsterDetailMemberItem:onInit()
    self.mHead:addClickListener(self.onHeadClickedHandler, self)

    self.mQZ:hide()
    self.mGLY:hide()
    self.mState:setSprite("offline")
end

function friendsterDetailMemberItem:onHeadClickedHandler()
    local ui = require("ui.friendster.friendsterMemberInfo").new(self.friendster, self.data)
    ui:show()

    playButtonClickSound()
end

function friendsterDetailMemberItem:set(friendster, data)
    self.friendster = friendster
    self.data = data

    self.mIcon:setTexture(data.headerUrl)
    self.mNickname:setText(cutoutString(data.nickname, gameConfig.nicknameMaxLength))
    self.mID:setText(string.format("账号:%d", data.acId))

    self:setStatus(data)

    if data.acId == managerId then
        self.mQZ:show()
    else
        self.mQZ:hide()

        if data.permission == 1 then
            self.mGLY:show()
        else
            self.mGLY:hide()
        end
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
