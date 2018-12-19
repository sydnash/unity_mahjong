--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local doushisiType = require("logic.doushisi.doushisiType")

local base = require("ui.common.view")
local gameEndPai = class("gameEndPai", base)

_RES_(gameEndPai, "GameEndUI/DouShiSi", "GameEndItemPai")

function gameEndPai:onInit()
    self.cards = {self.mA, self.mB, self.mC}
    for _, v in pairs(self.cards) do
        v:hide()
    end
end

function gameEndPai:setIds(ids)
    for idx, id in pairs(ids) do
        local typ = doushisiType.getDoushisiTypeId(id.id)
        local v = self.cards[idx]
        if v then
            v:setSprite(tostring(typ))
            v:show()
        end
    end
end

return gameEndPai

--endregion
