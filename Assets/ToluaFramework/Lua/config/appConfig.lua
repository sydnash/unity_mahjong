--region *.lua
--Date

local appConfig = {
    debug               = true,
    patchEnabled        = true,
    loadCountPreFrame   = 3,
}

if appConfig.debug then
    appConfig.patchEnabled = false
end

return appConfig

--endregion