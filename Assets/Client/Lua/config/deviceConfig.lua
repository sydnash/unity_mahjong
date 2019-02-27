--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local Application       = UnityEngine.Application
local RuntimePlatform   = UnityEngine.RuntimePlatform

local function isAndroid()
    return Application.platform == RuntimePlatform.Android
end

local function isApple()
    return Application.platform == RuntimePlatform.IPhonePlayer
end

local function isMacOSX()
    return Application.platform == RuntimePlatform.OSXEditor
end

return {
    isAndroid = isAndroid(),
    isApple   = isApple(),
    isMobile  = isAndroid() or isApple(),
    isMacOSX  = isMacOSX(),
    deviceId  = "xieheng002",
}

--endregion
