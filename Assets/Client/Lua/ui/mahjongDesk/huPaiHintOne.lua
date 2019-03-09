local base = require("ui.common.panel")

local huPaiHintOne = class("huPaiHintOne", base)
local mahjongType  = require ("logic.mahjong.mahjongType")

--function huPaiHintOne:ctor(info, start)
--    base.ctor(self)
--end

--function huPaiHintOne:onInit()

--end

local WHITE_COLOR = Color.white
local GRAY_COLOR = Color.New(1, 1, 1, 0.5)

function huPaiHintOne:setInfo(info)
    self:setMahjong(info.jiaoTid * 4, info.left)
    self:setFanShu(info.fan)
    self:setCount(info.left)
end

function huPaiHintOne:setMahjong(id, count)
    local spriteName = mahjongType.getMahjongTypeById(id).name
    self.mMahjong:setSprite(spriteName)

    if count > 0 then
        self.mMahjong:setColor(WHITE_COLOR)
    else
        self.mMahjong:setColor(GRAY_COLOR)
    end
end

function huPaiHintOne:setFanShu(fan)
    fan = fan or 0
    self.mFan:setText(string.format("%d番", fan))
end

function huPaiHintOne:setCount(cnt)
    cnt = cnt or 0
    self.mCount:setText(string.format("%d张", cnt))
end

return huPaiHintOne
