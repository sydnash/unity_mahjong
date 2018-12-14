--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberInfo = class("friendsterMemberInfo", base)

_RES_(friendsterMemberInfo, "FriendsterUI", "FriendsterMemberInfoUI")

function friendsterMemberInfo:ctor(friendsterId, managerId, data)
    self.friendsterId = friendsterId
    self.managerId = managerId
    self.data = data

    self.super.ctor(self)
end

function friendsterMemberInfo:onInit()
    self.mIp:hide()
    self.mExit:hide()
    self.mDissolve:hide()
    self.mDelete:hide()

    self.mIcon:setTexture(self.data.headerTex)
    -- self.mSex:setSprite("boy")
    self.mSex:hide()
    self.mNickname:setText(self.data.nickname)

    if self.managerId == self.data.acId then
        self.mQz:show()

        if self.data.acId == gamepref.player.acId then
            self.mDissolve:show()
        else
            self.mExit:show()
        end
    else
        self.mQz:hide()

        if self.managerId == gamepref.player.acId then
            self.mDelete:show()
        end
    end

    self.mId:setText(string.format("账号:%d", self.data.acId))

    if not string.isNilOrEmpty(self.data.ip) then
        self.mIp:show()
        self.mIp:setText(string.format("IP:%s", self.data.ip))
    end

    self.mTotalCount:setText(string.format("总局数:%d", self.data.totalPlayTimes))

    local winRate = (self.data.totalPlayTimes == 0) and 0 or math.floor(self.data.winPlayTimes / self.data.totalPlayTimes * 100)
    self.mWinRate:setText(string.format("胜率:%d%%", winRate))

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterMemberInfo:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function friendsterMemberInfo:onExitClickedHandler()
    showMessageUI(string.format("是否确定要退出亲友圈[%d]？", self.friendsterId),
                  function()
                      showWaitingUI("正在退出亲友圈，请稍候")
                      networkManager.exitFriendster(self.friendsterId, function(msg)
                          closeWaitingUI()
                          showMessageUI(string.format("已经成功退出亲友圈[%d]", self.friendsterId))
                          signalManager.signal(signalType.friendsterExitedSignal, self.friendsterId)
                          self:close()
                      end)
                  end,
                  function()
                  end)
    playButtonClickSound()
end

function friendsterMemberInfo:onDissolveClickedHandler()
    showMessageUI("是否确定要解散亲友圈？",
                  function()
                      showWaitingUI("正在解散亲友圈，请稍候")
                      networkManager.dissolveFriendster(self.friendsterId, function(msg)
                          closeWaitingUI()
                          showMessageUI(string.format("已经成功解散亲友圈[%d]", self.friendsterId))
                          self:close()
                      end)
                  end,
                  function()
                  end)
    playButtonClickSound()
end

function friendsterMemberInfo:onDeleteClickedHandler()
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

    playButtonClickSound()
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
