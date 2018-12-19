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

function gameEndPengPai:setMahjongId(mahjongId)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name
    self.mA:setSprite(spriteName)
    self.mB:setSprite(spriteName)
    self.mC:setSprite(spriteName)
end

return gameEndPengPai

--endregion
