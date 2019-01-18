--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local messageBox = class("messageBox", base)

_RES_(messageBox, "MessageBoxUI", "MessageBoxUI")

function messageBox:ctor(text, confirmCallback, cancelCallback)
    self.text = text
    self.confirmCallback = confirmCallback
    self.cancelCallback = cancelCallback

    base.ctor(self)
    self:setLevel(base.level.normal)
end

function messageBox:onInit()
    self.mText:setText(self.text)
    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)

    if self.confirmCallback == nil or self.cancelCallback == nil then
        self.mCancel:hide()
    else
        self.mCancel:show()
    end
end

function messageBox:onConfirmClickedHandler()
    playButtonClickSound()

    local keepAlive = false
    if self.confirmCallback ~= nil then
        keepAlive = self.confirmCallback()
    end

    if not keepAlive then
        self:close()
    end
end

function messageBox:onCancelClickedHandler()
    playButtonClickSound()

    local keepAlive = false
    if self.cancelCallback ~= nil then
        keepAlive = self.cancelCallback()
    end

    if not keepAlive then
        self:close()
    end
end

return messageBox

--endregion
