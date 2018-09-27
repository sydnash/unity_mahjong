--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local platform = UnityEngine.RuntimePlatform

local function ismobile()
    return (Application.platform == platform.Android) or (Application.platform == platform.IPhonePlayer)
end

return {
    ismobile = ismobile(),
    deviceId = "xieheng001",
}

--endregion
