--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local exitDesk = class("exitDesk", base)

exitDesk.folder = "ExitDeskUI"
exitDesk.resource = "ExitDeskUI"

local WAITING_COLOR = Color.New(165, 82, 27, 255)
local AGREE_COLOR   = Color.New(71, 146, 37, 255)
local REJECT_COLOR  = Color.New(226, 54, 50, 255)

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

    local idx = 1
    for k, v in pairs(self.game.players) do
        local p = players[idx]
        p.nickname:setText(v.Nickname)

        self.states[k] = p.state
        self:setPlayerState(v)

        idx = idx + 1
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
    self.game:agreeExit()
end

function exitDesk:onRejectClickedHandler()
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
