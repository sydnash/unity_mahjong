--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local lobby = class("lobby", base)

_RES_(lobby, "LobbyUI", "LobbyUI")

function lobby:onInit()
    self.mHeadIcon:setTexture(gamepref.player.headerTex)
    self.mNickname:setText(gamepref.player.nickname)
    self.mID:setText("编号:" .. gamepref.player.acId)

    self.mHead:addClickListener(self.onHeadClickedHandler, self)
    self.mSwitchCity:addClickListener(self.onSwitchCityClickedHandler, self)
    self.mAddRoomCard:addClickListener(self.onAddRoomCardClickedHandler, self)
    self.mHelp:addClickListener(self.onHelpClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
    self.mAccuse:addClickListener(self.onAccuseClickedHandler, self)
    self.mEnterDesk:addClickListener(self.onEnterDeskClickedHandler, self)
    self.mCreateDesk:addClickListener(self.onCreateDeskClickedHandler, self)
    self.mEnterQYQ:addClickListener(self.onEnterQYQClickedHandler, self)
    self.mShop:addClickListener(self.onShopClickedHandler, self)
    self.mHistory:addClickListener(self.onHistoryClickedHandler, self)
    self.mRank:addClickListener(self.onRankClickedHandler, self)
    self.mActive:addClickListener(self.onActiveClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mAuthenticate:addClickListener(self.onAuthenticateClickedHandler, self)
    self.mMail:addClickListener(self.onMailClickedHandler, self)
end

function lobby:onHeadClickedHandler()
    playButtonClickSound()
end

function lobby:onSwitchCityClickedHandler()
    playButtonClickSound()
end

function lobby:onAddRoomCardClickedHandler()
    playButtonClickSound()
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
end

function lobby:onEnterDeskClickedHandler()
    playButtonClickSound()

    local ui = require("ui.enterDesk").new(function(deskId)
        local cityType = cityType.xxxxx

        local loading = require("ui.loading").new()
        loading:show()

        self:enterDesk(loading, cityType, deskId)
    end)
    ui:show()
end

function lobby:onCreateDeskClickedHandler()
    playButtonClickSound()
    
    local loading = require("ui.loading").new()
    loading:show()

    networkManager.createDesk(cityType.xxxxx, {}, 0, function(ok, msg)
        if not ok then
            log("create desk error")
            loading:close()
            showMessageUI("网络繁忙，请稍后再试")
            return
        end
        log("create desk, msg = " .. table.tostring(msg))
        self:enterDesk(loading, msg.GameType, msg.DeskId)
    end)
end

function lobby:onEnterQYQClickedHandler()
    playButtonClickSound()
end

function lobby:onShopClickedHandler()
    playButtonClickSound()
end

function lobby:onHistoryClickedHandler()
    playButtonClickSound()
end

function lobby:onRankClickedHandler()
    playButtonClickSound()
end

function lobby:onActiveClickedHandler()
    playButtonClickSound()
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

function lobby:onDestroy()
    self.mHeadIcon:setTexture(nil)
end

return lobby

--endregion
