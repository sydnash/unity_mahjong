--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMessage = class("friendsterMessage", base)

_RES_(friendsterMessage, "FriendsterUI", "FriendsterMessageUI")

function friendsterMessage:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
end

function friendsterMessage:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMessage:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return friendsterMessage

--endregion
