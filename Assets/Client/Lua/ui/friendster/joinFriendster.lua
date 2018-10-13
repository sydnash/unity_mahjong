--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local joinFriendster = class("joinFriendster", base)

_RES_(joinFriendster, "FriendsterUI", "JoinFriendsterUI")

function joinFriendster:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function joinFriendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mQuery:addClickListener(self.onQueryClickedHandler, self)
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

        if msg.RetCode ~= retc.Ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end
        
        log("friendster jioned, msg = " .. table.tostring(msg))
        if self.callback ~= nil then
            msg.RetCode = nil
            self.callback(msg)
        end

        self:close()
    end)
end

function joinFriendster:onJoinClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在创建亲友圈，请稍候")
    networkManager.createFriendster(self.cityId, self.mName:getText(), function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        if msg.RetCode ~= retc.Ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI("亲友圈创建成功，快拉亲友们进圈吧")
        self:close()
    end)
end

return joinFriendster

--endregion
