--region *.lua
--Date

local appConfig = {
    debug               = true,
    patchEnabled        = true,--∆Ù”√»»∏¸
    loadCountPreFrame   = 3,
}

if appConfig.debug then
    appConfig.patchEnabled = true
end

return appConfig

--endregion