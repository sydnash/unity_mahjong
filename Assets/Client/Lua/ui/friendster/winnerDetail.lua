--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local winnerDetail = class("winnerDetail", base)

_RES_(winnerDetail, "FriendsterUI", "WinnerDetailUI")

function winnerDetail:ctor(data)
    self.data = data
    self.super.ctor(self)
end

function winnerDetail:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)

    local createItem = function()
        return require("ui.friendster.winnerDetailItem").new()
    end

    local refreshItem = function(item, index)
        item:set(self.data[index + 1])
    end

    self.mList:reset()
    self.mList:set(#self.data, createItem, refreshItem)
end

function winnerDetail:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

return winnerDetail

--endregion
