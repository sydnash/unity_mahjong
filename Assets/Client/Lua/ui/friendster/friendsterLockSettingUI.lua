--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--------------------------------------------------------------
-- gameType = {
--     doushisi    = 2, --斗十四
--     erqishi     = 3, --贰柒拾
--     paodekuai   = 4, --跑得快
--     mahjong     = 5, --麻将
--     doudizhu    = 6, --斗地主
--     hundizhu    = 7, --荤地主
--     dpd14       = 8, --短牌斗十四
-- }

local cityGames = {
    [cityType.jintang] = {
        gameType.doushisi, gameType.paodekuai, gameType.mahjong, gameType.doudizhu,
    }
}

local base = require("ui.common.view")

---------------------chosed line--------------------------------
local chosedLine = class("chosedLine", base)
_RES_(chosedLine, "FriendsterUI", "ChosedLine")

function chosedLine:ctor()
    base.ctor(self)
end

function chosedLine:onInit()
    self.items = {self.mItem1, self.mItem2}
end

function chosedLine:set(games, idx, callback)
    for _, item in pairs(self.items) do
        item:hide()
    end
    for i = 1, 2 do
        local index = idx + i
        local gt = games[index]
        if not gt then
            return
        end
        local item = self.items[i]
        item:show()
        item:setGameType(gt, gameName[gt], callback)
    end
end

---------------------not chosed line----------------------------
local notChosedLine = class("notChosedLine", base)
_RES_(notChosedLine, "FriendsterUI", "NotChosedLine")

function notChosedLine:ctor()
    base.ctor(self)
end

function notChosedLine:onInit()
    self.items = {self.mItem1, self.mItem2, self.mItem3, self.mItem4}
end

function notChosedLine:set(games, idx, callback)
    for _, item in pairs(self.items) do
        item:hide()
    end
    for i = 1, 4 do
        local index = idx + i
        local gt = games[index]
        if not gt then
            return
        end
        local item = self.items[i]
        item:show()
        item:setGameType(gt, gameName[gt], callback)
    end
end

---------------------setting ui---------------------------------
local friendsterLockSettingUI = class("friendsterLockSettingUI", base)

_RES_(friendsterLockSettingUI, "FriendsterUI", "FriendsterLockSettingUI")

function friendsterLockSettingUI.hasSetting(cityType)
    local games = cityGames[cityType]
    if not games then
        return false
    end
    return true
end

function friendsterLockSettingUI:ctor(cityType, friendsterId, friendsterData)
    self.cityType = cityType
    self.friendsterId = friendsterId
    self.friendsterData = friendsterData
    base.ctor(self)
end

function friendsterLockSettingUI:onCloseClickedHandler()
    local data = {}
    for _, gt in pairs(self.chosedGames) do
        table.insert(data, {Id = gt})
    end
    networkManager.friendsterGameSetting(self.friendsterId, 1, data)
    self:close()
end
function friendsterLockSettingUI:onCloseAllUIHandler()
    self:close()
end

function friendsterLockSettingUI:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    local games = cityGames[self.cityType]
    if games == nil then
        games = {}
    end
    local chosedGames = {}
    if self.friendsterData.createSetting then
        for _, gt in pairs(self.friendsterData.createSetting) do
            table.insert(chosedGames, gt.Id)
        end
    end
    if #chosedGames == 0 then
        for _, gt in pairs(games) do
            table.insert(chosedGames, gt)
        end
    end

    local notChosedGames = self:computeNotChosedGames(games, chosedGames)
    self.chosedGames = chosedGames
    self.notChosedGames = notChosedGames

    self:refreshUI(chosedGames, notChosedGames)
end

function friendsterLockSettingUI:onDeleteChosedHandler(gt)
    table.removeItem(self.chosedGames, gt)
    if not table.indexOf(self.notChosedGames, gt) then
        table.insert(self.notChosedGames, gt)
    end
    self:refreshUI(self.chosedGames, self.notChosedGames)
end
function friendsterLockSettingUI:onAddChosedHandler(gt)
    table.removeItem(self.notChosedGames, gt)
    if not table.indexOf(self.chosedGames, gt) then
        table.insert(self.chosedGames, gt)
    end
    self:refreshUI(self.chosedGames, self.notChosedGames)
end

function friendsterLockSettingUI:refreshUI(chosed, notChosed)
    local createItem = function()
        return chosedLine.new()
    end
    local refreshItem = function(item, index)
        item:set(chosed, index * 2, function(gt)
            self:onDeleteChosedHandler(gt)
        end)
    end
    self.mChosedList:reset()
    self.mChosedList:set(math.ceil(#chosed / 2), createItem, refreshItem)

    local createItem = function()
        return notChosedLine.new()
    end
    local refreshItem = function(item, index)
        item:set(notChosed, index * 4, function(gt)
            self:onAddChosedHandler(gt)
        end)
    end
    self.mNotChosed:reset()
    self.mNotChosed:set(math.ceil(#notChosed / 4), createItem, refreshItem)
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
    
    base.onDestroy(self)
end

return friendsterLockSettingUI
