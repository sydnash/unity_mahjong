--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberManager = class("friendsterMemberManager", base)

_RES_(friendsterMemberManager, "FriendsterUI", "FriendsterMemberManagerUI")

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
end

function friendsterMemberManager:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMemberManager:onQueryClickedHandler()
    playButtonClickSound()

    local id = tonumber(self.mId:getText())

    showWaitingUI("正在查询玩家信息，请稍候")
    networkManager.queryAcId(id, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        self.mName:setText(msg.Nickname)
    end)
end

function friendsterMemberManager:onTabAddClickedHandler()
    playButtonClickSound()

    self.mTabAdd:hide()
    self.mTabAddS:show()
    self.mTabDelete:show()
    self.mTabDeleteS:hide()

    self.mAdd:show()
    self.mDelete:hide()

    self.mId:setText(string.empty)
    self.mName:setText(string.empty)
end

function friendsterMemberManager:onTabDeleteClickedHandler()
    playButtonClickSound()

    self.mTabAdd:show()
    self.mTabAddS:hide()
    self.mTabDelete:hide()
    self.mTabDeleteS:show()

    self.mAdd:hide()
    self.mDelete:show()

    self.mId:setText(string.empty)
    self.mName:setText(string.empty)
end

function friendsterMemberManager:onAddClickedHandler()
    playButtonClickSound()

    local acid = tonumber(self.mId:getText())

    showWaitingUI("正在将玩家添加到亲友圈，请稍候")
    networkManager.addAcIdToFriendster(self.friendsterId, acid, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log(msg)
        showMessageUI("玩家已经添加到亲友圈")
        self:close()
    end)
end

function friendsterMemberManager:onDeleteClickedHandler()
    playButtonClickSound()

    local acid = tonumber(self.mId:getText())

    showWaitingUI("正在将玩家从亲友圈中删除，请稍候")
    networkManager.deleteAcIdFromFriendster(self.friendsterId, acid, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log(msg)
        showMessageUI("玩家已经从亲友圈中删除")
        self:close()
    end)
end

function friendsterMemberManager:set(friendsterId)
    self.friendsterId = friendsterId
end

return friendsterMemberManager

--endregion
