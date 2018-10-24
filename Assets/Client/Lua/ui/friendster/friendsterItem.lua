--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterItem = class("friendsterItem", base)

_RES_(friendsterItem, "FriendsterUI", "FriendsterItem")

function friendsterItem:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function friendsterItem:onInit()
    self.mThis:addClickListener(self.onClickedHandler, self)
end

function friendsterItem:onClickedHandler()
    playButtonClickSound()
    local friendsterId = self.data.id

    showWaitingUI("正在获取亲友圈数据，请稍候...")
    networkManager.queryFriendsterMembers(friendsterId, function(ok, msg)
        if not ok then
            closeWaitingUI()
            showWaitingUI("网络繁忙，请稍后再试")
            return
        end

        if msg.RetCode ~= retc.Ok then
            closeWaitingUI()
            showWaitingUI(retcText[msg.RetCode])
            return
        end

        log("query friendster members, msg = " .. table.tostring(msg))
        self.data:setMembers(msg.Players)

        networkManager.queryFriendsterDesks(friendsterId, function(ok, msg)
            closeWaitingUI()

            if not ok then
                showWaitingUI("网络繁忙，请稍后再试")
                return
            end

            if msg.RetCode ~= retc.Ok then
                showWaitingUI(retcText[msg.RetCode])
                return
            end

            log("query friendster desks, msg = " .. table.tostring(msg))
            self.data:setDesks(msg.Desks)

            if self.callback ~= nil then
                self.callback(self.data)
            end
        end)
    end)
end

function friendsterItem:set(data)
    self.data = data

    self.mIcon:setTexture(data.headerTex)
    self.mName:setText(cutoutString(data.name, gameConfig.friendsterNameMaxLength))
    self.mId:setText(string.format("编号:%d", data.id))
    self.mCount:setText(string.format("人数:%d/%d", data.curMemberCount, data.maxMemberCount))
end

return friendsterItem

--endregion
