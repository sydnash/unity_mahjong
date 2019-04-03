--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongType = require("logic.mahjong.mahjongType")

local base = require("ui.common.view")
local gameEndGangPai = class("gameEndGangPai", base)

_RES_(gameEndGangPai, "GameEndUI/Mahjong", "GameEndUI_GangPai")
gameEndGangPai.width = 139

function gameEndGangPai:onInit()
    self.items = { 
        { m = self.mA, f = self.mLaiziA },
        { m = self.mB, f = nil          },
        { m = self.mC, f = self.mLaiziC },
        { m = self.mD, f = self.mLaiziD },
    }

    for _, v in pairs(self.items) do
        if v.f ~= nil then
            v.f:hide()
        end
    end

    self.mTimes:hide()
end

local function setSprite(item, mid)
    local spriteName = mahjongType.getMahjongTypeById(mid).name
    item.m:setSprite(spriteName)

    local game = clientApp.currentDesk
    if game ~= nil and game:isLaizi(mid) and item.f ~= nil then
        item.f:show()
    end
end

function gameEndGangPai:setMahjongId(mahjongIds, angang)
    for i=1, 4 do
        if angang and i < 4 then
            spt:setSprite("back")
        else
            setSprite(self.items[i], mahjongIds[i])
        end
    end

    local times = #mahjongIds - 3
    if times > 1 then
        self.mTimes:setText("x" .. tostring(times))
        self.mTimes:show()
    end
end

return gameEndGangPai

--endregion
