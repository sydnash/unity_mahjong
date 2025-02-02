--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local loading = class("loading", base)

_RES_(loading, "LoadingUI", "LoadingUI")

function loading:onInit()
    self:setProgress(0)
    self:setText(string.empty)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function loading:setProgress(value)
    self.mProgress:setFillAmount(value)
end

function loading:setText(text)
    self.mText:setText(text)
end

function loading:onCloseAllUIHandler()
    self:close()
end

function loading:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self:setProgress(0)
    self:setText(string.empty)

    base.onDestroy(self)
end

return loading

--endregion
