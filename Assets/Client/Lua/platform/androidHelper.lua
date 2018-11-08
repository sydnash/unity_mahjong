--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local androidHelper = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.registerLoginWxCallback(callback)
    AndroidHelper.instance:RegisterLoginWXCallback(callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.registerInviteSgCallback(callback)
    AndroidHelper.instance:RegisterInviteSGCallback(callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.showErrorMessage(errorMessage)
    AndroidHelper.instance:ShowErrorMessage(errorMessage)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.setLogined(logined)
    AndroidHelper.instance:SetLogined(logined)
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function androidHelper.loginWx()
    AndroidHelper.instance:LoginWX()
end

-------------------------------------------------------------------
-- 分享文字到微信
-------------------------------------------------------------------
function androidHelper.shareTextWx(text, pyq)
    AndroidHelper.instance:ShareTextWX(text, pyq)
end

-------------------------------------------------------------------
-- 分享URL到微信
-------------------------------------------------------------------
function androidHelper.shareUrlWx(title, desc, url, thumb, pyq)
    AndroidHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function androidHelper.shareImageWx(image, thumb, pyq)
    AndroidHelper.instance:ShareImageWX(image, thumb, pyq)
end

-------------------------------------------------------------------
-- 分享文字到闲聊
-------------------------------------------------------------------
function androidHelper.shareTextSg(text)
    AndroidHelper.instance:ShareTextSG(text)
end

-------------------------------------------------------------------
-- 分享应用邀请到闲聊
-------------------------------------------------------------------
function androidHelper.shareInvitationSg(title, description, imgname, params, androidDownloadUrl, iOSDownloadUrl)
    local launcherPath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "shimgs", imgname)

    if androidDownloadUrl == nil or string.isNilOrEmpty(androidDownloadUrl) then
        androidDownloadUrl = ""
    end

    if iOSDownloadUrl == nil or string.isNilOrEmpty(iOSDownloadUrl) then
        iOSDownloadUrl = ""
    end

    AndroidHelper.instance:ShareInvitationSG(title, description, launcherPath, params, androidDownloadUrl, iOSDownloadUrl)
end

-------------------------------------------------------------------
-- 分享图片到闲聊
-------------------------------------------------------------------
function androidHelper.shareImageSg(imgname)
    local imgpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "shimgs", imgname)
    AndroidHelper.instance:ShareImageSG(imgpath)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function androidHelper.getParamsSg()
    return AndroidHelper.instance:GetParamsSG()
end

return androidHelper

--endregion
