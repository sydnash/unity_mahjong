--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetailMemberItem = class("friendsterDetailMemberItem", base)

_RES_(friendsterDetailMemberItem, "FriendsterUI", "FriendsterDetailMemberItem")

function friendsterDetailMemberItem:onInit()
    self.mQZ:hide()
    self.mState:setSprite("offline")
end

function friendsterDetailMemberItem:set(managerId, data)
    self.data = data

    self.mIcon:setTexture(data.headerTex)
    self.mNickname:setText(data.nickname)
    self.mID:setText(string.format("账号:%d", data.acId))

    if data.online then
        self.mState:setSprite("online")
    end

    if data.acId == managerId then
        self.mQZ:show()
    end
end

return friendsterDetailMemberItem

--endregion
