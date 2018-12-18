--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterStatisticsRankItem = class("friendsterStatisticsRankItem", base)

_RES_(friendsterStatisticsRankItem, "FriendsterUI", "FriendsterStatisticsRankItem")

function friendsterStatisticsRankItem:onInit()
    self.mSearch:addClickListener(self.onSearchClickedHandler, self)
end

function friendsterStatisticsRankItem:onSearchClickedHandler()
    local ui = require("ui.friendster.winnerDetail").new(self.data.winnerDetail)
    ui:show()

    playButtonClickSound()
end

function friendsterStatisticsRankItem:set(data)
    self.data = data

    self.mIcon:setTexture(data.headerUrl)
    self.mNickname:setText(cutoutString(data.nickname, gameConfig.nicknameMaxLength))
    self.mId:setText(tostring(data.acId))
    self.mWinner:setText(string.format("%d次", data.winnerTimes))
    if data.winnerTimes == 0 then
        self.mSearch:hide()
    else
        self.mSearch:show()
    end
    self.mScore:setText(string.format("%d分", data.score))
    self.mTimes:setText(string.format("%d次", data.playTimes))
end

return friendsterStatisticsRankItem

--endregion
