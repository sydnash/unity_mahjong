--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local header = class("header", base)

function header:onInit()
    self:reset()
end

function header:setPlayer(player)
    self:reset()

    self.signalId = signalType.headerDownloaded .. tostring(player.acId)
    signalManager.registerSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)

    self.mIcon:setTexture(player.headerTex)
end

function header:setColor(color)
    self.mIcon:setColor(color)
end

function header:onHeaderDownloadedHandler(tex)
    self.mIcon:setTexture(tex)
end

function header:reset()
    if not string.isNilOrEmpty(self.signalId) then
        signalManager.unregisterSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)
    end

    local tex = self.mIcon:getTexture()
    if tex ~= nil then
        self.mIcon:setTexture(nil)
    end
end

function header:onDestroy()
    self:reset()
    self.super.onDestroy(self)
end

return header

--endregion
