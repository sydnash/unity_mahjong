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
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:RegisterLoginWXCallback(callback)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.registerShareWXCallback(callback)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:RegisterShareWXCallback(callback)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:RegisterShareWXCallback(callback)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.registerInviteSgCallback(callback)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:RegisterInviteSGCallback(callback)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:RegisterInviteSGCallback(callback)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.showErrorMessage(errorMessage)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShowErrorMessage(errorMessage)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then

    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.setLogined(logined)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:SetLogined(logined)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:SetLogined(logined)
    end
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function platformHelper.loginWx()
    if deviceConfig.isAndroid then
        AndroidHelper.instance:LoginWX()
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:LoginWX()
    end
end

-------------------------------------------------------------------
-- 分享文字到微信
-------------------------------------------------------------------
function platformHelper.shareTextWx(text, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextWX(text, pyq)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareTextWX(text, pyq)
    end
end

-------------------------------------------------------------------
-- 分享URL到微信
-------------------------------------------------------------------
function platformHelper.shareUrlWx(title, desc, url, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
    end
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function platformHelper.shareImageWx(image, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageWX(image, thumb, pyq)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareImageWX(image, thumb, pyq)
    end
end

-------------------------------------------------------------------
-- 分享文字到闲聊
-------------------------------------------------------------------
function platformHelper.shareTextSg(text)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextSG(text)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareTextSG(text)
    end
end

-------------------------------------------------------------------
-- 分享应用邀请到闲聊
-------------------------------------------------------------------
function platformHelper.shareInvitationSg(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    if string.isNilOrEmpty(androidDownloadUrl) then
        androidDownloadUrl = networkConfig.server.shareURL
    end

    if string.isNilOrEmpty(iOSDownloadUrl) then
        iOSDownloadUrl = networkConfig.server.shareURL
    end

    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareInvitationSG(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareInvitationSG(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    end
end

-------------------------------------------------------------------
-- 分享图片到闲聊
-------------------------------------------------------------------
function platformHelper.shareImageSg(image)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageSG(image)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareImageSG(image)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getParamsSg()
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetParamsSG()
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        return IOSHelper.instance:GetParamsSG()
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.clearSGInviteParam()
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ClearSGInviteParam()
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ClearSGInviteParam()
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.changeWindowTitle(new)
    WINHelper.instance:ChangeWindowTitle(new)
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getDistance(latitude1, longitude1, latitude2, longitude2)
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetDistance(latitude1, longitude1, latitude2, longitude2)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        return IOSHelper.instance:GetDistance(latitude1, longitude1, latitude2, longitude2)
    end

    return 0
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getDeviceId()
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetDeviceId()
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        return IOSHelper.instance:GetDeviceId()
    end

    return string.empty
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.openExplorer(url)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:OpenExplore(url)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:OpenExplore(url)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.setToClipboard(text)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:SetToClipboard(text)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:SetToClipboard(text)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getFromClipboard()
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetFromClipboard()
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        return IOSHelper.instance:GetFromClipboard()
    end

    return string.empty
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.shareUrlCn(title, desc, url, thumb)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareUrlCN(title, desc, url, thumb)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareUrlCN(title, desc, url, thumb)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.shareImageCn(imageFile)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageCN("幺九麻将", imageFile)
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:ShareImageCN(imageFile)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.openWechat()
    if queryFromCSV("chuiniusdk") == nil then
        return
    end

    if deviceConfig.isAndroid then
        AndroidHelper.instance:OpenThirdApp("com.tencent.mm")
    elseif deviceConfig.isApple and not deviceConfig.isMacOSX then
        IOSHelper.instance:OpenThirdApp("weixin://", "")
    end
end

return platformHelper

--endregion
