--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenPosition = class("tweenPosition")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenPosition:ctor(target, duration, from, to, callback)
    self.speed      = 1
    self.target     = target
    self.duration   = math.max(0.01, duration)
    self.from       = (from == nil) and target.transform.localPosition or from
    self.to         = (to   == nil) and target.transform.localPosition or to
    self.callback   = callback
    self.playing    = false
    self.finished   = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenPosition:play()
    self.playing   = true
    self.finished  = false
    self.timestamp = time.realtimeSinceStartup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenPosition:update()
    if self.playing and not self.finished then
        local deltaTime = (time.realtimeSinceStartup() - self.timestamp) * self.speed

        if deltaTime >= self.duration then
            self.target:setLocalPosition(self.to)
            self.playing = false
            self.finished = true
        else
            local t = deltaTime / self.duration
            self.target:setLocalPosition(Vector3.Lerp(self.from, self.to, t))
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

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenPosition:setSpeed(speed)
    self.speed = math.min(100, math.max(0.01, speed))
end

return tweenPosition

--endregion
