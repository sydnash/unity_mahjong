--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local platformHelper = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.registerLoginWxCallback(callback)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:RegisterLoginWXCallback(callback)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.registerInviteSgCallback(callback)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:RegisterInviteSGCallback(callback)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.showErrorMessage(errorMessage)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShowErrorMessage(errorMessage)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.setLogined(logined)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:SetLogined(logined)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function platformHelper.loginWx()
    if deviceConfig.isAndroid then
        AndroidHelper.instance:LoginWX()
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享文字到微信
-------------------------------------------------------------------
function platformHelper.shareTextWx(text, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextWX(text, pyq)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享URL到微信
-------------------------------------------------------------------
function platformHelper.shareUrlWx(title, desc, url, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function platformHelper.shareImageWx(image, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageWX(image, thumb, pyq)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享文字到闲聊
-------------------------------------------------------------------
function platformHelper.shareTextSg(text)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextSG(text)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享应用邀请到闲聊
-------------------------------------------------------------------
function platformHelper.shareInvitationSg(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    if string.isNilOrEmpty(androidDownloadUrl) then
        androidDownloadUrl = "http://www.cdbshy.com/"
    end

    if string.isNilOrEmpty(iOSDownloadUrl) then
        iOSDownloadUrl = "http://www.cdbshy.com/"
    end

    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareInvitationSG(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 分享图片到闲聊
-------------------------------------------------------------------
function platformHelper.shareImageSg(image)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageSG(image)
    elseif deviceConfig.isApple then

    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getParamsSg()
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetParamsSG()
    elseif deviceConfig.isApple then

    end
end

return platformHelper

--endregion
