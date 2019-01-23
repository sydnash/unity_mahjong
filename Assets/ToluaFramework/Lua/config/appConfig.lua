--region *.lua
--Date

local appConfig = {
    debug               = false,
    patchEnabled        = true,--∆Ù”√»»∏¸
    loadCountPreFrame   = 3,
}

if appConfig.debug then
    appConfig.patchEnabled = false
end

return appConfig

--endregion