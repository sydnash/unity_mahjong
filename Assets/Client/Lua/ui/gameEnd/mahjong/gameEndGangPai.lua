--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndGangPai = class("gameEndGangPai", base)

_RES_(gameEndGangPai, "GameEndUI/Mahjong", "GameEndUI_GangPai")
gameEndGangPai.width = 139

function gameEndGangPai:onInit()
    self.mA:setSprite(self.spriteName)
    self.mB:setSprite(self.spriteName)
    self.mC:setSprite(self.spriteName)
    self.mD:setSprite(self.spriteName)
end

function gameEndGangPai:setMahjongId(mahjongId)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name
    self.mA:setSprite(spriteName)
    self.mB:setSprite(spriteName)
    self.mC:setSprite(spriteName)
    self.mD:setSprite(spriteName)
end

return gameEndGangPai

--endregion
