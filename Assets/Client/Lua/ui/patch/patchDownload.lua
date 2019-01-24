--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchViewManager = require("ui.patch.patchViewManager")
local patchDownload = class("patchDownload")

function patchDownload:ctor()
    local gameObject = patchViewManager.load("PatchDownloadUI")
    self.gameObject = gameObject
    self.transform  = gameObject.transform
    self.transform:SetParent(patchViewManager.root.transform, false)

    local textTr = self.transform:Find("Text")
    if textTr ~= nil then
        local go = textTr.gameObject
        self.mText = go:GetComponent(typeof(UnityEngine.UI.Text))
    end

    local progressTr = self.transform:Find("ProgressBar/Foreground")
    if progressTr ~= nil then
        local go = progressTr.gameObject
        self.mProgress = go:GetComponent(typeof(UnityEngine.UI.Image))
    end

    local versionTr = self.transform:Find("Ver")
    if versionTr ~= nil then
        local go = versionTr.gameObject
        local verText = go:GetComponent(typeof(UnityEngine.UI.Text))

        verText.text = string.format("V%s", G_Current_Version)
    end
end

function patchDownload:show()
    self.gameObject:SetActive(true)
end

function patchDownload:setProgress(progress)
    self.mProgress.fillAmount = progress
end

function patchDownload:setText(text)
    self.mText.text = text
end

function patchDownload:close()
    patchViewManager.unload(self)
    self.gameObject = nil
    self.transform  = nil
end

return patchDownload

--endregion
