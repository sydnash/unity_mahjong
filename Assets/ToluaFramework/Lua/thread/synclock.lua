--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local synclock = class("synclock")

function synclock:ctor()
    self.sync = SyncObject.New()
end

function synclock:lock()
    self.sync:Lock()
end

function synclock:unlock()
    self.sync:Unlock()
end

function synclock:destroy()
    self.sync:Destroy()
end

return synclock

--endregion
