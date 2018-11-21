--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenFunction = class("tweenFunction")

function tweenFunction:ctor(func, args)
    self.func = func
    self.args = args
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenFunction:play()
    self.playing = true

    if self.func ~= nil then
        self.func(self.args)
    end

    self.finished = true
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenFunction:update()
    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenFunction:stop()

end

return tweenFunction

--endregion
