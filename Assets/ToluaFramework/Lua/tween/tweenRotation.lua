--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenRotation = class("tweenRotation")

local Quaternion = UnityEngine.Quaternion

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenRotation:ctor(target, duration, from, to, callback)
    self.speed      = 1

    from = (from == nil) and target.transform.localRotation or from
    to   = (to   == nil) and target.transform.localRotation or to

    self.target     = target
    self.duration   = math.max(0.01, duration)
    self.from       = from--Quaternion.Euler(from.x, from.y, from.z)
    self.to         = to  --Quaternion.Euler(to.x, to.y, to.z)
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
        local deltaTime = (time.realtimeSinceStartup() - self.timestamp) * self.speed

        if deltaTime >= self.duration then
            self.target:setLocalRotation(self.to)
            self.playing  = false
            self.finished = true
        else
            local t = deltaTime / self.duration
            --Quaternion.Slerp(self.from, self.to, t)

            -- 用四元数有点问题，暂时用下面的方式替代
            local x = Mathf.Lerp(self.from.x, self.to.x, t)
            local y = Mathf.Lerp(self.from.y, self.to.y, t)
            local z = Mathf.Lerp(self.from.z, self.to.z, t)
            
            self.target:setLocalRotation(Quaternion.Euler(x, y, z))
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenRotation:stop()
    self.playing  = false
    self.finished = true
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenRotation:setSpeed(speed)
    self.speed = math.min(100, math.max(0.01, speed))
end

return tweenRotation

--endregion
