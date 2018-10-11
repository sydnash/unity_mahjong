--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetailDeskItem = class("friendsterDetailDeskItem", base)

_RES_(friendsterDetailDeskItem, "FriendsterUI", "FriendsterDetailDeskItem")

function friendsterDetailDeskItem:onInit()

end

function friendsterDetailDeskItem:set(data)
    self.data = data
end

return friendsterDetailDeskItem

--endregion
