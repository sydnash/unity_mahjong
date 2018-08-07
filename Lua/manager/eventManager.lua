--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local eventManager = {}

local EventSystem = UnityEngine.EventSystems.EventSystem

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function eventManager.setup()
    eventSystem = GameObject.FindObjectOfType(typeof(EventSystem))
    assert(eventSystem ~= nil, "can't find ui eventSystem")
end

return eventManager

--endregion
