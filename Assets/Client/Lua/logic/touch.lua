--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local touch = class("touch")
local Input = UnityEngine.Input

touch.phaseType = {
    began = 1,
    ended = 2,
}

touch.phase = touch.phaseType.ended

function touch.update()
    if touch.phase == touch.phaseType.ended then
        if appConfig.usemouse then
            if Input.GetMouseButtonDown(0) then
                touch.phase = touch.phaseType.began
            end
        else
            if Input.touchCount > 0 then
                local t = Input.GetTouch(0)
                if t.phase == TouchPhase.Began then
                    touch.phase = touch.phaseType.began
                end
            end
        end
    else
        if appConfig.usemouse then
            if Input.GetMouseButtonUp(0) then
                touch.phase = touch.phaseType.ended
            end
        else
            if Input.touchCount > 0 then
                local t = Input.GetTouch(0)
                if t.phase == TouchPhase.Ended then
                    touch.phase = touch.phaseType.ended
                end
            end
        end
    end
end

function touch.position()
    if touch.phase == touch.phaseType.began then
        if appConfig.usemouse then
            return Input.mousePosition
        else
            return Input.GetTouch(0).position
        end
    end

    return nil
end

return touch

--endregion
