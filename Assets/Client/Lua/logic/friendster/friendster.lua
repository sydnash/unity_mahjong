--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")
local friendsterDesk = require("logic.friendster.friendsterDesk")

local friendster = class("friendster")

local function createPlayer(data)
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

local function createDesk(data)
    local desk = friendsterDesk.new(data)
    return desk
end

function friendster:ctor(id)
    self.id                 = id
    self.name               = string.empty
    self.headerUrl          = string.empty
    self.headerTex          = nil
    self.cityType           = cityType.chengdu
    self.gameType           = gameType.mahjong
    self.cards              = 0
    self.curDeskCount       = 0
    self.maxMemberCount     = 0
    self.curMemberCount     = 0
    self.applyCode          = 0
    self.managerAcId        = 0
    self.managerNickname    = string.empty
end

function friendster:setData(data)
    local lc = self
    lc.name             = data.ClubName
    lc.headerUrl        = data.HeadUrl
    lc:loadHeaderTex()
    lc.cityType         = data.GameType
    lc.cards            = data.CurCardNum
    lc.maxMemberCount   = data.MaxMemberCnt
    lc.curMemberCount   = data.CurMemberCnt
    lc.applyCode        = data.ApplyCode
    lc.managerAcId      = data.AcId
    lc.managerNickname  = data.NickName
    lc.applyList        = data.ApplyList or {}
end

function friendster:loadHeaderTex()
    self:destroy()

    --先显示默认头像
    self.headerTex = textureManager.load(string.empty, "JS_tx_a")
    --同时开始下载真实头像
    if not string.isNilOrEmpty(self.headerUrl) then 
        downloadIcon(self.headerUrl, function(tex)
            if self.headerTex ~= nil then
                textureManager.unload(self.headerTex, false)
            end

            self.headerTex = tex
            
            local signalId = signalType.headerDownloaded .. tostring(self.id)
            signalManager.signal(signalId, self.headerTex)
        end)
    end
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
    if self.headerTex ~= nil then
        textureManager.unload(self.headerTex, true)
        self.headerTex = nil
    end

    if self.members ~= nil then
        for _, m in pairs(self.members) do
            m:destroy()
        end
    end
end

return friendster

--endregion
