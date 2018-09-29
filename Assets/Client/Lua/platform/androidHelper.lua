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
--
-------------------------------------------------------------------
function androidHelper.loginWx(callback)
    AndroidHelper.instance:LoginWx(callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.shareTextWx(text, pyq)
    AndroidHelper.instance:ShareTextWx(text, pyq)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.shareUrlWx(title, desc, url, pyq)
    AndroidHelper.instance:ShareUrlWx(title, desc, url, pyq)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function androidHelper.shareImageWx(imgname, pyq)
    local imgpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "shimgs", imgname)
    AndroidHelper.instance:ShareImageWx(imgpath, pyq)
end

return androidHelper

--endregion
