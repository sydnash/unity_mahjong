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
    self.cards              = 0
    self.curDeskCount       = 0
    self.maxMemberCount     = 0
    self.curMemberCount     = 0
    self.applyCode          = 0
    self.managerAcId        = 0
    self.managerNickname    = string.empty
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
    local player = createPlayer(data)
    self.members[player.acId] = player
    self.curMemberCount = self.curMemberCount + 1
end

function friendster:removeMember(acId)
    self.members[acId] = nil
    self.curMemberCount = self.curMemberCount - 1
end

function friendster:setMemberOnlineState(acId, online)
    local player = self.members[acId]
    player.online = online

    if not online then
        player.lastOnlineTime = time.now()
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
    local desk = createDesk(data)
    self.desks[desk.deskId] = desk
    self.curDeskCount = self.curDeskCount + 1

    return desk
end

function friendster:removeDesk(deskId)
    self.desks[deskId] = nil
    self.curDeskCount = self.curDeskCount - 1
end

function friendster:addPlayerToDesk(acId, deskId)
    local player = self.members[acId]
    local desk = self.desks[deskId]

    desk:addPlayer(player)
end

function friendster:removePlayerFromDesk(acId, deskId)
    local desk = self.desks[deskId]
    desk:removePlayer(acId)
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
