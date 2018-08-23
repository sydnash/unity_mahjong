--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjong = require("logic.mahjong.mahjong")
local mahjongType = require("logic.mahjong.mahjongType")
local touch = require("logic.touch")
local camera = UnityEngine.Camera
local objectPicker = GameObjectPicker

local mahjongDesk = class("mahjongDesk")

mahjongDesk.siteType = {
    mine  = 1,
    left  = 2,
    right = 3,
    top   = 4,
}

mahjongDesk.sites = {
    [1] = { idle = { pos = Vector3.New( 0.235, 0.155, -0.268), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
            shou = { pos = Vector3.New(-0.410, 0.190, -0.540), rot = Quaternion.Euler(-65, 0, 0), scl = Vector3.New(2, 2, 2) },
            peng = { pos = Vector3.New(0, 0.155, 0), },
            chu  = { pos = Vector3.New(0, 0.155, 0), },
    },
    [2] = { idle = { pos = Vector3.New(-0.31, 0.155, -0.195), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
            shou = { pos = Vector3.New(-0.45, 0.165,  0.215), rot = Quaternion.Euler(-90, 0, 90), scl = Vector3.New(1, 1, 1) },
            peng = { pos = Vector3.New(0, 0.155, 0), },
            chu  = { pos = Vector3.New(0, 0.155, 0), },
    },
    [3] = { idle = { pos = Vector3.New(0.309, 0.155, 0.27), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
            shou = { pos = Vector3.New(0.45, 0.165, -0.165), rot = Quaternion.Euler(-90, 0, -90), scl = Vector3.New(1, 1, 1) },
            peng = { pos = Vector3.New(0, 0.155, 0), },
            chu  = { pos = Vector3.New(0, 0.155, 0), },
    },
    [4] = { idle = { pos = Vector3.New(-0.233, 0.155, 0.33), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
            shou = { pos = Vector3.New( 0.204, 0.165, 0.45), rot = Quaternion.Euler(-90, 0, 180), scl = Vector3.New(1, 1, 1) },
            peng = { pos = Vector3.New(0, 0.155, 0), },
            chu  = { pos = Vector3.New(0, 0.155, 0), },
    },
}

mahjongDesk.plane_pos = {
    down = Vector3.New(0, 0, 0.026),
    up   = Vector3.New(0, 0.144, 0.026)
}

function mahjongDesk:ctor(playerCount, mahjongCount)
    self.plane = find("table_plane")
    self.planeAnim = getComponentU(self.plane, typeof(UnityEngine.Animation))
    self.planeAnim:Play()

    self.idleMahjongRoot = find("idle_mahjong_root")
    self.idleMahjongRoot = getComponentU(self.idleMahjongRoot, typeof(UnityEngine.Animation))
    self.idleMahjongRoot:Play()

    self.playerCount = playerCount
    self.mahjongCount = mahjongCount

    --发送准备状态，调试用
    networkManager.ready(true, function(ok, msg)
        if not ok then
            log("enter desk error")
            return
        end

        networkManager.registerCommandHandler(protoType.sc.start, function(msg)
            self:onGameStartHandler(msg)
        end)
        networkManager.registerCommandHandler(protoType.sc.fapai, function(msg)
            self:onFaPaiHandler(msg)
        end)
    end)
    --发送准备状态，调试用
end

function mahjongDesk:onGameStartHandler(msg)
    log("startGame, msg = " .. table.tostring(msg))

    self:createIdleMahjongs()
    self:createInHandMahjongs()

    eventManager.registerAnimationTrigger("idle_mahjong_root", function()
        for _, m in pairs(self.mahjongs) do
            m:show()
        end
    end)
end

function mahjongDesk:onFaPaiHandler(msg)
    log("startGame, msg = " .. table.tostring(msg))
    touch.addListener(self.touchHandler, self)
end

function mahjongDesk:endGame()
    touch.removeListener()
end

function mahjongDesk:createIdleMahjongs()
    local c = self.mahjongCount / self.playerCount
    local i, f = math.modf(c / 2)

    if f > 0.1 then
        c = c + 1
    end

    self.mahjongs = {}

    for i=1, self.playerCount do
        local site = self.sites[i]
        local o = site.idle.pos

        for k=0, c-1 do
            local m = mahjong.new(mahjongType[k + 1])
            m:setParent(self.idleMahjongRoot.transform)

            local t, f = math.modf(k / 2)
            local y = math.abs(f) < 0.01 and o.y or o.y + mahjong.z
            local p = nil

            if i == mahjongDesk.siteType.mine then
                p = Vector3.New(o.x - (mahjong.w * t), y, o.z)
            elseif i == mahjongDesk.siteType.left then
                p = Vector3.New(o.x, y, o.z + (mahjong.w * t))
            elseif i == mahjongDesk.siteType.right then
                p = Vector3.New(o.x, y, o.z - (mahjong.w * t))
            else
                p = Vector3.New(o.x + (mahjong.w * t), y, o.z)
            end

            m:setLocalPosition(p)
            m:setLocalRotation(site.idle.rot)
            m:setLocalScale(site.idle.scl)
            m:setPickabled(false)

            m:hide()

            local iid = m:getInstanceID()
            self.mahjongs[iid] = m
        end
    end
end

function mahjongDesk:createInHandMahjongs()
    self.inhandMahjongs = {}

    for i=1, self.playerCount do
        local site = self.sites[i]
        local o = site.shou.pos
        local s = site.shou.scl

        for k=0, 12 do
            local m = mahjong.new(mahjongType[k])
            local p = nil

            if i == mahjongDesk.siteType.mine then
                p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
                
                local iid = m:getInstanceID()
                self.inhandMahjongs[iid] = m
            elseif i == mahjongDesk.siteType.left then
                p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
            elseif i == mahjongDesk.siteType.right then
                p = Vector3.New(o.x, o.y, o.z + (mahjong.w * k) * s.z)
            else
                p = Vector3.New(o.x - (mahjong.w * k) * s.x, o.y, o.z)
            end

            m:setLocalPosition(p)
            m:setLocalRotation(site.shou.rot)
            m:setLocalScale(site.shou.scl)
            m:setPickabled(true)
        end
    end
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
