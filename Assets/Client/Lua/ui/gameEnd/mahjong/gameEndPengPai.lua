--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndPengPai = class("gameEndPengPai", base)

_RES_(gameEndPengPai, "GameEndUI/Mahjong", "GameEndUI_PengPai")
gameEndPengPai.width = 139

function gameEndPengPai:onInit()

end

local function setSprite(sprite, mahjongId)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name
    sprite:setSprite(spriteName)
end

function gameEndPengPai:setMahjongId(mahjongIds)
    setSprite(self.mA, mahjongIds[1])
    setSprite(self.mB, mahjongIds[2])
    setSprite(self.mC, mahjongIds[3])
end

return gameEndPengPai

--endregion
