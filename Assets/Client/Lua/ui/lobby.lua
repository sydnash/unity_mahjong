--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local lobby = class("lobby", base)

_RES_(lobby, "LobbyUI", "LobbyUI")

function lobby:onInit()
    self.mIcon:setPlayer(gamepref.player)
    self.mNickname:setText(cutoutString(gamepref.player.nickname, gameConfig.nicknameMaxLength))
    self.mID:setText("帐号:" .. gamepref.player.acId)
    self.mCards:setText(tostring(gamepref.player.cards))
    self.mCityText:setSprite(cityTypeSID[gamepref.city.City])

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

    if clientApp.currentDesk ~= nil and clientApp.currentDesk.deskId ~= nil then
        self.mReturnDesk:show()
        self.mCreateDesk:hide()
    else
        self.mReturnDesk:hide()
        self.mCreateDesk:show()
    end

    self:refreshMailRP()

    signalManager.registerSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.registerSignalHandler(signalType.enterDesk, self.onEnterDeskHandler, self)
    signalManager.registerSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.registerSignalHandler(signalType.city, self.onCityChangedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function lobby:onHeadClickedHandler()
    playButtonClickSound()

    local ui = require("ui.playerInfo").new(gamepref.player)
    ui:show()
end

function lobby:onSwitchCityClickedHandler()
    playButtonClickSound()

    local ui = require("ui.city").new()
    ui:show()
end

function lobby:onAddRoomCardClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function lobby:onHelpClickedHandler()
    playButtonClickSound()
end

function lobby:onSettingClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.setting").new()
    ui:show()
end

function lobby:onAccuseClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function lobby:onEnterDeskClickedHandler()
    playButtonClickSound()

    local ui = require("ui.enterDesk").new(function(deskId)
        local cityType = gamepref.city.City

        local loading = require("ui.loading").new()
        loading:show()

        self:enterDesk(loading, cityType, deskId)
    end)
    ui:show()
end

function lobby:onReturnDeskClickedHandler()
    playButtonClickSound()

    local loading = require("ui.loading").new()
    loading:show()

    local cityType = clientApp.currentDesk.cityType
    local deskId = clientApp.currentDesk.deskId
    self:enterDesk(loading, cityType, deskId)
end

function lobby:onCreateDeskClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.createDesk").new(gamepref.city.City, 0)
    ui:show()
end

function lobby:onEnterQYQClickedHandler()
    playButtonClickSound()
    
    showWaitingUI("正在获取亲友圈数据，请稍候...")
    networkManager.queryFriendsterList(function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("获取亲友圈数据失败")
            return
        end

        log("query friendster list, msg = " .. table.tostring(msg))

        local ui = require("ui.friendster.friendster").new(msg.Clubs)
        ui:show()
    end)
end

function lobby:onShopClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function lobby:onHistoryClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function lobby:onRankClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function lobby:onActivityClickedHandler()
    playButtonClickSound()

    local ui = require("ui.activity").new()
    ui:show()
end

function lobby:onShareClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.share").new()
    ui:show()
end

function lobby:onAuthenticateClickedHandler()
    playButtonClickSound()

    local ui = require("ui.authentication").new()
    ui:show()
end

function lobby:onMailClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.mail.mail").new()
    ui:show()
end

function lobby:enterDesk(loading, cityType, deskId)
    enterDesk(cityType, deskId, function(ok, errText, preload, progress, msg)
        if not ok then
            loading:close()
            showMessageUI(errText)
        else
            if msg == nil then
                loading:setProgress(progress * 0.4)
            else
                loading:setProgress(0.4)

                sceneManager.load("scene", "mahjongscene", function(completed, progress)
                    loading:setProgress(0.4 + 0.6 * progress)

                    if completed then
                        if preload ~= nil then
                            preload:stop()
                        end

                        msg.Reenter = table.fromjson(msg.Reenter)
                        msg.Config = table.fromjson(msg.Config)

                        local desk = require("logic.mahjong.mahjongGame").new(msg)
                        loading:close()
                    end
                end)

                self:close()
            end
        end
    end)
end

function lobby:onCardsChangedHandler()
    self.mCards:setText(tostring(gamepref.player.cards))
end

function lobby:onEnterDeskHandler(args)
    local loading = args.loading
    local cityType = args.cityType
    local deskId = args.deskId

    self:enterDesk(loading, cityType, deskId)
end

function lobby:onMailHandler()
    self:refreshMailRP()
end

function lobby:onCityChangedHandler(city)
    self.mCityText:setSprite(cityTypeSID[city])
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

function lobby:onCloseAllUIHandler()
    self:close()
end

function lobby:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.enterDesk, self.onEnterDeskHandler, self)
    signalManager.unregisterSignalHandler(signalType.mail, self.onMailHandler, self)
    signalManager.unregisterSignalHandler(signalType.city, self.onCityChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    self.mIcon:reset()
    self.super.onDestroy(self)
end

return lobby

--endregion
