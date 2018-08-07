--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenRotation = class("tweenRotation")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenRotation:ctor(target, duration, from, to, callback)
    from = (from == nil) and target.transform.localRotation or from
    to   = (to   == nil) and target.transform.localRotation or to

    self.target     = target
    self.duration   = math.max(0.01, duration)
    self.from       = Quaternion.Euler(from.x, from.y, from.z)
    self.to         = Quaternion.Euler(to.x, to.y, to.z)
    self.callback   = callback
    self.playing    = false
    self.finished   = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenRotation:play()
    self.playing   = true
    self.finished  = false
    self.timestamp = time.realtimeSinceStartup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenRotation:update()
    if self.playing and not self.finished then
        local deltaTime = time.realtimeSinceStartup() - self.timestamp

        if deltaTime >= self.duration then
            self.target:setLocalRotation(self.to)
            self.playing  = false
            self.finished = true
        else
            local t = deltaTime / self.duration
            self.target:setLocalRotation(Quaternion.Slerp(self.from, self.to, t))
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenPosition:stop()
    self.playing  = false
    self.finished = true
end

return tweenRotation

--endregion
