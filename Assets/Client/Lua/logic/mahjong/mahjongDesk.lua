--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer    = require("logic.player.gamePlayer")
local mahjong       = require("logic.mahjong.mahjong")
local mahjongType   = require("logic.mahjong.mahjongType")
local touch         = require("logic.touch")
local camera        = UnityEngine.Camera
local objectPicker  = GameObjectPicker

local mahjongDesk = class("mahjongDesk")

mahjongDesk.siteType = {
    mine  = 0,
    right = 1,
    top   = 2,
    left  = 3,
}

mahjongDesk.cardType = {
    idle = 1,
    shou = 2,
    peng = 3,
    chu  = 4,
}

mahjongDesk.sites = {
    [mahjongDesk.siteType.mine] = { 
        [mahjongDesk.cardType.idle] = { pos = Vector3.New( 0.235, 0.155, -0.268), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.shou] = { pos = Vector3.New(-0.410, 0.190, -0.540), rot = Quaternion.Euler(-65, 0, 0), scl = Vector3.New(2, 2, 2) },
        [mahjongDesk.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), },
        [mahjongDesk.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), },
    },
    [mahjongDesk.siteType.right] = { 
        [mahjongDesk.cardType.idle] = { pos = Vector3.New(0.309, 0.155, 0.27), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.shou] = { pos = Vector3.New(0.45, 0.165, -0.165), rot = Quaternion.Euler(-90, 0, -90), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), },
        [mahjongDesk.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), },
    },
    [mahjongDesk.siteType.top] = { 
        [mahjongDesk.cardType.idle] = { pos = Vector3.New(-0.233, 0.155, 0.33), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.shou] = { pos = Vector3.New( 0.204, 0.165, 0.45), rot = Quaternion.Euler(-90, 0, 180), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), },
        [mahjongDesk.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), },
    },
    [mahjongDesk.siteType.left] = { 
        [mahjongDesk.cardType.idle] = { pos = Vector3.New(-0.31, 0.155, -0.195), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.shou] = { pos = Vector3.New(-0.45, 0.165,  0.215), rot = Quaternion.Euler(-90, 0, 90), scl = Vector3.New(1, 1, 1) },
        [mahjongDesk.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), },
        [mahjongDesk.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), },
    },
}

mahjongDesk.plane_pos = {
    down = Vector3.New(0, 0, 0.026),
    up   = Vector3.New(0, 0.144, 0.026)
}

function mahjongDesk:ctor(data)
    self.plane = find("table_plane")
    self.planeAnim = getComponentU(self.plane, typeof(UnityEngine.Animation))

    self.idleMahjongRoot = find("idle_mahjong_root")
    self.idleMahjongRootAnim = getComponentU(self.idleMahjongRoot, typeof(UnityEngine.Animation))

    self.mahjongCount   = 108
    self.deskId         = data.DeskId
    self.cityType       = data.GameType
    self.config         = data.Config

    self.players = {}
    self.playerMahjongs = {}

    self:registerCommandHandlers()
    self:onEnter(data)

    --发送准备状态，调试用
    if not data.Ready then
        networkManager.ready(true, function(ok, msg)
            if not ok then
                log("enter desk error")
                return
            end

            self:onReady(msg)
        end)
    end
    --发送准备状态，调试用
end

function mahjongDesk:registerCommandHandlers()
    networkManager.registerCommandHandler(protoType.sc.otherEnterDesk, function(msg)
        self:onOtherEnterHandler(msg)
    end, true)

    networkManager.registerCommandHandler(protoType.sc.start, function(msg)
        self:onGameStartHandler(msg)
    end, false)

    networkManager.registerCommandHandler(protoType.sc.fapai, function(msg)
        self:onFaPaiHandler(msg)
    end, false)
end

function mahjongDesk:onEnter(msg)
    local player = gamePlayer.new(gamepref.acId)

    player.nickname = gamepref.nickname
    player.ip       = gamepref.ip
    player.sex      = gamepref.sex
    player.laolai   = gamepref.laolai
    player.conncted = true
    player.ready    = msg.Ready
    player.turn     = msg.Turn
    player.score    = msg.Score

    self.players[player.acId] = player

    if msg.Reenter ~= nil then
        self:syncDesk(msg.Reenter.SyncSeatInfos, msg.Others)

        local count = 0
        local ready = true
    
        for _, v in pairs(self.players) do 
            count = count + 1
            ready = ready and v.ready
        end

        if ready and (count == self.config.RenShu) then
            for _, v in pairs(self.players) do 
                self:createInHandMahjongs(v, player.turn)
            end

            self:createIdleMahjongs(player.turn, true)
        end
    end
end

function mahjongDesk:onReady(msg)
    local player = self.players[gamepref.acId]
    player.ready = msg.Ready
end

function mahjongDesk:syncDesk(sync, others)
    local mineTurn = 0

    for _, v in pairs(sync) do
        local player = self.players[v.AcId] or gamePlayer.new(v.AcId)

        player[mahjongDesk.cardType.shou] = v.CardsInHand
        player[mahjongDesk.cardType.chu]  = v.CardsInChuPai
        player[mahjongDesk.cardType.peng] = v.ChiCheInfos

        if player.acId == gamepref.acId then
            mineTurn = player.turn
        end

        self.players[v.AcId] = player
    end

    for _, v in pairs(others) do
        local player = self.players[v.AcId]

        player.nickname     = v.Nickname
        player.ip           = v.Ip
        player.sex          = v.Sex
        player.laolai       = v.IsLaoLai
        player.connected    = v.IsConnected
        player.ready        = v.Ready
        player.turn         = v.Turn
        player.score        = v.Score
    end
end

function mahjongDesk:onOtherEnterHandler(msg)
    log("otherEnter, msg = " .. table.tostring(msg))

    local player = gamePlayer.new(msg.AcId)

    player.nickname     = msg.Nickname
    player.ip           = msg.Ip
    player.sex          = msg.Sex
    player.laolai       = msg.IsLaoLai
    player.connected    = msg.IsConnected
    player.ready        = msg.Ready
    player.turn         = msg.Turn
    player.score        = msg.Score

    self.players[player.acId] = player
end

function mahjongDesk:onGameStartHandler(msg)
    log("startGame, msg = " .. table.tostring(msg))

    local mineTurn = 0
    for _, v in pairs(self.players) do
        if v.acId == gamepref.acId then
            mineTurn = v.turn
            break
        end
    end

    self:createIdleMahjongs(mineTurn, false)

    eventManager.registerAnimationTrigger("idle_mahjong_root", function()
        for _, m in pairs(self.mahjongs) do
            m:show()
        end
    end)

    self.planeAnim:Play()
    self.idleMahjongRootAnim:Play()
end

function mahjongDesk:onFaPaiHandler(msg)
    log("fapai, msg = " .. table.tostring(msg))

    for _, v in pairs(msg.Seats) do
        local player = self.players[v.AcId]
        player[mahjongDesk.cardType.shou] = v.Cards
    end

    local mineTurn = 0
    for _, v in pairs(self.players) do
        if v.acId == gamepref.acId then
            mineTurn = v.turn
            break
        end
    end

    for _, v in pairs(self.players) do 
        self:createInHandMahjongs(v, mineTurn)
    end

    touch.addListener(self.touchHandler, self)
end

function mahjongDesk:endGame()
    touch.removeListener()
end

function mahjongDesk:createIdleMahjongs(mineTurn, visible)
    local playerCount = self.config.RenShu

    local c = self.mahjongCount / playerCount
    local i, f = math.modf(c / 2)

    if f > 0.1 then
        c = c + 1
    end

    self.mahjongs = {}

    for _, v in pairs(self.players) do
        local turn = v.turn - mineTurn
        local site = self.sites[turn]

        local o = site[mahjongDesk.cardType.idle].pos
        local r = site[mahjongDesk.cardType.idle].rot
        local s = site[mahjongDesk.cardType.idle].scl

        for k=0, c-1 do
            local m = mahjong.new(mahjongType[k + 1])
            m:setParent(self.idleMahjongRoot.transform)

            local t, f = math.modf(k / 2)
            local y = math.abs(f) < 0.01 and o.y or o.y + mahjong.z
            local p = nil

            if turn == mahjongDesk.siteType.mine then
                p = Vector3.New(o.x - (mahjong.w * t), y, o.z)
            elseif turn == mahjongDesk.siteType.left then
                p = Vector3.New(o.x, y, o.z + (mahjong.w * t))
            elseif turn == mahjongDesk.siteType.right then
                p = Vector3.New(o.x, y, o.z - (mahjong.w * t))
            else
                p = Vector3.New(o.x + (mahjong.w * t), y, o.z)
            end

            m:setLocalPosition(p)
            m:setLocalRotation(r)
            m:setLocalScale(s)
            m:setPickabled(false)

            if visible then
                m:show()
            else
                m:hide()
            end

            local iid = m:getInstanceID()
            self.mahjongs[iid] = m
        end
    end
end

function mahjongDesk:createInHandMahjongs(player, mineTurn)
    local mahjongs = {}
    
    local data = player[mahjongDesk.cardType.shou]
    local turn = player.turn - mineTurn
    local site = self.sites[turn]

    local o = site[mahjongDesk.cardType.shou].pos
    local r = site[mahjongDesk.cardType.shou].rot
    local s = site[mahjongDesk.cardType.shou].scl

    for k, v in pairs(data) do
        if v < 0 then v = 0 end

        local m = mahjong.new(mahjongType[v])
        local p = nil

        if turn == mahjongDesk.siteType.mine then
            p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(true)
            local iid = m:getInstanceID()
            mahjongs[iid] = m
        elseif turn == mahjongDesk.siteType.left then
            p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
            m:setPickabled(false)
        elseif turn == mahjongDesk.siteType.right then
            p = Vector3.New(o.x, o.y, o.z + (mahjong.w * k) * s.z)
            m:setPickabled(false)
        else
            p = Vector3.New(o.x - (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(false)
        end

        m:setLocalPosition(p)
        m:setLocalRotation(r)
        m:setLocalScale(s)
    end

    self.playerMahjongs[player.acId] = mahjongs
end

function mahjongDesk:touchHandler(phase, pos)
    if phase == touch.phaseType.began then
        local go = objectPicker.Pick(camera.main, pos)
        if go ~= nil then
            local iid = go:GetInstanceID()
            self.selectedMahjong = self.inhandMahjongs[iid]
            
            if self.selectedMahjong ~= nil then
                self.selectedOrgPos = self.selectedMahjong:getPosition()
                local cpos = camera.main.transform.localPosition
                pos.z = self.selectedOrgPos.z - cpos.z
                self.selectedLastPos = camera.main:ScreenToWorldPoint(pos)
            end
        end
    elseif phase == touch.phaseType.moved then
        if self.selectedMahjong ~= nil then
            local mpos = self.selectedMahjong:getPosition()
            local cpos = camera.main.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera.main:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedLastPos
            
            mpos = Vector3.New(mpos.x + dpos.x, mpos.y + dpos.y, mpos.z)
            self.selectedMahjong:setPosition(mpos)
            self.selectedLastPos = wpos
        end
    else
        local mpos = self.selectedMahjong:getPosition()
        local cpos = camera.main.transform.localPosition
        pos.z = mpos.z - cpos.z
        local wpos = camera.main:ScreenToWorldPoint(pos)
        local dpos = wpos - self.selectedOrgPos
        
        log(dpos.y)

        if dpos.y < 0.226 then
            self.selectedMahjong:setPosition(self.selectedOrgPos)
        else
            --出牌
        end
    end
end

return mahjongDesk

--endregion
