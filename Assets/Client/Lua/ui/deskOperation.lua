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
    [mahjongGame.seatType.mine] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.235, 0.155, -0.268), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.440, 0.190, -0.540), rot = Quaternion.Euler(-65, 0, 0), scl = Vector3.New(2, 2, 2) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.480, 0.155, -0.520), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.180, 0.155, -0.180), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.seatType.right] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.309, 0.155,  0.270), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New( 0.410, 0.165, -0.165), rot = Quaternion.Euler(-90, 0, -90), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.524, 0.155, -0.362), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.240, 0.155, -0.075), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.seatType.top] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.233, 0.155,  0.330), rot = Quaternion.Euler(180, 0, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New( 0.204, 0.165,  0.450), rot = Quaternion.Euler(-90, 0, 180), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.440, 0.155,  0.480), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.180, 0.155,  0.180), rot = Quaternion.Euler(0, 0, 0), scl = Vector3.New(1, 1, 1)},
    },
    [mahjongGame.seatType.left] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.310, 0.155, -0.195), rot = Quaternion.Euler(180, 90, 0), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.450, 0.165,  0.215), rot = Quaternion.Euler(-90, 0, 90), scl = Vector3.New(1, 1, 1) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.520, 0.155,  0.420), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.220, 0.155,  0.180), rot = Quaternion.Euler(0, 90, 0), scl = Vector3.New(1, 1, 1)},
    },
}

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function deskOperation:ctor(game)
    self.game = game
    self.super.ctor(self)
end

-------------------------------------------------------------------------------
-- 初始化
-------------------------------------------------------------------------------
function deskOperation:onInit()
    self.mineTurn = self.game:getTurn(gamepref.acId)

    self.plane = find("table_plane")
    self.planeAnim = getComponentU(self.plane, typeof(UnityEngine.Animation))

    self.idleMahjongRoot = find("idle_mahjong_root")
    self.idleMahjongRootAnim = getComponentU(self.idleMahjongRoot, typeof(UnityEngine.Animation))

    self.planeRoot = find("planes")
    self.planeRoot.transform.localRotation = Quaternion.Euler(0, 90 * self.mineTurn, 0)

    local circle = find("planes/circle/Cricle_0")
    self.circleMat = getComponentU(circle, typeof(UnityEngine.MeshRenderer)).sharedMaterial
    self.circleMat.mainTexture = textureManager.load("", "deskfw")

    self.planeMats = {}
    for i=mahjongGame.seatType.mine, mahjongGame.seatType.left do
        local a = (i + 2 == 5) and 1 or i + 2

        local go = findChild(self.planeRoot.transform, "plane0" .. tostring(a) .. "/plane0" .. tostring(a) .. "_0")
        local mesh = getComponentU(go, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.planeMats[i] = mat
    end
    self:highlightPlaneByTurn(-1)

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
function deskOperation:onGameSync(reenter)
    self:createIdleMahjongs(true)

    for _, v in pairs(self.game.players) do 
        self:createInHandMahjongs(v)
    end

    self:onOpList(reenter.CurOpList)
    self:highlightPlaneByTurn(reenter.CurOpTurn)

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
        local turn = self:getSeatType(v.turn)
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

            if turn == mahjongGame.seatType.mine then
                p = Vector3.New(o.x - (mahjong.w * t), y, o.z)
            elseif turn == mahjongGame.seatType.left then
                p = Vector3.New(o.x, y, o.z + (mahjong.w * t))
            elseif turn == mahjongGame.seatType.right then
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

    for _, id in pairs(data) do
        local m = mahjong.new(math.max(0, id))
        table.insert(mahjongs, m)
    end

    self.inhandMahjongs[player.acId] = mahjongs
    self:relocateInhandMahjongs(player, mahjongs)
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function deskOperation:onMoPai(acId, cards)
    self:highlightPlaneByAcId(acId)
    self:increaseInhandMahjongs(acId, cards)
end

-------------------------------------------------------------------------------
-- OpList
-------------------------------------------------------------------------------
function deskOperation:onOpList(oplist)
    if oplist ~= nil then
        local infos = oplist.OpInfos
        local leftTime = oplist.L

        for _, v in pairs(infos) do
            if v.Op == opType.chu then
                self:beginChuPai()
            end
        end

        self:showOperations(infos, leftTime)
    end
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
        
            if dpos.y < 0.23 or not self.canChuPai then
                self.selectedMahjong:setPosition(self.selectedOrgPos)
            else
                local id = self.selectedMahjong.id

                networkManager.chuPai({ id }, function(ok, msg)
                    log("chu pai failed")
                end)

                playMahjongSound(id, 1)
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
        elseif v.Op == opType.bao then
            self.mBao:show()
        elseif v.Op == opType.chi then
            self.mChi:show()
        elseif v.Op == opType.peng then
            self.mPeng:show()
            self.mPeng.cs = v.C[1].Cs
        elseif v.Op == opType.gang then
            self.mGang:show()
            self.mGang.cs = v.C[1].Cs
        elseif v.Op == opType.hu then
            self.mHu:show()
            self.mHu.cs = v.C[1].Cs
        end
    end

    local x = self.layout.preferredWidth * -0.5
    local p = self:getLocalPosition()
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
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“报”
-------------------------------------------------------------------------------
function deskOperation:onBaoClickedHandler()
    playButtonClickSound()

    self.game:bao()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“吃”
-------------------------------------------------------------------------------
function deskOperation:onChiClickedHandler()
    playButtonClickSound()

    self.game:chi()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“碰”
-------------------------------------------------------------------------------
function deskOperation:onPengClickedHandler()
    playMahjongOpSound(opType.peng, 1)

    self.game:peng(self.mPeng.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“杠”
-------------------------------------------------------------------------------
function deskOperation:onGangClickedHandler()
    playMahjongOpSound(opType.gang, 1)

    self.game:gang(self.mGang.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“胡”
-------------------------------------------------------------------------------
function deskOperation:onHuClickedHandler()
    playMahjongOpSound(opType.hu, 1)

    self.game:hu(self.mHu.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 出牌
-------------------------------------------------------------------------------
function deskOperation:onOpDoChu(acId, cards)
    self:endChuPai()

    local mahjongs = self:decreaseInhandMahjongs(acId, cards)
    for _, m in pairs(mahjongs) do
        self:putMahjongToChu(acId, m)
    end

    if acId ~= gamepref.acId then 
        playMahjongSound(cards[1], 2)
    end
end

-------------------------------------------------------------------------------
-- 碰
-------------------------------------------------------------------------------
function deskOperation:onOpDoPeng(acId, cards, beAcId, beCard)
    beAcId = beAcId[1]

    local mahjongs = self:decreaseInhandMahjongs(acId, cards)
    local chuMahjongs = self.chuMahjongs[beAcId]

    for k, v in pairs(chuMahjongs) do
        if v.id == beCard then
            table.insert(mahjongs, v)
            table.remove(chuMahjongs, k)
            break
        end
    end

    self:putMahjongsToPeng(acId, mahjongs)

    local bePlayer = self.game:getPlayerByAcId(beAcId)
    self:relocateInhandMahjongs(player, chuMahjongs)

    self:beginChuPai()
    self:highlightPlaneByAcId(acId)

    if acId ~= gamepref.acId then 
        playMahjongOpSound(opType.peng, 2)
    end
end

-------------------------------------------------------------------------------
-- 杠
-------------------------------------------------------------------------------
function deskOperation:onOpDoGang(acId, cards, beAcId, beCard)
    beAcId = beAcId[1]

    local mahjongs = self:decreaseInhandMahjongs(acId, cards)
    local chuMahjongs = self.chuMahjongs[beAcId]

    for k, v in pairs(chuMahjongs) do
        if v.id == beCard then
            table.insert(mahjongs, v)
            table.remove(chuMahjongs, k)
            break
        end
    end

    self:putMahjongsToPeng(acId, mahjongs)

    local bePlayer = self.game:getPlayerByAcId(beAcId)
    self:relocateInhandMahjongs(player, chuMahjongs)

    if acId ~= gamepref.acId then 
        playMahjongOpSound(opType.gang, 2)
    end
end

-------------------------------------------------------------------------------
-- 胡
-------------------------------------------------------------------------------
function deskOperation:onOpDoHu(acId, cards, beAcId, beCard)
    if acId ~= gamepref.acId then 
        playMahjongOpSound(opType.hu, 2)
    end
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function deskOperation:onClear()
    self:hideOperations()
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
    local turn = self:getSeatType(player.turn)
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.shou].pos
    local r = seat[mahjongGame.cardType.shou].rot
    local s = seat[mahjongGame.cardType.shou].scl

    for k, m in pairs(mahjongs) do
        local p = nil

        if turn == mahjongGame.seatType.mine then
            p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(true)
        elseif turn == mahjongGame.seatType.left then
            p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
            m:setPickabled(false)
        elseif turn == mahjongGame.seatType.right then
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
    local turn = self:getSeatType(player.turn)
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.chu].pos
    local r = seat[mahjongGame.cardType.chu].rot
    local s = seat[mahjongGame.cardType.chu].scl
    local k = #self.chuMahjongs[acId]

    if turn == mahjongGame.seatType.mine then
        local p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
        mj:setLocalPosition(p)
    elseif turn == mahjongGame.seatType.left then
        local p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
        mj:setLocalPosition(p)
    elseif turn == mahjongGame.seatType.right then
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
    local turn = self:getSeatType(player.turn)
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

        if turn == mahjongGame.seatType.mine then
            local p = Vector3.New(o.x + (mahjong.w * i) * s.x, o.y, o.z)
            m:setLocalPosition(p)
        elseif turn == mahjongGame.seatType.left then
            local p = Vector3.New(o.x, o.y, o.z - (mahjong.w * i) * s.z)
            m:setLocalPosition(p)
        elseif turn == mahjongGame.seatType.right then
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

-------------------------------------------------------------------------------
-- 将当前acid的plane高亮
-------------------------------------------------------------------------------
function deskOperation:highlightPlaneByAcId(acId)
    local player = self.game:getPlayerByAcId(acId)
    local turn = player and player.turn or -1

    self:highlightPlaneByTurn(turn)
end

-------------------------------------------------------------------------------
-- 将当前turn的plane高亮
-------------------------------------------------------------------------------
function deskOperation:highlightPlaneByTurn(turn)
    for t, m in pairs(self.planeMats) do
        if m.mainTexture ~= nil then
            textureManager.unload(m.mainTexture)
        end

        if t == turn then
            m.mainTexture = textureManager.load("", "deskfw_gl")
        else
            m.mainTexture = textureManager.load("", "deskfw")
        end
    end
end

-------------------------------------------------------------------------------
-- 将当前plane高亮
-------------------------------------------------------------------------------
function deskOperation:getSeatType(turn)
    if turn - self.mineTurn >= 0 then
        return turn - self.mineTurn
    end
    
    local playerCount = self.game:getPlayerCount()
    return playerCount + turn - self.mineTurn
end

return deskOperation

--endregion
