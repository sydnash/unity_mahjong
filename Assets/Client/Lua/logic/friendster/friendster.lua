--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")
local friendsterDesk = require("logic.friendster.friendsterDesk")

local friendster = class("friendster")
local iconDownloadId = 1

local function createPlayer(data)
    local player = gamePlayer.new(data.AcId)

    player.nickname         = data.Nickname
    player.headerUrl        = data.HeadUrl  
    player.online           = data.IsOnline
    player.lastOnlineTime   = data.LastOnlineTime
    player.totalPlayTimes   = data.TotalPlayTimes
    player.winPlayTimes     = data.WinPlayTimes
    player.isProxy          = data.IsProxy

    return player
end

local function createDesk(data)
    local desk = friendsterDesk.new(data)
    return desk
end

function friendster:ctor(id)
    self.id                 = id
    self.name               = string.empty
    self.headerUrl          = string.empty
    self.cityType           = cityType.chengdu
    self.gameType           = gameType.mahjong
    self.cards              = 0
    self.curDeskCount       = 0
    self.maxMemberCount     = 0
    self.curMemberCount     = 0
    self.applyCode          = 0
    self.managerAcId        = 0
    self.managerNickname    = string.empty

    iconDownloadId = iconDownloadId + 1
    self.headerTexDownloaded = false
end

function friendster:setData(data)
    local lc = self
    lc.name             = data.ClubName
    lc.headerUrl        = data.HeadUrl
    lc.cityType         = data.GameType
    lc.cards            = data.CurCardNum
    lc.maxMemberCount   = data.MaxMemberCnt
    lc.curMemberCount   = data.CurMemberCnt
    lc.applyCode        = data.ApplyCode
    lc.managerAcId      = data.AcId
    lc.managerNickname  = data.NickName
    lc.applyList        = isNilOrNull(data.ApplyList) and {} or data.ApplyList
end

function friendster:setMembers(data)
    self.members = {}
    self.curMemberCount = 0

    for _, v in pairs(data) do
        self:addMember(v)
    end
end

function friendster:addMember(data)
    if self.members == nil then
        self.members = {}
    end

    local player = createPlayer(data)
    self.members[player.acId] = player
    self.curMemberCount = self.curMemberCount + 1
end

function friendster:removeMember(acId)
    if self.members == nil then
        return
    end
    self.members[acId] = nil
    self.curMemberCount = self.curMemberCount - 1
end

function friendster:setMemberOnlineState(acId, online)
    if self.members == nil then
        return
    end

    local player = self.members[acId]
    if player ~= nil then
        player.online = online

        if not online then
            player.lastOnlineTime = time.now()
        end
    end
end

function friendster:setDesks(data)
    self.desks = {}
    self.curDeskCount = 0

    for _, v in pairs(data) do
        local desk = self:addDesk(v)

        for _, acId in pairs(v.Players) do 
            local player = self.members[acId]
            if player ~= nil then
                desk:addPlayer(player)
            end
        end
    end
end

function friendster:addDesk(data)
    if self.desks == nil then
        self.desks = {}
    end

    local desk = createDesk(data)
    self.desks[desk.deskId] = desk
    self.curDeskCount = self.curDeskCount + 1

    return desk
end

function friendster:getDeskByDeskId(deskId)
    if self.desks == nil then
        return nil
    end

    return self.desks[deskId]
end

function friendster:removeDesk(deskId)
    if self.desks == nil then
        return
    end

    self.desks[deskId] = nil
    self.curDeskCount = self.curDeskCount - 1
end

function friendster:addPlayerToDesk(acId, deskId)
    if self.members == nil or self.desks == nil then
        return
    end

    local player = self.members[acId]
    local desk = self.desks[deskId]

    if not player and not desk then
        return
    end

    desk:addPlayer(player)
end

function friendster:removePlayerFromDesk(acId, deskId)
    if self.desks ~= nil then
        local desk = self.desks[deskId]
        if desk ~= nil then
            desk:removePlayer(acId)
        end
    end
end

function friendster:destroy()
    
end

return friendster

--endregion
