--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wechatHelper = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function wechatHelper.login(callback)
    WechatHelper.instance:Login(callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function wechatHelper.shareText(text, pyq)
    WechatHelper.instance:ShareText(text, pyq)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function wechatHelper.shareUrl(title, desc, url, pyq)
    WechatHelper.instance:ShareUrl(title, desc, url, pyq)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function wechatHelper.shareImage(imgname, pyq)
    local imgpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "ShareImages", imgname)
    WechatHelper.instance:ShareImage(imgpath, pyq)
end

return wechatHelper

--endregion
