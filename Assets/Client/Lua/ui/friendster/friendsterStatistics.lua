--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterStatistics = class("friendsterStatistics", base)

_RES_(friendsterStatistics, "FriendsterUI", "FriendsterStatisticsUI")

function friendsterStatistics:onInit()
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
end

function friendsterStatistics:onReturnClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterStatistics:onDestroy()
    self.mHistoryList:reset()
    self.mRankList:reset()

    self.super.onDestroy(self)
end

return friendsterStatistics

--endregion
