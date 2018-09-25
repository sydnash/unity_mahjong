--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local exitDeskState = require("const.exitDeskState")

local base = require("ui.common.view")
local exitDesk = class("exitDesk", base)

_RES_(exitDesk, "ExitDeskUI", "ExitDeskUI")

function exitDesk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function exitDesk:onInit()
    self.leftSeconds = self.game.leftVoteSeconds / 1000
    self.timestamp = time.realtimeSinceStartup()

    local items = { self.mItemA, self.mItemB, self.mItemC, self.mItemD, }
    self.items = {}

    for k, v in pairs(self.game.players) do
        if self.game.exitVoteProposer == v.acId then
            self.mProposer:setText(v.nickname)
            v.exitVoteState = -1
        end

        local item = items[k+1]
        item:setPlayerInfo(v)
        self.items[v.turn] = item
    end

    if self.game.exitVoteProposer == gamepref.acId then
        self.mAgree:setInteractabled(false)
        self.mReject:setInteractabled(false)
        self.mAgreeC:setSprite("JS_zi02_h")
        self.mRejectC:setSprite("JS_zi01_h")
    else
        self.mAgree:setInteractabled(true)
        self.mReject:setInteractabled(true)
        self.mAgreeC:setSprite("JS_zi02")
        self.mRejectC:setSprite("JS_zi01")
        self.mAgree:addClickListener(self.onAgreeClickedHandler, self)
        self.mReject:addClickListener(self.onRejectClickedHandler, self)
    end
end

function exitDesk:setPlayerState(player)
    local item = self.items[player.turn]

    if player.acId == self.game.exitVoteProposer then
        item:setState(-1)
    else
        item:setState(player.exitVoteState)
    end
end

function exitDesk:onAgreeClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)
    self.mAgreeC:setSprite("JS_zi02_h")
    self.mRejectC:setSprite("JS_zi01_h")

    local player = self.game:getPlayerByAcId(gamepref.acId)
    self.items[player.turn]:setState(exitDeskState.agree)

    self.game:agreeExit()
end

function exitDesk:onRejectClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)
    self.mAgreeC:setSprite("JS_zi02_h")
    self.mRejectC:setSprite("JS_zi01_h")

    local player = self.game:getPlayerByAcId(gamepref.acId)
    self.items[player.turn]:setState(exitDeskState.reject)

    self.game:rejectExit()
end

function exitDesk:update()
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

return exitDesk

--endregion
