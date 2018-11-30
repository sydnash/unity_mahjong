--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local touch = class("touch")
local Input = UnityEngine.Input

touch.phaseType = {
    began       = 1,
    moved       = 2,
    ended       = 3,
    canceled    = 4,
}

local phase = touch.phaseType.ended
local phaseCallback = nil
local phaseCallbackTarget = nil
local updateHandler = nil

local function position()
    return deviceConfig.isMobile and Input.GetTouch(0).position or Input.mousePosition 
end

local function update()
    if phase == touch.phaseType.ended or pahse == touch.phaseType.canceled then
        if not deviceConfig.isMobile then
            if Input.GetMouseButtonDown(0) then
                phase = touch.phaseType.began
                phaseCallback(phaseCallbackTarget, phase, position())
            end
        else
            if Input.touchCount > 0 then
                local t = Input.GetTouch(0)
                if t.phase == TouchPhase.Began then
                    phase = touch.phaseType.began
                    phaseCallback(phaseCallbackTarget, phase, position())
                end
            end
        end
    else
        if not deviceConfig.isMobile then
            if Input.GetMouseButtonUp(0) then
                phase = touch.phaseType.ended
            else
                phase = touch.phaseType.moved
            end
        else
            if Input.touchCount > 0 then
                local t = Input.GetTouch(0)
                if t.phase == TouchPhase.Ended then
                    phase = touch.phaseType.ended
                elseif t.phase == TouchPhase.Moved then
                    phase = touch.phaseType.moved
                elseif t.phase == TouchPhase.Canceled then
                    phase = touch.phaseType.canceled
                end
            else
                phase = touch.phaseType.canceled
                phaseCallback(phaseCallbackTarget, phase, Vector2.New(0, 0))
                return
            end
        end

        phaseCallback(phaseCallbackTarget, phase, position())
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function touch.addListener(callback, target)
    if callback ~= nil then
        if updateHandler == nil then
            updateHandler = registerUpdateListener(update, nil)
        end

        phaseCallback = callback
        phaseCallbackTarget = target
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function touch.removeListener()
    unregisterUpdateListener(updateHandler)
    updateHandler = nil

    phaseCallback = nil
    phaseCallbackTarget = nil
end

return touch

--endregion
