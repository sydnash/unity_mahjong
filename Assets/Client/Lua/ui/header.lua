--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local header = class("header", base)

function header:onInit()
    --self:reset()
end

function header:setTexture(id, tex)
    self:reset()

    self.signalId = signalType.headerDownloaded .. tostring(id)
    signalManager.registerSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)

    self.mIcon:setTexture(tex)
end

function header:getTexture()
    return self.mIcon:getTexture()
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

    self.mIcon:setTexture(nil)
end

function header:onDestroy()
    self:reset()
    self.super.onDestroy(self)
end

return header

--endregion
