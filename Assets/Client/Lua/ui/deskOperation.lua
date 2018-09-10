--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local opType        = require("const.opType")
local mahjongGame   = require("logic.mahjong.mahjongGame")
local mahjong       = require("logic.mahjong.mahjong")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local deskOperation = class("deskOperation", base)

deskOperation.folder = "DeskOperationUI"
deskOperation.resource = "DeskOperationUI"

deskOperation.seats = {
    [mahjongGame.seatType.mine] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.235, 0.156, -0.268), rot = Quaternion.Euler(180, 0, 0),   scl = Vector3.New(1.0, 1.0, 1.0), len = 0.50 },
        [mahjongGame.cardType.shou] = { pos = Vector3.New( 0.204, 0.175, -0.355), rot = Quaternion.Euler(-100, 0, 0),  scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.400, 0.156, -0.360), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.110, 0.156, -0.140), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
    },
    [mahjongGame.seatType.right] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.309, 0.156,  0.275), rot = Quaternion.Euler(180, 90, 0),  scl = Vector3.New(1.0, 1.0, 1.0), len = 0.50 },
        [mahjongGame.cardType.shou] = { pos = Vector3.New( 0.370, 0.167,  0.228), rot = Quaternion.Euler(-90, 0, -90), scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.420, 0.156, -0.320), rot = Quaternion.Euler(0, 90, 0),    scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.160, 0.156, -0.080), rot = Quaternion.Euler(0, 90, 0),    scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156,  0.320), rot = Quaternion.Euler(0, 90, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
    },
    [mahjongGame.seatType.top] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.235, 0.156,  0.330), rot = Quaternion.Euler(180, 0, 0),   scl = Vector3.New(1.0, 1.0, 1.0), len = 0.50 },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.215, 0.167,  0.390), rot = Quaternion.Euler(-90, 0, 180), scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.360, 0.156,  0.420), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.100, 0.156,  0.195), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156,  0.320), rot = Quaternion.Euler(0, 0, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
    },
    [mahjongGame.seatType.left] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.310, 0.156, -0.195), rot = Quaternion.Euler(180, 90, 0),  scl = Vector3.New(1.0, 1.0, 1.0), len = 0.50 },
        [mahjongGame.cardType.shou] = { pos = Vector3.New(-0.370, 0.167, -0.180), rot = Quaternion.Euler(-90, 0, 90),  scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.420, 0.156,  0.320), rot = Quaternion.Euler(0, 90, 0),    scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.170, 0.156,  0.150), rot = Quaternion.Euler(0, 90, 0),    scl = Vector3.New(1.0, 1.0, 1.0) },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 90, 0),     scl = Vector3.New(1.0, 1.0, 1.0) },
    },
}

local mopaiConfig = {
    position = Vector3.New(0.255, 0.175, -0.355),
    rotation = Quaternion.Euler(-100, 0, 0),
    scale    = Vector3.New(1, 1, 1),
}

local totalCountdown = 20

-------------------------------------------------------------------------------
-- 交换两个牌
-------------------------------------------------------------------------------
local function swap(ta, ia, tb, ib)
    local a = ta[ia]
    local b = tb[ib]

    if a ~= nil and b ~= nil then
        --交换位置
        local p = a:getLocalPosition()
        local r = a:getLocalRotation()
        local s = a:getLocalScale()

        a:setLocalPosition(b:getLocalPosition())
        a:setLocalRotation(b:getLocalRotation())
        a:setLocalScale(b:getLocalScale())

        b:setLocalPosition(p)
        b:setLocalRotation(r)
        b:setLocalScale(s)
        --交换索引
        ta[ia] = b
        tb[ib] = a
    end
end

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
    self.turnStartTime = -1

    --麻将出口的板子节点
    self.plane = find("table_plane")
    self.planeAnim = getComponentU(self.plane, typeof(UnityEngine.Animation))
    local planeClip = animationManager.load("deskplane", "deskplane")
    self.planeAnim:AddClip(planeClip, planeClip.name)
    self.planeAnim.clip = planeClip
    --麻将根节点
    self.mahjongsRoot = find("mahjongs_root")
    self.mahjongsRootAnim = getComponentU(self.mahjongsRoot, typeof(UnityEngine.Animation))
    local mahjongsRootClip = animationManager.load("mahjongroot", "mahjongroot")
    self.mahjongsRootAnim:AddClip(mahjongsRootClip, mahjongsRootClip.name)
    self.mahjongsRootAnim.clip = mahjongsRootClip

    local mineTurn = self.game:getTurn(gamepref.acId)
    self.planeRoot = find("planes")
    self.planeRoot.transform.localRotation = Quaternion.Euler(0, 90 * mineTurn, 0)
    --圆盘
    local circle = find("planes/cricle/Cricle_0")
    self.circleMat = getComponentU(circle, typeof(UnityEngine.MeshRenderer)).sharedMaterial
    self.circleMat.mainTexture = textureManager.load("", "deskfw")
    --方向指示节点
    self.planeMats = {}
    for i=mahjongGame.seatType.mine, mahjongGame.seatType.left do
        local a = (i + 2 == 5) and 1 or i + 2

        local go = findChild(self.planeRoot.transform, "plane0" .. tostring(a) .. "/plane0" .. tostring(a) .. "_0")
        local mesh = getComponentU(go, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.planeMats[i] = mat
    end
    self:highlightPlaneByTurn(-1)
    --骰子节点和动画
    self.diceRoot = find("shaizi")
    self.diceRootAnim = getComponentU(self.diceRoot, typeof(UnityEngine.Animation))
    local diceRootClip = animationManager.load("diceroot", "diceroot")
    self.diceRootAnim:AddClip(diceRootClip, diceRootClip.name)
    self.diceRootAnim.clip = diceRootClip

    self.diceMats = {}
    for i=1, 2 do
        local go = findChild(self.diceRoot.transform, "shaizi0" .. tostring(i) .. "/shaizi0".. tostring(i) ..  "_0")
        local mesh = getComponentU(go, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.diceMats[i] = mat
    end

    self.centerGlass = find("planes/glass")
    self:setCountdownVisible(false)

    --按钮
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

    self.mGang_MS:hide()

    self.mGang_MS_ButtonA:addClickListener(self.onGangAClickedHandler, self)
    self.mGang_MS_ButtonB:addClickListener(self.onGangBClickedHandler, self)
    self.mGang_MS_ButtonC:addClickListener(self.onGangCClickedHandler, self)

    self.idleMahjongs = {}
    self.inhandMahjongs = {}
    self.chuMahjongs = {}
    self.pengMahjongs = {}
    self.huMahjongs = {}

    self:preload()
end

-------------------------------------------------------------------------------
-- 预加载
-------------------------------------------------------------------------------
function deskOperation:preload()
    for i=0, self.game:getTotalMahjongCount() - 1 do
        local m = mahjong.new(i)
        m:setParent(self.mahjongsRoot)
        m:hide()

        table.insert(self.idleMahjongs, m)
    end
end

-------------------------------------------------------------------------------
-- 主要处理中间的倒计时
-------------------------------------------------------------------------------
function deskOperation:update()
    if self.turnStartTime ~= nil and self.turnStartTime > 0 then
        local delta = math.floor(time.realtimeSinceStartup() - self.turnStartTime)
        local countdown = math.max(0, totalCountdown - delta)

        self.mCountdownA:setSprite(tostring(math.floor(countdown / 10)))
        self.mCountdownB:setSprite(tostring(math.floor(countdown % 10)))
    end
end

-------------------------------------------------------------------------------
-- 设置倒计时的可见性
-------------------------------------------------------------------------------
function deskOperation:setCountdownVisible(visible)
    if visible then
        self.centerGlass:SetActive(true)
        self.mCountdown:show()
    else
        self.centerGlass:SetActive(false)
        self.mCountdown:hide()
    end
end

-------------------------------------------------------------------------------
-- 游戏开始
-------------------------------------------------------------------------------
function deskOperation:onGameStart()
    self:setCountdownVisible(false)

    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(false)

    eventManager.registerAnimationTrigger("idle_mahjong_root", function()
        for _, m in pairs(self.idleMahjongs) do
            m:show()
        end
    end)

    eventManager.registerAnimationTrigger("table_plane_up", function()
        for _, v in pairs(self.inhandMahjongs) do
            for _, m in pairs(v) do
                m:show()
            end
        end
    end)

    self.planeAnim:Play()
    self.mahjongsRootAnim:Play()
    self.diceRootAnim:Play()

    local diceMat1 = self.diceMats[1]
    if diceMat1.mainTexture ~= nil then
        textureManager.unload(diceMat1.mainTexture)
    end
    diceMat1.mainTexture = textureManager.load("dice", "dice" .. self.game.dices[1])

    local diceMat2 = self.diceMats[2]
    if diceMat1.mainTexture ~= nil then
        textureManager.unload(diceMat2.mainTexture)
    end
    diceMat2.mainTexture = textureManager.load("dice", "dice" .. self.game.dices[2])
end

-------------------------------------------------------------------------------
-- 游戏同步
-------------------------------------------------------------------------------
function deskOperation:onGameSync(reenter)
    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(true)

    for _, v in pairs(self.game.players) do 
        self:createPengMahjongs(v)
        self:createChuMahjongs(v)
        self:createInHandMahjongs(v, true)
    end

    self:onOpList(reenter.CurOpList)
    self:highlightPlaneByTurn(reenter.CurOpTurn)
    self.turnStartTime = time.realtimeSinceStartup()
    self:setCountdownVisible(true)

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 创建“城墙”
-------------------------------------------------------------------------------
function deskOperation:relocateIdleMahjongs(visible)
    local mahjongCount = self.game:getTotalMahjongCount()
    local playerCount  = self.game:getTotalPlayerCount()
    local markerTurn   = self.game:getMarkerTurn()
    local playerStart  = (self.game.dices[1] + self.game.dices[2] + markerTurn) % playerCount - 1

    local c = mahjongCount / playerCount
    local i, f = math.modf(c / 2)

    local acc = 1

    for t=playerStart, playerStart-playerCount+1, -1 do
        local player = self.game:getPlayerByTurn((playerCount+t) % playerCount)

        if f > 0.1 then
            i = (player.turn % 2 == 0) and c + 1 or c - 1 
        end

        local turn = self.game:getSeatType(player.turn)
        local seat = self.seats[turn]

        local o = seat[mahjongGame.cardType.idle].pos
        local r = seat[mahjongGame.cardType.idle].rot
        local s = seat[mahjongGame.cardType.idle].scl
        local l = seat[mahjongGame.cardType.idle].len
        local d = (l - (mahjong.w * (i * 0.5))) * 0.5

        for k=1, i do
            local m = self.idleMahjongs[acc]
            acc = acc + 1

            local u, v = math.modf((k - 1) / 2)
            local x = o.x
            local y = math.abs(v) > 0.01 and o.y or o.y + mahjong.z
            local z = o.z
            local w = mahjong.w * u

            if turn == mahjongGame.seatType.mine then
                x = (o.x - d) - w * s.x
            elseif turn == mahjongGame.seatType.left then
                z = (o.z + d) + w * s.z
            elseif turn == mahjongGame.seatType.right then
                z = (o.z - d) - w * s.z
            else
                x = (o.x + d) + w * s.x
            end
            
            local p = m:getLocalPosition()
            p:Set(x, y, z)

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
function deskOperation:OnFaPai()
    for _, player in pairs(self.game.players) do
        self:createInHandMahjongs(player, false)
    end

    self:highlightPlaneByTurn(self.game:getMarkerTurn())
    self.turnStartTime = time.realtimeSinceStartup()
    self:setCountdownVisible(true)

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 创建手牌
-------------------------------------------------------------------------------
function deskOperation:createInHandMahjongs(player, visible)
    local datas = player[mahjongGame.cardType.shou]

    self.inhandMahjongs[player.acId] = {}
    self:increaseInhandMahjongs(player.acId, datas, visible)
end

-------------------------------------------------------------------------------
-- 创建出牌
-------------------------------------------------------------------------------
function deskOperation:createChuMahjongs(player)
    local datas = player[mahjongGame.cardType.chu]

    for _, id in pairs(datas) do
        local m = self:getMahjongFromIdle(id)
        m:show()
        self:putMahjongToChu(player.acId, m)
        local index = self:getIdleStart()
        table.remove(self.idleMahjongs, index)
    end    
end

-------------------------------------------------------------------------------
-- 创建碰/杠牌
-------------------------------------------------------------------------------
function deskOperation:createPengMahjongs(player)
    local mahjongs = {}
    local datas = player[mahjongGame.cardType.peng]

    for _, d in pairs(datas) do
        local mahjongs = {}

        for _, id in pairs(d.Cs) do
            local m = self:getMahjongFromIdle(id)
            m:show()
            table.insert(mahjongs, m)
            local index = self:getIdleStart()
            table.remove(self.idleMahjongs, index)
        end

        self:putMahjongsToPeng(player.acId, mahjongs)
    end
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function deskOperation:onMoPai(acId, cards)
    self.turnStartTime = time.realtimeSinceStartup()
    self:highlightPlaneByAcId(acId)
    
    if acId ~= gamepref.acId then
        self:increaseInhandMahjongs(acId, cards, true)
    else
        self.mo = self:getMahjongFromIdle(cards[1])
        local index = self:getIdleStart()
        table.remove(self.idleMahjongs, index)

        self.mo:setLocalPosition(mopaiConfig.position)
        self.mo:setLocalRotation(mopaiConfig.rotation)
        self.mo:setLocalScale(mopaiConfig.scale)

        self.mo:setPickabled(true)
        self.mo:show()
    end
end

-------------------------------------------------------------------------------
-- OpList
-------------------------------------------------------------------------------
function deskOperation:onOpList(oplist)
    if oplist ~= nil then
        local infos = oplist.OpInfos
        local leftTime = oplist.L

        for _, v in pairs(infos) do
            if v.Op == opType.chu.id then
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
    local camera = GameObjectPicker.instance.camera

    if phase == touch.phaseType.began then
        local go = GameObjectPicker.instance:Pick(pos)
        if go ~= nil then
            if self.mo ~= nil and self.mo.gameObject == go then
                self.selectedMahjong = self.mo
            else
                local inhandMahjongs = self.inhandMahjongs[gamepref.acId]
                self.selectedMahjong = self:getMahjongByGo(inhandMahjongs, go)
            end

            if self.selectedMahjong ~= nil then
                self.selectedOrgPos = self.selectedMahjong:getPosition()
                local cpos = camera.transform.localPosition
                pos.z = self.selectedOrgPos.z - cpos.z
                self.selectedLastPos = camera:ScreenToWorldPoint(pos)
            end
        end
    elseif phase == touch.phaseType.moved then
        if self.selectedMahjong ~= nil then
            local mpos = self.selectedMahjong:getPosition()
            local cpos = camera.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedLastPos
            
            mpos = Vector3.New(mpos.x + dpos.x, mpos.y + dpos.y, mpos.z)
            self.selectedMahjong:setPosition(mpos)
            self.selectedLastPos = wpos
        end
    else
        if self.selectedMahjong ~= nil then
            local mpos = self.selectedMahjong:getPosition()
            local cpos = camera.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedOrgPos
            
            if dpos.y < 0.04 or not self.canChuPai then
                self.selectedMahjong:setPosition(self.selectedOrgPos)
            else
                local id = self.selectedMahjong.id

                networkManager.chuPai({ id }, function(ok, msg)
                    log("chu pai failed")
                    local player = self.game:getPlayerByAcId(gamepref.acId)
                    local mahjongs = self.inhandMahjongs[gamepref.acId]
                    self:relocateInhandMahjongs(player, mahjongs)
                end)

                playMahjongSound(id, 1)
            end

            self.selectedMahjong = nil
        end
    end
end

-------------------------------------------------------------------------------
-- 显示操作按钮
-------------------------------------------------------------------------------
function deskOperation:showOperations(ops, leftTime)
    for _, v in pairs(ops) do 
        if v.Op == opType.guo.id then
            self.mGuo:show()
--        elseif v.Op == opType.bao.id then
--            self.mBao:show()
        elseif v.Op == opType.chi.id then
            self.mChi:show()
        elseif v.Op == opType.peng.id then
            self.mPeng:show()
            self.mPeng.cs = v.C[1].Cs
        elseif v.Op == opType.gang.id then
            self.mGang:show()
            self.mGang.c = v.C
        elseif v.Op == opType.hu.id then
            self.mHu:show()
            self.mHu.cs = v.C[1].Cs
        end
    end
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

    self.mGang_MS:hide()
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
    local player = self.game:getPlayerByAcId(gamepref.acId)
    playMahjongOpSound(opType.peng.id, player.sex)

    self.game:peng(self.mPeng.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- “杠”
-------------------------------------------------------------------------------
local function opGang(game, cs)
    local player = game:getPlayerByAcId(gamepref.acId)
    playMahjongOpSound(opType.gang.id, player.sex)

    game:gang(cs)
end

-------------------------------------------------------------------------------
-- 点击“杠”
-------------------------------------------------------------------------------
function deskOperation:onGangClickedHandler()
    if #self.mGang.c == 1 then
        opGang(self.game, self.mGang.c[1].Cs)
        self:hideOperations()
    else
        local buttons = { self.mGang_MS_ButtonA, self.mGang_MS_ButtonB, self.mGang_MS_ButtonC }
        local sprites = { self.mGang_MS_SpriteA, self.mGang_MS_SpriteB, self.mGang_MS_SpriteC }

        for _, v in pairs(buttons) do
            v:hide()
        end

        for i, c in pairs(self.mGang.c) do
            local cs = c.Cs
            buttons[i].cs = cs
            local id = math.floor(cs[1] / 4)
            sprites[i]:setSprite(convertMahjongIdToSpriteName(id))

            buttons[i]:show()
        end

        self.mGang_MS:show()
    end
end

-------------------------------------------------------------------------------
-- 点击“杠A”
-------------------------------------------------------------------------------
function deskOperation:onGangAClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonA.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“杠B”
-------------------------------------------------------------------------------
function deskOperation:onGangBClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonB.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“杠C”
-------------------------------------------------------------------------------
function deskOperation:onGangCClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonC.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“胡”
-------------------------------------------------------------------------------
function deskOperation:onHuClickedHandler()
    local player = self.game:getPlayerByAcId(gamepref.acId)
    playMahjongOpSound(opType.hu.id, player.sex)

    self.game:hu(self.mHu.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 出牌
-------------------------------------------------------------------------------
function deskOperation:onOpDoChu(acId, cards)
    self:endChuPai()

    if acId == gamepref.acId and self.mo ~= nil and cards[1] == self.mo.id then
        self:putMahjongToChu(acId, self.mo)
    else
        self:insertMahjongToInhand(self.mo)

        local mahjongs = self:decreaseInhandMahjongs(acId, cards)
        for _, m in pairs(mahjongs) do
            self:putMahjongToChu(acId, m)
        end
    end

    self.mo = nil

    if acId ~= gamepref.acId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongSound(cards[1], player.sex)
    end
end

-------------------------------------------------------------------------------
-- 碰
-------------------------------------------------------------------------------
function deskOperation:onOpDoPeng(acId, cards, beAcId, beCard)
    beAcId = beAcId[1]

    local pengMahjongs = self:decreaseInhandMahjongs(acId, cards)
    local chuMahjongs = self.chuMahjongs[beAcId]

    for k, v in pairs(chuMahjongs) do
        if v.id == beCard then
            table.insert(pengMahjongs, v)
            table.remove(chuMahjongs, k)
            break
        end
    end

    self:putMahjongsToPeng(acId, pengMahjongs)

    local bePlayer = self.game:getPlayerByAcId(beAcId)
    self:relocateChuMahjongs(bePlayer, chuMahjongs)

    self:beginChuPai()
    self:highlightPlaneByAcId(acId)

    if acId ~= gamepref.acId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.peng.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 杠
-------------------------------------------------------------------------------
function deskOperation:onOpDoGang(acId, cards, beAcId, beCard, t)
    
    local detail = opType.gang.detail

    if t == detail.minggang then
        beAcId = beAcId[1]

        local mahjongs = self:decreaseInhandMahjongs(acId, cards)
        local chu = self.chuMahjongs[beAcId]

        for k, v in pairs(chu) do
            if v.id == beCard then
                table.insert(mahjongs, v)
                table.remove(chu, k)
                break
            end
        end

        self:putMahjongsToPeng(acId, mahjongs)

        local bePlayer = self.game:getPlayerByAcId(beAcId)
        self:relocateChuMahjongs(bePlayer, chuMahjongs)
    else
        if self.mo ~= nil then
            self:insertMahjongToInhand(self.mo)
        end

        local mahjongs = self:decreaseInhandMahjongs(acId, cards)
        self:putMahjongsToPeng(acId, mahjongs)
    end

    if acId ~= gamepref.acId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.gang.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 胡
-------------------------------------------------------------------------------
function deskOperation:onOpDoHu(acId, cards, beAcId, beCard, t)
    local hu = nil
    local detail = opType.hu.detail

    if t == detail.zimo or t == detail.gangshanghua or t == detail.haidilao then
        local inhand = self.inhandMahjongs[acId]

        if acId ~= gamepref.acId then
            hu = inhand[1]
            table.remove(inhand, 1)
        else
            hu = self.mo
            self.mo = nil
        end
    else
        beAcId = beAcId[1]
        local chu = self.chuMahjongs[beAcId]

        for k, v in pairs(chu) do
            if v.id == beCard then
                hu = v
                table.remove(chu, k)
                break
            end
        end
    end

    if hu == nil then
        log("hu, new a mahjong, id = " .. tostring(beCard))
        hu = mahjong.new(beCard)
    end
    
    self.huMahjongs[acId] = hu

    local s = self.game:getSeatTypeByAcId(acId)
    local t = self.seats[s][mahjongGame.cardType.hu]
    hu:setLocalPosition(t.pos)
    hu:setLocalRotation(t.rot)
    hu:setLocalScale(t.scl)

    if acId ~= gamepref.acId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.hu.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function deskOperation:onClear()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 获取从idle列表拿牌的索引值
-------------------------------------------------------------------------------
function deskOperation:getIdleStart()
    return (self.idleMahjongStart <= #self.idleMahjongs) and self.idleMahjongStart or 1
end

-------------------------------------------------------------------------------
-- 从idle列表或者其他玩家手牌中获取一张由mid指定的牌，并将它放在idle列表第一位
-------------------------------------------------------------------------------
function deskOperation:getMahjongFromIdle(mid)
    local index = self:getIdleStart()

    if mid < 0 then
        return self.idleMahjongs[index]
    end

    --现在“城墙”里面查找
    for k, v in pairs(self.idleMahjongs) do
        if v.id == mid then
            swap(self.idleMahjongs, k, self.idleMahjongs, index)
            return v
        end
    end
    --如果没有，就在其他玩家的手牌里查找（都是从“城墙”里面临时借出的）
    for acid, h in pairs(self.inhandMahjongs) do
        if acid ~= gamepref.acId then
            for k, v in pairs(h) do
                if v.id == mid then
                    swap(h, k, self.idleMahjongs, index)
                    return v
                end
            end
        end
    end
        
    return nil
end

-------------------------------------------------------------------------------
-- 增加手牌
-------------------------------------------------------------------------------
function deskOperation:increaseInhandMahjongs(acId, datas, visible)
    local mahjongs = self.inhandMahjongs[acId]
    local index = self:getIdleStart()

    for _, id in pairs(datas) do
        local m = self:getMahjongFromIdle(id)
        table.insert(mahjongs, m)
        table.remove(self.idleMahjongs, index)

        if visible then
            m:show()
        else
            m:hide()
        end
    end

    local player = self.game:getPlayerByAcId(acId)
    self:relocateInhandMahjongs(player, mahjongs)
end

-------------------------------------------------------------------------------
-- 将麻将m插入到手牌中
-------------------------------------------------------------------------------
function deskOperation:insertMahjongToInhand(m)
    local mahjongs = self.inhandMahjongs[gamepref.acId]
    table.insert(mahjongs, m)

    local player = self.game:getPlayerByAcId(gamepref.acId)
    self:relocateInhandMahjongs(player, mahjongs)
end

-------------------------------------------------------------------------------
-- 减少手牌
-------------------------------------------------------------------------------
function deskOperation:decreaseInhandMahjongs(acId, datas)
    local decreaseMahjongs = {}
    local mahjongs = self.inhandMahjongs[acId]
    
    if acId == gamepref.acId then
        for _, id in pairs(datas) do
            for k, v in pairs(mahjongs) do
                if v.id == id then
                    table.insert(decreaseMahjongs, v)
                    table.remove(mahjongs, k)
                    break
                end
            end
        end
    else
        for _, id in pairs(datas) do
            local m = self:getMahjongFromIdle(id)
            local index = self:getIdleStart()
            swap(mahjongs, 1, self.idleMahjongs, index)
            table.insert(decreaseMahjongs, m)
            table.remove(mahjongs, 1)
        end
    end

    local player = self.game:getPlayerByAcId(acId)
    self:relocateInhandMahjongs(player, mahjongs)

    return decreaseMahjongs
end

-------------------------------------------------------------------------------
-- 调整手牌位置
-------------------------------------------------------------------------------
function deskOperation:relocateInhandMahjongs(player, mahjongs)
    if mahjongs == nil then
        return
    end

    if player.acId == gamepref.acId then
        table.sort(mahjongs, function(a, b)
            return a.id > b.id
        end)
    end

    local turn = self.game:getSeatType(player.turn)
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.shou].pos
    local r = seat[mahjongGame.cardType.shou].rot
    local s = seat[mahjongGame.cardType.shou].scl

    for k, m in pairs(mahjongs) do
        k = k - 1
        local p = nil

        if turn == mahjongGame.seatType.mine then
            p = Vector3.New(o.x - (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(true)
        elseif turn == mahjongGame.seatType.left then
            p = Vector3.New(o.x, o.y, o.z + (mahjong.w * k) * s.z)
            m:setPickabled(false)
        elseif turn == mahjongGame.seatType.right then
            p = Vector3.New(o.x, o.y, o.z - (mahjong.w * k) * s.z)
            m:setPickabled(false)
        else
            p = Vector3.New(o.x + (mahjong.w * k) * s.x, o.y, o.z)
            m:setPickabled(false)
        end

        m:setLocalPosition(p)
        m:setLocalRotation(r)
        m:setLocalScale(s)
    end
end

-------------------------------------------------------------------------------
-- 调整出牌位置
-------------------------------------------------------------------------------
function deskOperation:relocateChuMahjongs(player)
    local acId = player.acId
    local turn = self.game:getSeatType(player.turn)
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.chu].pos
    local r = seat[mahjongGame.cardType.chu].rot
    local s = seat[mahjongGame.cardType.chu].scl

    local chuMahjongs = self.chuMahjongs[acId]

    for k, m in pairs(chuMahjongs) do
        k = k - 1
        local p = m:getLocalPosition()

        local u = math.floor(k / 10)
        local c = k % 10
        local y = (u < 2) and o.y or o.y + (mahjong.z * s.y)
        local d = (u % 2) * (mahjong.h * s.z)

        if turn == mahjongGame.seatType.mine then
            p:Set(o.x + (mahjong.w * c) * s.x, y, o.z - d)
        elseif turn == mahjongGame.seatType.left then
            p:Set(o.x - d, y, o.z - (mahjong.w * c) * s.z)
        elseif turn == mahjongGame.seatType.right then
            p:Set(o.x + d, y, o.z + (mahjong.w * c) * s.z)
        else
            p:Set(o.x - (mahjong.w * c) * s.x, y, o.z + d)
        end

        m:setPickabled(false)
        m:setLocalPosition(p)
        m:setLocalRotation(r)
        m:setLocalScale(s)
    end
end

-------------------------------------------------------------------------------
-- 调整碰/杠牌位置
-------------------------------------------------------------------------------
function deskOperation:relocatePengMahjongs(player)
    local acId = player.acId
    local turn = self.game:getSeatType(player.turn)
    local seat = self.seats[turn]

    local o = seat[mahjongGame.cardType.peng].pos
    local r = seat[mahjongGame.cardType.peng].rot
    local s = seat[mahjongGame.cardType.peng].scl

    local pengMahjongs = self.pengMahjongs[acId]

    for i, mahjongs in pairs(pengMahjongs) do
        i = i - 1
        local d = 0.015 * i -- 碰/杠牌每组之间的间隔

        for k, m in pairs(mahjongs) do 
            local c = 3 * i + k - 1
            local p = m:getLocalPosition()
            local y = o.y
        
            if k == 4 then -- 杠的第4张牌放在第2张上面
                c = 3 * i + 1
                y = o.y + mahjong.z
            end 

            if turn == mahjongGame.seatType.mine then
                p:Set(o.x + (mahjong.w * c) * s.x + d, y, o.z)
            elseif turn == mahjongGame.seatType.left then
                p:Set(o.x, y, o.z - (mahjong.w * c) * s.z - d)
            elseif turn == mahjongGame.seatType.right then
                p:Set(o.x, y, o.z + (mahjong.w * c) * s.z + d)
            else
                p:Set(o.x - (mahjong.w * c) * s.x - d, y, o.z)
            end

            m:setPickabled(false)
            m:setLocalPosition(p)
            m:setLocalRotation(r)
            m:setLocalScale(s)
        end
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
    if self.chuMahjongs[acId] == nil then
        self.chuMahjongs[acId] = {}
    end

    table.insert(self.chuMahjongs[acId], mj)

    local player = self.game:getPlayerByAcId(acId)
    self:relocateChuMahjongs(player)
end

-------------------------------------------------------------------------------
-- 将mahjong放到出牌区
-------------------------------------------------------------------------------
function deskOperation:putMahjongsToPeng(acId, mahjongs)
    if self.pengMahjongs[acId] == nil then
        self.pengMahjongs[acId] = {}
    end

    table.insert(self.pengMahjongs[acId], mahjongs)

    local player = self.game:getPlayerByAcId(acId)
    self:relocatePengMahjongs(player)
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
-- 重置
-------------------------------------------------------------------------------
function deskOperation:clear(forceDestroy)
    log("clear, forceDestroy = " .. tostring(forceDestroy))

    if forceDestroy then
        -- 直接删除
        for _, m in pairs(self.idleMahjongs) do
            m:destroy()
        end
        self.idleMahjongs = {}

        for _, p in pairs(self.game.players) do
            local inhand = self.inhandMahjongs[p.acId]
            if inhand ~= nil then
                for _, v in pairs(inhand) do
                    v:destroy()
                end
            end

            local peng = self.pengMahjongs[p.acId]
            if peng ~= nil then
                for _, u in pairs(peng) do
                    for _, v in pairs(u) do
                        v:destroy()
                    end
                end
            end

            local chu = self.chuMahjongs[p.acId]
            if chu ~= nil then
                for _, v in pairs(chu) do
                    v:destroy()
                end
            end

            local hu = self.huMahjongs[package.acId]
            if hu ~= nil then
                hu:destroy()
            end

            self.inhandMahjongs[p.acId] = nil
            self.chuMahjongs[p.acId]    = nil
            self.pengMahjongs[p.acId]   = nil
            self.huMahjongs[p.acId]     = nil
        end
    else
        -- 不强制删除，则将麻将重新有序地放回idle列表并剔除重复id（一炮多响会出现一个id对应多个麻将实体）
        local set = {}

        local function insert(m)
            if m == nil then
                return
            end

            if set[m.id] == nil then
                m:hide()
                set[m.id] = m
            else
                m:destroy()
            end
        end

        if self.mo ~= nil then
            insert(self.mo)
        end

        for _, m in pairs(self.idleMahjongs) do
            insert(m)
        end
        self.idleMahjongs = {}

        for _, p in pairs(self.game.players) do
            local inhand = self.inhandMahjongs[p.acId]
            if inhand ~= nil then
                for _, v in pairs(inhand) do
                    insert(v)
                end
            end

            local peng = self.pengMahjongs[p.acId]
            if peng ~= nil then
                for _, u in pairs(peng) do
                    for _, v in pairs(u) do
                        insert(v)
                    end
                end
            end

            local chu = self.chuMahjongs[p.acId]
            if chu ~= nil then
                for _, v in pairs(chu) do
                    insert(v)
                end
            end

            local hu = self.huMahjongs[p.acId]
            insert(hu)

            self.inhandMahjongs[p.acId] = nil
            self.chuMahjongs[p.acId]    = nil
            self.pengMahjongs[p.acId]   = nil
            self.huMahjongs[p.acId]     = nil
        end

        for _, v in pairs(set) do
            table.insert(self.idleMahjongs, v)
        end
    end

    self.mo = nil
    log("clear over, idle count = " .. tostring(#self.idleMahjongs))
end

-------------------------------------------------------------------------------
-- 重置
-------------------------------------------------------------------------------
function deskOperation:reset()
    touch.removeListener()

    self:clear(false)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 销毁
-------------------------------------------------------------------------------
function deskOperation:onDestroy()
    touch.removeListener()
    self:clear(true)

    for _, v in pairs(self.diceMats) do
        if v.mainTexture ~= nil then
            textureManager.unload(v.mainTexture)
        end
    end

    for _, v in pairs(self.planeMats) do
        if v.mainTexture ~= nil then
            textureManager.unload(v.mainTexture)
        end
    end
end

return deskOperation

--endregion
