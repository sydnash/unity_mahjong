--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("ui.common.view")
local friendsterDetail = class("friendsterDetail", base)

_RES_(friendsterDetail, "FriendsterUI", "FriendsterDetailUI")

local function createPlayer(data)
    log(data)
    local player = gamePlayer.new(data.AcId)

    player.nickname         = data.Nickname
    player.headerUrl        = data.HeadUrl
    player:loadHeaderTex()    
    player.online           = data.IsOnline
    player.lastOnlineTime   = data.LastOnlineTime
    player.totalPlayTimes   = data.TotalPlayTimes
    player.winPlayTimes     = data.WinPlayTimes

    return player
end

local function sortMembers(acId, members)
    table.sort(members, function(a, b)
        --群主在最前面
        if acId == a.acId then 
            return true
        elseif acId == b.acId then
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
end

function friendsterDetail:onInit()
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mManage:addClickListener(self.onManageClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)

    self.mMail:hide()
    self.mMailRP:hide()
    self.mBank:hide()
    self.mStatistics:hide()

    signalManager.registerSignalHandler(signalType.cardsChangedSignal, self.onCardsChangedHandler, self)
    signalManager.registerSignalHandler(signalType.enterDeskSignal, self.onEnterDeskHandler, self)
end

function friendsterDetail:onReturnClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterDetail:onShareClickedHandler()
    playButtonClickSound()

    if deviceConfig.isAndroid then 
        local desc = string.format("编号：%d, 邀请码：%d", self.data.id, self.data.applyCode)
        androidHelper.shareUrlWx("亲友圈信息", desc, "www.cdbshy.com", false)
    end
end

function friendsterDetail:onManageClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.friendsterMemberManager").new(function(op, data)
        if op == "add" then
            local player = createPlayer(data)

            self.players[data.AcId] = player
            table.insert(self.members, player)
            sortMembers(self.data.AcId, self.members)
        else -- op == "delete"
            self.players[data] = nil

            for k, v in pairs(self.members) do
                if v.acId == data then
                    table.remove(self.members, k)
                    break
                end
            end
        end

        self:refreshMemberList()
    end)
    ui:set(self.data.ClubId)
    ui:show()
end

function friendsterDetail:onCreateClickedHandler()
    playButtonClickSound()

    local ui = require("ui.createDesk").new()
    ui:set(cityType.chengdu, self.data.ClubId)
    ui:show()
end

function friendsterDetail:set(data, members, desks)
    self.data = data

    self.players = {}
    for _, v in pairs(members) do
        self.players[v.AcId] = createPlayer(v)
    end

    self.members = {}
    for _, v in pairs(self.players) do
        table.insert(self.members, v)
    end

    sortMembers(self.data.AcId, self.members)

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
    
    self.deskCount = #desks

    for i=1, self.deskCount, 2 do
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
        if i + 1 <= self.deskCount then
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
    if self.data.managerAcId == gamepref.acId then
        self.mMail:show()
        self.mBank:show()
        self.mStatistics:show()

        self.mMail:addClickListener(self.onMailClickedHandler, self)
        self.mBank:addClickListener(self.onBankClickedHandler, self)
        self.mStatistics:addClickListener(self.onStatisticsClickedHandler, self)
    end

    self.mName:setText(self.data.name)
    self.mCards:setText(tostring(self.data.cards))
    self.mDeskCount:setText(string.format("当前房间:%d", self.deskCount))
    self.mId:setText(string.format("编号:%d", self.data.id))
    self.mPlayerCount:setText(string.format("人数:%d/%d", self.data.curMemberCount, self.data.maxMemberCount))

    local onlineCount = 0
    for _, v in pairs(self.players) do
        if v.online then onlineCount = onlineCount + 1 end
    end
    self.mOnlineCount:setText(string.format("在线:%d", onlineCount))

    self:refreshMemberList()
    self:refreshDeskList()
end

function friendsterDetail:refreshMemberList()
    self.mMemberList:reset()

    local createMemberItem = function()
        return require("ui.friendster.friendsterDetailMemberItem").new()
    end

    local refreshMemberItem = function(item, index)
        local m = self.members[index + 1]
        item:set(self.data.managerAcId, m)
        item.acId = m.AcId
    end

    self.mMemberList:set(#self.members, createMemberItem, refreshMemberItem)
end

function friendsterDetail:refreshDeskList()
    local count = #self.desks

    if count <= 0 then
        self.mDeskEmpty:show()
        self.mDeskList:hide()
    else
        self.mDeskEmpty:hide()
        self.mDeskList:show()

        local createDeskItem = function()
            return require("ui.friendster.friendsterDetailDeskItem").new(function(cityType, deskId, loading)
                if self.enterDeskCallback ~= nil then
                    self.enterDeskCallback(cityType, deskId, loading)
                end

                self:close()
            end)
        end

        local refreshDeskItem = function(item, index)
            item:set(self.desks[index + 1])
        end

        self.mDeskList:reset()
        self.mDeskList:set(#self.desks, createDeskItem, refreshDeskItem)
    end
end

function friendsterDetail:onMailClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.friendster.friendsterMessage").new()
    ui:show()
end

function friendsterDetail:onBankClickedHandler()
    playButtonClickSound()
    
    local ui = require("ui.friendster.friendsterBank").new()
    ui:set(self.data)
    ui:show()
end

function friendsterDetail:onStatisticsClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在获取亲友圈统计数据，请稍候")
    local startTime = time.today() - time.SECONDS_PER_DAY

    networkManager.queryFriendsterStatistics(self.data.id, startTime, function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("query friendster history, msg = " .. table.tostring(msg))

        local ui = require("ui.friendster.friendsterStatistics").new()
        ui:set(msg)
        ui:show()
    end)
end

function friendsterDetail:onCardsChangedHandler()
    self.mCards:setText(tostring(self.data.cards))
end

function friendsterDetail:onEnterDeskHandler()
    self:close()
end

function friendsterDetail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cardsChangedSignal, self.onCardsChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.enterDeskSignal, self.onEnterDeskHandler, self)

    for _, p in pairs(self.players) do
        p:destroy()
    end

    self.mMemberList:reset()
    self.mDeskList:reset()

    self.super.onDestroy(self)
end

return friendsterDetail

--endregion
