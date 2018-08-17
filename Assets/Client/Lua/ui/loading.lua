--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local loading = class("loading", base)

loading.folder = "LoadingUI"
loading.resource = "LoadingUI"

function loading:onInit()

end

function loading:setProgress(value)
    self.mProgress:setFillAmount(value)
    
    local x = self.mProgress:getWidth() * value
    self.mDot:setAnchoredPosition(Vector3.New(x, 0, 0))
end

return loading

--endregion
