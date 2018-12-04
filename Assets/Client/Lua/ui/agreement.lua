--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local agreement = class("agreement", base)

_RES_(agreement, "UserAgreementUI", "UserAgreementUI")

function agreement:onInit()
    self.mConfirm:addClickListener(self.onCloseClickedHandler, self)
end

function agreement:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

return agreement

--endregion
