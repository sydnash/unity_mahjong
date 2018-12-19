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
    self.super.ctor(self)
end

function createFriendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExpand:addClickListener(self.onExpandClickedHandler, self)
    self.mUnexpand:addClickListener(self.onUnexpandClickedHandler, self)
    self.mCityListMask:addClickListener(self.onUnexpandClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)

    self.mUnexpand:hide()
    self.mCityPanel:hide()

    self.mCity:setText(cityName[gamepref.city.City])
    self.mName:setCharacterLimit(gameConfig.friendsterNameMaxLength)
    self.mName:setText(string.empty)
    
    local citys = {}
    for k, v in pairs(cityOrder) do
        local toggle = findPointerToggle(self.mCityList.transform, "Viewport/Content/" .. tostring(k))
        if toggle ~= nil then
            toggle.id = v
            if gamepref.city.City == v then
                self.cityId = v
                toggle:setSelected(true)
            else
                toggle:setSelected(false)
            end
            toggle:addChangedListener(self.onCityChangedHandler, self)

            local label = findText(toggle.transform, "Label")
            if label ~= nil then
                label:setText(cityName[v])
            end
        end
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function createFriendster:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function createFriendster:onExpandClickedHandler()
    self.mExpand:hide()
    self.mUnexpand:show()
    self.mCityPanel:show()
    playButtonClickSound()
end

function createFriendster:onUnexpandClickedHandler()
    self.mExpand:show()
    self.mUnexpand:hide()
    self.mCityPanel:hide()
    self.mCityList:reset()

    playButtonClickSound()
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

function createFriendster:onCityChangedHandler(sender, selected, clicked)
    if clicked and selected then
        self.cityId = sender.id
        self.mCity:setText(cityName[sender.id])

        playButtonClickSound()
    end
end

function createFriendster:onCloseAllUIHandler()
    self:close()
end

function createFriendster:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return createFriendster

--endregion
