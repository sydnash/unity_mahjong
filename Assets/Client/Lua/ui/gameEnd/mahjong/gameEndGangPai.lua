--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndGangPai = class("gameEndGangPai", base)

_RES_(gameEndGangPai, "GameEndUI/Mahjong", "GameEndUI_GangPai")
gameEndGangPai.width = 139

function gameEndGangPai:onInit()
    self.bottomItems = { self.mA, self.mB, self.mC }
end

local function setSprite(sprite, mahjongId)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name
    sprite:setSprite(spriteName)
end

function gameEndGangPai:setMahjongId(mahjongIds, angang)
    for i=1, 3 do
        local spt = self.bottomItems[i]
        local mid = mahjongIds[i]

        if angang then
            spt:setSprite("back")
        else
            setSprite(spt, mid)
        end
    end

    setSprite(self.mD, mahjongIds[4])
end

return gameEndGangPai

--endregion
