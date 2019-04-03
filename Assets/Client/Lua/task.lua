--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local task = class("task")

function task:ctor()
    self.T = LuaTask.New()
end

function task:dofile(file)
    if self.T ~= nil then
        return self.T:DoFile(file)
    end

    return false
end

function task:call(method, args, callback)
    if self.T ~= nil then
        self.T:Call(method, args, callback)
    end
end

function task:destroy()
    if self.T ~= nil then
        self.T:Destroy()
        self.T = nil
    end
end

return task

--endregion
