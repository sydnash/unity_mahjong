--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local network  = require("network.network")
local gamepref = require("logic.gamepref")
local networkManager = class("networkManager")

function networkManager.login(callback)
    local form = table.toUrlArgs({ mac = getDeviceId() })
    network.requestText(appConfig.guestURL, form, function(ok, text)
        log(text)
        if not ok or string.isNilOrEmpty(text) then
            log("login failed: 1")
            callback(false)
        else
            local o = table.fromjson(text)

            local host = o.ip
            local port = o.port
            local acid = o.acid
            local session = o.session

            gamepref.acId = acid
            gamepref.session = session

            network.connect(host, port, function(connected)
                if not connected then
                    log("login failed: 2")
                    callback(false)
                else
                    log("login: 1")
                    local loginType = 1
                    local data = { AcId = acid, Session = session, LoginType = loginType }
                    network.send("CmdType.fly.CS.LoginHs", data, function(ok)
                        if not ok then
                            log("login failed: 3")
                        else
                            log("login: 2")
                        end
                    end)
                end
            end)
        end
    end)
end

return networkManager

--endregion
