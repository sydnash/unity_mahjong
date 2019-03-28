--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local enableConfig = require("config.enableConfig")
local costConfig = require("config.costConfig")

local base = require("ui.common.view")
local createDesk = class("createDesk", base)

_RES_(createDesk, "CreateDeskUI", "CreateDeskUI")

local CONFIGS_FOLDER = "CreateDeskConfigs"
local detailConfigs = {}

function createDesk:ctor(cityType, friendsterId, friendsterData)
    self.cityType = cityType
    self.gameType = gamepref.getSelectedGameType(friendsterId)
    self.friendsterId = friendsterId
    self.friendsterData = friendsterData

    base.ctor(self)
end

function createDesk:refreshLeftList(c)
    log(c)
    local isempty = true

    local ui = { 
        { key = "mahjong",  text = "麻将", init = function() self:initMahjongItems()  end, panel = self.mMahjongPanel,  gameType = gameType.mahjong,   gameTypeC = { [gameType.mahjong]   = true, [gameType.yaotongrenyong] = true}, },
        { key = "changpai", text = "长牌", init = function() self:initChangpaiItems() end, panel = self.mChangpaiPanel, gameType = gameType.doushisi,  gameTypeC = { [gameType.doushisi]  = true, }, },
        { key = "poke",     text = "扑克", init = function() self:initPokerItems()    end, panel = self.mPokePanel,     gameType = gameType.paodekuai, gameTypeC = { [gameType.paodekuai] = true, }, },
    }

    if self.gameItems == nil then
        self.gameItems = {}

        local root = self.mGameType
        for k, _ in pairs(ui) do
            local toggle = findPointerToggle(root.transform, tostring(k))
            local text   = findText(toggle.transform,   "Background/Text")
            local sprite = findSprite(toggle.transform, "Checkmark/Image")

            toggle:addChangedListener(self.onGameChangedHandler, self)
            toggle:hide()

            table.insert(self.gameItems, { toggle = toggle, text = text, sprite = sprite })
        end
    end

    for k, v in pairs(ui) do
        local panel  = v.panel
        panel:hide()

        if c[v.key].enable then
            local item = self.gameItems[k]
            
            local toggle = item.toggle
            local text   = item.text
            local sprite = item.sprite

            text:setText(v.text)
            sprite:setSprite(v.key)
            toggle:show()

            if v.gameTypeC[self.gameType] then
                toggle:setSelected(true)
                panel:show()
            else
                toggle:setSelected(false)
                panel:hide()
            end

            toggle.init     = v.init
            toggle.panel    = v.panel
            toggle.gameType = v.gameType

            if isempty then
                v.init()
            end

            isempty = false
        end
    end

    if isempty then
        self.mEmpty:show()
    else
        self.mEmpty:hide()
    end
end

function createDesk:onSupportGameChanges(games)
    if self.friendsterId and self.friendsterId > 0 then
        local oric = table.clone(enableConfig[self.cityType])
        local c = table.clone(enableConfig[self.cityType])
        c.mahjong.enable = false
        c.changpai.enable = false
        local supportGame
        local needChanged = true
        local hasMore = false
        for _, gt in pairs(games) do
            if gt == self.gameType then
                needChanged = false
            end
            if gt == gameType.mahjong then
                supportGame = gt
                hasMore = true
                c.mahjong.enable = oric.mahjong.enable
            elseif gt == gameType.doushisi then
                supportGame = gt
                hasMore = true
                c.changpai.enable = oric.changpai.enable
            elseif gt == gameType.paodekuai then
                supportGame = gt
                hasMore = true
                c.poke.enable = oric.poke.enable
            end
        end
        if needChanged then
            if not hasMore then
                showMessageUI("该亲友圈因为圈主设置原因，无法创建长牌和麻将，如有疑问请联系圈主。")
            else
                self.gameType = supportGame
            end
        end
        self:refreshLeftList(c)
        if needChanged then
            if not hasMore then
            else
                self.config = self:readConfig()
                self:createDetail()
                self:onGameTypeChanged()
            end
        end
    end
end

function createDesk:onInit()
    if self.friendsterId and self.friendsterId > 0 and self.friendsterData.managerAcId == gamepref.player.acId  then
        self.mSetting:show()
        self.mLock:show()
    else
        self.mSetting:hide()
        self.mLock:hide()
    end
    local c = table.clone(enableConfig[self.cityType])
    if self.friendsterId and self.friendsterId > 0 then
        local chosedGames = self.friendsterData:getSupportGames()
        self:onSupportGameChanges(chosedGames)
    else
        self:refreshLeftList(c)
    end

    self.config = self:readConfig()
    self:createDetail()
    self:onGameTypeChanged()

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
    self.mLock:addChangedListener(self.onLockChangedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function createDesk:onLockChangedHandler(sender, selected, isClicked)
    if not isClicked then
        return
    end
    local msg
    if selected then
        msg = "锁定之后本亲友圈玩家创建房间只能选择当前锁定玩法，是否锁定？"
    else
        msg = "解锁之后本亲友圈玩家创建房间可以自由选择玩法，是否解锁？"
    end
    sender:setSelected(not selected)
    showMessageUI(msg, function()
        self:saveSettingToServer(selected, sender)
    end, function()
    end)
end

function createDesk:saveSettingToServer(lock, node)
    showWaitingUI("正在保存数据...")

    local function saveOneSetting()
        local data = {}
        local cfg = ""
        if lock then
            local choose = self.detail:getCreateConfig()
            choose.Game = self.gameType
            cfg = table.tojson(choose)
        else
            cfg = ""
        end
        table.insert(data, {
            Id = self.gameType,
            Cfg = cfg,
        })
        networkManager.friendsterGameSetting(self.friendsterId, 2, data, function(msg)
            closeWaitingUI()
            if msg == nil then
                showMessageUI("保存数据失败，请重试。")
                return
            end
            if msg.RetCode ~= retc.ok then
                showMessageUI("保存数据失败，请重试。")
                return
            end
            showMessageUI("保存数据成功")
            node:setSelected(lock)
            self.isCreateLocked = lock
            if self.isCreateLocked then
                self.mLockedHint:show()
            else
                self.mLockedHint:hide()
            end
        end)
    end

    if self.friendsterData:hasCreateSetting() then
        saveOneSetting()
    else
        local data = {}
        for _, gt in pairs(defaultFriendsterSupporCityGames[self.cityType]) do
            table.insert(data, {Id = gt})
        end
        networkManager.friendsterGameSetting(self.friendsterId, 1, data, function(msg)
            if msg == nil then
                showMessageUI("保存数据失败，请重试。")
                closeWaitingUI()
                return
            end
            if msg.RetCode ~= retc.ok then
                showMessageUI("保存数据失败，请重试。")
                closeWaitingUI()
                return
            end
            saveOneSetting()
        end)
    end
end

function createDesk:onGameTypeChanged()
    if self.friendsterId ~= nil and self.friendsterId > 0 then
        if self.friendsterData.managerAcId == gamepref.player.acId  then
            local has, cfg = self.friendsterData:isSupportGame(self.gameType)
            if has then
                self.mLock:show()
                if cfg and cfg ~= "" then
                    self.mLock:setSelected(true)
                    self.isCreateLocked = true
                else
                    self.mLock:setSelected(false)
                    self.isCreateLocked = false
                end
            else
                self.mLock:hide()
                self.isCreateLocked = false
            end
        else
            local has, cfg = self.friendsterData:isSupportGame(self.gameType)
            if has then
                if cfg and cfg ~= "" then
                    self.isCreateLocked = true
                else
                    self.isCreateLocked = false
                end
            else
                self.isCreateLocked = false
            end
        end
    end
    if self.isCreateLocked then
        self.mLockedHint:show()
    else
        self.mLockedHint:hide()
    end
end

function createDesk:onSettingClickedHandler()
    local ui = require ("ui.friendster.friendsterLockSettingUI").new(self.cityType, self.friendsterId, self.friendsterData, self)
    ui:show()
end

function createDesk:updateCost()
    local gameConfig = self.config[self.gameType]
    gameConfig = self.detail:getCreateConfig()
    local renshu = gameConfig.RenShu
    local jushu  = gameConfig.JuShu
    local cost = self:getCost(renshu, jushu)
    self.mCost:setText(tostring(cost))
end

function createDesk:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function createDesk:onGameChangedHandler(sender, selected, clicked)
    if clicked then
        self.gameType = sender.gameType
        self:onGameTypeChanged()

        self.config = self:readConfig()
        self:createDetail()

        for _, v in pairs(self.gameItems) do
            if v.toggle.panel ~= nil then
                v.toggle.panel:hide()
            end
        end
        sender.panel:show()
        sender.init()

        playButtonClickSound()        
    end
end

function createDesk:initMahjongItems()
    if self.mahjongItems ~= nil then
        return
    end

    self.mahjongItems = {}
    for i=1, 4 do
        local name = "Viewport/Content/DetailType/" .. tostring(i)
        local item = findPointerToggle(self.mMahjongPanel.transform, name)
        item:addChangedListener(self.onGameDetailChangedHandler, self)
        item:hide()

        table.insert(self.mahjongItems, item)
    end

    local idx = 1
    for k, v in pairs(enableConfig[self.cityType].mahjong.detail) do
        if v then
            local it = self.mahjongItems[idx]
            it.gameType = k
            it:setSelected(idx == 1)
            it:show()

            local btxt = findText(it.transform, "Background/Text")
            local ctxt = findText(it.transform, "Checkmark/Text")
            btxt:setText(gameName[self.cityType].games[k])
            ctxt:setText(gameName[self.cityType].games[k])

            idx = idx + 1
        end
    end
end

function createDesk:initChangpaiItems()
    if self.changpaiItems ~= nil then
        return
    end

    self.changpaiItems = {}
    for i=1, 4 do
        local name = "Viewport/Content/DetailType/" .. tostring(i)
        local item = findPointerToggle(self.mChangpaiPanel.transform, name)
        item:addChangedListener(self.onGameDetailChangedHandler, self)
        item:hide()

        table.insert(self.changpaiItems, item)
    end

    local idx = 1
    for k, v in pairs(enableConfig[self.cityType].changpai.detail) do
        if v then
            local it = self.changpaiItems[idx]
            it.gameType = k
            it:setSelected(idx == 1)
            it:show()

            local btxt = findText(it.transform, "Background/Text")
            local ctxt = findText(it.transform, "Checkmark/Text")
            btxt:setText(gameName[self.cityType].games[k])
            ctxt:setText(gameName[self.cityType].games[k])

            idx = idx + 1
        end
    end
end

function createDesk:initPokerItems()
    if self.pokerItems ~= nil then
        return
    end

    self.pokerItems = {}
    for i=1, 4 do
        local name = "Viewport/Content/DetailType/" .. tostring(i)
        local item = findPointerToggle(self.mPokePanel.transform, name)
        item:addChangedListener(self.onGameDetailChangedHandler, self)
        item:hide()

        table.insert(self.pokerItems, item)
    end

    local idx = 1
    for k, v in pairs(enableConfig[self.cityType].poke.detail) do
        if v then
            local it = self.pokerItems[idx]
            it.gameType = k
            it:setSelected(idx == 1)
            it:show()

            local btxt = findText(it.transform, "Background/Text")
            local ctxt = findText(it.transform, "Checkmark/Text")
            btxt:setText(gameName[self.cityType].games[k])
            ctxt:setText(gameName[self.cityType].games[k])

            idx = idx + 1
        end
    end
end

function createDesk:onGameDetailChangedHandler(sender, selected, clicked)
    if clicked then
        self.gameType = sender.gameType

        self.config = self:readConfig()
        self:createDetail()
        self:onGameTypeChanged()

        playButtonClickSound()
    end
end

function createDesk:onCreateClickedHandler()
    local choose = self.detail:getCreateConfig()
    choose.Game = self.gameType
    self.config[self.gameType] = choose
--    log("createDesk:onCreateClickedHandler, choose = " .. table.tostring(choose))
    local friendsterId = self.friendsterId == nil and 0 or self.friendsterId

    showWaitingUI("正在创建房间，请稍候...")
    
    local eventName = "createdesk_" .. tostring(self.cityType) .. "_" .. tostring(self.gameType)
    talkingData.event(eventName, choose, true)

    networkManager.createDesk(self.cityType, choose, friendsterId, function(msg)
        closeWaitingUI()
        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("create desk, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        enterDesk(msg.GameType, msg.DeskId)
        self:close()
    end)

    gamepref.setSelectedGameType(self.friendsterId, self.gameType)
    self:writeConfig()

    playButtonClickSound()
end

function createDesk:createDetail()
    if self.detail == nil then
        self.detail = require("ui.deskDetail.deskDetailPanel").new(true, function(renshu, jushu)
            local cost = self:getCost(renshu, jushu)
            self.mCost:setText(tostring(cost))
        end, self)
        self.detail:setParent(self.mDetailRoot)
    end
    
    local layout = deskConfigLayout[self.cityType][self.gameType]
    local config = self.config[self.gameType]

    if self.friendsterData then
        local has, cfg = self.friendsterData:isSupportGame(self.gameType)
        if has and cfg ~= nil and cfg ~= "" then
            local cfgJson = table.fromjson(cfg)
            if self.gameType == gameType.mahjong then
                if cfgJson.JuShu > 2 then
                    cfgJson.JuShu = 2
                end
                if cfgJson.FengDing > 2 then
                    cfgJson.FengDing = 2
                end
            end
            config = cfgJson
        end
    end

    self.detail:set(self.cityType, self.gameType, layout, config)
    self.detail:show()
    self:updateCost()
end

function createDesk:getCost(renshu, jushu)
    local price = costConfig.prices[self.cityType][self.gameType][renshu][jushu]
    local discount = costConfig.discounts[self.cityType][self.gameType]

    return price * discount
end

function createDesk:readConfig()
    local config = detailConfigs[self.cityType]

    if config == nil then
        local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, CONFIGS_FOLDER, cityTypeSID[self.cityType] .. ".txt")
        local text = LFS.ReadText(path, LFS.UTF8_WITHOUT_BOM)

        if string.isNilOrEmpty(text) then
            config = deskConfig[self.cityType]
        else
            config = loadstring(text)()

            --麻将屏蔽掉16局和5番
            if self.gameType == gameType.mahjong then
                local c = config[gameType.mahjong]
                if c.JuShu == 3 then
                    c.JuShu = 2
                end

                if c.FengDing == 3 then
                    c.FengDing = 2
                end
            end
        end
    end

    local gc = config[self.gameType]
    if gc == nil then
        gc = deskConfig[self.cityType][self.gameType]
        config[self.gameType] = gc
    end

    detailConfigs[self.cityType] = config
    return config
end

function createDesk:writeConfig()
    local text = table.tostring(self.config)
    if not string.isNilOrEmpty(text) then
        text = "return " .. text

        local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, CONFIGS_FOLDER, cityTypeSID[self.cityType] .. ".txt")
        LFS.WriteText(path, text, LFS.UTF8_WITHOUT_BOM)
    end
end

function createDesk:onCloseAllUIHandler()
    self:close()
end

function createDesk:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    if self.gameItems ~= nil then
        for _, v in pairs(self.gameItems) do
            v.toggle:destroy()
        end
    end
    if self.mahjongItems ~= nil then
        for _, v in pairs(self.mahjongItems) do
            v:destroy()
        end
    end
    if self.changpaiItems ~= nil then
        for _, v in pairs(self.changpaiItems) do
            v:destroy()
        end
    end
    if self.pokerItems ~= nil then
        for _, v in pairs(self.pokerItems) do
            v:destroy()
        end
    end
    
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end

    base.onDestroy(self)
end

return createDesk

--endregion
