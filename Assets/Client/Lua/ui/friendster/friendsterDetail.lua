--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetail = class("friendsterDetail", base)

_RES_(friendsterDetail, "FriendsterUI", "FriendsterDetailUI")

local function getSortedMembers(acId, members)
    local m = {}
    for _, v in pairs(members) do
        table.insert(m, v)
    end

    table.sort(m, function(a, b)
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

    return m
end

local function getSoredDesks(desks)
    local d = {}

    for _, v in pairs(desks) do
        table.insert(d, v)
    end

    table.sort(d, function(a, b)
        --没开始游戏的排在前面
        if a.state == friendsterDeskStatus.waiting and a.state == friendsterDeskStatus.playing then
            return true
        elseif a.state == friendsterDeskStatus.playing and a.state == friendsterDeskStatus.waiting then
            return false
        end

        return (a.seatCount - a.playerCount) < (b.seatCount - b.playerCount)
    end)

    return d
end

function friendsterDetail:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function friendsterDetail:onInit()
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mManage:addClickListener(self.onManageClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mMail:addClickListener(self.onMailClickedHandler, self)
    self.mBank:addClickListener(self.onBankClickedHandler, self)
    self.mStatistics:addClickListener(self.onStatisticsClickedHandler, self)

    self.mMail:hide()
    self.mMailRP:hide()
    self.mBank:hide()
    self.mStatistics:hide()

    signalManager.registerSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.registerSignalHandler(signalType.enterDesk, self.onEnterDeskHandler, self)
    signalManager.registerSignalHandler(signalType.friendsterMessageOp, self.onMessageOptHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterDetail:onReturnClickedHandler()
    playButtonClickSound()

    if self.callback ~= nil then
        self.callback()
    end

    self:close()
end

function friendsterDetail:onShareClickedHandler()
    playButtonClickSound()

    local desc = string.format("编号：%d, 邀请码：%d", self.data.id, self.data.applyCode)
    local image = textureManager.load(string.empty, "appIcon")
    if image ~= nil then
        platformHelper.shareUrlWx("亲友圈信息", desc, "www.cdbshy.com", iamge, false)
    end
end

function friendsterDetail:onManageClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.friendsterMemberManager").new()
    ui:set(self.data.id)
    ui:show()
end

function friendsterDetail:onCreateClickedHandler()
    playButtonClickSound()

    local ui = require("ui.createDesk").new(self.data.cityType, self.data.id)
    ui:show()
end

function friendsterDetail:set(data)
    self.data = data

    self:refreshUI()
    self:refreshMemberList()
    self:refreshDeskList()
end

function friendsterDetail:refreshUI()
    if self.data.managerAcId == gamepref.acId then
        self.mMail:show()
        self.mBank:show()
        self.mStatistics:show()

        if self.data.applyList ~= nil and #self.data.applyList > 0 then
            self.mMailRP:show()
        end
    end

    self.mName:setText(cutoutString(self.data.name, gameConfig.friendsterNameMaxLength))
    self.mCards:setText(tostring(self.data.cards))
    self.mDeskCount:setText(string.format("当前房间:%d", self.data.curDeskCount))
    self.mId:setText(string.format("编号:%d", self.data.id))
    self.mPlayerCount:setText(string.format("人数:%d/%d", self.data.curMemberCount, self.data.maxMemberCount))
    self.mOnlineCount:setText(string.format("在线:%d", self:getOnlineCount()))
end

function friendsterDetail:getOnlineCount()
    local onlineCount = 0
    for _, v in pairs(self.data.members) do
        if v.online then onlineCount = onlineCount + 1 end
    end

    return onlineCount
end

function friendsterDetail:refreshMemberList()
    local members = getSortedMembers(self.data.managerAcId, self.data.members)
    self.mMemberList:reset()

    local createMemberItem = function()
        return require("ui.friendster.friendsterDetailMemberItem").new()
    end

    local refreshMemberItem = function(item, index)
        local m = members[index + 1]
        item:set(self.data.id, self.data.managerAcId, m)
    end

    self.mMemberList:set(#members, createMemberItem, refreshMemberItem)
end

function friendsterDetail:refreshDeskList()
    local desks = getSoredDesks(self.data.desks)
    
    local deskRows = {}
    local deskCount = #desks

    for i=1, deskCount, 2 do
        local L = desks[i]

        local R = nil 
        if i + 1 <= deskCount then
            R = desks[i + 1]
        end

        table.insert(deskRows, { L = L, R = R })
    end

    local count = #deskRows

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
            item:set(deskRows[index + 1])
        end

        self.mDeskList:reset()
        self.mDeskList:set(#deskRows, createDeskItem, refreshDeskItem)
    end
end

function friendsterDetail:onMailClickedHandler()
    playButtonClickSound()
    
    self.messageUI = require("ui.friendster.friendsterMessage").new()
    self.messageUI:set(self.data.id, self.data.applyList)
    self.messageUI:show()
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

function friendsterDetail:onMessageOptHandler(args)
    local acId = args.acId

    for k, v in pairs(self.data.applyList) do
        if v.AcId == acId then
            table.remove(self.data.applyList, k)
            break
        end
    end

    if self.messageUI ~= nil then
        self.messageUI:set(self.data.id, self.data.applyList)
    end

    if #self.data.applyList <= 0 then 
        self.mMailRP:hide()
    end
end

function friendsterDetail:onDissolvedHandler(friendsterId)
    self:close()
end

function friendsterDetail:onExitedHandler(friendsterId)
    self:close()
end

function friendsterDetail:onCloseAllUIHandler()
    self:close()
end

function friendsterDetail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.enterDesk, self.onEnterDeskHandler, self)
    signalManager.unregisterSignalHandler(signalType.friendsterMessageOp, self.onMessageOptHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self.mMemberList:reset()
    self.mDeskList:reset()

    if self.messageUI ~= nil then
        self.messageUI:close()
        self.messageUI = nil
    end

    self.super.onDestroy(self)
end

return friendsterDetail

--endregion
