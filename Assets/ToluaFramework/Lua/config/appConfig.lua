--region *.lua
--Date

local appConfig = {
    debug               = false,
    patchEnabled        = true,
    logEnabled          = true,
    loadCountPreFrame   = 3,
}

if appConfig.debug then
    appConfig.patchEnabled = false
    appConfig.logEnabled   = true
end

return appConfig

--endregion