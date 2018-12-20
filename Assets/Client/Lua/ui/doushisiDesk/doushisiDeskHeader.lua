--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local base = require("ui.deskHeader")
local doushisiDeskHeader = class("doushisiDeskHeader", base)
local doushisiGame = require("logic.doushisi.doushisiGame")

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
        self:setCount(player.zhangShu)
        self:setFuShu(player.fuShu)
    else
        self:setCount(0)
        self:setFuShu(0)
        self:hideDang()
        self:hide()
    end
end

function doushisiDeskHeader:setCount(count)
    count = count or 0
    self.mCount:setText(string.format("张数:%d", count))
end

function doushisiDeskHeader:setFuShu(fushu)
    fushu = fushu or 0
    self.mFuShu:setText(string.format("福数:%d", fushu))
end

function doushisiDeskHeader:reset()
    base.reset(self)
    self:hideDang()
    self:hideDaDang()
    self:hideZhuang()
    self:hidePiao()
    self:hideBao()
    self:hideXiao()
end

--dang
function doushisiDeskHeader:showDang()
    self.mFlagDang:show()
end
function doushisiDeskHeader:hideDang()
    self.mFlagDang:hide()
end

--piao
function doushisiDeskHeader:showPiao()
    self.mFlagPiao:show()
end
function doushisiDeskHeader:hidePiao()
    self.mFlagPiao:hide()
end

--bao
function doushisiDeskHeader:showBao()
    self.mFlagBao:show()
end
function doushisiDeskHeader:hideBao()
    self.mFlagBao:hide()
end

--zhuang
function doushisiDeskHeader:showZhuang()
    self.mZhuang:show()
end
function doushisiDeskHeader:hideZhuang()
    self.mZhuang:hide()
end

--da dang
function doushisiDeskHeader:showDaDang()
    self.mDang:show()
end
function doushisiDeskHeader:hideDaDang()
    self.mDang:hide()
end

--xiao
function doushisiDeskHeader:showXiao()
    self.mXiao:show()
end
function doushisiDeskHeader:hideXiao()
    self.mXiao:hide()
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
