--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local shop = class("shop", base)

_RES_(shop, "ShopUI", "ShopUI")

local COPY_TO_CLIPBOARD_STRING = "天地川牌"

function shop:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCopy:addClickListener(self.onCopyClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function shop:onCopyClickedHandler()
    platformHelper.setToClipboard(COPY_TO_CLIPBOARD_STRING)
    playButtonClickSound()
end

function shop:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function shop:onCloseAllUIHandler()
    self:close()
end

function shop:onDestroy()
    base.onDestroy(self)
end

return shop

--endregion
