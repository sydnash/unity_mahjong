--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playerInfo = class("playerInfo", base)

_RES_(playerInfo, "PlayerInfoUI", "PlayerInfoUI")

function playerInfo:ctor(data, desk)
    self.data = data
    self.super.ctor(self)
    self.isDesk = desk
end

function playerInfo:onInit()
    self.mIcon:setTexture(self.data.headerTex)
    self.mSex:setSprite((gamepref.player.sex == sexType.boy) and "boy" or "girl")
    self.mNickname:setText(self.data.nickname)
    self.mIp:hide()

    self.mId:setText(string.format("账号:%d", self.data.acId))

    if not string.isNilOrEmpty(self.data.ip) then
        self.mIp:show()
        self.mIp:setText(string.format("IP:%s", self.data.ip))
    end

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTransfer:addClickListener(self.onTransferClickedHandler, self)

    self.mTransfer:hide()
    if gamepref.player.userType == userType.transfer or gamepref.player.userType == userType.operation then
        self.mTransfer:show()
    end
    if self.isDesk then
        self.isDesk = true
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playerInfo:onTransferClickedHandler()
    local ui = require("ui.transfer").new()
    ui:show()
    playButtonClickSound()
end

function playerInfo:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function playerInfo:onCloseAllUIHandler()
    self:close()
end

function playerInfo:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return playerInfo

--endregion
