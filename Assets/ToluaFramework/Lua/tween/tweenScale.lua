--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenScale = class("tweenScale")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenScale:ctor(target, duration, from, to, callback)
    self.speed      = 1
    self.target     = target
    self.duration   = math.max(0.01, duration)
    self.from       = (from == nil) and target.transform.localScale or from
    self.to         = (to   == nil) and target.transform.localScale or to
    self.callback   = callback
    self.playing    = false
    self.finished   = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenScale:play()
    self.playing   = true
    self.finished  = false
    self.timestamp = time.realtimeSinceStartup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenScale:update()
    if self.playing and not self.finished then
        local deltaTime = (time.realtimeSinceStartup() - self.timestamp) * self.speed

        if deltaTime >= self.duration then
            self.target:setLocalScale(self.to)
            self.playing = false
            self.finished = true
        else
            local t = deltaTime / self.duration
            self.target:setLocalScale(Vector3.Lerp(self.from, self.to, t))
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenScale:stop()
    self.playing  = false
    self.finished = true
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenScale:setSpeed(speed)
    self.speed = math.min(100, math.max(0.01, speed))
end

return tweenScale

--endregion
