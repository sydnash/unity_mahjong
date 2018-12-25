local base = require("ui.common.view")

local huPaiHint = class("huPaiHint", base)
_RES_(huPaiHint, "MahjongDeskUI", "HuPaiHintUI")

function huPaiHint:ctor(info)
    base.ctor(self)
    self.huInfo = info
end

local singleSize = Vector2.New(314.6, 168.3)
local doubleHeight = 288.4
local add = 195.8
local base = 314.6

function huPaiHint:onInit()
    local cnt = #self.huInfo
    local size = singleSize
    if cnt > 1 then
        local t = math.floor(cnt / 2)
        local w = base + add * (t - 1)
        local h = 288.4
        size = Vector2.New(w, h)
    end
    self.mBg:setSize(size)
end

return huPaiHint
