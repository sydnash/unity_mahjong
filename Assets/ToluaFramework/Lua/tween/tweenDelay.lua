--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenDelay = class("tweenDelay")

function tweenDelay:ctor(duration)
    self.duration = math.max(0.01, duration)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenDelay:play()
    self.playing   = true
    self.finished  = false
    self.timestamp = time.realtimeSinceStartup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenDelay:update()
    if self.playing and not self.finished then
        local deltaTime = time.realtimeSinceStartup() - self.timestamp

        if deltaTime >= self.duration then
            self.playing = false
            self.finished = true
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenDelay:stop()
    self.playing  = false
    self.finished = true
end

return tweenDelay

--endregion
