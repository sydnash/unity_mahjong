--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenParallel = class("tweenParallel")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:ctor(autoDestroy)
    self.queue = {}
    self.playing = false
    self.autoDestroy = autoDestroy
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:add(tween)
    table.insert(self.queue, tween)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:play()
    if #self.queue > 0 then
        for _, v in pairs(self.queue) do
            v:play()
        end
    end

    self.playing = true
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:update()
    if self.playing then
        local temp = {}

        for k, v in pairs(self.queue) do
            if v.playing then
                v:play()
            end

            local finished = v:update()

            if finished then
                table.insert(temp, k)
            end
        end

        for i=#temp, 1, -1 do
            local k = temp[i]
            table.remove(self.queue, k)
        end
    end

    return (self.queue == 0)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:stop()
    for _, v in pairs(self.queue) do
        v:stop()
    end

    self.playing = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:clear()
    self:stop()
    self.queue = {}
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenParallel:setSpeed(speed)
    for _, v in pairs(self.queue) do
        v:setSpeed(speed)
    end
end

return tweenParallel

--endregion
