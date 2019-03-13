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
    self.mRain:hide()
    self.mWind:hide()

    if self.rainTween ~= nil then
        self.rainTween:stop()
        tweenManager.remove(self.rainTween)
        self.rainTween = nil
    end
    if self.windTween ~= nil then
        self.windTween:stop()
        tweenManager.remove(self.windTween)
        self.windTween = nil
    end

    base.reset(self)
end

function mahjongDeskHeader:playRain()
    if self.rainTween ~= nil then
        self.rainTween:stop()
        tweenManager.remove(self.rainTween)
    end

    self.rainTween = tweenSerial.new(true)

    local a = tweenFunction.new(function()
        self.mRain:hide()
        self.mRain:show()
        self.mRain:play("deskplayer_rain")
    end)
    local b = tweenDelay.new(2)
    local c = tweenFunction.new(function()
        self.mRain:hide()
        self.rainTween = nil
    end)

    self.rainTween:add(a)
    self.rainTween:add(b)
    self.rainTween:add(c)

    tweenManager.add(self.rainTween)
    self.rainTween:play()
end

function mahjongDeskHeader:playWind()
    if self.windTween ~= nil then
        self.rainTween:stop()
        tweenManager.remove(self.windTween)
    end

    self.windTween = tweenSerial.new(true)

    local a = tweenFunction.new(function()
        self.mWind:hide()
        self.mWind:show()
        self.mWind:play("deskplayer_wind")
    end)
    local b = tweenDelay.new(2)
    local c = tweenFunction.new(function()
        self.mWind:hide()
        self.windTween = nil
    end)

    self.windTween:add(a)
    self.windTween:add(b)
    self.windTween:add(c)

    tweenManager.add(self.windTween)
    self.windTween:play()
end

return mahjongDeskHeader

--endregion
