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

function gameEndGangPai:setMahjongId(mahjongId, angang)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name

    if angang then
        self.mA:setSprite("back")
        self.mB:setSprite("back")
        self.mC:setSprite("back")
    else
        self.mA:setSprite(spriteName)
        self.mB:setSprite(spriteName)
        self.mC:setSprite(spriteName)
    end

    self.mD:setSprite(spriteName)
end

return gameEndGangPai

--endregion
