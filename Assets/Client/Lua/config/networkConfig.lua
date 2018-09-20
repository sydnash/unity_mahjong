--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchURL = "file:///D:/xx"
local gameURL = "http://test.cdbshy.com:17776/"
--local gameURL = "http://192.168.0.80:17776/"

return {
    patchURL    = patchURL,
    gameURL     = gameURL,
    guestURL    = gameURL .. "anonymouslogin",
    httpTimeout = 10, --秒
    tcpTimeout  = 10, --秒
    ping        = 10,  --秒
    pong        = 15,  --秒
    encrypt     = true,
}

--endregion
