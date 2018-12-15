--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenColor = class("tweenColor")

function tweenColor.fadeIn(target, duration)
    local from = Color.New(1,1,1,0)
    local to = Color.New(1,1,1,1)
    local tween = tweenColor.new(target, duration, from, to, nil)
    return tween
end
function tweenColor.fadeOut(target, duration)
    local from = Color.New(1,1,1,1)
    local to = Color.New(1,1,1,0)
    local tween = tweenColor.new(target, duration, from, to, nil)
    return tween
end
-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenColor:ctor(target, duration, from, to, callback)
    self.speed      = 1
    self.target     = target
    self.duration   = math.max(0.01, duration)
    self.from       = from
    self.to         = to
    self.callback   = callback
    self.playing    = false
    self.finished   = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenColor:play()
    self.playing   = true
    self.finished  = false
    self.timestamp = time.realtimeSinceStartup()
    self.target:setColor(self.from)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenColor:update()
    if self.playing and not self.finished then
        local deltaTime = (time.realtimeSinceStartup() - self.timestamp) * self.speed

        if deltaTime >= self.duration then
            self.target:setColor(self.to)
            self.playing = false
            self.finished = true
        else
            local t = deltaTime / self.duration
            self.target:setColor(Color.Lerp(self.from, self.to, t))
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenColor:stop()
    self.playing  = false
    self.finished = true
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenColor:setSpeed(speed)
    self.speed = math.min(100, math.max(0.01, speed))
end

return tweenColor

--endregion

