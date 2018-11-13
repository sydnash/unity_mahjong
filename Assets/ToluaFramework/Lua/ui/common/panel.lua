--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local panel = class("panel", base)

local text          = require("ui.common.text")
local sprite        = require("ui.common.sprite")
local image         = require("ui.common.image")
local button        = require("ui.common.button")
local toggle        = require("ui.common.toggle")
local slider        = require("ui.common.slider")
local input         = require("ui.common.input")
local scrollview    = require("ui.common.scrollview")
local scrollrect    = require("ui.common.scrollrect")
local pageview      = require("ui.common.pageview")
local animation     = require("ui.common.animation")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function insertToWidgets(target, widget)
    if target.widgets == nil then 
        target.widgets = {} 
    end

    table.insert(target.widgets, widget)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function bind(target, variableName, gameObject, widgetType, panelScript)
    local widget = nil

    if widgetType == LuaPanel.WidgetType.GameObject then 
        widget = object.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Panel then
        widget = require(panelScript).new()
        widget:bind(gameObject)
        widget:init(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Text then
        widget = text.new(gameObject) 
    elseif widgetType == LuaPanel.WidgetType.Sprite then 
        widget = sprite.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Image then 
        widget = image.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Button then 
        widget = button.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Toggle then 
        widget = toggle.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Slider then 
        widget = slider.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Input then 
        widget = input.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.ScrollView then 
        widget = scrollview.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.ScrollRect then 
        widget = scrollrect.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.PageView then 
        widget = pageview.new(gameObject)
    elseif widgetType == LuaPanel.WidgetType.Animation then 
        widget = animation.new(gameObject)
    else
        error("unknown widget type: " .. tostring(widgetType))
        return
    end
    
    target[variableName] = widget
    insertToWidgets(target, widget)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function panel:ctor()

end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function panel:bind(gameObject)
    local LP = getComponentU(gameObject, typeof(LuaPanel))
    assert(LP ~= nil, "can't get the component: LuaPanel")
    LP:Bind(self, bind)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function panel:onDestroy()
    if self.widgets ~= nil then 
        for _, v in pairs(self.widgets) do 
            v:destroy()
        end
        self.widgets = nil
    end
end

return panel

--endregion
