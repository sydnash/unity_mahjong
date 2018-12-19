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
    self.super.ctor(self)
end

function doushisiDeskHeader:setPlayerInfo(player)
    self.super.setPlayerInfo(self, player)

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
    self.super.reset(self)
end

return mahjongDeskHeader

--endregion
