--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberInfo = class("friendsterMemberInfo", base)

_RES_(friendsterMemberInfo, "FriendsterUI", "FriendsterMemberInfoUI")

function friendsterMemberInfo:ctor(friendster, member)
    self.friendster = friendster
    self.member = member

    base.ctor(self)
end

function friendsterMemberInfo:onInit()
    self.mIp:hide()
    self.mQz:hide()
    self.mExit:hide()
    self.mDissolve:hide()
    self.mDelete:hide()
    self.mTobeManager:hide()
    self.mTobeMember:hide()

    self.mIcon:setTexture(self.member.headerUrl)
    self.mSex:hide()
    self.mNickname:setText(self.member.nickname)

    if self:isCreator(self.member.acId) or self:isManager(self.member.acId) then
        if self:isCreator(self.member.acId) then
            self.mQz:show()

            if self.member.acId == gamepref.player.acId then
                self.mDissolve:show()
            else
                self.mExit:show()
            end
        else
            self.mExit:show()

            if self.member.acId == gamepref.player.acId then
                --
            elseif self:isCreator(gamepref.player.acId) or self:isManager(gamepref.player.acId) then
                self.mTobeMember:show()
            end
        end
    else
        if self:isCreator(gamepref.player.acId) or self:isManager(gamepref.player.acId) then
            self.mDelete:show()
            self.mTobeManager:show()
        end
    end

    self.mId:setText(string.format("账号:%d", self.member.acId))

    if not string.isNilOrEmpty(self.member.ip) then
        self.mIp:show()
        self.mIp:setText(string.format("IP:%s", self.member.ip))
    end

    self.mTotalCount:setText(string.format("总局数:%d", self.member.totalPlayTimes))

    local winRate = (self.member.totalPlayTimes == 0) and 0 or math.floor(self.member.winPlayTimes / self.member.totalPlayTimes * 100)
    self.mWinRate:setText(string.format("胜率:%d%%", winRate))

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)
    self.mTobeManager:addClickListener(self.onTobeManagerClickedHandler, self)
    self.mTobeMember:addClickListener(self.onTobeMemberClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

------------------------------------------------------------------
-- 是否是群主
------------------------------------------------------------------
function friendsterMemberInfo:isCreator(acId)
    return self.friendster:isCreator(acId)
end

------------------------------------------------------------------
-- 是否是管理员
------------------------------------------------------------------
function friendsterMemberInfo:isManager(acId)
    return self.friendster:isManager(acId)
end

function friendsterMemberInfo:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function friendsterMemberInfo:onExitClickedHandler()
    showMessageUI(string.format("是否确定要退出亲友圈[%d]？", self.friendster.id),
                  function()
                      showWaitingUI("正在退出亲友圈，请稍候")
                      networkManager.exitFriendster(self.friendster.id, function(msg)
                          closeWaitingUI()
                          showToastUI(string.format("成功退出亲友圈[%d]", self.friendster.id))
                          signalManager.signal(signalType.friendsterExitedSignal, self.friendster.id)
                          self:close()
                      end)
                  end,
                  function()
                    --
                  end)
    playButtonClickSound()
end

function friendsterMemberInfo:onDissolveClickedHandler()
    showMessageUI("是否确定要解散亲友圈？",
                  function()
                      showWaitingUI("正在解散亲友圈，请稍候")
                      networkManager.dissolveFriendster(self.friendster.id, function(msg)
                          closeWaitingUI()
                          showToastUI(string.format("成功解散亲友圈[%d]", self.friendster.id))
                          self:close()
                      end)
                  end,
                  function()
                  end)
    playButtonClickSound()
end

function friendsterMemberInfo:onDeleteClickedHandler()
    showMessageUI(string.format("是否要将玩家（%d）从亲友圈中移除？", self.member.acId), function()
        showWaitingUI("正在将玩家从亲友圈中删除，请稍候")
        networkManager.deleteAcIdFromFriendster(self.friendster.id, self.member.acId, function(msg)
            closeWaitingUI()

            if msg == nil then
                showMessageUI(NETWORK_IS_BUSY)
                return
            end

            if msg.RetCode ~= retc.ok then
                showMessageUI(retcText[msg.RetCode])
                return
            end

            showToastUI("玩家已经从亲友圈中删除")
            self:close()
        end)
    end, function()
    end)

    playButtonClickSound()
end

function friendsterMemberInfo:onTobeManagerClickedHandler()
    showWaitingUI("正在设置玩家管理员权限，请稍候")
    networkManager.setMemberToBeManager(self.friendster.id, self.member.acId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showToastUI("管理员权限设置成功")
        self:close()
    end)

    playButtonClickSound()
end

function friendsterMemberInfo:onTobeMemberClickedHandler()
    showWaitingUI("正在取消玩家管理员权限，请稍候")
    networkManager.setManagerToBeMember(self.friendster.id, self.member.acId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showToastUI("管理员权限已经取消")
        self:close()
    end)

    playButtonClickSound()
end

function friendsterMemberInfo:onCloseAllUIHandler()
    self:close()
end

function friendsterMemberInfo:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end 

return friendsterMemberInfo

--endregion
