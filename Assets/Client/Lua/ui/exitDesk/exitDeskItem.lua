--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local exitDeskItem = class("exitDeskItem", base)

local WAITING_COLOR = Color.New(165 / 255, 82  / 255, 27 / 255, 1)
local AGREE_COLOR   = Color.New(71  / 255, 146 / 255, 37 / 255, 1)
local REJECT_COLOR  = Color.New(226 / 255, 54  / 255, 50 / 255, 1)

function exitDeskItem:onInit()
    self:reset()
end

function exitDeskItem:setPlayerInfo(player)
    self.mIcon:setTexture(player.acId, player.headerTex)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self:setState(player.exitVoteState)
end

function exitDeskItem:setState(state)
    if state == exitDeskStatus.proposer then
        self.mState:setText("申请解散")
        self.mState:setColor(AGREE_COLOR)
    elseif state == exitDeskStatus.agree then
        self.mState:setText("同意解散")
        self.mState:setColor(AGREE_COLOR)
    elseif state == exitDeskStatus.reject then
        self.mState:setText("拒绝解散")
        self.mState:setColor(REJECT_COLOR)
    else
        self.mState:setText("等待选择")
        self.mState:setColor(WAITING_COLOR)
    end
end

function exitDeskItem:reset()
    self.mState:setText("等待选择")
    self.mState:setColor(WAITING_COLOR)
end

function exitDeskItem:onDestroy()
    self.mIcon:setTexture(nil)
    self.super.onDestroy(self)
end

return exitDeskItem

--endregion
