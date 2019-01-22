--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMessage = class("friendsterMessage", base)

_RES_(friendsterMessage, "FriendsterUI", "FriendsterMessageUI")

function friendsterMessage:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterMessage:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function friendsterMessage:set(friendsterId, data)
    self.friendsterId = friendsterId
    self.data = data

    self:refreshList()
end

function friendsterMessage:refreshList()
    local count = json.isNilOrNull(self.data )and 0 or #self.data

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
            item:set(self.friendsterId, self.data[index + 1])
        end

        self.mList:reset()
        self.mList:set(count, createItem, refreshItem)
    end
end

function friendsterMessage:onCloseAllUIHandler()
    self:close()
end

function friendsterMessage:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.mList:reset()
    base.onDestroy(self)
end

return friendsterMessage

--endregion
