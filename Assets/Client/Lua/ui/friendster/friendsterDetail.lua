--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local friendsterDetail = class("friendsterDetail", base)

_RES_(friendsterDetail, "FriendsterUI", "FriendsterDetailUI")

local function createMemberItem()
    return require("ui.friendster.friendsterDetailMemberItem").new()
end

function friendsterDetail:ctor(enterDeskCallback)
    self.enterDeskCallback = enterDeskCallback
    self.super.ctor(self)
end

function friendsterDetail:onInit()
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
    self.mManage:addClickListener(self.onManageClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)

    self.mMail:hide()
    self.mBank:hide()
    self.mStatistics:hide()
end

function friendsterDetail:onReturnClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterDetail:onManageClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.friendsterMemberManager").new()
    ui:set(self.data.ClubId)
    ui:show()
end

function friendsterDetail:onCreateClickedHandler()
    playButtonClickSound()

    local ui = require("ui.createDesk").new(function(cityType, deskId, loading)
        if self.enterDeskCallback ~= nil then
            self.enterDeskCallback(cityType, deskId, loading)
        end

        self:close()
    end)
    ui:set(cityType.chengdu, self.data.ClubId)
    ui:show()
end

function friendsterDetail:set(data, members, desks)
    self.data = data

    self.players = {}
    for _, v in pairs(members) do
        local p = gamePlayer.new(v.AcId)

        p.nickname           = v.Nickname
        p.headerUrl          = v.HeadUrl
        p:loadHeaderTex()
        p.online             = v.IsOnline
        p.lastOnlineTime     = v.LastOnlineTime

        self.players[p.acId] = p
    end

    self.members = {}
    for _, v in pairs(self.players) do
        table.insert(self.members, v)
    end

    table.sort(self.members, function(a, b)
        --群主在最前面
        if self.data.AcId == a.acId then 
            return true
        elseif self.data.AcId == b.acId then
            return false
        end
        --在线的在离线的前面
        if a.online and not b.online then
            return true
        elseif b.online and not a.online then
            return false
        elseif b.online and a.online then
            --都在线的，acid越小越靠前
            return a.acId < b.acId
        end
        --离线时间越短越靠前
        return b.lastOnlineTime < a.lastOnlineTime
    end)

    self.desks = {}
    table.sort(desks, function(a, b)
        --没开始游戏的排在前面
        if a.CurJu == 0 and b.CurJu > 0 then
            return true
        elseif a.CurJu > 0 and b.CurJu == 0 then
            return false
        end

        return a.SeatCnt - a.PlayerCnt < b.SeatCnt - b.PlayerCnt
    end)
    
    local deskCount = #desks

    for i=1, deskCount, 2 do
        local L = desks[i]
        local config = table.fromjson(L.Config)
        L.Config = config
        local players = L.Players
        L.Players = {}
        for _, p in pairs(players) do
            if p > 0 then
                table.insert(L.Players, self.players[p])
            end
        end

        local R = nil 
        if i + 1 <= deskCount then
            R = desks[i + 1]

            local config = table.fromjson(R.Config)
            R.Config = config
            local players = L.Players
            L.Players = {}
            for _, p in pairs(players) do
                if p > 0 then
                    table.insert(L.Players, self.players[p])
                end
            end
        end

        table.insert(self.desks, { L = L, R = R })
    end

    self:refreshUI()
end

function friendsterDetail:refreshUI()
    if self.data.AcId == gamepref.acId then
        self.mMail:show()
        self.mBank:show()
        self.mStatistics:show()

        self.mMail:addClickListener(self.onMailClickedHandler, self)
        self.mBank:addClickListener(self.onBankClickedHandler, self)
        self.mStatistics:addClickListener(self.onStatisticsClickedHandler, self)
    end

    self.mName:setText(self.data.ClubName)
    self.mCards:setText(tostring(self.data.CurCardNum))

    self.mMemberList:set(#self.members, createMemberItem, function(item, index)
        local m = self.members[index + 1]
        item:set(self.data.AcId, m)
        item.acId = m.AcId
    end)

    local createDeskItem = function()
        return require("ui.friendster.friendsterDetailDeskItem").new(function(cityType, deskId, loading)
            if self.enterDeskCallback ~= nil then
                self.enterDeskCallback(cityType, deskId, loading)
            end

            self:close()
        end)
    end

    self.mDeskList:set(#self.desks, createDeskItem, function(item, index)
        item:set(self.desks[index + 1])
    end)
end

function friendsterDetail:onMailClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function friendsterDetail:onBankClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function friendsterDetail:onStatisticsClickedHandler()
    playButtonClickSound()
    showMessageUI("功能暂未开放，敬请期待")
end

function friendsterDetail:onDestroy()
    for _, p in pairs(self.players) do
        p:destroy()
    end

    self.mMemberList:reset()
    self.mDeskList:reset()
end

return friendsterDetail

--endregion
