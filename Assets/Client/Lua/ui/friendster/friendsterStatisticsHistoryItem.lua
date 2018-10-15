--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterStatisticsHistoryItem = class("friendsterStatisticsHistoryItem", base)

_RES_(friendsterStatisticsHistoryItem, "FriendsterUI", "FriendsterStatisticsHistoryItem")

function friendsterStatisticsHistoryItem:onInit()
    self.players = { { root = self.mPlayerA, icon = self.mPlayerA_Icon, score = { p = self.mPlayerA_ScoreP, n = self.mPlayerA_ScoreN }, winner = self.mPlayerA_Winner },
                     { root = self.mPlayerB, icon = self.mPlayerB_Icon, score = { p = self.mPlayerB_ScoreP, n = self.mPlayerB_ScoreN }, winner = self.mPlayerB_Winner },
                     { root = self.mPlayerC, icon = self.mPlayerC_Icon, score = { p = self.mPlayerC_ScoreP, n = self.mPlayerC_ScoreN }, winner = self.mPlayerC_Winner },
                     { root = self.mPlayerD, icon = self.mPlayerD_Icon, score = { p = self.mPlayerD_ScoreP, n = self.mPlayerD_ScoreN }, winner = self.mPlayerD_Winner },
    }

    for _, v in pairs(self.players) do
        v.root:hide()
    end
end

function friendsterStatisticsHistoryItem:set(data)

end

function friendsterStatisticsHistoryItem:onDestroy()
    for _, v in pairs(self.players) do
        local tex = v.icon:getTexture()
        if tex ~= nil then
            textureManager.unload(tex, true)
            v.icon:setTexture(nil)
        end
    end

    self.super.onDestroy(self)
end

return friendsterStatisticsHistoryItem

--endregion
