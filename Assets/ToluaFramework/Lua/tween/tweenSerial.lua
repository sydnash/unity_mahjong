--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenSerial = class("tweenSerial")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:ctor(autoDestroy)
    self.queue = {}
    self.currentIndex = 1
    self.playing = false
    self.finished = false
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
        local tween = self.queue[self.currentIndex]
        tween:play()

        self.playing = true
        self.finished = false
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:update()
    if self.playing and not self.finished then
        local tween = self.queue[self.currentIndex]
        self.finished = tween:update()

        if self.finished then
            self.currentIndex = self.currentIndex + 1
            self.playing = false

            if self.currentIndex <= #self.queue then
                tween = self.queue[self.currentIndex]
                tween:play()

                self.playing = true
                self.finished = false
            end
        end
    end

    return self.finished
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenSerial:stop()
    for _, v in pairs(self.queue) do
        v:stop()
    end
end

return tweenSerial

--endregion
