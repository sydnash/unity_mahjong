--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEndPengPai = class("gameEndPengPai", base)

gameEndPengPai.folder = "GameEndUI"
gameEndPengPai.resource = "GameEndUI_PengPai"
gameEndPengPai.width = 139

function gameEndPengPai:onInit()
    
end

function gameEndPengPai:setMahjongId(mahjongId)
    local spriteName = convertMahjongIdToSpriteName(mahjongId)
    self.mA:setSprite(spriteName)
    self.mB:setSprite(spriteName)
    self.mC:setSprite(spriteName)
end

return gameEndPengPai

--endregion
