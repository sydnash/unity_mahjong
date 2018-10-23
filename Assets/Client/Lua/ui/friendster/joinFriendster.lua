--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local joinFriendster = class("joinFriendster", base)

_RES_(joinFriendster, "FriendsterUI", "JoinFriendsterUI")

function joinFriendster:ctor()
    self.super.ctor(self)
end

function joinFriendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mQuery:addClickListener(self.onQueryClickedHandler, self)
    self.mJoin:addClickListener(self.onJoinClickedHandler, self)
end

function joinFriendster:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function joinFriendster:onQueryClickedHandler()
    playButtonClickSound()

    local id = tonumber(self.mId:getText())
    local vc = self.mVerification:getText()

    showWaitingUI("正在查询亲友圈信息，请稍候")
    networkManager.queryFriendsterInfo(id, vc, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("query friendster info, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.Ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end
        
        self.mName:setText(msg.ClubName)
    end)
end

function joinFriendster:onJoinClickedHandler()
    playButtonClickSound()

    local id = tonumber(self.mId:getText())
    local vc = self.mVerification:getText()

    showWaitingUI("正在加入亲友圈，请稍候")
    networkManager.joinFriendster(id, vc, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("join friendster, msg = " .. table.tostring(msg))

        showMessageUI("加入亲友圈申请发送成功，等待群主审核")
        self:close()
    end)
end

return joinFriendster

--endregion
