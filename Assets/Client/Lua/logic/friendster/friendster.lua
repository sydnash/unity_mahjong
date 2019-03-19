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
    player.online           = data.IsOnline
    player.lastOnlineTime   = data.LastOnlineTime
    player.totalPlayTimes   = data.TotalPlayTimes
    player.winPlayTimes     = data.WinPlayTimes
    player.isProxy          = data.IsProxy
    player.deskStatus       = data.DeskStatus

    return player
end

local function createDesk(data)
--    log("createDesk, data = " .. table.tostring(data))
    local config = table.fromjson(data.Config)
    local ok, _ = checkGame(data.GameType, config.Game)

    if ok then
        local desk = friendsterDesk.new(data)
        return desk
    end

    return nil
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
    self.createSetting      = {}
    -- self:checkCreateSetting()
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
    lc.applyList        = json.isNilOrNull(data.ApplyList) and {} or data.ApplyList
    self.createSetting  = json.isNilOrNull(data.CreateSettings) and {} or data.CreateSettings
    -- self:checkCreateSetting()
    -- log("club setting: " .. table.tostring(self.createSetting))
end

function friendster:getSupportGames()
    local ret = {}
    if #self.createSetting == 0 then
        local games = defaultFriendsterSupporCityGames[self.cityType]
        for _, gt in pairs(games) do
            table.insert(ret, gt)
        end
    else
        for _, gt in pairs(self.createSetting) do
            table.insert(ret, gt.Id)
        end
    end
    return ret
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

function friendster:setMemberDeskStatus(acId, status)
    if self.members == nil then
        return
    end

    local player = self.members[acId]
    if player ~= nil then
        player.deskStatus = status
    end
end

function friendster:setDesks(data)
    self.desks = {}
    self.curDeskCount = 0

    for _, v in pairs(data) do
        local desk = self:addDesk(v)
        if desk ~= nil then
            for _, acId in pairs(v.Players) do 
                local player = self.members[acId]
                if player ~= nil then
                    desk:addPlayer(player)
                end
            end
        end
    end
end

function friendster:addDesk(data)
    if self.desks == nil then
        self.desks = {}
    end

    local desk = createDesk(data)
    if desk ~= nil then
        self.desks[desk.deskId] = desk
        self.curDeskCount = self.curDeskCount + 1
    end

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

    local desk = self.desks[deskId]
    if desk then
        for _, p in pairs(desk.players) do
            self:setMemberDeskStatus(p.acId, friendsterMemberDeskStatus.idle)
        end
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

    if not player or not desk then
        return
    end

    desk:addPlayer(player)

    self:setMemberDeskStatus(acId, friendsterMemberDeskStatus.indesk)
end

function friendster:removePlayerFromDesk(acId, deskId)
    if self.desks ~= nil then
        local desk = self.desks[deskId]
        if desk ~= nil then
            desk:removePlayer(acId)
        end
        self:setMemberDeskStatus(acId, friendsterMemberDeskStatus.idle)
    end
end

function friendster:destroy()
end

function friendster:hasCreateSetting()
    if self.createSetting == nil or #self.createSetting == 0 then
        return false
    end
    return true
end

function friendster:isSupportGame(id)
	if self.createSetting == nil or #self.createSetting == 0 then
		return true
	end
	local find = false
	local cfg = nil
	for _, info in pairs(self.createSetting) do
		if info.Id == id then
			find = true
			cfg = info.Cfg
			break
		end
    end
    
	return find, cfg
end

function friendster:setSupportGameId(ids)
	local old = self.createSetting
	self.createSetting = {}
	for _, id in pairs(ids) do
		table.insert(self.createSetting, {
			Id = id,
		})
	end
	if old ~= nil then
		for _, info in pairs(self.createSetting) do
			for _, oldInfo in pairs(old) do
				if info.Id == oldInfo.Id then
					info.Cfg = oldInfo.Cfg
					break
				end
			end
		end
	end
end

function friendster:setGameIDCfg(cfg)
	local find = false
	for _, info in pairs(self.createSetting) do
		if info.Id == cfg.Id then
			info.Cfg = cfg.Cfg
			find = true
			break
		end
	end
	if not find then
		table.insert(self.createSetting, {
			Id = cfg.Id,
			Cfg = cfg.Cfg,
		})
	end
end

return friendster

--endregion
