--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local thread = class("thread")

function thread:ctor(func)
    self.t = Threading.New(func)
end

function thread:start(args)
    self.t:Start(args)
end

function thread:stop()
    self.t:Stop()
end

return thread

--endregion
