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
        IOSHelper.instance:RegisterLoginWXCallback(callback)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function platformHelper.registerInviteSgCallback(callback)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:RegisterInviteSGCallback(callback)
    elseif deviceConfig.isApple then
        IOSHelper.instance:RegisterInviteSGCallback(callback)
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
        IOSHelper.instance:SetLogined(logined)
    end
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function platformHelper.loginWx()
    if deviceConfig.isAndroid then
        AndroidHelper.instance:LoginWX()
    elseif deviceConfig.isApple then
        IOSHelper.instance:LoginWX()
    end
end

-------------------------------------------------------------------
-- 分享文字到微信
-------------------------------------------------------------------
function platformHelper.shareTextWx(text, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextWX(text, pyq)
    elseif deviceConfig.isApple then
        IOSHelper.instance:ShareTextWX(text, pyq)
    end
end

-------------------------------------------------------------------
-- 分享URL到微信
-------------------------------------------------------------------
function platformHelper.shareUrlWx(title, desc, url, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
    elseif deviceConfig.isApple then
        IOSHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
    end
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function platformHelper.shareImageWx(image, thumb, pyq)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageWX(image, thumb, pyq)
    elseif deviceConfig.isApple then
        IOSHelper.instance:ShareImageWX(image, thumb, pyq)
    end
end

-------------------------------------------------------------------
-- 分享文字到闲聊
-------------------------------------------------------------------
function platformHelper.shareTextSg(text)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareTextSG(text)
    elseif deviceConfig.isApple then
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
    elseif deviceConfig.isApple then
        IOSHelper.instance:ShareInvitationSG(title, description, image, params, androidDownloadUrl, iOSDownloadUrl)
    end
end

-------------------------------------------------------------------
-- 分享图片到闲聊
-------------------------------------------------------------------
function platformHelper.shareImageSg(image)
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ShareImageSG(image)
    elseif deviceConfig.isApple then
        IOSHelper.instance:ShareImageSG(image)
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getParamsSg()
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetParamsSG()
    elseif deviceConfig.isApple then
        return IOSHelper.instance:GetParamsSG()
    end
end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.clearSGInviteParam()
    if deviceConfig.isAndroid then
        AndroidHelper.instance:ClearSGInviteParam()
    elseif deviceConfig.isApple then
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
--function platformHelper.startLocation()
--    if deviceConfig.isAndroid then
--        AndroidHelper.instance:StartLocation()
--    elseif deviceConfig.isApple then

--    end
--end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
--function platformHelper.stopLocation()
--    if deviceConfig.isAndroid then
--        AndroidHelper.instance:StopLocation()
--    elseif deviceConfig.isApple then

--    end
--end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
--function platformHelper.getLocation()
--    if deviceConfig.isAndroid then
--        local status = AndroidHelper.instance:GetLocationStatus()
--        local latitude = AndroidHelper.instance:GetLocationLatitude()
--        local longitude = AndroidHelper.instance:GetLocationLongitude()

--        return { status = status, latitude = latitude, longitude = longitude }
--    elseif deviceConfig.isApple then

--    end

--    return { status = false, latitude = 0, longitude = 0 }
--end

-------------------------------------------------------------------
-- 
-------------------------------------------------------------------
function platformHelper.getDistance(latitude1, longitude1, latitude2, longitude2)
    if deviceConfig.isAndroid then
        return AndroidHelper.instance:GetDistance(latitude1, longitude1, latitude2, longitude2)
    elseif deviceConfig.isApple then
        return IOSHelper.instance:GetDistance(latitude1, longitude1, latitude2, longitude2)
    end

    return 0
end

return platformHelper

--endregion
