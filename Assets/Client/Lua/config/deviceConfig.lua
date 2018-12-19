--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local platform = UnityEngine.RuntimePlatform

local function isAndroid()
    return Application.platform == platform.Android
end

local function isApple()
    return Application.platform == platform.IPhonePlayer
end

return {
    isAndroid = isAndroid(),
    isApple   = isApple(),
    isMobile  = isAndroid() or isApple(),
    deviceId  = "sy1",
}

--endregion
