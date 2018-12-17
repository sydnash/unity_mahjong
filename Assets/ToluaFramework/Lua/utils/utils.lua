--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function _RES_(cls, folder, resource)
    cls._folder = folder
    cls._resource = resource
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            if type(mt.__index) == "function" then --C++可能重载了__index为一个函数
                setmetatableindex_(mt, index)
            else
                setmetatableindex_(mt.__index, index)
            end
        end
    end
end

setmetatableindex = setmetatableindex_

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end

local GameObject = UnityEngine.GameObject

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function find(name)
    local go = GameObject.Find(name)

    if go ~= nil then
        return object.new(go)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findChild(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local child = transform:Find(name)
    if child ~= nil then
        return object.new(child.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findText(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local text = require("ui.common.text")
        return text.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findSprite(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local sprite = require("ui.common.sprite")
        return sprite.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findImage(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local image = require("ui.common.image")
        return image.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findButton(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local button = require("ui.common.button")
        return button.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findToggle(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local toggle = require("ui.common.toggle")
        return toggle.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findPointerToggle(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local pointerToggle = require("ui.common.pointerToggle")
        return pointerToggle.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findToggleGroup(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local toggleGroup = require("ui.common.toggleGroup")
        return toggleGroup.new(target.gameObject)
    end

    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function findChildByIndex(transform, index)
    assert(transform ~= nil)

    local child = transform:GetChild(index)
    return (child ~= nil) and object.new(child.gameObject) or nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function addComponentU(gameObject, componentType)
    assert(gameObject ~= nil, "the gameobject is nil")
    assert(componentType ~= nil, "the component is nil")

    return gameObject:AddComponent(componentType)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function getComponentU(gameObject, componentType)
    assert(gameObject ~= nil, "the gameobject is nil")
    assert(componentType ~= nil, "the component is nil")

    return gameObject:GetComponent(componentType)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function removeComponentU(gameObject, componentType)
    assert(gameObject ~= nil, "the gameobject is nil")
    assert(componentType ~= nil, "the component is nil")

    local component = gameObject:GetComponent(componentType)

    if component ~= nil then
        GameObject.Destroy(component)
    end
end

Logger.debug = appConfig.debug
Logger.Open()

local logInfoD       = Logger.Log
local logWarningD    = Logger.LogWarning
local logErrorD      = Logger.LogError

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function log(message)
    if appConfig.debug then
        if type(message) == "table" then
            message = table.tostring(message)
        elseif type(message) ~= "string" then 
            message = tostring(message) 
        end

        logInfoD(message)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function logWarning(message)
    if appConfig.debug then
        if type(message) == "table" then
            message = table.tostring(message)
        elseif type(message) ~= "string" then 
            message = tostring(message) 
        end

        logWarningD(message)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function logError(message)
    if appConfig.debug then
        if type(message) == "table" then
            message = table.tostring(message)
        elseif type(message) ~= "string" then 
            message = tostring(message) 
        end

        logErrorD(message)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function callstack()
    return appConfig.debug and debug.traceback() or string.empty
end

local _gdb_tracebackk_callback_ = nil

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function registerTracebackCallback(callback)
    _gdb_tracebackk_callback_ = callback
end

-------------------------------------------------------------------
--全局错误/异常处理函数
-------------------------------------------------------------------
function _GDB_TRACKBACK_(errorMessage)
    if _gdb_tracebackk_callback_ ~= nil then
        local msg = string.format("Lua error: %s%s", tostring(errorMessage), debug.traceback("", 2))
        _gdb_tracebackk_callback_(msg)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function printError(msg)
    msg = "ERR: " .. msg
    local trance = debug.traceback("", 2)
    msg = msg .. "\n" .. trance
    -- if _gdb_tracebackk_callback_ ~= nil then
    --     _gdb_tracebackk_callback_(msg, debug)
    -- end
    log(msg)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function registerUpdateListener(method, args)
    local handler = nil

    if method ~= nil and type(method) == "function" then
        handler = UpdateBeat:CreateListener(method, args)
        UpdateBeat:AddListener(handler)
    end

    return handler
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function unregisterUpdateListener(handler)
    if handler ~= nil then
        UpdateBeat:RemoveListener(handler, true)
    end
end

-------------------------------------------------------------------
--十六进制颜色转Color  "RRGGBBAA"
-------------------------------------------------------------------
function hexColorToColor(colorString)
    if not colorString then
        return nil
	end
    local toTen = function (v)
        return tonumber("0x" .. v)
    end

    local r = string.sub(colorString, 1, 2) 
    local g = string.sub(colorString, 3, 4) 
    local b = string.sub(colorString, 5, 6)
    local a = string.sub(colorString, 7, 8)

    local red = toTen(r)
    local green = toTen(g)
    local blue = toTen(b)
    local alpha = toTen(a)
    if red and green and blue and alpha then 
        return Color.New(red / 255, green / 255, blue / 255, alpha / 255)
    end
    return nil
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function convertTextureToSprite(tex)
    return Utils.ConvertTextureToSprite(tex)
end

--endregion
