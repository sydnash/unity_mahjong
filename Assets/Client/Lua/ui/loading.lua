--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local loading = class("loading", base)

_RES_(loading, "LoadingUI", "LoadingUI")

function loading:onInit()
    self:setProgress(0)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function loading:setProgress(value)
    self.mProgress:setFillAmount(value)
    
    local x = self.mProgress:getWidth() * value
    self.mDot:setAnchoredPosition(Vector3.New(x, 0, 0))
end

function loading:onCloseAllUIHandler()
    self:close()
end

function loading:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return loading

--endregion
