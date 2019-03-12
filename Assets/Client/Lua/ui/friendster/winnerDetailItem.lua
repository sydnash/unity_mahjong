--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local winnerDetailItem = class("winnerDetailItem", base)

_RES_(winnerDetailItem, "FriendsterUI", "WinnerDetailItem")

function winnerDetailItem:set(data)
    self.mDeskId:setText(tostring(data.deskId))
    self.mScore:setText(string.format("%d分", data.score))
    self.mEndTime:setText(time.formatDateTimeWithoutSecond(data.endTime))
end

return winnerDetailItem

--endregion
