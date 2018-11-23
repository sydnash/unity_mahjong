--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local locationManager = {}
local input = UnityEngine.Input

function locationManager.checkEnabled()
    return input.location.isEnabledByUser 
end

function locationManager.start()
    input.location:Start()
end

function locationManager.stop()
    input.location:Stop()
end

function locationManager.getData()
    local location = { status = false, latitude = 0, longitude = 0 }
    
    if input.location.status == UnityEngine.LocationServiceStatus.Running then
        local data = input.location.lastData

        location.status     = true
        location.latitude   = data.latitude
        location.longitude  = data.longitude
    end

    return location
end

function locationManager.distance(a, b)
    return platformHelper.getDistance(a.latitude, a.longitude, b.latitude, b.longitude)
end

return locationManager

--endregion
