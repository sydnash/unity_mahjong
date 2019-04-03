--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndPengPai = class("gameEndPengPai", base)

_RES_(gameEndPengPai, "GameEndUI/Mahjong", "GameEndUI_PengPai")
gameEndPengPai.width = 139

function gameEndPengPai:onInit()
    self.items = { 
        { m = self.mA, f = self.mLaiziA },
        { m = self.mB, f = self.mLaiziB },
        { m = self.mC, f = self.mLaiziC },
    }

    for _, v in pairs(self.items) do
        v.f:hide()
    end
end

function gameEndPengPai:setMahjongId(mahjongIds)
    local game = clientApp.currentDesk

    for k, v in pairs(self.items) do
        local mid = mahjongIds[k]

        local spriteName = mahjongType.getMahjongTypeById(mid).name
        v.m:setSprite(spriteName)
        
        if game ~= nil and game:isLaizi(mid) then
            v.f:show()
        end
    end
end

return gameEndPengPai

--endregion
