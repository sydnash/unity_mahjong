--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local deskDetail = class("deskDetail", base)

_RES_(deskDetail, "DeskDetailUI", "DeskDetailUI")

function deskDetail:ctor(cityType, gameType, config, join, deskId)
    self.cityType = cityType
    self.gameType = gameType
    self.join = join
    self.deskId = deskId

    self.config = {}
    for k, v in pairs(config) do
        local c = deskDetailShiftConfig[cityType][gameType][k]
        if c ~= nil then
            self.config[k] = c[v]
        end
    end

    self.super.ctor(self)
end

function deskDetail:onInit()
    local layout = deskDetailLayout[self.cityType][self.gameType]
    local config = self.config

    self.detail = require("ui.deskDetail.deskDetailPanel").new(layout, config, false)
    if self.join then
        self.mDetailRoot:hide()
        self.mDetailRoot2:show()
        self.detail:setParent(self.mDetailRoot2)
    else
        self.mDetailRoot:show()
        self.mDetailRoot2:hide()
        self.detail:setParent(self.mDetailRoot)
    end
    self.detail:show()

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mJoin:addClickListener(self.onJoinClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function deskDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function deskDetail:onJoinClickedHandler()
    playButtonClickSound()

    local loading = require("ui.loading").new()
    loading:show()

    signalManager.signal(signalType.enterDesk, { cityType = self.cityType, deskId = self.deskId, loading = loading })
    self:close()
end

function deskDetail:onCloseAllUIHandler()
    self:close()
end

function deskDetail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end

    self.super.onDestroy(self)
end

return deskDetail

--endregion
