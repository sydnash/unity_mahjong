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
    self.mId:addChangedListener(self.onIdChangedHandler, self)
    self.mVerification:addChangedListener(self.onVerificationChangedHandler, self)

    self.mId:setText(string.empty)
    self.mVerification:setText(string.empty)

    self:refreshJoinState()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
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
    networkManager.queryFriendsterInfo(id, vc, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("query friendster info, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
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
    networkManager.joinFriendster(id, vc, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("join friendster, msg = " .. table.tostring(msg))

        showMessageUI("加入亲友圈申请发送成功，等待群主审核")
        self:close()
    end)
end

function joinFriendster:onIdChangedHandler()
    self:refreshJoinState()
end

function joinFriendster:onVerificationChangedHandler()
    self:refreshJoinState()
end

function joinFriendster:refreshJoinState()
    local id = self.mId:getText()
    local code = self.mVerification:getText()

    if string.isNilOrEmpty(id) or string.isNilOrEmpty(code) then
        self.mJoin:setInteractabled(false)
        self.mJoinZ:setSprite("gray")
    else
        self.mJoin:setInteractabled(true)
        self.mJoinZ:setSprite("light")
    end
end

function joinFriendster:onCloseAllUIHandler()
    self:close()
end

function joinFriendster:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return joinFriendster

--endregion
