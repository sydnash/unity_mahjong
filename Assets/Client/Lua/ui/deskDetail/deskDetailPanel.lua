--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local detailPanel = class("detailPanel", base)

_RES_(detailPanel, "DeskDetailUI", "DeskDetailPanel")

local function createItem(parent, name)
    local pointerToggle = findPointerToggle(parent, name)
    pointerToggle.background = findSprite(parent, name .. "/Background")
    pointerToggle.checkmark  = findSprite(parent, name .. "/Background/Checkmark")
    pointerToggle.label      = findText(parent, name .. "/Label")

    return pointerToggle
end

local function createGroup(parent, name)
    local group = findToggleGroup(parent, name)
    local item1 = createItem(group.transform, "1")
    local item2 = createItem(group.transform, "2")
    local item3 = createItem(group.transform, "3")
    local item4 = createItem(group.transform, "4")

    group.title = findText(group.transform, "Text")
    group.items = { item1, item2, item3, item4, }

    return group
end

local LABEL_S_COLOR = Color.New(12  / 255, 138 / 255, 33 / 255, 1)
local LABEL_U_COLOR = Color.New(146 / 255, 84  / 255, 46 / 255, 1)

local function setTextColor(text, selection)
    text:setColor(selection and LABEL_S_COLOR or LABEL_U_COLOR)
end

local MAX_GROUP_COUNT = 15

function detailPanel:ctor(interactable, callback, createUI)
    self.createUI = createUI
    self.interactable = interactable
    self.callback = callback

    base.ctor(self)
end

function detailPanel:onInit()
    self.groups = {}
    for i=1, MAX_GROUP_COUNT do
        local group = createGroup(self.mLayout.transform, tostring(i))
        table.insert(self.groups, group)

        for _, v in pairs(group.items) do
            v:hide()
        end

        group:hide()
    end

    self.mLayout:setSpacing(self.interactable and -25 or -40)
end

function detailPanel:set(cityType, gameType, layout, config)
    -- log("config" .. table.tostring(config))
    self.cityType = cityType
    self.gameType = gameType
    self.layout = layout
    self.config = {} --config

    for _, g in pairs(self.groups) do
        for _, v in pairs(g.items) do
            v:removeAllListeners()
            v:hide()
        end
        g:hide()
    end

    for k, L in pairs(self.layout) do
        local group = self.groups[k]
        group.title:setText(L.title)

        for n, u in pairs(L.items) do
            local item = group.items[n]
            item:show()
            item:setInteractable(self.interactable)
            item:setGroup(L.group.value and group or nil)

            item.key = u.key
            item.value = u.value
            item.label:setText(u.text)
            item.background:setSprite(u.style)
            item.checkmark:setSprite(u.style)
            
            local cvalue = config[u.key]
            self.config[u.key] = cvalue
            local selected = false

            if L.group.value then
                if L.group.switchOff then
                    selected = (cvalue == u.value.selected)
                else
                    selected = (cvalue == u.value)
                end
            else
                selected = (cvalue == u.value.selected)
            end

            item:setSelected(selected)
            setTextColor(item.label, selected)

            if self.interactable and u.disabled then
                item:setInteractable(false)
            end

            if not L.group.value then
                item:addChangedListener(self.onItemChangedHandler, self)
            else
                if L.group.switchOff then
                    item:addChangedListener(self.onSwitchOffGroupItemChangedHandler, self)
                else
                    item:addChangedListener(self.onGroupItemChangedHandler, self)
                end
            end
        end

        group:allowSwitchOff(L.group.switchOff)
        group:show()
    end
    self:processLayout()
    self:processConfig()
end

function detailPanel:getCreateConfig()
    return self.config
end

function detailPanel:checkIsLocked(item, selected)
    local isLocked = self.createUI.isCreateLocked

    if isLocked then
        item:setSelected(not selected)
        self:set(self.cityType, self.gameType, self.layout, self.config)
        showMessageUI("玩法已被亲友圈圈主锁定，如有疑问请联系圈主。")
    end

    return isLocked
end

function detailPanel:onItemChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()
        if self:checkIsLocked(sender, selected) then
            return
        end
        self.config[sender.key] = selected and sender.value.selected or sender.value.unselected
    end

    setTextColor(sender.label, selected)
end

function detailPanel:onGroupItemChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()

        if self:checkIsLocked(sender, selected) then
            return
        end
        if selected then
            self.config[sender.key] = sender.value
            self:processLayout()
            self:processConfig()
        end
    end

    setTextColor(sender.label, selected)

    if selected then
        if sender.key == "RenShu" or sender.key == "JuShu" then
            if self.callback ~= nil then
                local c = self.config
                self.callback(c.RenShu, c.JuShu)
            end
        end
    end
end

function detailPanel:onSwitchOffGroupItemChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()

        if self:checkIsLocked(sender, selected) then
            return
        end
        if selected then
            self.config[sender.key] = sender.value.selected
        else
            self.config[sender.key] = sender.value.unselected
        end
    end

    setTextColor(sender.label, selected)
end

function detailPanel:processLayout()
    if self.cityType == cityType.jintang then
        if self.gameType == gameType.doushisi then
            if self.config.CaiShen == 1 then
                self.groups[5].items[1].label:setText("3番(80)")
                self.groups[5].items[2].label:setText("4番(120)")
            else
                self.groups[5].items[1].label:setText("3番(100)")
                self.groups[5].items[2].label:setText("4番(150)")
            end
        end
    end
end

function detailPanel:processConfig()
    if self.cityType == cityType.jintang then
        if self.gameType == gameType.doushisi then
            if self.config.CaiShen == 1 then
                if self.config.FengDing == 1 then
                    self.config.DianShu = 1
                elseif self.config.FengDing == 2 then
                    self.config.DianShu = 3
                else
                    self.config.DianShu = 5
                end
            else
                if self.config.FengDing == 1 then
                    self.config.DianShu = 2
                elseif self.config.FengDing == 2 then
                    self.config.DianShu = 4
                else
                    self.config.DianShu = 5
                end
            end
        end
    end
end

function detailPanel:onDestroy()
    self.mScrollRect:reset()
    base.onDestroy(self)
end

return detailPanel

--endregion
