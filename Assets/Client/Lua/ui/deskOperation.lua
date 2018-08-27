--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local opType        = require("const.opType")
local mahjongGame   = require("logic.mahjong.mahjongGame")
local mahjong       = require("logic.mahjong.mahjong")
local touch         = require("logic.touch")
local camera        = UnityEngine.Camera
local objectPicker  = GameObjectPicker

local base = require("ui.common.view")
local deskOperation = class("deskOperation", base)

deskOperation.folder = "deskoperationui"
deskOperation.resource = "deskoperationui"

deskOperation.seats = {
    [mahjongGame.siteType.mine] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.235, 0.155, -0.268), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.440, 0.190, -0.540), rot = Quaternion.Euler(-65, 0, 0), scl = Vector3.New(2, 2, 2) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.siteType.right] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(0.309, 0.155, 0.27), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(0.41, 0.165, -0.165), rot = Quaternion.Euler(-90, 0, -90), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.siteType.top] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.233, 0.155, 0.33), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New( 0.204, 0.165, 0.45), rot = Quaternion.Euler(-90, 0, 180), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.siteType.left] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.31, 0.155, -0.195), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.45, 0.165,  0.215), rot = Quaternion.Euler(-90, 0, 90), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(0, 0.155, 0), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
    },
}

function deskOperation:ctor(game)
    self.game = game
    self.super.ctor(self)
end

-------------------------------------------------------------------------------
-- 初始化
-------------------------------------------------------------------------------
function deskOperation:onInit()
    self.plane = find("table_plane")
    self.planeAnim = getComponentU(self.plane, typeof(UnityEngine.Animation))

    self.idleMahjongRoot = find("idle_mahjong_root")
    self.idleMahjongRootAnim = getComponentU(self.idleMahjongRoot, typeof(UnityEngine.Animation))

    self.mGuo:addClickListener(self.onGuoClickedHandler, self)
    self.mBao:addClickListener(self.onBaoClickedHandler, self)
    self.mChi:addClickListener(self.onChiClickedHandler, self)
    self.mPeng:addClickListener(self.onPengClickedHandler, self)
    self.mGang:addClickListener(self.onGangClickedHandler, self)
    self.mHu:addClickListener(self.onHuClickedHandler, self)

    self.mGuo:hide()
    self.mBao:hide()
    self.mChi:hide()
    self.mPeng:hide()
    self.mGang:hide()
    self.mHu:hide()

    self.layout = getComponentU(self.gameObject, typeof(UnityEngine.UI.HorizontalLayoutGroup))
    
    self.inhandMahjongs = {}
    self.chuMahjongs = {}
    self.pengMahjongs = {}
end

-------------------------------------------------------------------------------
-- 游戏开始
-------------------------------------------------------------------------------
function deskOperation:onGameStart()
    self.mineTurn = self.game:getTurn(gamepref.acId)
    self:createIdleMahjongs(false)

    eventManager.registerAnimationTrigger("idle_mahjong_root", function()
        for _, m in pairs(self.idleMahjongs) do
            m:show()
        end
    end)

    self.planeAnim:Play()
    self.idleMahjongRootAnim:Play()
end

-------------------------------------------------------------------------------
-- 游戏同步
-------------------------------------------------------------------------------
function deskOperation:onGameSync()
    self.mineTurn = self.game:getTurn(gamepref.acId)
    self:createIdleMahjongs(true)

    for _, v in pairs(self.game.players) do 
        self:createInHandMahjongs(v)
    end

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 创建“城墙”
-------------------------------------------------------------------------------
function deskOperation:createIdleMahjongs(visible)
    local mahjongCount = self.game:getMahjongTotalCount()
    local playerCount = self.game:getPlayerCount()

    local c = mahjongCount / playerCount
    local i, f = math.modf(c / 2)

    if f > 0.1 then
        c = c + 1
    end

    self.idleMahjongs = {}

    for _, v in pairs(self.game.players) do
        local turn = (v.turn - self.mineTurn >= 0) and v.turn - self.mineTurn or playerCount + v.turn - self.mineTurn
        local seat = self.seats[turn]

        local o = seat[mahjongGame.cardType.idle].pos
        local r = seat[mahjongGame.cardType.idle].rot
        local s = seat[mahjongGame.cardType.idle].scl

        for k=0, c-1 do
            local m = mahjong.new(k + 1)
            table.insert(self.idleMahjongs, m)

            local t, f = math.modf(k / 2)
            local y = math.abs(f) < 0.01 and o.y or o.y + mahjong.z
            local p = nil

            if turn == mahjongGame.siteType.mine then
                p = Vector3.New(o.x - (mahjong.w * t), y, o.z)
            elseif turn == mahjongGame.siteType.left then
                p = Vector3.New(o.x, y, o.z + (mahjong.w * t))
            elseif turn == mahjongGame.siteType.right then
                p = Vector3.New(o.x, y, o.z - (mahjong.w * t))
            else
                p = Vector3.New(o.x + (mahjong.w * t), y, o.z)
            end

            m:setParent(self.idleMahjongRoot.transform)
            m:setLocalPosition(p)
            m:setLocalRotation(r)
            m:setLocalScale(s)
            m:setPickabled(false)

            if visible then
                m:show()
            else
                m:hide()
            end
        end
    end
end

-------------------------------------------------------------------------------
-- 发牌
-------------------------------------------------------------------------------
function deskOperation:OnMahjongDispatched()
    self.mineTurn = self.game:getTurn(gamepref.acId)

    for _, v in pairs(self.game.players) do 
        self:createInHandMahjongs(v)
    end

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 创建手牌
-------------------------------------------------------------------------------
function deskOperation:createInHandMahjongs(player)
    local mahjongs = {}
    
    local playerCount = self.game:getPlayerCount()
    local data = player[mahjongGame.cardType.shou]
--    local turn = (player.turn - self.mineTurn >= 0) and player.turn - self.mineTurn or playerCount + player.turn - self.mineTurn
--    local seat = self.seats[turn]

    

    for _, id in pairs(data) do
        local m = mahjong.new(math.max(0, id))
        table.insert(mahjongs, m)
        
        
    end

    self.inhandMahjongs[player.acId] = mahjongs
    self:relocateInhandMahjongs(player, mahjongs)
end

function deskOperation:onMoPai(acId, cards)
    self:increaseInhandMahjongs(acId, cards)
end

-------------------------------------------------------------------------------
-- 可以出牌
-------------------------------------------------------------------------------
function deskOperation:beginChuPai()
    self.canChuPai = true
end

-------------------------------------------------------------------------------
-- 不能出牌
-------------------------------------------------------------------------------
function deskOperation:endChuPai()
    self.canChuPai = false
end

-------------------------------------------------------------------------------
-- 处理鼠标/手指拖拽
-------------------------------------------------------------------------------
function deskOperation:touchHandler(phase, pos)
    if phase == touch.phaseType.began then
        local go = objectPicker.Pick(camera.main, pos)
        if go ~= nil then
            local inhandMahjongs = self.inhandMahjongs[gamepref.acId]
            self.selectedMahjong = self:getMahjongByGo(inhandMahjongs, go)
            
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
        if self.selectedMahjong ~= nil then
            local mpos = self.selectedMahjong:getPosition()
            local cpos = camera.main.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera.main:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedOrgPos
        
            log(dpos.y)
            log(tostring(self.canChuPai))

            if dpos.y < 0.23 or not self.canChuPai then
                self.selectedMahjong:setPosition(self.selectedOrgPos)
            else
                networkManager.chuPai({self.selectedMahjong.id}, function(ok, msg)
                    log("chu pai failed")
                end)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- 显示操作按钮
-------------------------------------------------------------------------------
function deskOperation:showOperations(ops, leftTime)
    for _, v in pairs(ops) do 
        if v.Op == opType.guo then
            self.mGuo:show()
--        elseif v.Op == opType.bao then
--            self.mBao:show()
        elseif v.Op == opType.chi then
            self.mChi:show()
        elseif v.Op == opType.peng then
            self.mPeng:show()
            self.mPeng.cs = v.C[1].Cs
        elseif v.Op == opType.gang then
            self.mGang:show()
            self.mPeng.cs = v.C[1].Cs
        elseif v.Op == opType.hu then
            self.mHu:show()
            self.mPeng.cs = v.C[1].Cs
        end
    end

    local p = self:getLocalPosition()
    local x = self.layout.preferredWidth * -0.5
    self:setLocalPosition(Vector3.New(x, p.y, p.z))
end

-------------------------------------------------------------------------------
-- 隐藏操作按钮
-------------------------------------------------------------------------------
function deskOperation:hideOperations()
    self.mGuo:hide()
    self.mBao:hide()
    self.mChi:hide()
    self.mPeng:hide()
    self.mGang:hide()
    self.mHu:hide()
end

-------------------------------------------------------------------------------
-- 点击“过”
-------------------------------------------------------------------------------
function deskOperation:onGuoClickedHandler()
    playButtonClickSound()
    self.game:guo()
end

-------------------------------------------------------------------------------
-- 点击“报”
-------------------------------------------------------------------------------
function deskOperation:onBaoClickedHandler()
    playButtonClickSound()
    self.game:bao()
end

-------------------------------------------------------------------------------
-- 点击“吃”
-------------------------------------------------------------------------------
function deskOperation:onChiClickedHandler()
    playButtonClickSound()
    self.game:chi()
end

-------------------------------------------------------------------------------
-- 点击“碰”
-------------------------------------------------------------------------------
function deskOperation:onPengClickedHandler()
    playButtonClickSound()
    self.game:peng(self.mPeng.cs)
end

-------------------------------------------------------------------------------
-- 点击“杠”
-------------------------------------------------------------------------------
function deskOperation:onGangClickedHandler()
    playButtonClickSound()
    self.game:gang(self.mGang.cs)
end

-------------------------------------------------------------------------------
-- 点击“胡”
-------------------------------------------------------------------------------
function deskOperation:onHuClickedHandler()
    playButtonClickSound()
    self.game:hu(self.mHu.cs)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function deskOperation:onOpDoChu(acId, cards)
    self:endChuPai()

    local mahjongs = self:decreaseInhandMahjongs(acId, cards)
    for _, m in pairs(mahjongs) do
        self:putMahjongToChu(acId, m)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function deskOperation:onOpDoPeng(acId, cards, beAcId, beCard)
    local mahjongs = self:decreaseInhandMahjongs(acId, cards)
    local beMahjong = self.chuMahjongs[beAcId][beCard]

    table.insert(mahjongs, beMahjong)

    for _, m in pairs(mahjongs) do
        self:putMahjongsToPeng(acId, mahjongs)
    end
end

-------------------------------------------------------------------------------
-- 增加手牌
-------------------------------------------------------------------------------
function deskOperation:increaseInhandMahjongs(acId, datas)
    local mahjongs = self.inhandMahjongs[acId]

    for _, id in pairs(datas) do
        table.insert(mahjongs, mahjong.new(math.max(0, id)))
    end

    local player = self.game:getPlayerByAcId(acId)
    self:relocateInhandMahjongs(player, mahjongs)
end

-------------------------------------------------------------------------------
-- 减少手牌
-------------------------------------------------------------------------------
function deskOperation:decreaseInhandMahjongs(acId, datas)
    local decreaseMahjongs = {}
    local mahjongs = self.inhandMahjongs[acId]

    if acId == gamepref.acId then
        local temp = {}

        for _, id in pairs(datas) do
            for k, v in pairs(mahjongs) do
                if v.id == id then
                    table.insert(temp, k)
                    break
                end
            end
        end

        for _, v in pairs(temp) do
            table.insert(decreaseMahjongs, mahjongs[v])
            table.remove(mahjongs, v)
        end
    else
        for k, v in pairs(datas) do
            mahjongs[k]:destroy()
            table.remove(mahjongs, k)

            table.insert(decreaseMahjongs, mahjong.new(v))
        end
    end

    local player = self.game:getPlayerByAcId(acId)
    self:relocateInhandMahjongs(player, mahjongs)

    return decreaseMahjongs
end

-------------------------------------------------------------------------------
-- 手牌排序
-------------------------------------------------------------------------------
function deskOperation:relocateInhandMahjongs(player, mahjongs)
    if player.acId == gamepref.acId then
        table.sort(mahjongs, function(a, b)
            return a.id < b.id
        end)
    end

    local playerCount = self.game:getPlayerCount()
    local turn = (player.turn - self.mineTurn >= 0) and player.turn - self.mineTurn or playerCount + player.turn - self.mineTurn
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.shou].pos
    local r = seat[mahjongGame.cardType.shou].rot
    local s = seat[mahjongGame.cardType.shou].scl

    for k, m in pairs(mahjongs) do
        local p = nil

        if turn == mahjongGame.siteType.mine then
            p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(true)
        elseif turn == mahjongGame.siteType.left then
            p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
            m:setPickabled(false)
        elseif turn == mahjongGame.siteType.right then
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
end

-------------------------------------------------------------------------------
-- 获取mahjong对象
-------------------------------------------------------------------------------
function deskOperation:getMahjongByGo(mahjongs, gameObject)
    for _, m in pairs(mahjongs) do
        if m.gameObject == gameObject then
            return m
        end
    end

    return nil
end

-------------------------------------------------------------------------------
-- 将mahjong放到出牌区
-------------------------------------------------------------------------------
function deskOperation:putMahjongToChu(acId, mj)
    log("deskOperation:putMahjongToChu, acId = " .. tostring(acId) .. ", mahjong.id = " .. tostring(mj.id))
    local player = self.game:getPlayerByAcId(acId)

    if self.chuMahjongs[acId] == nil then
        self.chuMahjongs[acId] = {}
    end

    local playerCount = self.game:getPlayerCount()
    local turn = (player.turn - self.mineTurn >= 0) and player.turn - self.mineTurn or playerCount + player.turn - self.mineTurn
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.chu].pos
    local r = seat[mahjongGame.cardType.chu].rot
    local s = seat[mahjongGame.cardType.chu].scl
    local k = #self.chuMahjongs[acId]

    if turn == mahjongGame.siteType.mine then
        local p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
        mj:setLocalPosition(p)
    elseif turn == mahjongGame.siteType.left then
        local p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
        mj:setLocalPosition(p)
    elseif turn == mahjongGame.siteType.right then
        local p = Vector3.New(o.x, o.y, o.z + (mahjong.w * k) * s.z)
        mj:setLocalPosition(p)
    else
        local p = Vector3.New(o.x - (mahjong.w * k) * s.x, o.y, o.z)
        mj:setLocalPosition(p)
    end

    mj:setPickabled(false)
    mj:setLocalRotation(r)
    mj:setLocalScale(s)

    table.insert(self.chuMahjongs[acId], mj)
end

-------------------------------------------------------------------------------
-- 将mahjong放到出牌区
-------------------------------------------------------------------------------
function deskOperation:putMahjongsToPeng(acId, mahjongs)
    local player = self.game:getPlayerByAcId(acId)

    if self.pengMahjongs[acId] == nil then
        self.pengMahjongs[acId] = {}
    end

    local playerCount = self.game:getPlayerCount()
    local turn = (player.turn - self.mineTurn >= 0) and player.turn - self.mineTurn or playerCount + player.turn - self.mineTurn
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.peng].pos
    local r = seat[mahjongGame.cardType.peng].rot
    local s = seat[mahjongGame.cardType.peng].scl
    local c = #self.pengMahjongs[acId]

    for k, m in pairs(mahjongs) do 
        local i = 3 * c + k - 1
        local y = o.y
        
        if k == 4 then -- 杠的第4张牌放在第2张上面
            i = 3 * c + 1
            y = o.y + mahjong.z
        end 

        if turn == mahjongGame.siteType.mine then
            local p = Vector3.New(o.x + (mahjong.w * i) * s.x, o.y, o.z)
            m:setLocalPosition(p)
        elseif turn == mahjongGame.siteType.left then
            local p = Vector3.New(o.x, o.y, o.z - (mahjong.w * i) * s.z)
            m:setLocalPosition(p)
        elseif turn == mahjongGame.siteType.right then
            local p = Vector3.New(o.x, o.y, o.z + (mahjong.w * i) * s.z)
            m:setLocalPosition(p)
        else
            local p = Vector3.New(o.x - (mahjong.w * i) * s.x, o.y, o.z)
            m:setLocalPosition(p)
        end

        m:setPickabled(false)
        m:setLocalRotation(r)
        m:setLocalScale(s)
    end

    table.insert(self.pengMahjongs[acId], mahjongs)
end

return deskOperation

--endregion
