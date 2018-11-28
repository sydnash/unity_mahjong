--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass  = require("const.mahjongClass")
local mahjongType   = require("logic.mahjong.mahjongType")
local mahjongGame   = require("logic.mahjong.mahjongGame")
local mahjong       = require("logic.mahjong.mahjong")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local mahjongOperation = class("mahjongOperation", base)

_RES_(mahjongOperation, "DeskOperationUI", "DeskOperationUI")

mahjongOperation.seats = {
    [mahjongGame.seatType.mine] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.235, 0.156, -0.268), rot = Quaternion.Euler(180, 0, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.204, 0.175, -0.355), rot = Quaternion.Euler(-100, 0, 0), },
            [gameMode.playback] = { pos = Vector3.New(-0.204, 0.175, -0.355), rot = Quaternion.Euler(-100, 0, 0), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.400 + mahjong.w * 2, 0.156, -0.360), rot = Quaternion.Euler(0, 0, 0), },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.110, 0.156, -0.140), rot = Quaternion.Euler(0, 0, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 0, 0), },
        [mahjongGame.cardType.huan] = { pos = Vector3.New( 0,     0.156, -0.180), rot = Quaternion.Euler(180, 0, 0), },
    },
    [mahjongGame.seatType.right] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.309, 0.156,  0.275), rot = Quaternion.Euler(180, 90, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New( 0.370, 0.167,  0.228), rot = Quaternion.Euler(-90, 0, -90), },
            [gameMode.playback] = { pos = Vector3.New( 0.370, 0.167,  0.228), rot = Quaternion.Euler(-90, 0, -90), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.420, 0.156, -0.320), rot = Quaternion.Euler(0, -90, 0), },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.160, 0.156, -0.080), rot = Quaternion.Euler(0, -90, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156,  0.320), rot = Quaternion.Euler(0, -90, 0), },
        [mahjongGame.cardType.huan] = { pos = Vector3.New( 0.200, 0.156,  0.004), rot = Quaternion.Euler(180, 90, 0), },
    },
    [mahjongGame.seatType.top] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.235, 0.156,  0.330), rot = Quaternion.Euler(180, 0, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.215, 0.167,  0.390), rot = Quaternion.Euler(-90, 0, 180), },
            [gameMode.playback] = { pos = Vector3.New(-0.215, 0.167,  0.390), rot = Quaternion.Euler(-90, 0, 180), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.360, 0.156,  0.420), rot = Quaternion.Euler(0, 180, 0), },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.100, 0.156,  0.195), rot = Quaternion.Euler(0, 180, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156,  0.320), rot = Quaternion.Euler(0, 180, 0), },
        [mahjongGame.cardType.huan] = { pos = Vector3.New( 0,     0.156,  0.180), rot = Quaternion.Euler(180, 0, 0), },
    },
    [mahjongGame.seatType.left] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.310, 0.156, -0.195), rot = Quaternion.Euler(180, 90, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.370, 0.167, -0.180), rot = Quaternion.Euler(-90, 0, 90), },
            [gameMode.playback] = { pos = Vector3.New(-0.370, 0.167, -0.180), rot = Quaternion.Euler(-90, 0, 90), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.420, 0.156,  0.320), rot = Quaternion.Euler(0, 90, 0), },
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.170, 0.156,  0.150), rot = Quaternion.Euler(0, 90, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 90, 0), },
        [mahjongGame.cardType.huan] = { pos = Vector3.New(-0.200, 0.156,  0.004), rot = Quaternion.Euler(180, 90, 0), },
    },
}

local mopaiConfig = {
    position = Vector3.New(0.255, 0.175, -0.355),
    rotation = Quaternion.Euler(-100, 0, 0),
}

local COUNTDOWN_SECONDS_C = 20

local ROTATION_90_DEGREE  = Quaternion.Euler(0,  90, 0)
local ROTATION_180_DEGREE = Quaternion.Euler(0, 180, 0)
local ROTATION_270_DEGREE = Quaternion.Euler(0, -90, 0)

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
        local visible = a:getVisibled()

        a:setLocalPosition(b:getLocalPosition())
        a:setLocalRotation(b:getLocalRotation())
        a:setVisibled(b:getVisibled())

        b:setLocalPosition(p)
        b:setLocalRotation(r)
        b:setVisibled(visible)
        --交换索引
        ta[ia] = b
        tb[ib] = a
    end
end

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function mahjongOperation:ctor(game)
    self.game = game
    self.super.ctor(self)
end

-------------------------------------------------------------------------------
-- 初始化
-------------------------------------------------------------------------------
function mahjongOperation:onInit()
    self.turnCountdown = COUNTDOWN_SECONDS_C
    self.countdownTick = -1

    --麻将出口的板子节点
    local plane = find("table_plane")
    self.planeAnim = getComponentU(plane.gameObject, typeof(UnityEngine.Animation))
    local planeClip = animationManager.load("deskplane", "deskplane")
    self.planeAnim:AddClip(planeClip, planeClip.name)
    self.planeAnim.clip = planeClip
    --麻将根节点
    self.mahjongsRoot = find("mahjongs_root")
    self.mahjongsRootAnim = getComponentU(self.mahjongsRoot.gameObject, typeof(UnityEngine.Animation))
    local mahjongsRootClip = animationManager.load("mahjongroot", "mahjongroot")
    self.mahjongsRootAnim:AddClip(mahjongsRootClip, mahjongsRootClip.name)
    self.mahjongsRootAnim.clip = mahjongsRootClip
    --圆盘
    local circle = find("planes/cricle/Cricle_0")
    local circleMat = getComponentU(circle.gameObject, typeof(UnityEngine.MeshRenderer)).sharedMaterial
    circleMat.mainTexture = textureManager.load("", "deskfw")
    --方向指示节点
    self.planeRoot = find("planes")
    self:rotatePlanes()
    local planeNames = { 
        [mahjongGame.seatType.mine]  = "plane02/plane02_0", 
        [mahjongGame.seatType.right] = "plane03/plane03_0", 
        [mahjongGame.seatType.top]   = "plane04/plane04_0", 
        [mahjongGame.seatType.left]  = "plane01/plane01_0", 
    }
    self.planeMats = {}
    for i=mahjongGame.seatType.mine, mahjongGame.seatType.left do
        local go = findChild(self.planeRoot.transform, planeNames[i])
        local mesh = getComponentU(go.gameObject, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.planeMats[i] = mat
    end
    self:darkPlanes()
    --骰子节点和动画
    self.diceRoot = find("shaizi")
    self.diceRootAnim = getComponentU(self.diceRoot.gameObject, typeof(UnityEngine.Animation))
    local diceRootClip = animationManager.load("diceroot", "diceroot")
    self.diceRootAnim:AddClip(diceRootClip, diceRootClip.name)
    self.diceRootAnim.clip = diceRootClip

    self.diceMats = {}
    for i=1, 2 do
        local go = findChild(self.diceRoot.transform, string.format("shaizi0%d/shaizi0%d_0", i, i))
        local mesh = getComponentU(go.gameObject, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.diceMats[i] = mat
    end

    self.centerGlass = find("planes/glass")
    self.countdown = find("countdown")
    local a = self.countdown:findChild("a")
    local b = self.countdown:findChild("b")
    self.countdown.a = getComponentU(a.gameObject, typeof(SpriteRD))
    self.countdown.b = getComponentU(b.gameObject, typeof(SpriteRD))
    self:setCountdownVisible(false)

    self.chupaiPtr = find("chupaiPtr")
    local chupaiPtrD = self.chupaiPtr:findChild("mesh_diamond2")
    local chupaiPtrAnim = getComponentU(chupaiPtrD.gameObject, typeof(UnityEngine.Animation))
    local chupaiPtrClip = animationManager.load("chupaiptr", "chupaiptr")
    chupaiPtrAnim:AddClip(chupaiPtrClip, chupaiPtrClip.name)
    chupaiPtrAnim.clip = chupaiPtrClip
    self.chupaiPtr:hide()

    --按钮
    self.mHnzDo:addClickListener(self.onHnzChooseClickedHandler, self)
    self.mTiao:addClickListener(self.onTiaoClickedHandler, self)
    self.mTong:addClickListener(self.onTongClickedHandler, self)
    self.mWan:addClickListener(self.onWanClickedHandler, self)

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

    self.mGang_MS_ButtonA:addClickListener(self.onGangAClickedHandler, self)
    self.mGang_MS_ButtonB:addClickListener(self.onGangBClickedHandler, self)
    self.mGang_MS_ButtonC:addClickListener(self.onGangCClickedHandler, self)

    self.mGang_MS:hide()
    self.mHnz:hide()
    self.mQue:hide()
    self.mDQTips:hide()
    self.mHnzNotify:hide()
    self:hideOperations()

    self.idleMahjongs   = {}
    self.inhandMahjongs = {}
    self.chuMahjongs    = {}
    self.pengMahjongs   = {}
    self.huMahjongs     = {}
    self.hnzMahjongs    = {}

    self:loadMahjongs()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    local oriScreenAspect = 16 / 9
    local inhandCamera = GameObjectPicker.instance.camera
    local inhandCameraH = inhandCamera.orthographicSize
    local inhandCameraW = inhandCameraH * oriScreenAspect
    local newH = inhandCameraW / inhandCamera.aspect

    local inhandCameraBottom = inhandCamera.transform.position.y - inhandCameraH
    inhandCamera.orthographicSize = newH
    local newy = inhandCameraBottom + newH

    log("new camera pos y " .. tostring(newy))
    inhandCamera.transform.position = Vector3.New(inhandCamera.transform.position.x, newy, inhandCamera.transform.position.z)
end

-------------------------------------------------------------------------------
-- 加载麻将模型
-------------------------------------------------------------------------------
function mahjongOperation:loadMahjongs()
    for i=0, self.game:getTotalMahjongCount() - 1 do
        local m = mahjong.new(i)
        m:hide()
        m:setParent(self.mahjongsRoot)

        table.insert(self.idleMahjongs, m)
    end
end

-------------------------------------------------------------------------------
-- 主要处理中间的倒计时
-------------------------------------------------------------------------------
function mahjongOperation:update()
    if self.countdownTick ~= nil and self.countdownTick > 0 and self.turnCountdown > 0 then
        local now = time.realtimeSinceStartup()
        local delta = math.floor(now - self.countdownTick)
        
        if delta >= 1 then
            self.turnCountdown = math.max(0, self.turnCountdown - delta)

            local a = math.floor(self.turnCountdown / 10)
            self.countdown.a.spriteName = tostring(a)
            local b = math.floor(self.turnCountdown % 10)
            self.countdown.b.spriteName = tostring(b)

            self.countdownTick = now
        end
    end
end

-------------------------------------------------------------------------------
-- 设置倒计时的可见性
-------------------------------------------------------------------------------
function mahjongOperation:setCountdownVisible(visible)
    if visible then
        self.diceRoot:hide()
        self.centerGlass:show()
        self.countdown:show()
    else
        self.diceRoot:show()
        self.centerGlass:hide()
        self.countdown:hide()
    end
end

-------------------------------------------------------------------------------
-- 游戏开始
-------------------------------------------------------------------------------
function mahjongOperation:onGameStart()
    self:rotatePlanes()

    self.countdownTick = -1
    self:darkPlanes()
    self:setCountdownVisible(false)
    self.chupaiPtr:hide()

    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(false)

    eventManager.registerAnimationTrigger("table_plane_down", function()
        for _, m in pairs(self.idleMahjongs) do
            m:show()
            m:setPickabled(false)
        end
    end)

    self:playAnimation(self.planeAnim)
    self:playAnimation(self.mahjongsRootAnim)
    self:playDiceAnim()
end

-------------------------------------------------------------------------------
-- 播放动画
-------------------------------------------------------------------------------
function mahjongOperation:playAnimation(animation)
    animation:Stop()
    animation:Rewind()
    animation:Play()
end

-------------------------------------------------------------------------------
-- 游戏同步
-------------------------------------------------------------------------------
function mahjongOperation:onGameSync()
    local reenter = self.game.data.Reenter

    if self.game.deskStatus == deskStatus.hsz then
        self.hnzCount = reenter.HSZCnt
        self.mHnzText:setText(string.format("请选择%d张", self.hnzCount))

        self.mHnz:show()
    else
        self.hnzCount = 0
        self.mHnz:hide()
    end

    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(true)    

    for _, v in pairs(self.game.players) do 
        if v.hu ~= nil then
            local mid = v.hu[1].HuCard

            if mid >= 0 then
                local m = self:getMahjongFromIdle(mid)

                if m ~= nil then
                    self:removeFromIdle()
                else
                    --如一炮双响的时候，会出现无法从idle列表中搜索到牌的情况
                    --此时，就直接创建一个新的麻将对象
                    m = mahjong.new(mid)
                end

                local s = self.game:getSeatTypeByAcId(v.acId)
                local c = self.seats[s][mahjongGame.cardType.hu]

                m:setLocalPosition(c.pos)
                m:setLocalRotation(c.rot)

                self.huMahjongs[v.acId] = m
            end
        end

        self:createPengMahjongs(v)
        self:createChuMahjongs(v)
        self:createInHandMahjongs(v)
        self:createHuanNZhangMahjongs(v)
    end

    local chu = nil

    for _, u in pairs(self.chuMahjongs) do
        for _, v in pairs(u) do
            if v.id == reenter.CurDiPai then
                chu = v
                break
            end
        end

        if chu ~= nil then
            local c = chu:getLocalPosition()
            local p = self.chupaiPtr:getLocalPosition()
            p:Set(c.x, c.y + mahjong.z * 0.55 + 0.025, c.z)
            self.chupaiPtr:setLocalPosition(p)
            self.chupaiPtr:show()

            break
        end
    end

    if self.game.deskStatus == deskStatus.dingque then
        self.mDQTips:show()

        local player = self.game:getPlayerByAcId(self.game.mainAcId)
        if player.que < 0 then
            self.mQue:show()
        end
    elseif self.game.deskStatus == deskStatus.playing then
        self:onOpList(reenter.CurOpList)
        self:highlightPlaneByAcId(reenter.CurOpAcId)
        self.turnCountdown = COUNTDOWN_SECONDS_C
        self.countdownTick = time.realtimeSinceStartup()
        self:setCountdownVisible(true)
    end

    if self.game.mode == gameMode.normal then
        touch.addListener(self.touchHandler, self)
    end
end

-------------------------------------------------------------------------------
-- 从idle列表中删除指定索引的数据，默认删除start index的数据
-------------------------------------------------------------------------------
function mahjongOperation:removeFromIdle(index)
    if index == nil then
        index = self:getIdleStart()
    end

    table.remove(self.idleMahjongs, index)
end

-------------------------------------------------------------------------------
-- 创建“城墙”
-------------------------------------------------------------------------------
function mahjongOperation:relocateIdleMahjongs(visible)
    local mahjongCount = self.game:getTotalMahjongCount()
    local markerTurn   = self.game:getMarkerPlayer().turn
    local playerStart  = (self.game.dices[1] + self.game.dices[2] + markerTurn) % 4 - 1

    local dirMahjongCnt = {}
    for i = 0, 3 do
        dirMahjongCnt[i] = 0
    end
    local i = 0
    while mahjongCount > 0 do
        mahjongCount = mahjongCount - 2
        dirMahjongCnt[i%4] = dirMahjongCnt[i%4] + 1
        i = i + 1
    end

    local acc = 1
    for dir = playerStart, playerStart-3, -1 do
        if dir < 0 then
            dir = dir + 4
        end
        local i = dirMahjongCnt[dir]
        i = i * 2

        local seat = self.seats[dir]

        local o = seat[mahjongGame.cardType.idle].pos
        local r = seat[mahjongGame.cardType.idle].rot
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

            if dir == mahjongGame.seatType.mine then
                x = (o.x - d) - w
            elseif dir == mahjongGame.seatType.left then
                z = (o.z + d) + w
            elseif dir == mahjongGame.seatType.right then
                z = (o.z - d) - w
            else
                x = (o.x + d) + w
            end
            
            local p = m:getLocalPosition()
            p:Set(x, y, z)

            m:setLocalPosition(p)
            m:setLocalRotation(r)
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
function mahjongOperation:OnFaPai()
    self:highlightPlaneByAcId(self.game.markerAcId)

    for _, player in pairs(self.game.players) do
        self:createInHandMahjongs(player)
    end
    
    if self.game.mode == gameMode.normal then
        touch.addListener(self.touchHandler, self)
    end
end

-------------------------------------------------------------------------------
-- 播放骰子动画
-------------------------------------------------------------------------------
function mahjongOperation:playDiceAnim()
    soundManager.playGfx("mahjong", "shaizi")
    self:playAnimation(self.diceRootAnim)

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
-- 定缺提示
-------------------------------------------------------------------------------
function mahjongOperation:onDingQueHint(msg)
    self.mDQTips:show()
    self.mQue:show()
end

-------------------------------------------------------------------------------
-- 定缺结束
-------------------------------------------------------------------------------
function mahjongOperation:onDingQueDo(msg)
    local acId = self.game.mainAcId

    local player = self.game:getPlayerByAcId(acId)
    local mahjongs = self.inhandMahjongs[acId]

    for _, v in pairs(mahjongs) do
        if v.class == player.que then
            v:dark()
        else
            v:light()
        end  
    end

    self:relocateInhandMahjongs(acId)

    self.mDQTips:hide()
    self.mQue:hide()
end

-------------------------------------------------------------------------------
-- 创建手牌
-------------------------------------------------------------------------------
function mahjongOperation:createInHandMahjongs(player)
    local datas = player[mahjongGame.cardType.shou]

    self.inhandMahjongs[player.acId] = {}
    self:increaseInhandMahjongs(player.acId, datas)
end

-------------------------------------------------------------------------------
-- 创建出牌
-------------------------------------------------------------------------------
function mahjongOperation:createChuMahjongs(player)
    local datas = player[mahjongGame.cardType.chu]

    for _, id in pairs(datas) do
        local m = self:getMahjongFromIdle(id)
        m:show()
        self:putMahjongToChu(player.acId, m)
        self:removeFromIdle()
    end    
end

-------------------------------------------------------------------------------
-- 创建碰/杠牌
-------------------------------------------------------------------------------
function mahjongOperation:createPengMahjongs(player)
    local datas = player[mahjongGame.cardType.peng]

    for _, d in pairs(datas) do
        local mahjongs = {}

        for _, id in pairs(d.Cs) do
            local m = self:getMahjongFromIdle(id)
            m:show()
            table.insert(mahjongs, m)
            self:removeFromIdle()
        end

        self:putMahjongsToPeng(player.acId, mahjongs)
    end
end

-------------------------------------------------------------------------------
-- 创建换牌
-------------------------------------------------------------------------------
function mahjongOperation:createHuanNZhangMahjongs(player)
    local mahjongs = {}
    local datas = player[mahjongGame.cardType.huan]

    for _, v in pairs(datas) do
        local m = self:getMahjongFromIdle(v)
        m:show()
        table.insert(mahjongs, m)
        self:removeFromIdle()
    end

    self:putMahjongsToHuan(player.acId, mahjongs)
end

-------------------------------------------------------------------------------
-- 摸牌
-------------------------------------------------------------------------------
function mahjongOperation:onMoPai(acId, cards)
    self.turnCountdown = COUNTDOWN_SECONDS_C
    self.countdownTick = time.realtimeSinceStartup()
    self:highlightPlaneByAcId(acId)
    
    if acId ~= self.game.mainAcId then
        self:increaseInhandMahjongs(acId, cards)
    else
        local player = self.game:getPlayerByAcId(acId)

        self.mo = self:getMahjongFromIdle(cards[1])
        self:removeFromIdle()

        local mahjongs = self.inhandMahjongs[player.acId]
        local moPaiPos = self:getMyInhandMahjongPos(player, #mahjongs + 1)
        moPaiPos.x = moPaiPos.x + mahjong.w * 0.33

        self.mo:setLocalPosition(moPaiPos)
        self.mo:setLocalRotation(mopaiConfig.rotation)
--        self.mo:setLocalScale(mopaiConfig.scale)

        if self.mo.class == player.que then
            self.mo:dark()
        else
            self.mo:light()
        end

        self.mo:setPickabled(true)
        self.mo:show()
    end
end

-------------------------------------------------------------------------------
-- OpList
-------------------------------------------------------------------------------
function mahjongOperation:onOpList(oplist)
    if oplist ~= nil then
        local infos = oplist.OpInfos
        local leftTime = oplist.L

        for _, v in pairs(infos) do
            if v.Op == opType.chu.id then
                self:beginChuPai()
            end
        end

        self.mDQTips:hide()
        self:showOperations(infos, leftTime)
    end
end

-------------------------------------------------------------------------------
-- 可以出牌
-------------------------------------------------------------------------------
function mahjongOperation:beginChuPai()
    self.canChuPai = true

    self:highlightPlaneByAcId(self.game.mainAcId)
    self.turnCountdown = COUNTDOWN_SECONDS_C
    self.countdownTick = time.realtimeSinceStartup()
    self:setCountdownVisible(true)

    if self.mo == nil then
        local player = self.game:getPlayerByAcId(self.game.mainAcId)
        local mahjongs = self.inhandMahjongs[self.game.mainAcId]
        local moPaiPos = self:getMyInhandMahjongPos(player, #mahjongs)
        moPaiPos.x = moPaiPos.x + mahjong.w * 0.33
        mahjongs[#mahjongs]:setLocalPosition(moPaiPos)
    end
end

-------------------------------------------------------------------------------
-- 不能出牌
-------------------------------------------------------------------------------
function mahjongOperation:endChuPai()
    self.canChuPai = false
end

-------------------------------------------------------------------------------
-- 处理鼠标/手指拖拽
-------------------------------------------------------------------------------
function mahjongOperation:touchHandler(phase, pos)
    local ds = self.game.deskStatus
    if self.game.mode == gameMode.playback or ds == deskStatus.none or ds == deskStatus.dingque then
        return
    end

    local camera = GameObjectPicker.instance.camera

    if ds == deskStatus.hsz then
        if phase == touch.phaseType.ended then
            local go = GameObjectPicker.instance:Pick(pos)
            if go ~= nil then
                if self.hnzMahjongs[self.game.mainAcId] == nil then
                    self.hnzMahjongs[self.game.mainAcId] = {}
                end

                local inhandMahjongs = self.inhandMahjongs[self.game.mainAcId]
                local hnzQueue = self.hnzMahjongs[self.game.mainAcId]
                local selectedMahjong = self:getMahjongByGo(inhandMahjongs, go)

                if selectedMahjong.selected then
                    selectedMahjong:setSelected(false)
                    table.removeItem(hnzQueue, selectedMahjong)
                    return
                end

                local chooseSameClass = true

                for _, v in pairs(hnzQueue) do
                    if v.class ~= selectedMahjong.class then
                        chooseSameClass = false
                        break
                    end
                end
                
                if chooseSameClass then
                    if #hnzQueue == self.hnzCount then
                        hnzQueue[1]:setSelected(false)
                        table.remove(hnzQueue, 1)
                    end
                else
                    for i=#hnzQueue, 1, -1 do
                        local v = hnzQueue[i]
                        v:setSelected(false)
                        table.remove(hnzQueue, i)
                    end
                end

                selectedMahjong:setSelected(true)
                table.insert(hnzQueue, selectedMahjong)
            end
        end
    else
        if phase == touch.phaseType.began then
            local go = GameObjectPicker.instance:Pick(pos)
            if go ~= nil then
                if self.mo ~= nil and self.mo.gameObject == go then
                    self.selectedMahjong = self.mo
                else
                    local inhandMahjongs = self.inhandMahjongs[self.game.mainAcId]
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

                    networkManager.chuPai({ id }, function(msg)
                        log("chu pai failed")
                        self:relocateInhandMahjongs(self.game.mainAcId)
                    end)

                    local player = self.game:getPlayerByAcId(self.game.mainAcId)
                    playMahjongSound(id, player.sex)
                end

                self.selectedMahjong = nil
            end
        end
    end
end

-------------------------------------------------------------------------------
-- 显示操作按钮
-------------------------------------------------------------------------------
function mahjongOperation:showOperations(ops, leftTime)
    for _, v in pairs(ops) do 
        if v.Op == opType.guo.id then
            self.mGuo:show()
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
function mahjongOperation:hideOperations()
    self.mGuo:hide()
    self.mBao:hide()
    self.mChi:hide()
    self.mPeng:hide()
    self.mGang:hide()
    self.mHu:hide()

    self.mGang_MS:hide()
end

-------------------------------------------------------------------------------
-- 点击“条”
-------------------------------------------------------------------------------
function mahjongOperation:onTiaoClickedHandler()
    playButtonClickSound()

    networkManager.dingque(mahjongClass.tiao, function(msg)
    end)
    self.mQue:hide()
end

-------------------------------------------------------------------------------
-- 点击“筒”
-------------------------------------------------------------------------------
function mahjongOperation:onTongClickedHandler()
    playButtonClickSound()

    networkManager.dingque(mahjongClass.tong, function(msg)
    end)
    self.mQue:hide()
end

-------------------------------------------------------------------------------
-- 点击“万”
-------------------------------------------------------------------------------
function mahjongOperation:onWanClickedHandler()
    playButtonClickSound()

    networkManager.dingque(mahjongClass.wan, function(msg)
    end)
    self.mQue:hide()
end

-------------------------------------------------------------------------------
-- 点击“过”
-------------------------------------------------------------------------------
function mahjongOperation:onGuoClickedHandler()
    playButtonClickSound()

    self.game:guo()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“报”
-------------------------------------------------------------------------------
function mahjongOperation:onBaoClickedHandler()
    playButtonClickSound()

    self.game:bao()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“吃”
-------------------------------------------------------------------------------
function mahjongOperation:onChiClickedHandler()
    playButtonClickSound()

    self.game:chi()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“碰”
-------------------------------------------------------------------------------
function mahjongOperation:onPengClickedHandler()
    local player = self.game:getPlayerByAcId(self.game.mainAcId)
    playMahjongOpSound(opType.peng.id, player.sex)

    self.game:peng(self.mPeng.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- “杠”
-------------------------------------------------------------------------------
local function opGang(game, cs)
    local player = game:getPlayerByAcId(game.mainAcId)
    playMahjongOpSound(opType.gang.id, player.sex)

    game:gang(cs)
end

-------------------------------------------------------------------------------
-- 点击“杠”
-------------------------------------------------------------------------------
function mahjongOperation:onGangClickedHandler()
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
            sprites[i]:setSprite(mahjongType[cs[1]].name)

            buttons[i]:show()
        end

        self.mGang_MS:show()
    end
end

-------------------------------------------------------------------------------
-- 点击“杠A”
-------------------------------------------------------------------------------
function mahjongOperation:onGangAClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonA.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“杠B”
-------------------------------------------------------------------------------
function mahjongOperation:onGangBClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonB.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“杠C”
-------------------------------------------------------------------------------
function mahjongOperation:onGangCClickedHandler()
    opGang(self.game, self.mGang_MS_ButtonC.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 点击“胡”
-------------------------------------------------------------------------------
function mahjongOperation:onHuClickedHandler()
    local player = self.game:getPlayerByAcId(self.game.mainAcId)
    playMahjongOpSound(opType.hu.id, player.sex)

    self.game:hu(self.mHu.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 出牌
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoChu(acId, cards)
    self:endChuPai()
    local chu = nil

    if acId == self.game.mainAcId and self.mo ~= nil and cards[1] == self.mo.id then
        self:putMahjongToChu(acId, self.mo)
        chu = self.mo
    else
        if acId == self.game.mainAcId and self.mo ~= nil then
            self:insertMahjongToInhand(self.mo)
        end

        local mahjongs = self:decreaseInhandMahjongs(acId, cards)
        for _, m in pairs(mahjongs) do
            self:putMahjongToChu(acId, m)
            chu = m
        end
    end

    if chu ~= nil then
        self.chupaiPtr.mahjongId = chu.id

        local c = chu:getLocalPosition()
        local p = self.chupaiPtr:getLocalPosition()
        p:Set(c.x, c.y + mahjong.z * 0.55 + 0.035, c.z)
        self.chupaiPtr:setLocalPosition(p)
        self.chupaiPtr:show()

        if acId == self.game.mainAcId then
            chu:light()
        end 
    end

    self.mo = nil
    soundManager.playGfx("mahjong", "chupai")

    if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongSound(cards[1], player.sex)
    end

    self.mDQTips:hide()
end

-------------------------------------------------------------------------------
-- 碰
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoPeng(acId, cards, beAcId, beCard)
    local beAcId = beAcId[1]

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

    if self.chupaiPtr.mahjongId == beCard then
        self.chupaiPtr:hide()
    end

    self:highlightPlaneByAcId(acId)

    if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.peng.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 杠
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoGang(acId, cards, beAcId, beCard, t)
    local detail = opType.gang.detail

    if t == detail.minggang then
        local beAcId = beAcId[1]

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

        if self.chupaiPtr.mahjongId == beCard then
            self.chupaiPtr:hide()
        end
    elseif t == detail.bagangwithmoney or t == detail.bagangwithoutmoney then
        if self.mo ~= nil then
            self:insertMahjongToInhand(self.mo)
            self.mo = nil
        end

        local m = self:decreaseInhandMahjongs(acId, cards)
        local p = self.pengMahjongs[acId]

        for _, v in pairs(p) do
            if v[1].name == m[1].name then
                table.insert(v, m[1])
                break
            end
        end 

        local player = self.game:getPlayerByAcId(acId)
        self:relocatePengMahjongs(player)
    else
        if self.mo ~= nil then
            self:insertMahjongToInhand(self.mo)
        end

        local mahjongs = self:decreaseInhandMahjongs(acId, cards)
        self:putMahjongsToPeng(acId, mahjongs)
    end

    if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.gang.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 胡
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoHu(acId, cards, beAcId, beCard, t)
    local hu = nil
    local detail = opType.hu.detail

    if t == detail.zimo or t == detail.gangshanghua or t == detail.haidilao then
        local inhand = self.inhandMahjongs[acId]

        if acId ~= self.game.mainAcId then
            local m, queue, idx = self:getMahjongFromIdle(beCard)
            swap(inhand, 1, queue, idx)
            table.remove(inhand, 1)

            hu = m
            --如果需要再把牌扣起来
            --
        else
            hu = self.mo
            self.mo = nil
        end
    else
        local beAcId = beAcId[1]
        local chu = self.chuMahjongs[beAcId]

        for k, v in pairs(chu) do
            if v.id == beCard then
                hu = v
                table.remove(chu, k)
                break
            end
        end

        if hu == nil then
            --如一炮双响的时候，会出现无法从idle列表中搜索到牌的情况
            --此时，就直接创建一个新的麻将对象
            hu = mahjong.new(beCard)
        end

        if self.chupaiPtr.mahjongId == beCard then
            self.chupaiPtr:hide()
        end
    end
    
    hu:setPickabled(false)
    self.huMahjongs[acId] = hu

    local s = self.game:getSeatTypeByAcId(acId)
    local t = self.seats[s][mahjongGame.cardType.hu]
    hu:setLocalPosition(t.pos)
    hu:setLocalRotation(t.rot)

    if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.hu.id, player.sex)
    end
end

-------------------------------------------------------------------------------
-- 取消所有操作
-------------------------------------------------------------------------------
function mahjongOperation:onClear()
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 获取从idle列表拿牌的索引值
-------------------------------------------------------------------------------
function mahjongOperation:getIdleStart()
    return (self.idleMahjongStart <= self.game:getLeftMahjongCount()) and self.idleMahjongStart or 1
end

-------------------------------------------------------------------------------
-- 从idle列表或者其他玩家手牌中获取一张由mid指定的牌，并将它放在idle列表第一位
-------------------------------------------------------------------------------
function mahjongOperation:getMahjongFromIdle(mid)
    local index = self:getIdleStart()

    if mid < 0 then
        return self.idleMahjongs[index], self.idleMahjongs, index
    end

    --先在“城墙”里面查找
    for k, v in pairs(self.idleMahjongs) do
        if v.id == mid then
            swap(self.idleMahjongs, k, self.idleMahjongs, index)
            return v, self.idleMahjongs, index
        end
    end
    --如果没有，就在其他玩家的手牌里查找（都是从“城墙”里面临时借出的）
    for acid, h in pairs(self.inhandMahjongs) do
        if acid ~= self.game.mainAcId then
            for k, v in pairs(h) do
                if v.id == mid then
                    if #self.idleMahjongs > 0 then
                        swap(h, k, self.idleMahjongs, index)
                        return v, self.idleMahjongs, index
                    else
                        return v, h, k
                    end
                end
            end
        end
    end
        
    log("connot find pai [id = " .. tostring(mid) .. "] from idle.")
    return nil, nil, nil
end

-------------------------------------------------------------------------------
-- 增加手牌
-------------------------------------------------------------------------------
function mahjongOperation:increaseInhandMahjongs(acId, datas)
    local mahjongs = self.inhandMahjongs[acId]

    for _, id in pairs(datas) do
        local m = self:getMahjongFromIdle(id)
        m:show()
        m:setPickabled(true)
        table.insert(mahjongs, m)
        self:removeFromIdle()

        if acId == self.game.mainAcId then
            local player = self.game:getPlayerByAcId(acId)
            if m.class == player.que then
                m:dark()
            else
                m:light()
            end
        end
    end

    self:relocateInhandMahjongs(acId)
end

-------------------------------------------------------------------------------
-- 将麻将m插入到手牌中
-------------------------------------------------------------------------------
function mahjongOperation:insertMahjongToInhand(m, relocate)
    m:setPickabled(true)

    local mahjongs = self.inhandMahjongs[self.game.mainAcId]
    table.insert(mahjongs, m)
    self:relocateInhandMahjongs(self.game.mainAcId)
end

-------------------------------------------------------------------------------
-- 减少手牌
-------------------------------------------------------------------------------
function mahjongOperation:decreaseInhandMahjongs(acId, datas)
    local decreaseMahjongs = {}
    local mahjongs = self.inhandMahjongs[acId]
    
    if acId == self.game.mainAcId then
        for _, id in pairs(datas) do
            for k, v in pairs(mahjongs) do
                if v.id == id then
                    v:setPickabled(false)
                    table.insert(decreaseMahjongs, v)
                    table.remove(mahjongs, k)
                    break
                end
            end
        end
    else
        for _, id in pairs(datas) do
            local m, mahjongQueue, idx = self:getMahjongFromIdle(id)
            swap(mahjongs, 1, mahjongQueue, idx)
            table.insert(decreaseMahjongs, m)
            table.remove(mahjongs, 1)
        end
    end

    self:relocateInhandMahjongs(acId)

    return decreaseMahjongs
end

-------------------------------------------------------------------------------
-- 调整手牌位置
-------------------------------------------------------------------------------
function mahjongOperation:getMyInhandMahjongPos(player, index) 
    index = index - 1
    local dir = self.game:getSeatTypeByAcId(player.acId)
    local seat = self.seats[dir]
    local o = seat[mahjongGame.cardType.shou][self.game.mode].pos
    o = Vector3.New(o.x, o.y, o.z)
    if dir == mahjongGame.seatType.mine then
        if self.lastPengPos then
            local sceneCamera = UnityEngine.Camera.main
            local screenPos = sceneCamera:WorldToScreenPoint(self.lastPengPos)
            local inhandCamera = GameObjectPicker.instance.camera
            local direct = o - inhandCamera.transform.position
            local project = Vector3.Project(direct, inhandCamera.transform.forward)
            screenPos.x = screenPos.x + 30
            local wp = inhandCamera:ScreenToWorldPoint(Vector3.New(screenPos.x, screenPos.y, project.magnitude))
            wp.x = wp.x + mahjong.w * 0.5
            o.x = wp.x
        end
        o.x = o.x + mahjong.w * index
        return o
    end
    return o
end

function mahjongOperation:relocateInhandMahjongs(acId)
    local player = self.game:getPlayerByAcId(acId)
    local mahjongs = self.inhandMahjongs[acId]

    if mahjongs ~= nil then
        self:sortInhand(player, mahjongs)

        local dir = self.game:getSeatTypeByAcId(player.acId)
        local seat = self.seats[dir]

        local o = self:getMyInhandMahjongPos(player, 1)
        local r = seat[mahjongGame.cardType.shou][self.game.mode].rot

        for k, m in pairs(mahjongs) do
            k = k - 1
            local p = m:getLocalPosition()

            if dir == mahjongGame.seatType.mine then
                p:Set(o.x + (mahjong.w * k), o.y, o.z)
                m:setPickabled(true)
            elseif dir == mahjongGame.seatType.left then
                p:Set(o.x, o.y, o.z + (mahjong.w * k))
                m:setPickabled(false)
            elseif dir == mahjongGame.seatType.right then
                p:Set(o.x, o.y, o.z - (mahjong.w * k))
                m:setPickabled(false)
            else
                p:Set(o.x + (mahjong.w * k), o.y, o.z)
                m:setPickabled(false)
            end

            m:setLocalPosition(p)
            m:setLocalRotation(r)
        end
    end
end

-------------------------------------------------------------------------------
-- 调整出牌位置
-------------------------------------------------------------------------------
function mahjongOperation:relocateChuMahjongs(player)
    local acId = player.acId
    local dir = self.game:getSeatTypeByAcId(acId)
    local seat = self.seats[dir]

    local o = seat[mahjongGame.cardType.chu].pos
    local r = seat[mahjongGame.cardType.chu].rot

    local chuMahjongs = self.chuMahjongs[acId]

    for k, m in pairs(chuMahjongs) do
        k = k - 1
        local p = m:getLocalPosition()

        local u = math.floor(k / 10)
        local c = k % 10
        local y = (u < 2) and o.y or o.y + mahjong.z
        local d = (u % 2) * mahjong.h

        if dir == mahjongGame.seatType.mine then
            p:Set(o.x + mahjong.w * c, y, o.z - d)
        elseif dir == mahjongGame.seatType.left then
            p:Set(o.x - d, y, o.z - mahjong.w * c)
        elseif dir == mahjongGame.seatType.right then
            p:Set(o.x + d, y, o.z + mahjong.w * c)
        else
            p:Set(o.x - mahjong.w * c, y, o.z + d)
        end

        m:setPickabled(false)
        m:setLocalPosition(p)
        m:setLocalRotation(r)
    end
end

-------------------------------------------------------------------------------
-- 调整碰/杠牌位置
-------------------------------------------------------------------------------
function mahjongOperation:relocatePengMahjongs(player)
    local acId = player.acId
    local dir = self.game:getSeatTypeByAcId(acId)
    local seat = self.seats[dir]

    local o = seat[mahjongGame.cardType.peng].pos
    local r = seat[mahjongGame.cardType.peng].rot

    local pengMahjongs = self.pengMahjongs[acId]

    local lastPengPos = nil
    for i, mahjongs in pairs(pengMahjongs) do
        i = i - 1
        local d = 0.015 * i -- 碰/杠牌每组之间的间隔

        for k, m in pairs(mahjongs) do 
            local c = 3 * i + k - 1
            local p = m:getLocalPosition()
            local y = o.y
        
            local isUpon = false
            if k == 4 then -- 杠的第4张牌放在第2张上面
                c = 3 * i + 1
                y = o.y + mahjong.z
                isUpon = true
            end 

            if dir == mahjongGame.seatType.mine then
                p:Set(o.x + mahjong.w * c + d, y, o.z)
            elseif dir == mahjongGame.seatType.left then
                p:Set(o.x, y, o.z - mahjong.w * c - d)
            elseif dir == mahjongGame.seatType.right then
                p:Set(o.x, y, o.z + mahjong.w * c + d)
            else
                p:Set(o.x - mahjong.w * c - d, y, o.z)
            end

            m:setPickabled(false)
            m:setLocalPosition(p)
            m:setLocalRotation(r)
--            m:setLocalScale(s)
            if not isUpon then
                lastPengPos = Vector3.New(o.x + mahjong.w * c + d + mahjong.w * 0.5, y, o.z - mahjong.z * 0.5)
            end
        end
    end

    if dir == mahjongGame.seatType.mine then
        self.lastPengPos = lastPengPos
    end

    if dir == mahjongGame.seatType.mine then
        self:relocateInhandMahjongs(self.game.mainAcId)
    end
end

-------------------------------------------------------------------------------
-- 获取mahjong对象
-------------------------------------------------------------------------------
function mahjongOperation:getMahjongByGo(mahjongs, gameObject)
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
function mahjongOperation:putMahjongToChu(acId, mj)
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
function mahjongOperation:putMahjongsToPeng(acId, mahjongs)
    if self.pengMahjongs[acId] == nil then
        self.pengMahjongs[acId] = {}
    end

    table.insert(self.pengMahjongs[acId], mahjongs)

    local player = self.game:getPlayerByAcId(acId)
    self:relocatePengMahjongs(player)
end

-------------------------------------------------------------------------------
-- 将mahjong放到换牌区
-------------------------------------------------------------------------------
function mahjongOperation:putMahjongsToHuan(acId, mahjongs)
    self.hnzMahjongs[acId] = mahjongs

    
    local t = self.game:getSeatTypeByAcId(acId)
    local s = self.seats[t]
    local o = s[mahjongGame.cardType.huan].pos
    local r = s[mahjongGame.cardType.huan].rot
    
    local m = self.game:getSeatTypeByAcId(acId)
    local c = mahjong.w * (self.hnzCount - 1) / 2

    for k, v in pairs(mahjongs) do
        local p = v:getLocalPosition()

        if m == mahjongGame.seatType.mine or m == mahjongGame.seatType.top then
            p:Set((k - 1) * mahjong.w - c, o.y, o.z)
        else
            p:Set(o.x, o.y, (k - 1) * mahjong.w - c)
        end

        v:setLocalPosition(p)
        v:setLocalRotation(r)
    end
end

-------------------------------------------------------------------------------
-- 将当前acid的plane高亮
-------------------------------------------------------------------------------
function mahjongOperation:highlightPlaneByAcId(acId)
    if self.game.markerAcId == nil or acId <= 0 then
        self:darkPlanes()
    else
        local base = self.game:getSeatTypeByAcId(self.game.markerAcId)
        local seat = self.game:getSeatTypeByAcId(acId)
        local diff = (seat ~= nil) and (seat - base + 4) % 4 or nil

        for s, m in pairs(self.planeMats) do
            if m.mainTexture ~= nil then
                textureManager.unload(m.mainTexture)
            end

            if diff ~= nil and s == diff then
                m.mainTexture = textureManager.load("", "deskfw_gl")
            else
                m.mainTexture = textureManager.load("", "deskfw")
            end
        end
    end
end

-------------------------------------------------------------------------------
-- 将当前acid的plane高亮
-------------------------------------------------------------------------------
function mahjongOperation:darkPlanes()
    for _, m in pairs(self.planeMats) do
        if m.mainTexture ~= nil then
            textureManager.unload(m.mainTexture)
        end

        m.mainTexture = textureManager.load("", "deskfw")
    end
end

-------------------------------------------------------------------------------
-- 重置
-------------------------------------------------------------------------------
function mahjongOperation:clear(forceDestroy)
--    log("clear, forceDestroy = " .. tostring(forceDestroy))
    self.lastPengPos = nil

    local function destroy(m)
        if m ~= nil then
            m:destroy()
        end
    end

    local set = {}
    local function insert(m)
        if m ~= nil then
            if set[m.id] == nil then
                m:reset()
                m:hide()
                set[m.id] = m
            else
                m:destroy()
            end
        end
    end

    local func = forceDestroy and destroy or insert

    for _, m in pairs(self.idleMahjongs) do
        func(m)
    end
    self.idleMahjongs = {}

    for _, p in pairs(self.game.players) do
        local inhand = self.inhandMahjongs[p.acId]
        if inhand ~= nil then
            for _, v in pairs(inhand) do
                func(v)
            end
        end

        local peng = self.pengMahjongs[p.acId]
        if peng ~= nil then
            for _, u in pairs(peng) do
                for _, v in pairs(u) do
                    func(v)
                end
            end
        end

        local chu = self.chuMahjongs[p.acId]
        if chu ~= nil then
            for _, v in pairs(chu) do
                func(v)
            end
        end

        local hu = self.huMahjongs[p.acId]
        if hu ~= nil then
            func(hu)
        end

        local huan = self.hnzMahjongs[p.acId]
        if huan ~= nil then
            for _, v in pairs(huan) do
                func(v)
            end
        end

        self.inhandMahjongs[p.acId] = nil
        self.chuMahjongs[p.acId]    = nil
        self.pengMahjongs[p.acId]   = nil
        self.huMahjongs[p.acId]     = nil
        self.hnzMahjongs[p.acId]    = nil
    end

    if not forceDestroy then
        for _, v in pairs(set) do
            table.insert(self.idleMahjongs, v)
        end
    end

    self.mo = nil
    self.chupaiPtr:hide()
    self.canChuPai = false
--    log("clear over, idle count = " .. tostring(#self.idleMahjongs))
end

-------------------------------------------------------------------------------
-- 重置
-------------------------------------------------------------------------------
function mahjongOperation:reset()
    if self.game.mode == gameMode.normal then
        touch.removeListener()
    end

    self.diceRoot:show()
    self.centerGlass:show()
    self.countdown:show()

    self:clear(false)

    self.mGang_MS:hide()
    self.mHnz:hide()
    self.mQue:hide()
    self.mDQTips:hide()
    self.mHnzNotify:hide()
    self:hideOperations()
end

function mahjongOperation:onCloseAllUIHandler()
    self:close()
end

-------------------------------------------------------------------------------
-- 销毁
-------------------------------------------------------------------------------
function mahjongOperation:onDestroy()
    if self.game.mode == gameMode.normal then
        touch.removeListener()
    end
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    self.diceRoot:show()
    self.centerGlass:show()
    self.countdown:show()

    self:clear(true)

    for _, v in pairs(self.diceMats) do
        if v.mainTexture ~= nil then
            textureManager.unload(v.mainTexture)
            v.mainTexture = nil
        end
    end

    for _, v in pairs(self.planeMats) do
        if v.mainTexture ~= nil then
            textureManager.unload(v.mainTexture)
            v.mainTexture = nil
        end
    end

    self.super.onDestroy(self)
end

-------------------------------------------------------------------------------
-- 手牌排序
-------------------------------------------------------------------------------
function mahjongOperation:sortInhand(player, mahjongs)
    if mahjongs == nil then
        return
    end
    if player.acId == self.game.mainAcId then
        table.sort(mahjongs, function(a, b)
            if a.class == player.que and b.class ~= player.que then
                return false
            elseif b.class == player.que and a.class ~= player.que then
                return true
            end

            return a.id < b.id
        end)
    end
end

-------------------------------------------------------------------------------
-- 旋转方位标志牌
-------------------------------------------------------------------------------
function mahjongOperation:rotatePlanes()
    if self.game.markerAcId ~= nil then
        local base = self.game:getSeatTypeByAcId(self.game.markerAcId)
        local seat = self.game:getSeatTypeByAcId(self.game.mainAcId)

        local rot = 0
        if base ~= nil and seat ~= nil then
            rot = 90 * (seat - base)
        end

        self.planeRoot.transform.localRotation = Quaternion.Euler(0, rot, 0)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongOperation:onHuanNZhangHint(msg)
    self.hnzCount = msg.Count
    self.mHnzText:setText(string.format("请选择%d张", self.hnzCount))
    self.mHnz:show()
end

-------------------------------------------------------------------------------
-- 通知服务器换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHnzChooseClickedHandler()
    playButtonClickSound()

    local hnzQueue = self.hnzMahjongs[self.game.mainAcId]
    if #hnzQueue < self.hnzCount then
        showMessageUI(string.format("请先选择%d张同花色的牌", self.hnzCount))
        return
    end

    local data = {}
    for _, v in pairs(self.hnzMahjongs[self.game.mainAcId]) do
        table.insert(data, v.id)
    end
    networkManager.huanNZhang(data)

    local mahjongs = self:decreaseInhandMahjongs(self.game.mainAcId, data)
    self:putMahjongsToHuan(self.game.mainAcId, mahjongs)

    self.mHnz:hide()
end

-------------------------------------------------------------------------------
-- 服务器通知换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHnzChoose(msg)
    local acId = msg.AcId
    local mahjongs = self.inhandMahjongs[acId]

    if acId == self.game.mainAcId then
        --先把换的牌放回手牌，因为客户端选择的和服务器通知的可能不一致
        for _, v in pairs(self.hnzMahjongs[acId]) do
            v:setPickabled(true)
            table.insert(mahjongs, v)
        end

        local mahjongs = self:decreaseInhandMahjongs(acId, msg.Cs)
        self:putMahjongsToHuan(acId, mahjongs)
    else
        local hms = {}

        for i=1, self.hnzCount do
            table.insert(hms, mahjongs[1])
            table.remove(mahjongs, 1)
        end
        self:putMahjongsToHuan(acId, hms)

        self:relocateInhandMahjongs(acId)
    end
end

-------------------------------------------------------------------------------
-- 服务器通知确定换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHuanNZhangDo(msg)
    local animation = tweenSerial.new(true)

    animation:add(tweenDelay.new(0.5))
    animation:add(tweenFunction.new(function()
        local text = string.empty
        local playerCount = self.game:getTotalPlayerCount()

        if playerCount == 4 then
            if msg.R == 1 then
                text = "逆时针交换"
            elseif msg.R == 2 then
                text = "对家交换"
            else
                text = "顺时针交换"
            end
        elseif playerCount == 3 then
            if msg.R == 1 then
                text = "逆时针交换"
            else
                text = "顺时针交换"
            end
        else
            text = "相互交换"
        end

        self.mHnzNotify:show(text)
    end))
    animation:add(tweenDelay.new(0.8))
    animation:add(tweenFunction.new(function()
        self.mHnzNotify:hide()
    end))
    animation:add(tweenDelay.new(0.5))
    animation:add(tweenFunction.new(function()
        for k, v in pairs(self.hnzMahjongs) do
            if k ~= msg.AcId then
                local mahjongs = self.inhandMahjongs[k]
                for _, u in pairs(v) do
                    table.insert(mahjongs, u)
                end
                self:relocateInhandMahjongs(k)
            end
        end

        local temp = self.hnzMahjongs[msg.AcId]--删除的牌
        self.hnzMahjongs = {}

        for k, id in pairs(msg.I) do
            local m, queue, idx = self:getMahjongFromIdle(id)
            swap(temp, k, queue, idx)
        end
        --把增加的牌插入手牌
        local mahjongs = self.inhandMahjongs[msg.AcId]
        for _, v in pairs(temp) do
            v:setPickabled(true)
            table.insert(mahjongs, v)
        end
        --重新排序手牌
        self:relocateInhandMahjongs(msg.AcId)
    end))

    tweenManager.add(animation)
    animation:play()
end

-------------------------------------------------------------------------------
-- 回放换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHuanNZhangDoPlayback(msg)
    local animation = tweenSerial.new(true)
    local huanMahjongs = {}

    animation:add(tweenFunction.new(function()
        for _, v in pairs(msg.Dos) do
            self.hnzCount = #v.D

            local temp = self:decreaseInhandMahjongs(v.AcId, v.D)
            self:putMahjongsToHuan(v.AcId, temp)

            for _, u in pairs(temp) do
                table.insert(huanMahjongs, u)
            end 
        end
    end))
    animation:add(tweenDelay.new(1.5))
    animation:add(tweenFunction.new(function()
        for _, v in pairs(msg.Dos) do
            local mahjongs = self.inhandMahjongs[v.AcId]
            for _, u in pairs(v.I) do
                for _, h in pairs(huanMahjongs) do
                    if h.id == u then
                        table.insert(mahjongs, h)
                        break
                    end
                end
            end
            self:relocateInhandMahjongs(v.AcId)
        end
    end))

    tweenManager.add(animation)
    animation:play()
end

return mahjongOperation

--endregion
