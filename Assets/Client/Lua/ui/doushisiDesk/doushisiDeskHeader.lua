--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = require("const.mahjongClass")

local base = require("ui.deskHeader")
local doushisiDeskHeader = class("doushisiDeskHeader", base)

local res = {
    [seatType.mine]  = "DeskHeaderM",
    [seatType.right] = "DeskHeaderR",
    [seatType.top]   = "DeskHeaderT",
    [seatType.left]  = "DeskHeaderL",
}

function doushisiDeskHeader:ctor(seatType)
    _RES_(self, "DoushisiDeskUI", res[seatType])
    base.ctor(self)
end

function doushisiDeskHeader:setPlayerInfo(player)
    base.setPlayerInfo(self, player)

    if player ~= nil then
        
    end
end

function doushisiDeskHeader:setCount(count)
    self.mCount:setText(string.format("张数:%d", count))
end

function doushisiDeskHeader:setFuShu(fushu)
    self.mFuShu:setText(string.format("福数:%d", fushu))
end

function doushisiDeskHeader:reset()
    base.reset(self)
end

local tweenConfig = {
    { f = 0 / 60, s = Vector3.New(1, 1, 1)},
    { f = 4 / 60, s = Vector3.New(2.20, 2.20, 1)},
    { f = 10 / 60, s = Vector3.New(2.0, 2.0, 1)},
    { f = 22 / 60, s = Vector3.New(1.0, 1.0, 1)},
    { f = 60 / 60, s = Vector3.New(1.0, 1.0, 1)},
}
function doushisiDeskHeader:getOpTween(node, baseS)
    local tweens = {}
    node:setLocalScale(baseS * tweenConfig[1].s)
    node:show()
    for i = 2, #tweenConfig do
        local t1 = tweenConfig[i - 1].f
        local t2 = tweenConfig[i].f
        local ac = tweenScale.new(node, t2 - t1, baseS * tweenConfig[i - 1].s, baseS * tweenConfig[i].s)
        table.insert(tweens, ac)
    end
    table.insert(tweens, tweenFunction.new(function()
        node:hide()
    end))
    return tweenSerial.getByVec(true, doNextImmediately, tweens)
end

return doushisiDeskHeader

--endregion
