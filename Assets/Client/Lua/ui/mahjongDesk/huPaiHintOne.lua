local base = require("ui.common.panel")

local huPaiHintOne = class("huPaiHintOne", base)
local mahjongType  = require ("logic.mahjong.mahjongType")

function huPaiHintOne:ctor(info, start)
    base.ctor(self)
end

function huPaiHintOne:onInit()
end

function huPaiHintOne:setInfo(info)
    self:setMahjong(info.jiaoTid * 4)
    self:setFanShu(info.fan)
    self:setCount(info.left)
end

function huPaiHintOne:setMahjong(id)
    local spriteName = mahjongType.getMahjongTypeById(id).name
--    log("sprite name : " .. spriteName)
    self.mMahjong:setSprite(spriteName)
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
