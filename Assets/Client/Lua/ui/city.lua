--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local city = class("city", base)

_RES_(city, "CityUI", "CityUI")

function city:onInit()
    self.regionId = gamepref.city.Region

    self.mRegion_ChengDu_U.id   = "ChengDu"
    self.mRegion_YaAn_U.id      = "YaAn"
    self.mRegion_DeYang_U.id    = "DeYang"
    self.mRegion_NanChong_U.id  = "NanChong"

    self.regions = { 
        ["ChengDu"]     = { s = self.mRegion_ChengDu,   u = self.mRegion_ChengDu_U,     d = self.mCity_ChengDu, },
        ["YaAn"]        = { s = self.mRegion_YaAn,      u = self.mRegion_YaAn_U,        d = self.mCity_YaAn, },
        ["DeYang"]      = { s = self.mRegion_DeYang,    u = self.mRegion_DeYang_U,      d = self.mCity_DeYang, },
        ["NanChong"]    = { s = self.mRegion_NanChong,  u = self.mRegion_NanChong_U,    d = self.mCity_NanChong, },
    }

    for k, v in pairs(self.regions) do
        if k == gamepref.city.Region then
            v.s:show()
            v.u:hide()
            v.d:reset()
            v.d:show()
        else
            v.s:hide()
            v.u:show()
            v.d:hide()
        end

        v.u:addClickListener(self.onRegionClickedHandler, self)
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

function city:onRegionClickedHandler(sender)
    self.regionId = sender.id

    for k, v in pairs(self.regions) do
        if k == self.regionId then
            v.s:show()
            v.u:hide()
            v.d:reset()
            v.d:show()
        else
            v.s:hide()
            v.u:show()
            v.d:hide()
        end
    end

    playButtonClickSound()
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
