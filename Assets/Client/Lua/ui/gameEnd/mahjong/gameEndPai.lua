--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndPai = class("gameEndPai", base)

_RES_(gameEndPai, "GameEndUI/Mahjong", "GameEndUI_Pai")
gameEndPai.width = 51

function gameEndPai:onInit()
    self.mPai:setSprite(self.spriteName)
    self.mHuk:hide()
    self.mLaizi:hide()
end

function gameEndPai:setMahjongId(mahjongId)
    local spriteName = mahjongType.getMahjongTypeById(mahjongId).name
    self.mPai:setSprite(spriteName)

    local game = clientApp.currentDesk
    if game ~= nil then
        if game:isLaizi(mahjongId) then
            self.mLaizi:show()
        end
    end
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
