--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local city = class("city", base)

_RES_(city, "CityUI", "CityUI")

function city:onInit()
    self.regionId = gamepref.city.Region

    self.mRegion_ChengDu_U.id = "ChengDu"

    self.regions = { 
        ["ChengDu"] = { s = self.mRegion_ChengDu, u = self.mRegion_ChengDu_U, d = self.mList_ChengDu, },
    }

    self.mRegion_ChengDu_U:addClickListener(self.onRegionClickedHandler, self)

    self.mChengDu.id = cityType.chengdu
    self.mJinTang.id = cityType.jintang

    self.cityChoseUI = {self.mChengDu, self.mJinTang}

    self.mChengDu:addClickListener(self.onCityClickedHandler, self)
    self.mJinTang:addClickListener(self.onCityClickedHandler, self)
    self.mClose:addClickListener(self.onCloseClickedHandler, self)

    self:showChosedHint()
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function city:showChosedHint()
    for _, ui in pairs(self.cityChoseUI) do
        if ui.id == gamepref.city.City then
            self:showChosedHintOnUI(ui)
        end
    end
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
        if k == regionId then
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
