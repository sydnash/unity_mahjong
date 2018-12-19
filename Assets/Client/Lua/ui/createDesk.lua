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

function createDesk:ctor(cityType, friendsterId)
    self.cityType = cityType
    self.gameType = gameType.mahjong
    self.friendsterId = friendsterId

    base.ctor(self)
end

function createDesk:onInit()
    local c = enableConfig[self.cityType]

    if c.mahjong.enable then
        self.mMahjong:show()
        self.mMahjong:setSelected(true)
    else
        self.mMahjong:hide()
    end

    if c.changpai.enable then
        self.mChangpai:show()

        if c.mahjong.enable then
            self.mChangpai:setSelected(false)
        else
            self.mChangpai_S:setSelected(true)
        end
    else
        self.mChangpai:hide()
    end

    self.mMahjongPanel:show()
    self.mChangpaiPanel:hide()

    self.config = self:readConfig()
    self:createDetail()

    local gameConfig = self.config[self.gameType]
    local renshu = gameConfig.RenShu
    local jushu  = gameConfig.JuShu

    local cost = costConfig[self.cityType][self.gameType][renshu][jushu]
    self.mCost:setText(tostring(cost))

    self.mMahjong:addChangedListener(self.onMahjongChangedHandler, self)
    self.mChangpai:addChangedListener(self.onChangpaiChangedHandler, self)
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function createDesk:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function createDesk:onMahjongChangedHandler(sender, selected, clicked)
    if clicked then
        self.gameType = gameType.mahjong

        self.config = self:readConfig()
        self:createDetail()

        self.mMahjongPanel:show()
        self.mChangpaiPanel:hide()

        playButtonClickSound()
    end
end

function createDesk:onChangpaiChangedHandler(sender, selected, clicked)
    if clicked then
        self.gameType = gameType.doushisi

        self.config = self:readConfig()
        self:createDetail()

        self.mMahjongPanel:hide()
        self.mChangpaiPanel:show()

        playButtonClickSound()
    end
end

function createDesk:onCreateClickedHandler()
    local choose = table.clone(self.config[self.gameType])
    choose.Game = self.gameType
    local friendsterId = self.friendsterId == nil and 0 or self.friendsterId

    showWaitingUI("正在创建房间，请稍候...")
    
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

    self:writeConfig()
    playButtonClickSound()
end

function createDesk:createDetail()
    if self.detail == nil then
        self.detail = require("ui.deskDetail.deskDetailPanel").new(true, function(renshu, jushu)
            local cost = costConfig[self.cityType][self.gameType][renshu][jushu]
            self.mCost:setText(tostring(cost))
        end)
        self.detail:setParent(self.mDetailRoot)
    end
    
    local layout = deskConfigLayout[self.cityType][self.gameType]
    local config = self.config[self.gameType]

    self.detail:set(layout, config)
    self.detail:show()
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
    
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end

    base.onDestroy(self)
end

return createDesk

--endregion
