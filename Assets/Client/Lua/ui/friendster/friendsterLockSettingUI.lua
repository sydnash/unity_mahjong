--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--------------------------------------------------------------
local base = require("ui.common.view")

---------------------setting ui---------------------------------
local friendsterLockSettingUI = class("friendsterLockSettingUI", base)

_RES_(friendsterLockSettingUI, "FriendsterUI", "FriendsterLockSettingUI")

function friendsterLockSettingUI.hasSetting(cityType)
    local games = defaultFriendsterSupporCityGames[cityType]
    if not games then
        return false
    end
    return true
end

local LABEL_S_COLOR = Color.New(12  / 255, 138 / 255, 33 / 255, 1)
local LABEL_U_COLOR = Color.New(146 / 255, 84  / 255, 46 / 255, 1)

local function setTextColor(text, selection)
    text:setColor(selection and LABEL_S_COLOR or LABEL_U_COLOR)
end

function friendsterLockSettingUI:ctor(cityType, friendsterId, friendsterData, createUI)
    self.createUI = createUI
    self.cityType = cityType
    self.friendsterId = friendsterId
    self.friendsterData = friendsterData
    base.ctor(self)
end

function friendsterLockSettingUI:onCloseClickedHandler()
    self:close()
end

function friendsterLockSettingUI:onConfirmClickedHandler()
    self:onConfirmSetting()
end

function friendsterLockSettingUI:onConfirmSetting()
    local data = {}
    for _, gt in pairs(self.chosedGames) do
        table.insert(data, {Id = gt})
    end
    showWaitingUI("正在保存数据...")
    networkManager.friendsterGameSetting(self.friendsterId, 1, data, function(msg)
        closeWaitingUI()
        if msg == nil then
            showMessageUI("保存数据失败，请重试。")
            return
        end
        if msg.RetCode ~= retc.ok then
            showMessageUI("保存数据失败，请重试。")
            return
        end
        showMessageUI("保存成功")
        if self.createUI then
            self.createUI:onSupportGameChanges(self.chosedGames)
        end
        self:close()
    end)
end

function friendsterLockSettingUI:onCloseAllUIHandler()
    self:close()
end


local function createItem(parent, name)
    local pointerToggle = findPointerToggle(parent, name)
    pointerToggle.background = findSprite(parent, name .. "/Background")
    pointerToggle.checkmark  = findSprite(parent, name .. "/Background/Checkmark")
    pointerToggle.label      = findText(parent, name .. "/Label")

    return pointerToggle
end

function friendsterLockSettingUI:initUI()
    self.lines = {}
    for i = 1, 8 do
        local o = findChild(self.mContent.transform, tostring(i))
        o.title = findText(o.transform, "Text")
        o.items = {}
        o.title:hide()
        o:hide()
        for j = 1, 3 do
            local item = createItem(o.transform, tostring(j))
            item:setSelected(false)
            setTextColor(item.label, false)
            item:hide()
            table.insert(o.items, item)
        end
        table.insert(self.lines, o)
    end
    local games = defaultFriendsterSupporCityGames[self.cityType]
    local allInfos = {
        { id = 1, games = {} },
        { id = 1, games = {} },
        { id = 1, games = {} },
        { id = 1, games = {} },
        { id = 1, games = {} },
    }
    for _, gt in pairs(games) do
        local id, name = getGameClassify(gt)
        if id then
            local info = allInfos[id]
            if info then
                table.insert( info.games, gt)
                info.name = name
                info.id = id
            end
        end
    end

    self.gtToItem = {}
    local row = 1
    for _, info in pairs(allInfos) do
        if #info.games > 0 then
            local startRow = self.lines[row]
            startRow:show()
            startRow.title:show()
            startRow.title:setText(info.name)
            for i, gt in pairs(info.games) do
                local col = i - 1
                local rowNode = self.lines[row + math.floor( col / 3 ) ]
                rowNode:show()
                local gname = gameName[self.cityType].games[gt]
                local item = rowNode.items[col % 3 + 1]
                item:show()
                item.label:setText(gname)
                item.gameType = gt

                item:addChangedListener(self.onItemChangedHandler, self)
                item:setSelected(false)
                self.gtToItem[gt] = item
            end
            row = row + math.ceil(#info.games / 3)
        end
    end
end

function friendsterLockSettingUI:onItemChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()
    end

    setTextColor(sender.label, selected)

    if clicked then
        if selected then
            self:onAddChosedHandler(sender.gameType)
        else
            self:onDeleteChosedHandler(sender.gameType)
        end
    end
end

function friendsterLockSettingUI:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCancel:addClickListener(self.onCloseClickedHandler, self)
    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    self:initUI()

    local games = defaultFriendsterSupporCityGames[self.cityType]
    if games == nil then
        games = {}
    end
    local chosedGames = self.friendsterData:getSupportGames()

    local notChosedGames = self:computeNotChosedGames(games, chosedGames)
    self.chosedGames = chosedGames
    self.notChosedGames = notChosedGames

    self:refreshUI(chosedGames, notChosedGames)
end

function friendsterLockSettingUI:onDeleteChosedHandler(gt)
    if #self.chosedGames == 1 then
        local item = self.gtToItem[gt]
        if item then
            item:setSelected(true)
        end
        showMessageUI("至少需要保留一个游戏。", 
                      function()--确定：回到登录界面
                      end)
        return
    end
    table.removeItem(self.chosedGames, gt)
    if not table.indexOf(self.notChosedGames, gt) then
        table.insert(self.notChosedGames, gt)
    end
    -- self:refreshUI(self.chosedGames, self.notChosedGames)
end
function friendsterLockSettingUI:onAddChosedHandler(gt)
    table.removeItem(self.notChosedGames, gt)
    if not table.indexOf(self.chosedGames, gt) then
        table.insert(self.chosedGames, gt)
    end
    -- self:refreshUI(self.chosedGames, self.notChosedGames)
end

function friendsterLockSettingUI:refreshUI(chosed, notChosed)
    for _, gt in pairs(chosed) do
        local item = self.gtToItem[gt]
        if item then
            item:setSelected(true)
        end
    end
end

function friendsterLockSettingUI:computeNotChosedGames(total, chosed)
    local notChosedGames = {}
    for _, game in pairs(total) do
        if not table.indexOf(chosed, game) then
            table.insert(notChosedGames, game)
        end
    end
    return notChosedGames
end

function friendsterLockSettingUI:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    for _, line in pairs(self.lines) do
        for _, item in pairs(line.items) do
            item:destroy()
        end
    end
    base.onDestroy(self)
end

return friendsterLockSettingUI
