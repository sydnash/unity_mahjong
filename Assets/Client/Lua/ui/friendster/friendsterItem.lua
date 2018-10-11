--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterItem = class("friendsterItem", base)

_RES_(friendsterItem, "FriendsterUI", "FriendsterItem")

function friendsterItem:onInit()
    self.mThis:addClickListener(self.onClickedHandler, self)
end

function friendsterItem:onClickedHandler()
    local friendsterId = self.data.ClubId

    showWaitingUI("正在获取亲友圈数据，请稍候...")
    networkManager.queryFriendsterMembers(friendsterId, function(ok, msg)
        if not ok then
            closeWaitingUI()
            return
        end

        if msg.RetCode ~= retc.Ok then
            closeWaitingUI()
            return
        end

        log("query friendster members, msg = " .. table.tostring(msg))
        local members = msg.Players

        networkManager.queryFriendsterDesks(friendsterId, function(ok, msg)
            closeWaitingUI()

            if not ok then
                closeWaitingUI()
                return
            end

            if msg.RetCode ~= retc.Ok then
                closeWaitingUI()
                return
            end

            log("query friendster desks, msg = " .. table.tostring(msg))
            local desks = msg.Desks

            local ui = require("ui.friendster.friendsterDetail").new()
            ui:set(self.data, members, desks)
            ui:show()
        end)
    end)

    if self.callback ~= nil then
        self.callback()
    end
end

function friendsterItem:set(data, callback)
    self.data = data
    self.callback = callback

    self.mName:setText(data.ClubName)
    self.mId:setText(string.format("编号:%d", data.ClubId))
    self.mCount:setText(string.format("人数:%d/%d", data.CurMemberCnt, data.MaxMemberCnt))
end

return friendsterItem

--endregion
