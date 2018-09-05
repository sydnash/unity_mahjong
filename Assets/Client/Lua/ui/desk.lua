--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongGame   = require("logic.mahjong.mahjongGame")

local base = require("ui.common.view")
local desk = class("desk", base)

desk.folder = "DeskUI"
desk.resource = "DeskUI"

function desk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function desk:onInit()
    local players = { 
        { nickname = self.mNicknameM, score = self.mScoreM, },
        { nickname = self.mNicknameR, score = self.mScoreR, p = self.mPlayerR_P, u = self.mPlayerR_U, },
        { nickname = self.mNicknameT, score = self.mScoreT, p = self.mPlayerT_P, u = self.mPlayerT_U, },
        { nickname = self.mNicknameL, score = self.mScoreL, p = self.mPlayerL_P, u = self.mPlayerL_U, },
    }

    local playerCount = self.game:getPlayerCount()

    for i=2, #players do
        players[i].p:hide()

        if playerCount == 4 then
            players[i].u:show()
        elseif playerCount == 3 then
            if i % 2 == 0 then
                players[i].u:show()
            else
                players[i].u:hide()
            end
        elseif playerCount == 2 then
            if i % 2 == 0 then
                players[i].u:hide()
            else
                players[i].u:show()
            end
        end
    end

    self.mDeskID:setText("房号:" .. tostring(self.game.deskId))
    self:updateCurrentGameIndex()
    self.mTime:setText(time.formatTime())

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatType(v.turn)
        local p = players[s + 1]

        if s ~= mahjongGame.seatType.mine then
            p.p:show()
            p.u:hide()
        end

        p.nickname:setText(v.nickname)
        p.score:setText("分数:" .. tostring(v.score))
    end

    self.mReady:addClickListener(self.onReadyClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
end

function desk:onReadyClickedHandler()
    playButtonClickSound()
    self.game:ready(true)
end

function desk:onCancelClickedHandler()
    playButtonClickSound()
    self.game:ready(false)
end

function desk:onSettingClickedHandler()
    playButtonClickSound()

    local ui = require("ui.setting").new(self.game)
    ui:show()
end

function desk:setReady(acId, ready)
    if acId == gamepref.acId then
        if ready then
            self.mReady:hide()
            self.mCancel:show()
        else
            self.mReady:show()
            self.mCancel:hide()
        end
    else
        --其他的准备状态改变
    end
end

function desk:setNickname(seat, nickname)
    if seat == mahjongGame.seatType.mine then
        self.mNicknameM:setText(nickname)
    elseif seat == mahjongGame.seatType.right then
        self.mNicknameR:setText(nickname)
    elseif seat == mahjongGame.seatType.top then
        self.mNicknameT:setText(nickname)
    else
        self.mNicknameL:setText(nickname)
    end
end

function desk:onGameStart()
    self.mReady:hide()
    self.mCancel:hide()
end

function desk:reset()
    self.mReady:show()
    self.mCancel:hide()
end

function desk:update()
    self.mTime:setText(time.formatTime())
end

function desk:updateCurrentGameIndex()
    local totalGameCount = self.game:getTotalGameCount()
    local leftGameCount = self.game:getLeftGameCount()
    local currentGameIndex = totalGameCount - leftGameCount + 1

    self.mGameCount:setText("第" .. tostring(currentGameIndex) .. "/" .. tostring(totalGameCount) .. "局")
end

return desk

--endregion
