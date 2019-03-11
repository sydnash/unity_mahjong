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
        if a.state == friendsterDeskStatus.waiting and b.state == friendsterDeskStatus.playing then
            return true
        elseif a.state == friendsterDeskStatus.playing and b.state == friendsterDeskStatus.waiting then
            return false
        end

        return (a.seatCount - a.playerCount) < (b.seatCount - b.playerCount)
    end)

    return d
end

function friendsterDetail:ctor(data, callback)
    self.data = data
    self.callback = callback
    base.ctor(self)
end

function friendsterDetail:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mManage:addClickListener(self.onManageClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
    self.mMail:addClickListener(self.onMailClickedHandler, self)
    self.mBank:addClickListener(self.onBankClickedHandler, self)
    self.mStatistics:addClickListener(self.onStatisticsClickedHandler, self)

    if gamepref.player.currentDesk == nil then
        self.mCreate:show()
        self.mReturn:hide()
    else
        self.mCreate:hide()
        self.mReturn:show()
    end

    self.mShare:hide()
    self.mManage:hide()
    self.mMail:hide()
    self.mMailRP:hide()
    self.mBank:hide()
    self.mStatistics:hide()

    signalManager.registerSignalHandler(signalType.refreshFriendsterDetailInfo, self.onReconnectedHandler, self)
    signalManager.registerSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.registerSignalHandler(signalType.friendsterMessageOp, self.onMessageOptHandler, self)
    signalManager.registerSignalHandler(signalType.deskDestroy, self.onDeskDestroyHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterDetail:onCloseClickedHandler()
    if self.callback ~= nil then
        self.callback()
    end

    self:close()
    playButtonClickSound()
end

function friendsterDetail:onShareClickedHandler()
    playButtonClickSound()
    
    local title = string.format("%s 邀请您加入幺九麻将", gamepref.player.nickname)
    local desc = string.format("点击亲友圈，输入编号[%d]和邀请码[%s]加入亲友圈开始游戏", self.data.id, self.data.applyCode)
    
    log("desc: " .. desc)
    local url = networkConfig.server.shareURL
    local image = textureManager.load(string.empty, "appicon")
    if image ~= nil then
        platformHelper.shareUrlWx(title, desc, url, image, false)
    end
end

function friendsterDetail:onManageClickedHandler()
    local ui = require("ui.friendster.friendsterMemberManager").new(self.data.id)
    ui:show()

    playButtonClickSound()
end

function friendsterDetail:onCreateClickedHandler()
    local cfg = defaultFriendsterSupporCityGames[self.data.cityType]
    if cfg == nil then
        showMessageUI(string.format("暂不支持%s地区创建房间", cityName[self.data.cityType]))
        playButtonClickSound()
        return
    end

    local ui = require("ui.createDesk").new(self.data.cityType, self.data.id, self.data)
    ui:show()

    playButtonClickSound()
end

function friendsterDetail:onReturnClickedHandler()
    if gamepref.player.currentDesk == nil then
        self.mCreate:show()
        self.mReturn:hide()
        return
    end

    local cityType = gamepref.player.currentDesk.cityType
    local deskId = gamepref.player.currentDesk.deskId
    
    enterDesk(cityType, deskId)
    playButtonClickSound()
end

function friendsterDetail:onReconnectedHandler()
    local friendsterId = self.data.id
    showWaitingUI("正在同步亲友圈数据，请稍候...")
    self.mySelf = self
    networkManager.queryFriendsterMembers(friendsterId, function(msg)
        if msg == nil then
            closeWaitingUI()
            showWaitingUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            closeWaitingUI()
            showWaitingUI(retcText[msg.RetCode])
            return
        end
        if not self.mySelf then
            return
        end

        self.data:setMembers(msg.Players)

        networkManager.queryFriendsterDesks(friendsterId, function(msg)
            closeWaitingUI()

            if msg == nil then
                showWaitingUI(NETWORK_IS_BUSY)
                return
            end

            if msg.RetCode ~= retc.ok then
                showWaitingUI(retcText[msg.RetCode])
                return
            end

            if not self.mySelf then
                return
            end

            self.data:setDesks(msg.Desks)
            
            self:refreshUI()
            self:refreshMemberList()
            self:refreshDeskList()
        end)
    end)
end
  
function friendsterDetail:refreshUI()
    if self.data.managerAcId == gamepref.player.acId then
        self.mShare:show()
        self.mManage:show()
        self.mMail:show()
        self.mBank:show()
        self.mStatistics:show()

        if #self.data.applyList > 0 then
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
    self.members = getSortedMembers(self.data.managerAcId, self.data.members)
    self.mMemberList:reset()

    local createMemberItem = function()
        return require("ui.friendster.friendsterDetailMemberItem").new()
    end

    local refreshMemberItem = function(item, index)
        log("friendsterDetail:refreshMemberList, index = " .. tostring(index))
        local m = self.members[index + 1]
        item:set(self.data.id, self.data.managerAcId, m)
    end

    self.mMemberList:set(#self.members, createMemberItem, refreshMemberItem)
end

function friendsterDetail:addMember()
    self.members = getSortedMembers(self.data.managerAcId, self.data.members)
    self.mMemberList:add()
end

function friendsterDetail:refreshDeskList()
    local desks = getSoredDesks(self.data.desks)
    
    local deskRows = {}
    local deskCount = #desks

    for i=1, deskCount, 2 do
        local L = desks[i]
        L.friendsterId = self.data.id
        L.managerAcId = self.data.managerAcId

        local R = nil 
        if i + 1 <= deskCount then
            R = desks[i + 1]
            R.friendsterId = self.data.id
            R.managerAcId = self.data.managerAcId
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
    self.messageUI = require("ui.friendster.friendsterMessage").new()
    self.messageUI:set(self.data.id, self.data.applyList)
    self.messageUI:show()

    playButtonClickSound()
end

function friendsterDetail:onBankClickedHandler()
    local ui = require("ui.friendster.friendsterBank").new(self.data)
    ui:show()

    playButtonClickSound()
end

function friendsterDetail:onStatisticsClickedHandler()
    playButtonClickSound()

    showWaitingUI("正在获取亲友圈统计数据，请稍候")
    local startTime = time.today() - time.SECONDS_PER_DAY

    local playHistory = gamepref.player:getFriendsterPlayHistory(self.data.id)
    playHistory:updateHistory(function(ok)
        closeWaitingUI()
        if not ok then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end
        local ui = require("ui.friendster.friendsterStatistics").new()
        local histories = playHistory:getData()
        ui:set(histories, playHistory)
        ui:show()
    end)
end

function friendsterDetail:onCardsChangedHandler()
    self.mCards:setText(tostring(self.data.cards))
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

function friendsterDetail:onDeskDestroyHandler(msg)
    self.mCreate:show()
    self.mReturn:hide()
end

--function friendsterDetail:onDissolvedHandler(friendsterId)
--    self:close()
--end

--function friendsterDetail:onExitedHandler(friendsterId)
--    self:close()
--end

function friendsterDetail:onCloseAllUIHandler()
    self:close()
end

function friendsterDetail:onDestroy()
    signalManager.unregisterSignalHandler(signalType.cardsChanged, self.onCardsChangedHandler, self)
    signalManager.unregisterSignalHandler(signalType.friendsterMessageOp, self.onMessageOptHandler, self)
    signalManager.unregisterSignalHandler(signalType.deskDestroy, self.onDeskDestroyHandler, self)
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    signalManager.unregisterSignalHandler(signalType.refreshFriendsterDetailInfo, self.onReconnectedHandler, self)
    
    self.mySelf = nil
    self.mMemberList:reset()
    self.mDeskList:reset()

    if self.messageUI ~= nil then
        self.messageUI:close()
        self.messageUI = nil
    end

    base.onDestroy(self)
end

return friendsterDetail

--endregion
