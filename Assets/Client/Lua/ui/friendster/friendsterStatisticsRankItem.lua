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
    playButtonClickSound()
end

function friendsterStatisticsRankItem:set(data)

end

function friendsterStatisticsRankItem:onDestroy()
    local tex = self.mIcon:getTexture()
    if tex ~= nil then
        textureManager.unload(tex, true)
        self.mIcon:setTexture(nil)
    end

    self.super.onDestroy(self)
end

return friendsterStatisticsRankItem

--endregion
