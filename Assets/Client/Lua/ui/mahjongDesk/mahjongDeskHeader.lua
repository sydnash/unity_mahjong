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
    base.ctor(self)
end

function mahjongDeskHeader:setPlayerInfo(player)
    base.setPlayerInfo(self, player)

    if player ~= nil then
        if player.isMarker then
            self:showMarker()
        else
            self:hideMarker()
        end

        if not json.isNilOrNull(player.hu) and player.hu[1].HuCard >= 0 then
            local name
            local t = player.hu[1].HuType
            local detail = opType.hu.detail
            if t == detail.zimo then
                name = "zimo"
            elseif t == detail.gangshanghua then
                name = "gangshanghua"
            else
                name = "hu"
            end
            self:showHu(name)
        else
            self:hideHu()
        end

        if player.que ~= nil and player.que >= 0 then
            self:showDingQue(player.que)
        else
            self:hideDingQue()
        end
    end
end

function mahjongDeskHeader:showMarker()
    self.mZhuang:show()
end

function mahjongDeskHeader:hideMarker()
    self.mZhuang:hide()
end

function mahjongDeskHeader:showDingQue(mjtype)
    self.mQue:setSprite(getMahjongClassName(mjtype))
    self.mQue:show()
end

function mahjongDeskHeader:hideDingQue()
    self.mQue:hide()
end

function mahjongDeskHeader:showHu(name)
    self.mHu:show()
    self.mHu:setSprite(name)
end

function mahjongDeskHeader:hideHu()
    self.mHu:hide()
end

function mahjongDeskHeader:reset()
    self:hideDingQue()
    self:hideHu()
    base.reset(self)
end

return mahjongDeskHeader

--endregion
