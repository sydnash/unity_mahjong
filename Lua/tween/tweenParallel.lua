--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tweenParallel = class("tweenParallel")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:ctor()
    self.queue = {}
    self.playing = false
    self.finished = false
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

        self.playing = true
        self.finished = false
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenParallel:update()
    if self.playing and not self.finished then
        self.playing = false
        self.finished = true

        for _, v in pairs(self.queue) do
            if not v:update() then
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
function tweenParallel:stop()
    for _, v in pairs(self.queue) do
        v:stop()
    end
end

return tweenParallel

--endregion
