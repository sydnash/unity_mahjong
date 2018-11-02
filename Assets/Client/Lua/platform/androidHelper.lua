--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local androidHelper = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.showErrorMessage(errorMessage)
    AndroidHelper.instance:ShowErrorMessage(errorMessage)
end

-------------------------------------------------------------------
-- 微信登录
-------------------------------------------------------------------
function androidHelper.loginWx(callback)
    AndroidHelper.instance:LoginWX(callback)
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
function androidHelper.shareUrlWx(title, desc, url, pyq)
    AndroidHelper.instance:ShareUrlWX(title, desc, url, pyq)
end

-------------------------------------------------------------------
-- 分享图片到微信
-------------------------------------------------------------------
function androidHelper.shareImageWx(imgname, pyq)
    local imgpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "shimgs", imgname)
    AndroidHelper.instance:ShareImageWX(imgpath, pyq)
end

-------------------------------------------------------------------
-- 分享文字到闲聊
-------------------------------------------------------------------
function androidHelper.shareTextSg(text)
    AndroidHelper.instance:ShareTextSG(text)
end

-------------------------------------------------------------------
-- 分享图片到闲聊
-------------------------------------------------------------------
function androidHelper.shareImageSg(imgname)
    local imgpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "shimgs", imgname)
    AndroidHelper.instance:ShareImageSG(imgpath)
end

return androidHelper

--endregion
