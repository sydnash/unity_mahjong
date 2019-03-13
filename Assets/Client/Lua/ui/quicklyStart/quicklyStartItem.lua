--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local quicklyStartItem = class("quicklyStartItem", base)

local WAITING_COLOR = Color.New(165 / 255, 82  / 255, 27 / 255, 1)
local AGREE_COLOR   = Color.New(71  / 255, 146 / 255, 37 / 255, 1)
local REJECT_COLOR  = Color.New(226 / 255, 54  / 255, 50 / 255, 1)

function quicklyStartItem:onInit()
    self:reset()
end

function quicklyStartItem:setPlayerInfo(player)
    self.mIcon:setTexture(player.headerUrl)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self:setState(player.quicklyStartVoteState)
end

function quicklyStartItem:setState(state)
    if state == exitDeskStatus.proposer then
        self.mState:setText("申请开局")
        self.mState:setColor(AGREE_COLOR)
    elseif state == exitDeskStatus.agree then
        self.mState:setText("同意开局")
        self.mState:setColor(AGREE_COLOR)
    elseif state == exitDeskStatus.reject then
        self.mState:setText("拒绝开局")
        self.mState:setColor(REJECT_COLOR)
    else
        self.mState:setText("等待选择")
        self.mState:setColor(WAITING_COLOR)
    end
end

function quicklyStartItem:reset()
    self.mState:setText("等待选择")
    self.mState:setColor(WAITING_COLOR)
end

return quicklyStartItem

--endregion
