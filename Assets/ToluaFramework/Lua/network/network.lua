--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamepref = require("logic.gamepref")

local callbackPool = class("callbackPool")

function callbackPool:ctor()
    self.token = 1
    self.pool = {}
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function callbackPool:generateToken()
    self.token = self.token + 1
    return self.token
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function callbackPool:push(callback)
    local token = self:generateToken()
    self.pool[token] = callback

    return token
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function callbackPool:pop(token)
    local callback = self.pool[token]
    self.pool[token] = nil

    return callback
end








local network = class("network")
local callbacks = callbackPool.new()

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function network.requestText(url, form, callback)
    NetworkManager.instance:RequestText(url, form, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function network.connect(host, port, callback)
    NetworkManager.instance:Connect(host, port, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function network.send(command, data, callback)
    local token = callbacks:push(callback)
    local payload = data --and table.tojson(data) or string.empty

    local msg = { Command   = command or string.empty, 
                  RequestId = token, 
                  AcId      = gamepref.acId, 
                  Session   = gamepref.session, 
                  Payload   = payload,
    }
    
    local json = table.tojson(msg)
    NetworkManager.instance:Send(json)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function network.dispatch(msg)
    local callback = callbacks:pop(msg.RequestId)
    if callback ~= nil then

    end
end

return network

--endregion
