--region *.lua
--Date

local appConfig = {
    debug               = false,
    patchEnabled        = true,--�����ȸ�
    loadCountPreFrame   = 3,
}

if appConfig.debug then
    appConfig.patchEnabled = false
end

return appConfig

--endregion