--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local deskDetail = class("deskDetail", base)

_RES_(deskDetail, "DeskDetailUI", "DeskDetailUI")

function deskDetail:ctor(cityType, gameType, friendsterId, config, join, deskId, managerAcId)
    self.cityType = cityType
    self.gameType = gameType
    self.friendsterId = friendsterId
    self.join = join
    self.deskId = deskId
    self.managerAcId = managerAcId

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

        if self.managerAcId == gamepref.player.acId then 
            self.mDissolve:show()
        else
            self.mDissolve:hide()
        end
    else
        self.mDetailRoot:show()
        self.mDetailRoot2:hide()
        self.detail:setParent(self.mDetailRoot)
    end
    self.detail:show()

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mJoin:addClickListener(self.onJoinClickedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function deskDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function deskDetail:onJoinClickedHandler()
    playButtonClickSound()

    enterDesk(self.cityType, self.deskId)
    self:close()
end

function deskDetail:onDissolveClickedHandler()
    playButtonClickSound()

    networkManager.dissolveFriendsterDesk(self.friendsterId, self.cityType, self.deskId, function(msg)
        if msg == nil then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI(string.format("房间[%d]已经解散", self.deskId))
    end)
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
