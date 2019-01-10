--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local headerManager = require("logic.manager.headerManager")

local base = require("ui.common.panel")
local header = class("header", base)

function header:onInit()
    
end

function header:setTexture(url)
    --clear pre signal handler.
    self:reset()

    self.signalId = headerManager.token(url)
    signalManager.registerSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)

    headerManager.request(self.signalId, url)
end

function header:setColor(color)
    self.mIcon:setColor(color)
end

function header:onHeaderDownloadedHandler(tex)
    self.mIcon:setTexture(tex)
end

function header:reset()
    self.mIcon:setTexture(nil)

    if not string.isNilOrEmpty(self.signalId) then
        headerManager.drop(self.signalId)
        signalManager.unregisterSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)
        self.signalId = nil
    end
end

function header:onDestroy()
    self:reset()
    base.onDestroy(self)
end

return header

--endregion
