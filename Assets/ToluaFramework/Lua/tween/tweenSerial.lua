--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenSerial = class("tweenSerial")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:ctor(autoDestroy)
    self.queue = {}
    self.playing = false
    self.autoDestroy = autoDestroy
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

    if self.playing and count > 0 then
        local tween = self.queue[1]

        if not tween.playing then
            tween:play()
        end

        local finished = tween:update()

        if finished then
            table.remove(self.queue, 1)
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

return tweenSerial

--endregion
