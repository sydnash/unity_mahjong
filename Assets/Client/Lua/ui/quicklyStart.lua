--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local quicklyStart = class("quicklyStart", base)

_RES_(quicklyStart, "QuicklyStartUI", "QuicklyStartUI")

function quicklyStart:ctor(game)
    self.game = game
    base.ctor(self)
end

function quicklyStart:onInit()
    self.leftSeconds = self.game.quicklyStartVoteSeconds / 1000
    self.timestamp = time.realtimeSinceStartup()

    local items = { self.mItemA, self.mItemB, self.mItemC, self.mItemD, }
    self.items = {}

    local i = 0
    for k, v in pairs(self.game.players) do
        i = i + 1
        if self.game.quicklyStartVoteProposer == v.acId then
            self.mProposer:setText(v.nickname)
            v.exitVoteState = quicklyStartStatus.proposer
        end

        local item = items[i]
        item:show()
        item:setPlayerInfo(v)
        self.items[v.acId] = item
    end
    for j = i + 1, 4 do
        items[j]:hide()
    end

    if self.game.quicklyStartVoteProposer == gamepref.acId then
        self.mAgree:setInteractabled(false)
        self.mReject:setInteractabled(false)
        self.mAgreeC:setSprite("ks_ks_h")
        self.mRejectC:setSprite("ks_jj_h")
    else
        self.mAgree:setInteractabled(true)
        self.mReject:setInteractabled(true)
        self.mAgreeC:setSprite("ks_ks")
        self.mRejectC:setSprite("ks_jj")
        self.mAgree:addClickListener(self.onAgreeClickedHandler, self)
        self.mReject:addClickListener(self.onRejectClickedHandler, self)
    end

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function quicklyStart:setPlayerState(player)
    local item = self.items[player.acId]

    if player.acId == self.game.quicklyStartVoteProposer then
        item:setState(-1)
    else
        item:setState(player.quicklyStartVoteState)
    end
end

function quicklyStart:onAgreeClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)
    self.mAgreeC:setSprite("ks_ks")
    self.mRejectC:setSprite("ks_jj")

    local player = self.game:getPlayerByAcId(gamepref.acId)
    self.items[player.acId]:setState(quicklyStartStatus.agree)

    networkManager.quicklyStartChose(true)
end

function quicklyStart:onRejectClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)
    self.mAgreeC:setSprite("ks_ks_h")
    self.mRejectC:setSprite("ks_jj_h")

    local player = self.game:getPlayerByAcId(gamepref.acId)
    self.items[player.acId]:setState(quicklyStartStatus.reject)

    networkManager.quicklyStartChose(false)
end

function quicklyStart:update()
    local countdown = self.leftSeconds - (time.realtimeSinceStartup() - self.timestamp)

    local m = math.floor(countdown / 60)
    local s = math.floor(countdown % 60)

    self.mMinuteH:setText(tostring(math.floor(m / 10)))
    self.mMinuteL:setText(tostring(m % 10))
    self.mSecondH:setText(tostring(math.floor(s / 10)))
    self.mSecondL:setText(tostring(s % 10))

    if countdown <= 0 then
        self.game:agreeExit()
        self:close()
    end
end

function quicklyStart:onCloseAllUIHandler()
    self:close()
end

function quicklyStart:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return quicklyStart

--endregion
