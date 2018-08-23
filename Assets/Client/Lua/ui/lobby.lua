--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local cityType = require("const.cityType")

local base = require("ui.common.view")
local lobby = class("lobby", base)

lobby.folder = "LobbyUI"
lobby.resource = "LobbyUI"

function lobby:onInit()
    self.mNickname:setText(app.gamePlayer.nickname)
    self.mID:setText(app.gamePlayer.acId)

    self.mEnterDesk:addClickListener(self.onEnterDeskClickedHandler, self)
    self.mCreateDesk:addClickListener(self.onCreateDeskClickedHandler, self)
end

function lobby:onEnterDeskClickedHandler()
    soundManager.playButtonClickedSound()

    local ui = require("ui.enterDesk").new(function(deskId)
        local cityType = cityType.xxxxx

        local loading = require("ui.loading").new()
        loading:show()

        self:enterDesk(loading, cityType, deskId)
    end)
    ui:show()
end

function lobby:onCreateDeskClickedHandler()
    soundManager.playButtonClickedSound()
    
    local loading = require("ui.loading").new()
    loading:show()

    networkManager.createDesk(cityType.xxxxx, {}, 0, function(ok, msg)
        if not ok then
            loading:close()
            log("create desk error")
            return
        end
        
        self:enterDesk(loading, msg.GameType, msg.DeskId)
    end)
end

function lobby:enterDesk(loading, cityType, deskId)
    networkManager.checkDesk(cityType, deskId, function(ok, msg)
        if not ok then
            loading:close()
            log("check desk error")
            return
        end

        networkManager.enterDesk(cityType, deskId, function(ok, msg)
            if not ok then
                loading:close()
                log("enter desk error")
                return
            end

            if msg.RetCode ~= retc.Ok then
                loading:close()
                log(retcText[msg.RetCode])
                return
            end

            sceneManager.load("MahjongScene", function(completed, progress)
                loading:setProgress(progress)

                if completed then
                    require("logic.mahjong.mahjongDesk").new(4, 108)
                    loading:close()
                end
            end)

            self:close()
        end)
    end)
end

return lobby

--endregion
