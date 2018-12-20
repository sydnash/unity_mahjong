--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local headerManager = require("logic.manager.headerManager")

local base = require("ui.common.panel")
local header = class("header", base)

function header:onInit()
    
end

function header:setTexture(url)
    local token, tex = headerManager.request(url)
    self.mIcon:setTexture(tex)

    self.signalId = token
    signalManager.registerSignalHandler(self.signalId, self.onHeaderDownloadedHandler, self)
end

function header:setColor(color)
    self.mIcon:setColor(color)
end

function header:onHeaderDownloadedHandler(tex)
    self.mIcon:setTexture(tex)
end

function header:reset()
    local tex = self.mIcon:getTexture()
    if tex ~= nil then
        self.mIcon:setTexture(nil)
        headerManager.drop(self.signalId, tex)
    end

    if not string.isNilOrEmpty(self.signalId) then
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
