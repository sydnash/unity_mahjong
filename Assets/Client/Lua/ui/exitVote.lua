--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local exitVote = class("exitVote", base)

exitVote.folder = "ExitVoteUI"
exitVote.resource = "ExitVoteUI"

function exitVote:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function exitVote:onInit()
    self.mAgree:addClickListener(self.onAgreeClickedHandler, self)
    self.mReject:addClickListener(self.onRejectClickedHandler, self)
end

function exitVote:onAgreeClickedHandler()
    self.game:agreeExit()
end

function exitVote:onRejectClickedHandler()
    self.game:rejectExit()
end

return exitVote

--endregion
