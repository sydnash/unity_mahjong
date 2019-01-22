--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchViewManager = require("ui.patch.patchViewManager")
local patchWaiting = class("patchWaiting")

function patchWaiting:ctor(text)
    local gameObject = patchViewManager.load("PatchWaitingUI")
    self.gameObject = gameObject
    self.transform  = gameObject.transform
    self.transform:SetParent(patchViewManager.root.transform, false)

    local textTr = self.transform:Find("Text")
    if textTr ~= nil then
        local go = textTr.gameObject
        self.mText = go:GetComponent(typeof(UnityEngine.UI.Text))
    end

    local circle = self.transform:Find("Circle")
    local timestamp = Time.realtimeSinceStartup

    self.updateHandler = UpdateBeat:CreateListener(function()
        circle.localRotation = Quaternion.Euler(0, 0, (Time.realtimeSinceStartup - timestamp) * -30)
    end)
    UpdateBeat:AddListener(self.updateHandler)

    self.mText.text = (text == nil or text == "") and "请稍候" or text
end

function patchWaiting:show()
    self.gameObject:SetActive(true)
end

function patchWaiting:close()
    UpdateBeat:RemoveListener(self.updateHandler, true)
    self.updateHandler = nil

    patchViewManager.unload(self)

    self.gameObject = nil
    self.transform  = nil
end

return patchWaiting

--endregion
