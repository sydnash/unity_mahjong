--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchURL = "http://127.0.0.1:8000/patches/"
local gameURL  = "http://login.cdbshy.com:17776/"
local gameURL  = "http://test.cdbshy.com:17776/"
--local gameURL  = "http://192.168.0.80:17776/"

return {
    patchURL        = patchURL,
    patchTimeout    = 30,  --秒
    gameURL         = gameURL .. (deviceConfig.isMobile and "wechatlogin" or "anonymouslogin"),
    httpTimeout     = 10,  --秒
    tcpTimeout      = 10,  --秒
    ping            = 10,  --秒
    pong            = 15,  --秒
    encrypt         = true,--对网络数据进行加解密
    gvoiceTimeout   = 10,  --秒
}

--endregion
