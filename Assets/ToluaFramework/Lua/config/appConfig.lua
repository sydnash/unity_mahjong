--region *.lua
--Date

local appConfig = {
    debug               = true,
    patchEnabled        = true,
    logEnabled          = false,
}

if appConfig.debug then
    appConfig.patchEnabled = false
    appConfig.logEnabled   = true
end

return appConfig

--endregion