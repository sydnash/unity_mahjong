--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local object = class("object")

Transform   	= UnityEngine.Transform
RectTransform   = UnityEngine.RectTransform

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:ctor(gameObject)
    self:init(gameObject)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:init(gameObject)
    assert(gameObject ~= nil, "")  

    self.gameObject     = gameObject
    self.transform      = gameObject.transform
    self.name           = gameObject.name
    self.rectTransform  = getComponentU(gameObject, typeof(RectTransform))

    if self.onInit ~= nil and type(self.onInit) == "function" then
        self:onInit()
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getInstanceID()
    return self.gameObject:GetInstanceID()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setParent(parent)
    self.transform:SetParent(parent.transform, false)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getParent()
    local parent = self.transform.parent
    return object.new(parent.gameObject)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:show()
    if self.updateHandler == nil then
        self.updateHandler = registerUpdateListener(self.update, self)
    end

    self.gameObject:SetActive(true)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:hide()
    unregisterUpdateListener(self.updateHandler)
    self.updateHandler = nil

    self.gameObject:SetActive(false)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getVisibled()
    return self.gameObject.activeSelf
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setVisibled(v)
    if v then
        self:show()
    else
        self:hide()
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setAsLastSibling()
    self.transform:SetAsLastSibling()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:destroy()
    unregisterUpdateListener(self.updateHandler)
    self.updateHandler = nil

    if self.onDestroy ~= nil and type(self.onDestroy) == "function" then
        self:onDestroy()
    end

    self.gameObject = nil
    self.transform  = nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setPosition(pos)
    self.transform.position = pos
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getPosition()
    return self.transform.position
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setLocalPosition(pos)
    self.transform.localPosition = pos
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getLocalPosition()
    return self.transform.localPosition
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setAnchoredPosition(pos)
    self.transform.anchoredPosition = pos
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getAnchoredPosition()
    return self.transform.anchoredPosition
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setRotation(rot)
    self.transform.rotation = rot
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getRotation()
    return self.transform.rotation
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setLocalRotation(rot)
    self.transform.localRotation = rot
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getLocalRotation()
    return self.transform.localRotation
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getEulerAngles()
    return self.transform.eulerAngles
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setEulerAngles(angles)
    self.transform.eulerAngles = angles
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getLocalEulerAngles()
    return self.transform.localEulerAngles
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setLocalEulerAngles(angles)
    self.transform.localEulerAngles = angles
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:getLocalScale()
    return self.transform.localScale
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setLocalScale(scale)
    self.transform.localScale = scale
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:findChild(name)
    return findChild(self.transform, name)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function setLayer(transform, layer, includeChildren)
    if transform.gameObject.layer == layer then
        return
    end

    transform.gameObject.layer = layer

    if includeChildren then
        local childCount = transform.childCount
        for i=0, childCount-1 do
            local child = transform:GetChild(i)
            setLayer(child, layer)
        end
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function object:setLayer(layer, includeChildren)
    setLayer(self.transform, layer, includeChildren)
end

return object

--endregion
