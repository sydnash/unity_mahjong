--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local city = class("city", base)

_RES_(city, "CityUI", "CityUI")

function city:onInit()
    self.regionId = gamepref.city.Region

    self.mRegionChengDu.id   = "ChengDu"
    self.mRegionYaAn.id      = "YaAn"
    self.mRegionDeYang.id    = "DeYang"
    self.mRegionNanChong.id  = "NanChong"

    self.regions = { 
        ["ChengDu"]     = { r = self.mRegionChengDu,   p = self.mChengDuPanel, },
        ["YaAn"]        = { r = self.mRegionYaAn,      p = self.mYaAnPanel, },
        ["DeYang"]      = { r = self.mRegionDeYang,    p = self.mDeYangPanel, },
        ["NanChong"]    = { r = self.mRegionNanChong,  p = self.mNanChongPanel, },
    }

    for k, v in pairs(self.regions) do
        if k == gamepref.city.Region then
            v.r:setSelected(true)
            v.p:reset()
            v.p:show()
        else
            v.r:setSelected(false)
            v.p:hide()
        end

        v.r:addChangedListener(self.onRegionChangedHandler, self)
    end

    self.mChengDu.id    = cityType.chengdu
    self.mJinTang.id    = cityType.jintang
    self.mWenJiang.id   = cityType.wenjiang
    self.mYingJing.id   = cityType.yingjing
    self.mZhongJiang.id = cityType.zhongjiang
    self.mNanChong.id   = cityType.nanchong
    self.mXiChong.id    = cityType.xichong

    self.cityChoseUI = { self.mChengDu, 
                         self.mJinTang,
                         self.mWenJiang,
                         self.mYingJing,
                         self.mZhongJiang,
                         self.mNanChong,
                         self.mXiChong,
    }

    for _, v in pairs(self.cityChoseUI) do
        if v.id == gamepref.city.City then
            self:showChosedHintOnUI(v)
        end

        v:addClickListener(self.onCityClickedHandler, self)
    end

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function city:showChosedHintOnUI(ui)
    self.mChosedHint:setParent(ui)
    self.mChosedHint:setLocalPosition(Vector3.zero)
end

function city:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function city:onRegionChangedHandler(sender, selected, clicked)
    if clicked and selected then
        self.regionId = sender.id

        for k, v in pairs(self.regions) do
            if k == self.regionId then
                v.r:setSelected(true)
                v.p:reset()
                v.p:show()
            else
                v.r:setSelected(false)
                v.p:hide()
            end
        end

        playButtonClickSound()
    end
end

function city:onCityClickedHandler(sender)
    local cityType = sender.id
    if gamepref.city.City ~= cityType then
        gamepref.city.Region = self.regionId
        gamepref.city.City = cityType

        signalManager.signal(signalType.city, cityType)
        writeCityConfig(gamepref.city)
    end

    self:close()
    playButtonClickSound()
end

function city:onCloseAllUIHandler()
    self:close()
end

function city:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return city

--endregion
