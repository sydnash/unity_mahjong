--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberManager = class("friendsterMemberManager", base)

_RES_(friendsterMemberManager, "FriendsterUI", "FriendsterMemberManagerUI")

function friendsterMemberManager:ctor(friendsterId)
    self.friendsterId = friendsterId
    self.super.ctor(self)
end

function friendsterMemberManager:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mQuery:addClickListener(self.onQueryClickedHandler, self)
    self.mTabAdd:addClickListener(self.onTabAddClickedHandler, self)
    self.mTabDelete:addClickListener(self.onTabDeleteClickedHandler, self)
    self.mAdd:addClickListener(self.onAddClickedHandler, self)
    self.mDelete:addClickListener(self.onDeleteClickedHandler, self)

    self.mTabAdd:hide()
    self.mTabAddS:show()
    self.mTabDelete:show()
    self.mTabDeleteS:hide()

    self.mAdd:show()
    self.mDelete:hide()

    self.mId:setText(string.empty)
    self.mName:setText(string.empty)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterMemberManager:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function friendsterMemberManager:onQueryClickedHandler()
    local text = self.mId:getText()

    if string.isNilOrEmpty(text) then
        showMessageUI("请输入玩家账号")
        playButtonClickSound()
        return
    end

    local id = tonumber(text)

    showWaitingUI("正在查询玩家信息，请稍候")
    networkManager.queryAcId(id, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        self.mName:setText(cutoutString(msg.Nickname, gameConfig.nicknameMaxLength))
    end)

    playButtonClickSound()
end

function friendsterMemberManager:onTabAddClickedHandler()
    self.mTabAdd:hide()
    self.mTabAddS:show()
    self.mTabDelete:show()
    self.mTabDeleteS:hide()

    self.mAdd:show()
    self.mDelete:hide()

    self.mId:setText(string.empty)
    self.mName:setText(string.empty)

    playButtonClickSound()
end

function friendsterMemberManager:onTabDeleteClickedHandler()
    self.mTabAdd:show()
    self.mTabAddS:hide()
    self.mTabDelete:hide()
    self.mTabDeleteS:show()

    self.mAdd:hide()
    self.mDelete:show()

    self.mId:setText(string.empty)
    self.mName:setText(string.empty)

    playButtonClickSound()
end

function friendsterMemberManager:onAddClickedHandler()
    local text = self.mId:getText()

    if string.isNilOrEmpty(text) then
        showMessageUI("请输入玩家账号")
        playButtonClickSound()
        return
    end

    local acid = tonumber(text)

    showWaitingUI("正在将玩家添加到亲友圈，请稍候")
    networkManager.addAcIdToFriendster(self.friendsterId, acid, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("add player to friendster, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI("玩家已经添加到亲友圈")
        self:close()
    end)

    playButtonClickSound()
end

function friendsterMemberManager:onDeleteClickedHandler()
    local text = self.mId:getText()

    if string.isNilOrEmpty(text) then
        showMessageUI("请输入玩家账号")
        playButtonClickSound()
        return
    end

    local acid = tonumber(text)

    showWaitingUI("正在将玩家从亲友圈中删除，请稍候")
    networkManager.deleteAcIdFromFriendster(self.friendsterId, acid, function(msg)
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

function friendsterMemberManager:onCloseAllUIHandler()
    self:close()
end

function friendsterMemberManager:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return friendsterMemberManager

--endregion
