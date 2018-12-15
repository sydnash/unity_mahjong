--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenForever = class("tweenForever")

function tweenForever:ctor(actions)
    self.queue = actions
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenForever:play()
    self.playing   = true
    self.finished  = false
    self.curIndex  = 1
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenForever:update()
    if self.playing and not self.finished then
        if #self.queue == 0 then
            return
        end
        if self.curIndex > #self.queue then
            self.curIndex = 1
        end
        local t = self.queue[self.curIndex]
        if not t then
            return
        end
        if not t.playing then
            t:play()
        else
            local finished = t:update()
            if finished then
                self.curIndex = self.curIndex + 1
            end
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenForever:stop()
    self.playing  = false
    self.finished = true
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenForever:setSpeed(speed)
    self.speed = math.min(100, math.max(0.01, speed))
end

return tweenForever

--endregion
