--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetailDeskItem = class("friendsterDetailDeskItem", base)

_RES_(friendsterDetailDeskItem, "FriendsterUI", "FriendsterDetailDeskItem")

function friendsterDetailDeskItem:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function friendsterDetailDeskItem:onInit()
    
end

function friendsterDetailDeskItem:set(data)
    self.mL:set(data.L, self.callback)

    if data.R == nil then
        self.mR:hide()
    else
        self.mR:set(data.R, self.callback)
        self.mR:show()
    end
end

return friendsterDetailDeskItem

--endregion
