--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local lobby = class("lobby", base)

_RES_(lobby, "LobbyUI", "LobbyUI")

function lobby:onInit()
    self.mIcon:setTexture(gamepref.player.headerUrl)
    self.mNickname:setText(cutoutString(gamepref.player.nickname, gameConfig.nicknameMaxLength))
    self.mID:setText("帐号:" .. gamepref.player.acId)
    self.mCards:setText(tostring(gamepref.player.cards))
    self.mCityText:setSprite(cityTypeSID[gamepref.city.City])

    self.mAccuse:hide()

    self.mHead:addClickListener(self.onHeadClickedHandler, self)
    self.mSwitchCity:addClickListener(self.onSwitchCityClickedHandler, self)
    self.mAddRoomCard:addClickListener(self.onAddRoomCardClickedHandler, self)
    self.mHelp:addClickListener(self.onHelpClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
    self.mAccuse:addClickListener(self.onAccuseClickedHandler, self)
    self.mEnterDesk:addClickListener(self.onEnterDeskClickedHandler, self)
    self.mReturnDesk:addClickListener(self.onReturnDeskClickedHandler, self)
    self.mCreateDesk:addClickListener(self.onCreateDeskClickedHandler, self)
    self.mEnterQYQ:addClickListener(self.onEnterQYQClickedHandler, self)
    self.mShop:addClickListener(self.onShopClickedHandler, self)
    self.mHistory:addClickListener(self.onHistoryClickedHandler, self)
    self.mRank:addClickListener(self.onRankClickedHandler, self)
    self.mActivity:addClickListener(self.onActivityClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mAuthenticate:addClickListener(self.onAuthenticateClickedHandler, self)
    self.mMail:addClickListener(self.onMailClickedHandler, self)
    self.mProxy:addClickListener(self.onProxyClickedHandler, self)

    if gamepref.player.currentDesk ~= nil then
        self.mReturnDesk:show()
        self.mCreateDesk:hide()
    else
        self.mReturnDesk:hide()
        self.mCreateDesk:show()
    end

--    if gamepref.player.complainLevel == 0 then
--        self.mAccuse:hide()
--    else
--        self.mAccuse:show()
--    end

    self:refreshMailRP()

    signalManager.registerSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.registerSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.registerSignalHandler(signalType.city, self.onCityChangedHandler, self)
    signalManager.registerSignalHandler(signalType.deskDestroy, self.onDeskDestroyHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function lobby:onHeadClickedHandler()
    local ui = require("ui.playerInfo").new(gamepref.player)
    ui:show()

    playButtonClickSound()
end

function lobby:onSwitchCityClickedHandler()
    local ui = require("ui.city").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onAddRoomCardClickedHandler()
    local ui = require("ui.shop").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onHelpClickedHandler()
    local ui = require("ui.rule").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onSettingClickedHandler()
    local ui = require("ui.setting.lobbySetting").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onAccuseClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待！")
end

function lobby:onEnterDeskClickedHandler()
    if gamepref.player.currentDesk ~= nil then
        local cityType = gamepref.player.currentDesk.cityType
        local deskId = gamepref.player.currentDesk.deskId

        showMessageUI(string.format("您已经在[%d]桌子中，是否进入桌子？", deskId), 
                                    function()
                                        enterDesk(cityType, deskId)
                                    end,
                                    function()
        
                                    end)
    else
        local ui = require("ui.enterDesk").new(function(deskId)
            local cityType = gamepref.city.City
            enterDesk(cityType, deskId)
        end)
        ui:show()
    end

    playButtonClickSound()
end

function lobby:onReturnDeskClickedHandler()
    playButtonClickSound()

    local cityType = gamepref.player.currentDesk.cityType
    local deskId = gamepref.player.currentDesk.deskId
    
    enterDesk(cityType, deskId)
end

function lobby:onCreateDeskClickedHandler()
    local ui = require("ui.createDesk").new(gamepref.city.City, 0, nil)
    ui:show()

    playButtonClickSound()
end

function lobby:onEnterQYQClickedHandler()
    playButtonClickSound()
    
    showWaitingUI("正在获取亲友圈数据，请稍候...")
    networkManager.queryFriendsterList(function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI("获取亲友圈数据失败")
            return
        end

        local ui = require("ui.friendster.friendster").new(msg.Clubs)
        ui:show()
    end)
end

function lobby:onShopClickedHandler()
    local ui = require("ui.shop").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onHistoryClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在拉取战绩数据，请稍候")
    gamepref.player.playHistory:updateHistory(function(ok)
        closeWaitingUI()
        if not ok then
            showMessageUI("同步战绩失败")
            return
        end
        local ui = require("ui.playHistory.playHistory").new(gamepref.player.playHistory)
        ui:show()
    end)
end

function lobby:onRankClickedHandler()
    playButtonClickSound()
    showToastUI("功能暂未开放，敬请期待！")
end

function lobby:onActivityClickedHandler()
    local ui = require("ui.activity").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onShareClickedHandler()
    local ui = require("ui.share").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onAuthenticateClickedHandler()
    local ui = require("ui.authentication.authentication").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onMailClickedHandler()
    local ui = require("ui.mail.mail").new()
    ui:show()

    playButtonClickSound()
end

function lobby:onProxyClickedHandler()
    local wxid = "tdcpkf001"
    platformHelper.setToClipboard(wxid)

    showMessageUI("客服微信已复制\n请前往微信添加客服", function()
        platformHelper.openWechat()
    end)

    playButtonClickSound()
end

function lobby:onCardsChangedHandler()
    self.mCards:setText(tostring(gamepref.player.cards))
end

function lobby:onMailHandler()
    self:refreshMailRP()
end

function lobby:onCityChangedHandler(city)
    self.mCityText:setSprite(cityTypeSID[city])
end

function lobby:onDeskDestroyHandler(msg)
    self.mReturnDesk:hide()
    self.mCreateDesk:show()
end

function lobby:refreshMailRP()
    local newmail = false

    for _, v in pairs(gamepref.player.mails) do
        if v.status == mailStatus.notRead then
            newmail = true
            break
        end
    end

    if newmail then
        self.mMailRP:show()
    else
        self.mMailRP:hide()
    end
end

function lobby:show()
    base.show(self)

--    if not clientApp.activityShown then
--        local ui = require("ui.activity").new()
--        ui:show()

--        clientApp.activityShown = true
--    end
end

function lobby:onCloseAllUIHandler()
    self:close()
end

function lobby:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.unregisterSignalHandler(signalType.city, self.onCityChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.deskDestroy, self.onDeskDestroyHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    base.onDestroy(self)
end

return lobby

--endregion
