--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local messageBox = class("messageBox", base)

messageBox.folder = "MessageBoxUI"
messageBox.resource = "MessageBoxUI"

function messageBox:ctor(text, confirmCallback, cancelCallback)
    self.text = text
    self.confirmCallback = confirmCallback
    self.cancelCallback = cancelCallback

    self.super.ctor(self)
end

function messageBox:onInit()
    self.mText:setText(self.text)
    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)

    if self.confirmCallback == nil or self.cancelCallback == nil then
        self.mConfirm:setLocalPosition(Vector3.New(0, -90, 0))
        self.mCancel:hide()
    else
        self.mConfirm:setLocalPosition(Vector3.New(-145, -90, 0))
        self.mCancel:show()
    end
end

function messageBox:onConfirmClickedHandler()
    if self.confirmCallback ~= nil then
        self.confirmCallback()
    end

    self:close()
end

function messageBox:onCancelClickedHandler()
    if self.cancelCallback ~= nil then
        self.cancelCallback()
    end

    self:close()
end

return messageBox

--endregion
