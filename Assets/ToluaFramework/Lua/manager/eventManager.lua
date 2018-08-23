--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local eventManager = {}

local AnimationEventManager = AnimationEventManager

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function eventManager.setup()

end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function eventManager.registerAnimationTrigger(key, callback)
    AnimationEventManager.instance:RegisterTrigger(key, callback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function eventManager.unregisterAnimationTrigger(key)
    AnimationEventManager.instance:UnregisterTrigger(key)
end

return eventManager

--endregion
