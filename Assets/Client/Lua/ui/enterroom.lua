--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local enterroom = class("enterroom", base)

enterroom.folder = "EnterRoomUI"
enterroom.resource = "EnterRoomUI"

function enterroom:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
end

function enterroom:onCloseClickedHandler()
    soundManager.playButtonClickedSound()
    self:close()
end

return enterroom

--endregion
