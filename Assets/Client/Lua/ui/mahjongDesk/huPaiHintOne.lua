local base = require("ui.common.panel")

local huPaiHintOne = class("huPaiHintOne", base)
local mahjongType  = require ("logic.mahjong.mahjongType")

function huPaiHintOne:ctor(info, start)
    base.ctor(self)
end

function huPaiHintOne:onInit()
end

function huPaiHintOne:setInfo(info)
    if type(info) ~= "table" then
        info = {
            id = math.random(1,26),
            fan = math.random(0,4),
            left = math.random(0,4),
        }
    end
    self:setMahjong(info.id)
    self:setFanShu(info.fan)
    self:setCount(info.left)
end

function huPaiHintOne:setMahjong(id)
    local spriteName = mahjongType.getMahjongTypeById(id).name
    self.mMahjong:setSprite(spriteName)
end

function huPaiHintOne:setFanShu(fan)
    fan = fan or 0
    self.mFan:setText(string.format("%d番", fan))
end

function huPaiHintOne:setCount(cnt)
    cnt = cnt or 0
    self.mFan:setText(string.format("%d张", cnt))
end

return huPaiHintOne
