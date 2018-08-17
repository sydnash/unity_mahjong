--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local lobby = class("lobby", base)

lobby.folder = "LobbyUI"
lobby.resource = "LobbyUI"

function lobby:onInit()
    self.mNickname:setText(app.gamePlayer.nickname)
    self.mID:setText(app.gamePlayer.acId)

    self.mEnterRoom:addClickListener(self.onEnterRoomClickedHandler, self)
    self.mCreateRoom:addClickListener(self.onCreateRoomClickedHandler, self)
end

function lobby:onEnterRoomClickedHandler()
    soundManager.playButtonClickedSound()

    local ui = require("ui.enterroom").new()
    ui:show()
end

function lobby:onCreateRoomClickedHandler()
    soundManager.playButtonClickedSound()
    local room = require("logic.gameroom.majiang.majiangRoomBase").new()
end

return lobby

--endregion
