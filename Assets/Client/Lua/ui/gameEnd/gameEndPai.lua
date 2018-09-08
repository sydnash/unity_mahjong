--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEndPai = class("gameEndPai", base)

gameEndPai.folder = "GameEndUI"
gameEndPai.resource = "GameEndUI_Pai"
gameEndPai.width = 51

function gameEndPai:onInit()
    self.mPai:setSprite(self.spriteName)
    self.mHuk:hide()
end

function gameEndPai:setMahjongId(mahjongId)
    local spriteName = convertMahjongIdToSpriteName(mahjongId)
    self.mPai:setSprite(spriteName)
end

function gameEndPai:setHighlight(highlight)
    if highlight then
        self.mHuk:show()
    else
        self.mHuk:hide()
    end
end

return gameEndPai

--endregion
