--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playHistory = class("playHistory", base)

_RES_(playHistory, "PlayHistory", "PlayHistory")

function playHistory:onInit()
    self:refreshUI()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function playHistory:onCloseClickedHandler()
    playButtonClickSound()

    self:close()
    signalManager.signal(signalType.mail)
end

function playHistory:refreshUI()
    local count = 0

    if count <= 0 then
        self.mEmpty:show()
    else
        self.mEmpty:hide()
    end
end

function playHistory:onCloseAllUIHandler()
    self:close()
end

function playHistory:onDestroy()
    self.mList:reset()
    self.super.onDestroy(self)
end

return playHistory

--endregion
