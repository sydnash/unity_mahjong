--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchViewManager = require("ui.patch.patchViewManager")
local patchMessageBox = class("patchMessageBox")

function patchMessageBox:ctor(text, confirmCallback, cancelCallback)
    local gameObject = patchViewManager.load("PatchMessageBoxUI")
    self.gameObject = gameObject
    self.transform  = gameObject.transform
    self.transform:SetParent(patchViewManager.root.transform, false)

    self.text = text
    self.confirmCallback = confirmCallback
    self.cancelCallback = cancelCallback

    local textTr = self.transform:Find("Text")
    if textTr ~= nil then
        local go = textTr.gameObject
        self.mText = go:GetComponent(typeof(UnityEngine.UI.Text))
    end

    local confirmTr = self.transform:Find("Buttons/Confirm")
    if confirmTr ~= nil then
        local go = confirmTr.gameObject
        self.mConfirm = go:GetComponent(typeof(UnityEngine.UI.Button))
    end

    local cancelTr = self.transform:Find("Buttons/Cancel")
    if cancelTr ~= nil then
        local go = cancelTr.gameObject
        self.mCancel = go:GetComponent(typeof(UnityEngine.UI.Button))
    end

    self:onInit()
end

function patchMessageBox:onInit()
    self.mText.text = self.text
    self.mConfirm.onClick:AddListener(function() self.onConfirmClickedHandler(self) end)
    self.mCancel.onClick:AddListener(function() self.onCancelClickedHandler(self) end)

    if self.cancelCallback == nil then
        self.mCancel.gameObject:SetActive(false)
    else
        self.mCancel.gameObject:SetActive(true)
    end
end

function patchMessageBox:onConfirmClickedHandler()
    local keepAlive = false
    if self.confirmCallback ~= nil then
        keepAlive = self.confirmCallback()
    end

    if not keepAlive then
        self:close()
    end
end

function patchMessageBox:onCancelClickedHandler()
    local keepAlive = false
    if self.cancelCallback ~= nil then
        keepAlive = self.cancelCallback()
    end

    if not keepAlive then
        self:close()
    end
end

function patchMessageBox:show()
    self.gameObject:SetActive(true)
end

function patchMessageBox:close()
    patchViewManager.unload(self)

    self.mConfirm.onClick:RemoveAllListeners()
    self.mCancel.onClick:RemoveAllListeners()

    self.gameObject = nil
    self.transform  = nil
end

return patchMessageBox

--endregion
