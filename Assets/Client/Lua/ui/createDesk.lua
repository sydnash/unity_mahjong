--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local createDesk = class("createDesk", base)

_RES_(createDesk, "CreateDeskUI", "CreateDeskUI")

function createDesk:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function createDesk:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
end

function createDesk:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function createDesk:onCreateClickedHandler()
    playButtonClickSound()

    local loading = require("ui.loading").new()
    loading:show()

    local choose = self.config[gameTypeSID[self.gameType]]
--    log("create desk, choose = " .. table.tostring(choose))
    local friendsterId = self.friendsterId == nil and 0 or self.friendsterId

    networkManager.createDesk(self.cityType, self.gameType, choose, friendsterId, function(ok, msg)
        if not ok then
            loading:close()
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

--        log("create desk, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
            loading:close()
            showMessageUI(retcText[msg.RetCode])
            return
        end

        signalManager.signal(signalType.enterDesk, { cityType = msg.GameType, deskId = msg.DeskId, loading = loading })
        self:close()
    end)

    self:writeConfig()

    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end
end

function createDesk:set(cityType, friendsterId)
    self.cityType = cityType
    self.gameType = gameType.mahjong
    self.friendsterId = friendsterId

    self.config = self:readConfig()
    self:createDetail()
end

function createDesk:createDetail()
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end
    
    local path = string.format("ui.createDesk.%s.createDeskDetail_%s", gameTypeSID[self.gameType], cityTypeSID[self.cityType])
    
    self.detail = require(path).new()
    self.detail:setParent(self.mDetailRoot)
    self.detail:set(self.config[gameTypeSID[self.gameType]])
    self.detail:show()
end

function createDesk:readConfig()
    local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "CreateDeskConfigs", cityTypeSID[self.cityType] .. ".txt")
    local text = LFS.ReadText(path, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        return require("config.createDeskConfig")
    end

    return loadstring(text)()
end

function createDesk:writeConfig()
    local text = table.tostring(self.config)
    if not string.isNilOrEmpty(text) then
        text = "return " .. text

        local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "CreateDeskConfigs", cityTypeSID[self.cityType] .. ".txt")
        LFS.WriteText(path, text, LFS.UTF8_WITHOUT_BOM)
    end
end

function createDesk:onDestroy()
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end

    self.super.onDestroy(self)
end

return createDesk

--endregion
