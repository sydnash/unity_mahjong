--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

tweenPosition   = require("tween.tweenPosition")
tweenRotation   = require("tween.tweenRotation")
tweenScale      = require("tween.tweenScale")
tweenDelay      = require("tween.tweenDelay")
tweenFunction   = require("tween.tweenFunction")
tweenSerial     = require("tween.tweenSerial")
tweenParallel   = require("tween.tweenParallel")

local tweenManager = {}
local queue = nil
local handler = nil

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function destroyUpdateHandler()
    unregisterUpdateListener(handler)
    handler = nil
    queue = nil
--    log("tween manager has been remove the update listener")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function update()
    if queue == nil or #queue <= 0 then return end

    local finishedTweens = {}

    for k, v in pairs(queue) do
        local finished = v:update()
        
        if v.autoDestroy and finished then
            table.insert(finishedTweens, k)
        end
    end

    for i=#finishedTweens, 1, -1 do
        local k = finishedTweens[i]
        table.remove(queue, k)
    end

    if #queue == 0 then
        destroyUpdateHandler()
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenManager.add(tween)
    if queue == nil then queue = {} end
    table.insert(queue, tween)

    if handler == nil then
        handler = registerUpdateListener(update)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function tweenManager.remove(tween)
    if tween ~= nil then
        tween:stop()
    end

    if queue == nil then return end

    for k, v in pairs(queue) do
        if v == tween then
            table.remove(queue, k)
            break
        end
    end

    if #queue == 0 then
        destroyUpdateHandler()
    end
end

return tweenManager

--endregion
