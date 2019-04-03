--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.mahjongDesk.mahjongOperation")
local mahjongOperation = class("mahjongOperation_YaoTongRenYong", base)

-------------------------------------------------------------------------------
-- 杠
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoGang(acId, cards, beAcId, beCard, t)
    local player = self.game:getPlayerByAcId(acId)
    playMahjongOpSound(opType.gang.id, player.sex, t)
end

return mahjongOperation

--endregion
