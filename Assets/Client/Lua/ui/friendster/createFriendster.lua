--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local createFriendster = class("createFriendster", base)

_RES_(createFriendster, "FriendsterUI", "CreateFriendsterUI")

local cityOrder = {
    cityType.chengdu,
    cityType.wenjiang,
    cityType.jintang,
    cityType.xichong,
    cityType.nanchong,
    cityType.jiangyou,
    cityType.yingjing,
}

function createFriendster:ctor(callback)
    self.callback = callback
    base.ctor(self)
end

function createFriendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExpand:addClickListener(self.onExpandClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)

    self.mCity:setText(cityName[gamepref.city.City])
    self.cityId = gamepref.city.City
    self.mName:setCharacterLimit(gameConfig.friendsterNameMaxLength)
    self.mName:setText(string.empty)

    signalManager.registerSignalHandler(signalType.cityForClub, self.onCityChangedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function createFriendster:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function createFriendster:onExpandClickedHandler()
    local ui = require("ui.city").new(true)
    ui:show()

    playButtonClickSound()
end

function createFriendster:onCityChangedHandler(cityType)
    self.cityId = cityType
    self.mCity:setText(cityName[self.cityId])
end

function createFriendster:onCreateClickedHandler()
    playButtonClickSound()

    if self.cityId == nil or self.cityId <= 0 then
        showMessageUI("请选择地区")
        return
    end

    local name = self.mName:getText()
    if string.isNilOrEmpty(name) then
        showMessageUI("请输入亲友圈名字")
        return
    end 

    showWaitingUI("正在创建亲友圈")
    networkManager.createFriendster(self.cityId, name, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

--        log("friendster created, msg = " .. table.tostring(msg))
        if self.callback ~= nil then
            msg.RetCode = nil
            self.callback(msg)
        end

        self:close()
    end)
end

function createFriendster:onCloseAllUIHandler()
    self:close()
end

function createFriendster:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cityForClub, self.onCityChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return createFriendster

--endregion
