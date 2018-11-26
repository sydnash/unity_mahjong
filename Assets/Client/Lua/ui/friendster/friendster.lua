--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local friendster_Lc = require("logic.friendster.friendster")

local base = require("ui.common.view")
local friendster = class("friendster", base)

_RES_(friendster, "FriendsterUI", "FriendsterUI")

local filter = {
    none    = 0,
    my      = 1,
    joined  = 2,
}

local function createFriendsterLC(friendster)
    local lc = friendster_Lc.new(friendster.ClubId)

    lc.name             = friendster.ClubName
    lc.headerUrl        = friendster.HeadUrl
    lc:loadHeaderTex()
    lc.cityType         = friendster.GameType
    lc.cards            = friendster.CurCardNum
    lc.maxMemberCount   = friendster.MaxMemberCnt
    lc.curMemberCount   = friendster.CurMemberCnt
    lc.applyCode        = friendster.ApplyCode
    lc.managerAcId      = friendster.AcId
    lc.managerNickname  = friendster.NickName
    lc.applyList        = friendster.ApplyList or {}

    return lc
end

function friendster:ctor(data)
--    self.data = data
    self.friendsters = {}

    for _, v in pairs(data) do
        local lc = createFriendsterLC(v)
        self.friendsters[lc.id] = lc
    end

    self.my = {}
    self.joined = {}

    for _, d in pairs(self.friendsters) do 
        if d.managerAcId == gamepref.acId then
            table.insert(self.my, d)
        else
            table.insert(self.joined, d)
        end
    end 

    table.sort(self.my, function(a, b)
        return a.id < b.id
    end)

    table.sort(self.joined, function(a, b)
        return a.id < b.id
    end)

    self.super.ctor(self)
end

function friendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTabMyU:addClickListener(self.onMyClickedHandler, self)
    self.mTabJoinedU:addClickListener(self.onJoinedClickedHandler, self)
    self.mTabGuideU:addClickListener(self.onGuideClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mJoin:addClickListener(self.onJoinClickedHandler, self)
    
    if gamepref.player.userType == userType.normal then
        self.mTabMyS:hide()
        self.mTabMyU:show()
        self.mTabJoinedS:show()
        self.mTabJoinedU:hide()

        self.mCreate:hide()
        self.mJoin:show()

        self.filter = filter.joined
    elseif gamepref.player.userType == userType.proxy or gamepref.player.userType == userType.operation then
        self.mTabMyS:show()
        self.mTabMyU:hide()
        self.mTabJoinedS:hide()
        self.mTabJoinedU:show()

        self.mCreate:show()
        self.mJoin:hide()

        self.filter = filter.my
    end

    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    networkManager.registerCommandHandler(protoType.sc.notifyFriendster, function(msg) 
        self:onNotifyFriendster(msg)
    end, true)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self:refreshList()
end

function friendster:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendster:onMyClickedHandler()
    playButtonClickSound()

    self.mTabMyS:show()
    self.mTabMyU:hide()
    self.mTabJoinedS:hide()
    self.mTabJoinedU:show()
    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    self.mCreate:show()
    self.mJoin:hide()

    self.filter = filter.my
    self:refreshList()
end

function friendster:onJoinedClickedHandler()
    playButtonClickSound()

    self.mTabMyS:hide()
    self.mTabMyU:show()
    self.mTabJoinedS:show()
    self.mTabJoinedU:hide()
    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    self.mCreate:hide()
    self.mJoin:show()

    self.filter = filter.joined
    self:refreshList()
end

function friendster:onGuideClickedHandler()
    playButtonClickSound()

    self.mTabMyS:hide()
    self.mTabMyU:show()
    self.mTabJoinedS:hide()
    self.mTabJoinedU:show()
    self.mTabGuideS:show()
    self.mTabGuideU:hide()

    self.mPageRows:hide()
    self.mPageGuide:show()

    self.filter = filter.none
end

function friendster:onCreateClickedHandler()
    playButtonClickSound()

    if gamepref.player.userType == userType.proxy or gamepref.player.userType == userType.operation then
        local ui = require("ui.friendster.createFriendster").new(function(friendster)
            local lc = createFriendsterLC(friendster)
            self.friendsters[lc.id] = lc
            table.insert(self.my, lc)

            table.sort(self.my, function(a, b)
                return a.id < b.id
            end)

            self:refreshList()
        end)
        ui:show()
    else
        showMessageUI("您不是代理没有创建亲友圈的权限，\n可以联系客服成为代理哦")
    end
end

function friendster:onJoinClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.joinFriendster").new()
    ui:show()
end

function friendster:refreshList()
    self.mList:reset()
    
    local data = nil
    if self.filter == filter.my then
        data = self.my
    elseif self.filter == filter.joined then
        data = self.joined
    end
    
    if data ~= nil then
        local count = #data

        if count <= 0 then
            self.mEmpty:show()
            self.mList:hide()
        else
            self.mEmpty:hide()
            self.mList:show()

            local createItem = function()
                return require("ui.friendster.friendsterItem").new(function(data)
                    self.detailUI = require("ui.friendster.friendsterDetail").new(function()
                        if self.detailUI ~= nil then
                            self.detailUI:close()
                            self.detailUI = nil
                        end
                    end)
                    self.detailUI:set(data)
                    self.detailUI:show()
                end)
            end

            local refreshItem = function(item, index)
                item:set(data[index + 1])
            end
    
            self.mList:set(count, createItem, refreshItem)
        end
    end
end

function friendster:onNotifyFriendster(msg)
    log("friendster:onNotifyFriendster, msg = " .. table.tostring(msg))
    local t = msg.Type
    local d = table.fromjson(msg.Msg) 

    local lc = self.friendsters[d.ClubId]

    if t == friendsterNotifyType.createDesk then
        if lc ~= nil then
            lc:addDesk(d.DeskInfo)

            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.deskStart then
        if lc ~= nil then
            local desk = lc.desks[d.DeskId]
            if desk ~= nil then
                desk.state = friendsterDeskStatus.playing
            end

            if self.detailUI ~= nil then
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.deskDestroy then
        if lc ~= nil then
            lc:removeDesk(d.DeskId)
            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.deskPlayerEnter then
        if lc ~= nil then
            local desk = lc:addPlayerToDesk(d.AcId, d.DeskId)
            if self.detailUI ~= nil then
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.deskPlayerExit then
        if lc ~= nil then
            local desk = lc:removePlayerFromDesk(d.AcId, d.DeskId)
            if self.detailUI ~= nil then
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.cardsChanged then
        if self.detailUI ~= nil then
            self.detailUI:refreshUI()
        end
    elseif t == friendsterNotifyType.deskJuShuChanged then
        local desk = lc.desks[d.DeskId]
        if desk then
            desk.playedCount = d.CurJu
            if self.detailUI ~= nil then
                self.detailUI:refreshDeskList()
            end
        end
    elseif t == friendsterNotifyType.friendsterDestroy then
        self.friendsters[d.ClubId] = nil

        for k, v in pairs(self.my) do
            if v.id == d.ClubId then
                table.remove(self.my, k)
                break
            end
        end

        for k, v in pairs(self.joined) do
            if v.id == d.ClubId then
                table.remove(self.joined, k)
                break
            end
        end

        self:refreshList()

        if self.detailUI ~= nil then
            if self.detailUI.data.id == d.ClubId then
                self.detailUI:close()
                self.detailUI = nil
            end
        end
    elseif t == friendsterNotifyType.removeMember then
        if lc ~= nil then
            lc:removeMember(d.AcId)
            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshMemberList()
            end
        end
    elseif t == friendsterNotifyType.addMember then
        if lc ~= nil then
            lc:addMember(d.PlayerInfo)
            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshMemberList()
            end
        end
    elseif t == friendsterNotifyType.playerOffline then
        if lc ~= nil then
            lc:setMemberOnlineState(d.AcId, false)
            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshMemberList()
            end
        end
    elseif t == friendsterNotifyType.playerOnline then
        if lc ~= nil then
            lc:setMemberOnlineState(d.AcId, true)
            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
                self.detailUI:refreshMemberList()
            end
        end
    elseif t == friendsterNotifyType.applyEnterRequest then
        if lc ~= nil then
            for _, v in pairs(lc.applyList) do
                if v.acId == d.Info.AcId then return end
            end

            table.insert(lc.applyList, d.Info)

            if self.detailUI ~= nil then
                self.detailUI:refreshUI()
            end
        end
    end
end

function friendster:onCloseAllUIHandler()
    self:close()
end

function friendster:onDestroy()
    networkManager.unregisterCommandHandler(protoType.sc.notifyFriendster)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    self.mList:reset()

    for _, v in pairs(self.my) do
        v:destroy()
    end

    for _, v in pairs(self.joined) do
        v:destroy()
    end

    self.my = nil
    self.joined = nil

    if self.detailUI ~= nil then
        self.detailUI:close()
        self.detailUI = nil
    end

    self.super.onDestroy(self)
end

return friendster

--endregion
