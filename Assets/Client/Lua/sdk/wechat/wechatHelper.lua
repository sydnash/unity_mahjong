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

return wechatHelper

--endregion
