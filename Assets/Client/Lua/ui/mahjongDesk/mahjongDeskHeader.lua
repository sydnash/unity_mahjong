--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = require("const.mahjongClass")

local base = require("ui.deskHeader")
local mahjongDeskHeader = class("mahjongDeskHeader", base)

local res = {
    [seatType.mine]  = "DeskHeaderM",
    [seatType.right] = "DeskHeaderR",
    [seatType.top]   = "DeskHeaderT",
    [seatType.left]  = "DeskHeaderL",
}

function mahjongDeskHeader:ctor(seatType)
    _RES_(self, "MahjongDeskUI", res[seatType])
    self.super.ctor(self)
end

function mahjongDeskHeader:setPlayerInfo(player)
    self.super.setPlayerInfo(self, player)

    if player ~= nil then
        if player.que ~= nil and player.que >= 0 then
            self:showDingQue(player.que)
        else
            self:hideDingQue()
        end
    end
end

function mahjongDeskHeader:showDingQue(mjtype)
    self.mQue:setSprite(getMahjongClassName(mjtype))
    self.mQue:show()
end

function mahjongDeskHeader:hideDingQue()
    self.mQue:hide()
end

function mahjongDeskHeader:reset()
    self:hideDingQue()
    self.super.reset(self)
end

return mahjongDeskHeader

--endregion
