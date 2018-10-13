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
end

function friendsterMessageItem:onAgreeClickedHandler()
    playButtonClickSound()
end

return friendsterMessageItem

--endregion
