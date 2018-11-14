--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local createFriendster = class("createFriendster", base)

_RES_(createFriendster, "FriendsterUI", "CreateFriendsterUI")

function createFriendster:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function createFriendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExpand:addClickListener(self.onExpandClickedHandler, self)
    self.mUnexpand:addClickListener(self.onUnexpandClickedHandler, self)
    self.mCityListMask:addClickListener(self.onUnexpandClickedHandler, self)
    self.mName:addChangedListener(self.onNameChangedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mCityList_ChengDu:addChangedListener(self.onCityChangedHandler, self)
    self.mCityList_JinTang:addChangedListener(self.onCityChangedHandler, self)

    self.mUnexpand:hide()
    self.mCityList:hide()

    self.mCity:setText(cityName[gamepref.city.City])
    self.mName:setCharacterLimit(gameConfig.friendsterNameMaxLength)
    self.mName:setText(string.empty)
    
    self.mCityList_ChengDu:setSelected(false)
    self.mCityList_JinTang:setSelected(false)

    self.mCityList_ChengDu.id  = cityType.chengdu
    self.mCityList_JinTang.id  = cityType.jintang

    local citys = {
        self.mCityList_ChengDu,
        self.mCityList_JinTang,
    }

    for _, v in pairs(citys) do
        v:setSelected(v.id == gamepref.city.City)
    end

    self:refreshCreateState()
end

function createFriendster:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function createFriendster:onExpandClickedHandler()
    playButtonClickSound()

    self.mExpand:hide()
    self.mUnexpand:show()
    self.mCityList:show()
end

function createFriendster:onUnexpandClickedHandler()
    playButtonClickSound()

    self.mExpand:show()
    self.mUnexpand:hide()
    self.mCityList:hide()
end

function createFriendster:onNameChangedHandler()
    self:refreshCreateState()
end

function createFriendster:onCreateClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在创建亲友圈")
    networkManager.createFriendster(self.cityId, self.mName:getText(), function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
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
        playButtonClickSound()

        self.cityId = sender.id
        self.mCity:setText(cityName[sender.id])

        self:refreshCreateState()
    end
end

function createFriendster:refreshCreateState()
    local name = self.mName:getText()
    if self.cityId == nil or string.isNilOrEmpty(name) then
        self.mCreate:setInteractabled(false)
        self.mCreateZ:setSprite("gray")
    else
        self.mCreate:setInteractabled(true)
        self.mCreateZ:setSprite("light")
    end
end

return createFriendster

--endregion
