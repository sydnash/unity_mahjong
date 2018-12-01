--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberInfo = class("friendsterMemberInfo", base)

_RES_(friendsterMemberInfo, "FriendsterUI", "FriendsterMemberInfoUI")

function friendsterMemberInfo:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)

    self.mIp:hide()
    self.mQz:hide()
    self.mExit:hide()
    self.mDissolve:hide()
    self.mDelete:hide()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterMemberInfo:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMemberInfo:onExitClickedHandler()
    playButtonClickSound()
    
    networkManager.exitFriendster(self.friendsterId, function(msg)
--        log("exit friendster, msg = " .. table.tostring(msg))
        signalManager.signal(signalType.friendsterExitedSignal, self.friendsterId)
        self:close()
    end)
end

function friendsterMemberInfo:onDissolveClickedHandler()
    playButtonClickSound()

    networkManager.dissolveFriendster(self.friendsterId, function(msg)
--        log("dissolve friendster, msg = " .. table.tostring(msg))
        self:close()
    end)
end

function friendsterMemberInfo:onDeleteClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在将玩家从亲友圈中删除，请稍候")
    networkManager.deleteAcIdFromFriendster(self.friendsterId, self.data.acId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("delete player from friendster, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI("玩家已经从亲友圈中删除")
        self:close()
    end)
end

function friendsterMemberInfo:set(friendsterId, managerId, data)
    self.friendsterId = friendsterId
    self.data = data

    self.mIcon:setTexture(data.headerTex)
    self.mSex:setSprite("boy")
    self.mNickname:setText(data.nickname)

    if managerId == data.acId then
        self.mQz:show()

        if data.acId == gamepref.player.acId then
            self.mDissolve:show()
        else
            self.mExit:show()
        end
    else
        self.mQz:hide()
        self.mDelete:show()
    end

    self.mId:setText(string.format("账号:%d", data.acId))

    if not string.isNilOrEmpty(data.ip) then
        self.mIp:show()
        self.mIp:setText(string.format("IP:%s", data.ip))
    end

    self.mTotalCount:setText(string.format("总局数:%d", data.totalPlayTimes))

    local winRate = (data.totalPlayTimes == 0) and 0 or math.floor(data.winPlayTimes / data.totalPlayTimes * 100)
    self.mWinRate:setText(string.format("胜率:%d%%", winRate))
end

function friendsterMemberInfo:onCloseAllUIHandler()
    self:close()
end

function friendsterMemberInfo:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end 

return friendsterMemberInfo

--endregion
