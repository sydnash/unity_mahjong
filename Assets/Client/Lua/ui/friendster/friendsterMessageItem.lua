--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMessageItem = class("friendsterMessageItem", base)

_RES_(friendsterMessageItem, "FriendsterUI", "FriendsterMessageItem")

function friendsterMessageItem:onInit()
    self.mReject:addClickListener(self.onRejectClickedHandler, self)
    self.mAgree:addClickListener(self.onAgreeClickedHandler, self)
end

function friendsterMessageItem:onRejectClickedHandler()
    playButtonClickSound()

    networkManager.replyFriendsterRequest(self.friendsterId, self.acId, false, function(msg)
        log("reject friendster apply, msg = " .. table.tostring(msg))
        signalManager.signal(signalType.friendsterMessageOptSignal, { friendsterId = self.friendsterId, acId = self.acId })
    end)
end

function friendsterMessageItem:onAgreeClickedHandler()
    playButtonClickSound()

    networkManager.replyFriendsterRequest(self.friendsterId, self.acId, true, function(msg)
        log("agree friendster apply, msg = " .. table.tostring(msg))
        signalManager.signal(signalType.friendsterMessageOptSignal, { friendsterId = self.friendsterId, acId = self.acId })
    end)
end

function friendsterMessageItem:set(friendsterId, data)
    self.friendsterId = friendsterId
    self.acId = data.AcId

    self.mName:setText(data.Nickname)
end

return friendsterMessageItem

--endregion
