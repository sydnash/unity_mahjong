--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local deskDetail = class("deskDetail", base)

_RES_(deskDetail, "DeskDetailUI", "DeskDetailUI")

function deskDetail:ctor(cityType, gameType, friendsterId, config, canJoin, deskId, managerAcId)
    self.cityType = cityType
    self.gameType = gameType
    self.friendsterId = friendsterId
    self.canJoin = canJoin
    self.deskId = deskId
    self.managerAcId = managerAcId

    self.config = {}
    for k, v in pairs(config) do
        local c = deskShiftConfig[cityType][gameType][k]
        if c ~= nil then
            self.config[k] = c[v]
        end
    end

    self.super.ctor(self)
end

function deskDetail:onInit()
    local layout = deskConfigLayout[self.cityType][self.gameType]
    local config = self.config

    self.detail = require("ui.deskDetail.deskDetailPanel").new(layout, config, false)
    if self.friendsterId ~= nil and self.friendsterId > 0 then
        self.mDetailRoot:hide()
        self.mDetailRoot2:show()
        self.detail:setParent(self.mDetailRoot2)

        if self.managerAcId == gamepref.player.acId then 
            self.mDissolve:show()
        else
            self.mDissolve:hide()
        end

        if self.deskId == gamepref.player.currentDesk.deskId then
            self.mJoin:hide()
            self.mReturn:show()
        else
            self.mJoin:hide()
            self.mReturn:show()
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
    self.mReturn:addClickListener(self.onRerurnClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function deskDetail:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function deskDetail:onJoinClickedHandler()
    if self.canJoin then
        enterDesk(self.cityType, self.deskId)
        self:close()
    else
        showMessageUI("人数已满，无法加入该房间")
    end

    playButtonClickSound()
end

function deskDetail:onRerurnClickedHandler()
    enterDesk(self.cityType, self.deskId)
    self:close()

    playButtonClickSound()
end

function deskDetail:onDissolveClickedHandler()
    showWaitingUI("正在关闭房间")

    networkManager.dissolveFriendsterDesk(self.friendsterId, self.cityType, self.deskId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI(string.format("房间[%d]已经解散", self.deskId))
    end)

    self:close()
    playButtonClickSound()
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
