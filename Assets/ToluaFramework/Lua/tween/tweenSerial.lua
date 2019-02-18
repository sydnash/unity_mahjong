--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenSerial = class("tweenSerial")

function tweenSerial.getByVec(autoDestroy, doNextImmediately, vec)
    local ret = tweenSerial.new(autoDestroy, doNextImmediately)
    for _, t in pairs(vec) do
        ret:add(t)
    end
    return ret
end
-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:ctor(autoDestroy, doNextImmediately)
    self.queue = {}
    self.playing = false
    self.autoDestroy = autoDestroy
    self.doNextImmediately = doNextImmediately
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:add(tween)
    table.insert(self.queue, tween)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:play()
    if #self.queue > 0 then
        local tween = self.queue[1]
        tween:play()
    end

    self.playing = true
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:update()
    local count = #self.queue
    local loop = true

    while loop do
        loop = false
        if self.playing and count > 0 then
            local tween = self.queue[1]

            if not tween.playing then
                tween:play()
            end

            local finished = tween:update()

            if finished then
                table.remove(self.queue, 1)
                if self.doNextImmediately then
                    loop = true
                    count = #self.queue
                end
            end
        end
    end

    return (count == 0)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:stop()
    for _, v in pairs(self.queue) do
        v:stop()
    end

    self.playing = false
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:clear()
    self:stop()
    self.queue = {}
end

-------------------------------------------------------------------
-- speed is between 0.01 and 100
-------------------------------------------------------------------
function tweenSerial:setSpeed(speed)
    for _, v in pairs(self.queue) do
        v:setSpeed(speed)
    end
end

return tweenSerial

--endregion
