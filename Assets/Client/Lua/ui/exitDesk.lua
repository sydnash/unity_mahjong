--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local exitDesk = class("exitDesk", base)

exitDesk.folder = "ExitDeskUI"
exitDesk.resource = "ExitDeskUI"

local WAITING_COLOR = Color.New(165 / 255, 82  / 255, 27 / 255, 1)
local AGREE_COLOR   = Color.New(71  / 255, 146 / 255, 37 / 255, 1)
local REJECT_COLOR  = Color.New(226 / 255, 54  / 255, 50 / 255, 1)

function exitDesk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function exitDesk:onInit()
    self.leftSeconds = self.game.leftVoteSeconds / 1000
    self.timestamp = time.realtimeSinceStartup()
    self.states = {}

    local players = { { icon = self.mHeaderA, nickname = self.mNicknameA, state = self.mStateA },
                      { icon = self.mHeaderB, nickname = self.mNicknameB, state = self.mStateB },
                      { icon = self.mHeaderC, nickname = self.mNicknameC, state = self.mStateC },
                      { icon = self.mHeaderD, nickname = self.mNicknameD, state = self.mStateD },
    }
    self.players = players

    for k, v in pairs(self.game.players) do
        local p = players[k+1]

        p.icon:setTexture(v.headerTex)
        p.nickname:setText(v.nickname)

        self.states[v.turn] = p.state
        self:setPlayerState(v)

        if self.game.exitVoteProposer == v.acId then
            self.mProposer:setText(v.nickname)
        end
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
    local state = self.states[player.turn]

    if player.acId == self.game.exitVoteProposer then
        state:setText("申请解散")
        state:setColor(AGREE_COLOR)
    else
        if player.exitVoteState == 0 then
            state:setText("等待选择")
            state:setColor(WAITING_COLOR)
        elseif player.exitVoteState == 1 then
            state:setText("同意解散")
            state:setColor(AGREE_COLOR)
        else
            state:setText("拒绝解散")
            state:setColor(REJECT_COLOR)
        end
    end
end

function exitDesk:onAgreeClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)

    self.game:agreeExit()
end

function exitDesk:onRejectClickedHandler()
    self.mAgree:setInteractabled(false)
    self.mReject:setInteractabled(false)

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

function exitDesk:onDestroy()
    for _, v in pairs(self.players) do
        v.icon:setTexture(nil)
    end
end

return exitDesk

--endregion
