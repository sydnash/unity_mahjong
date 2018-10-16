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

function friendsterMessage:set(data)
    self.data = data
    self:refreshList()
end

function friendsterMessage:refreshList()
    local count = (self.data ~= nil) and #self.data or 0

    if count <= 0 then
        self.mEmpty:show()
        self.mList:hide()
    else
        self.mEmpty:hide()
        self.mList:show()

        local createItem = function()
            return require("ui.friendster.friendsterMessageItem").new()
        end

        local refreshItem = function(item, index)

        end

        self.mList:reset()
        self.mList:set(count, createItem, refreshItem)
    end
end

function friendsterMessage:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return friendsterMessage

--endregion
