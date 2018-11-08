local iosHelper = {}

function iosHelper.registerLoginWxCallback(callback)
    IOSHelper.instance:RegisterLoginWXCallback(callback)
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function iosHelper.loginWx()
    IOSHelper.instance:LoginWX()
end

-------------------------------------------------------------------
-- 分享文字到微信
-------------------------------------------------------------------
function iosHelper.shareTextWx(text, pyq)
    IOSHelper.instance:ShareTextWX(text, pyq)
end

-------------------------------------------------------------------
-- 分享URL到微信
-------------------------------------------------------------------
function iosHelper.shareUrlWx(title, desc, url, thumb, pyq)
    IOSHelper.instance:ShareUrlWX(title, desc, url, thumb, pyq)
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function iosHelper.shareImageWx(image, thumb, pyq)
    IOSHelper.instance:ShareImageWX(image, thumb, pyq)
end


return iosHelper
