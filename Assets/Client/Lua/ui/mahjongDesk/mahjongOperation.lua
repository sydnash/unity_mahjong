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

_RES_(mahjongOperation, "MahjongDeskUI", "DeskOperationUI")

mahjongOperation.seats = {
    [seatType.mine] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.235, 0.156, -0.268), rot = Quaternion.Euler(180, 0, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.226, 0.175, -0.355), rot = Quaternion.Euler(-100, 0, 0), },
            [gameMode.playback] = { pos = Vector3.New(-0.226, 0.175, -0.355), rot = Quaternion.Euler(-100, 0, 0), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.400 + mahjong.w * 0, 0.156, -0.340), rot = { default = Quaternion.Euler(0, 0, 0), angang = Quaternion.Euler(180, 0, 0), }},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.074, 0.156, -0.100), rot = Quaternion.Euler(0, 0, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 0, 0), },
        [mahjongGame.cardType.huan] = {
            [gameMode.normal]   = { pos = Vector3.New( 0,     0.156, -0.180), rot = Quaternion.Euler(180, 0, 0), },
            [gameMode.playback] = { pos = Vector3.New( 0,     0.156, -0.180), rot = Quaternion.Euler(0, 0, 0), },
        },
    },
    [seatType.right] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New( 0.309, 0.156,  0.275), rot = Quaternion.Euler(180, 90, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New( 0.370, 0.168,  0.228), rot = Quaternion.Euler(-90, 0, -90), },
            [gameMode.playback] = { pos = Vector3.New( 0.370, 0.156,  0.228), rot = Quaternion.Euler(0, -90, 0), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.420, 0.156, -0.320 + mahjong.w * 2), rot = { default = Quaternion.Euler(0, -90, 0), angang = Quaternion.Euler(180, -90, 0),}},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.125, 0.156, -0.046), rot = Quaternion.Euler(0, -90, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New( 0.290, 0.156,  0.320), rot = Quaternion.Euler(0, -90, 0), },
        [mahjongGame.cardType.huan] = {
            [gameMode.normal]   = { pos = Vector3.New( 0.200, 0.156,  0.004), rot = Quaternion.Euler(180, 90, 0), },
            [gameMode.playback] = { pos = Vector3.New( 0.200, 0.156,  0.004), rot = Quaternion.Euler(0, -90, 0), },
        },
    },
    [seatType.top] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.235, 0.156,  0.330), rot = Quaternion.Euler(180, 0, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.215, 0.168,  0.390), rot = Quaternion.Euler(-90, 0, 180), },
            [gameMode.playback] = { pos = Vector3.New(-0.215, 0.156,  0.425), rot = Quaternion.Euler(0, 180, 0), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New( 0.360, 0.156,  0.420), rot = { default = Quaternion.Euler(0, 180, 0), angang = Quaternion.Euler(180, 180, 0), }},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New( 0.069, 0.156,  0.173), rot = Quaternion.Euler(0, 180, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156,  0.320), rot = Quaternion.Euler(0, 180, 0), },
        [mahjongGame.cardType.huan] = {
            [gameMode.normal]   = { pos = Vector3.New( 0,     0.156,  0.180), rot = Quaternion.Euler(180, 0, 0), },
            [gameMode.playback] = { pos = Vector3.New( 0,     0.156,  0.180), rot = Quaternion.Euler(0, 180, 0), },
        },
    },
    [seatType.left] = { 
        [mahjongGame.cardType.idle] = { pos = Vector3.New(-0.310, 0.156, -0.195), rot = Quaternion.Euler(180, 90, 0), len = 0.50 },
        [mahjongGame.cardType.shou] = { 
            [gameMode.normal]   = { pos = Vector3.New(-0.370, 0.168, -0.180), rot = Quaternion.Euler(-90, 0, 90), },
            [gameMode.playback] = { pos = Vector3.New(-0.370, 0.156, -0.180), rot = Quaternion.Euler(0, 90, 0), },
        },
        [mahjongGame.cardType.peng] = { pos = Vector3.New(-0.420, 0.156,  0.320), rot = { default = Quaternion.Euler(0, 90, 0), angang = Quaternion.Euler(180, 90, 0), }},
        [mahjongGame.cardType.chu ] = { pos = Vector3.New(-0.132, 0.156,  0.114), rot = Quaternion.Euler(0, 90, 0), },
        [mahjongGame.cardType.hu  ] = { pos = Vector3.New(-0.290, 0.156, -0.250), rot = Quaternion.Euler(0, 90, 0), },
        [mahjongGame.cardType.huan] = {
            [gameMode.normal]   = { pos = Vector3.New(-0.200, 0.156,  0.004), rot = Quaternion.Euler(180, 90, 0), },
            [gameMode.playback] = { pos = Vector3.New(-0.200, 0.156,  0.004), rot = Quaternion.Euler(0, 90, 0), },
        },
    },
}

local topChuPosTwo = Vector3.New( 0.200, 0.156,  0.173)
local mineChuPosTwo = Vector3.New(-0.200, 0.156, -0.100)

local mopaiConfig = {
    position = Vector3.New(0.255, 0.175, -0.355),
    rotation = Quaternion.Euler(-100, 0, 0),
}

local mainCameraParams = {
    position = Vector3.New(0, 0.9, -0.88),
    rotation = Quaternion.Euler(40, 0, 0),
    fov      = 30,
}
local inhandCameraParams = {
    position = Vector3.New(0, 0.291, -1),
    size = 0.14,
}

local COUNTDOWN_SECONDS_C = 15
local PLANE_BREATHE_SECONDS = 1.5

local panleDarkTex = nil
local panleHighlightTex = nil

-------------------------------------------------------------------------------
-- 交换两个牌，包括位置、旋转、缩放、可见性及阴影模式
-------------------------------------------------------------------------------
local function swap(ta, ia, tb, ib)
    local a = ta[ia]
    local b = tb[ib]

    if a ~= nil and b ~= nil then
        local p = a:getLocalPosition()
        local r = a:getLocalRotation()
        local s = a:getLocalScale()
        local visible = a:getVisibled()
        local shadowMode = a:getShadowMode()

        a:setLocalPosition(b:getLocalPosition())
        a:setLocalRotation(b:getLocalRotation())
        a:setVisibled(b:getVisibled())
        a:setShadowMode(b:getShadowMode())

        b:setLocalPosition(p)
        b:setLocalRotation(r)
        b:setVisibled(visible)
        b:setShadowMode(shadowMode)

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
    base.ctor(self)
end

-------------------------------------------------------------------------------
-- 初始化
-------------------------------------------------------------------------------
function mahjongOperation:onInit()
    self.turnCountdown = COUNTDOWN_SECONDS_C
    self.countdownTick = -1

    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
    fixMainCameraByFov(mainCameraParams.fov, mainCamera)

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size
    fixInhandCameraParam(inhandCameraParams.size, camera)

    --麻将出口的板子节点
    local plane = find("mahjong/table_plane")
    self.planeAnim = getComponentU(plane.gameObject, typeof(UnityEngine.Animation))
    local planeClip = animationManager.load("deskplane", "deskplane")
    self.planeAnim:AddClip(planeClip, planeClip.name)
    self.planeAnim.clip = planeClip
    --麻将根节点
    self.mahjongsRoot = find("mahjong/mahjongs_root")
    self.mahjongsRootAnim = getComponentU(self.mahjongsRoot.gameObject, typeof(UnityEngine.Animation))
    local mahjongsRootClip = animationManager.load("mahjongroot", "mahjongroot")
    self.mahjongsRootAnim:AddClip(mahjongsRootClip, mahjongsRootClip.name)
    self.mahjongsRootAnim.clip = mahjongsRootClip
    --方向指示节点
    self.planeRoot = find("mahjong/planes")
    self:rotatePlanes()
    local planeNames = { 
        [seatType.mine]  = "plane02/plane02_0", 
        [seatType.right] = "plane03/plane03_0", 
        [seatType.top]   = "plane04/plane04_0", 
        [seatType.left]  = "plane01/plane01_0", 
    }
    self.planeMats = {}
    for i=seatType.mine, seatType.left do
        local go = findChild(self.planeRoot.transform, planeNames[i])
        local mesh = getComponentU(go.gameObject, typeof(UnityEngine.MeshRenderer))
        local mat = mesh.sharedMaterial

        self.planeMats[i] = mat
    end
    if panleDarkTex == nil then
        panleDarkTex = textureManager.load(string.empty, "deskfw")
    end
    if panleHighlightTex == nil then
        panleHighlightTex = textureManager.load(string.empty, "deskfw_gl")
    end
    self:darkPlanes()
    --骰子节点和动画
    self.diceRoot = find("mahjong/shaizi")
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
    self.diceRoot:hide()
    --倒计时
    self.centerGlass = find("mahjong/planes/glass")
    self.countdown = find("mahjong/countdown")
    self.countdown.a = findSpriteRD(self.countdown.transform, "a")
    self.countdown.b = findSpriteRD(self.countdown.transform, "b")
    self.centerGlass:show()
    self.countdown:hide()
    --出牌指示器
    self.chupaiPtr = find("mahjong/chupaiPtr")
    local chupaiPtrD = self.chupaiPtr:findChild("mesh_diamond2")
    local chupaiPtrAnim = getComponentU(chupaiPtrD.gameObject, typeof(UnityEngine.Animation))
    local chupaiPtrClip = animationManager.load("chupaiptr", "chupaiptr")
    chupaiPtrAnim:AddClip(chupaiPtrClip, chupaiPtrClip.name)
    chupaiPtrAnim.clip = chupaiPtrClip
    self.chupaiPtr:hide()

    self.mChuHuHints = {}
    for i = 1, 14 do
        local name = string.format("mChuHuHint%d",i)
        table.insert(self.mChuHuHints, self[name])
    end
    self:hideChuPaiArrow()
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

    self.mahjongs           = {}
    self.idleMahjongs       = {}
    self.inhandMahjongs     = {}
    self.chuMahjongs        = {}
    self.pengMahjongs       = {}
    self.huMahjongs         = {}
    self.hnzMahjongs        = {}
    self.hasHnzChoosed      = false
    self.redundancyMahjongs = {}

    self.chuPaiHintParent = {
        [seatType.top]      = self.mChuT,
        [seatType.left]     = self.mChuL,
        [seatType.right]    = self.mChuR,
    }
    self:hideChuPaiHint()

    self.animationManager = tweenParallel.new(false)
    tweenManager.add(self.animationManager)
    self.animationManager:play()

    self:loadMahjongs()
    self:computeMyPengStartPos()

    self.mHuHint:hide()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

-------------------------------------------------------------------------------
-- 加载麻将模型
-------------------------------------------------------------------------------
function mahjongOperation:loadMahjongs()
    for i=0, self.game:getTotalCardsCount() - 1 do
        local m = mahjong.new(i)
        m:hide()
        m:setParent(self.mahjongsRoot)

        table.insert(self.idleMahjongs, m)
        table.insert(self.mahjongs, m)
    end
end

function mahjongOperation:showChuPaiHint(acId, id)
    self:hideChuPaiHint()
    local st = self.game:getSeatTypeByAcId(acId)
    local parent = self.chuPaiHintParent[st]
    if not parent then
        return
    end
    self.mChuPaiHint:show()
    self.mChuPaiHint:setParent(parent)
    self.mChuPaiHint:setLocalPosition(Vector3.zero)

    local spriteName = mahjongType.getMahjongTypeById(id).name
    self.mChuPaiHintImg:setSprite(spriteName)
end

function mahjongOperation:hideChuPaiHint()
    self.mChuPaiHint:hide()
end

-------------------------------------------------------------------------------
-- 主要处理中间的倒计时和指向的呼吸闪烁
-------------------------------------------------------------------------------
function mahjongOperation:update()
    if self.game.mode == gameMode.playback then
        return
    end

    local now = time.realtimeSinceStartup()

    if self.countdownTick ~= nil and self.countdownTick > 0 and self.turnCountdown > 0 then
        local delta = math.floor(now - self.countdownTick)
        
        if delta > 0.99999 then
            self.turnCountdown = math.max(0, self.turnCountdown - 1)

            if self.turnCountdown <= 5 and self.m_curOPDir == self.game.mainAcId then
                playClockTimerSound()
            end

            local a = math.floor(self.turnCountdown / 10)
            self.countdown.a:setSprite(tostring(a))
            local b = math.floor(self.turnCountdown % 10)
            self.countdown.b:setSprite(tostring(b))

            self.countdownTick = now
        end
    end

    if self.curPlaneMat ~= nil then
        local delta = now - self.planeTick

        if self.curPlaneToD then
            local c = 0.4 + 0.6 * (1 - (delta / PLANE_BREATHE_SECONDS))
            self.curPlaneMat.color = Color.New(c, c, c, 1)
        else
            local c = 0.4 + 0.6 * (delta / PLANE_BREATHE_SECONDS)
            self.curPlaneMat.color = Color.New(c, c, c, 1)
        end

        if delta >= PLANE_BREATHE_SECONDS then
            if self.curPlaneToD then
                self.curPlaneToD = false 
            else
                self.curPlaneToD = true
            end

            self.planeTick = now
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
        if self.game.mode == gameMode.normal then
            self.countdown:show()
        end
    else
        self.diceRoot:show()
        self.centerGlass:hide()
        self.countdown:hide()
    end
end

function mahjongOperation:clearCountdownTick()
    self.countdownTick = -1

    self.turnCountdown = 0
    local a = math.floor(self.turnCountdown / 10)
    self.countdown.a:setSprite(tostring(a))
    local b = math.floor(self.turnCountdown % 10)
    self.countdown.b:setSprite(tostring(b))
end
function mahjongOperation:setCountdownTick()
    self.countdownTick = time.realtimeSinceStartup()

    self.turnCountdown = COUNTDOWN_SECONDS_C
    local a = math.floor(self.turnCountdown / 10)
    self.countdown.a:setSprite(tostring(a))
    local b = math.floor(self.turnCountdown % 10)
    self.countdown.b:setSprite(tostring(b))
end

-------------------------------------------------------------------------------
-- 游戏开始
-------------------------------------------------------------------------------
function mahjongOperation:onGameStart()
    self:clearChosedMahjong()
    self:rotatePlanes()

    self.countdownTick = -1
    self:darkPlanes()
    self:setCountdownVisible(false)
    self.chupaiPtr:hide()

    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(false)

    eventManager.registerAnimationTrigger("table_plane_down", function()
        for i, m in pairs(self.mahjongs) do
            m:show()
        end
    end)
    eventManager.registerAnimationTrigger("table_plane_up", function()
        self:showChuPaiArrow()
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
    self:clearChosedMahjong()
    local reenter = self.game.data.Reenter

    self.hnzCount = reenter.HSZCnt
    self.idleMahjongStart = math.min(self.game.dices[1], self.game.dices[2]) * 2 + 1
    self:relocateIdleMahjongs(true)    

    for _, v in pairs(self.game.players) do 
        if not json.isNilOrNull(v.hu) then
            local mid = v.hu[1].HuCard

            if mid >= 0 then
                local m = self:getMahjongFromIdle(mid)

                if m ~= nil then
                    self:removeFromIdle()
                else
                    --如一炮双响的时候，会出现无法从idle列表中搜索到牌的情况
                    --此时，就直接创建一个新的麻将对象
                    m = self:createRedundancyMahjong(mid)
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

    self.chupaiPtr:hide()
    for acId, u in pairs(self.chuMahjongs) do
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
            self:showChuPaiHint(acId, chu.id)

            break
        end
    end
    
    if self.game.deskPlayStatus == mahjongGame.status.hsz then
        self:setDices()
        self:highlightPlaneByAcId(self.game.mainAcId)
        self:setCountdownVisible(true)
        local datas = self.game.players[self.game.mainAcId][mahjongGame.cardType.huan]
        if datas ~= nil and #datas == self.hnzCount then
            self.hasHnzChoosed = true
            self:clearCountdownTick()
            self.mHnz:hide()
        else
            self:setCountdownTick()
            self.mHnz:show()
            self.mHnzText:setText(string.format("请选择%d张", self.hnzCount))
        end
    elseif self.game.deskPlayStatus == mahjongGame.status.dingque then
        self:setDices()
        self:highlightPlaneByAcId(self.game.mainAcId)
        self:setCountdownVisible(true)
        self.mDQTips:show()

        local player = self.game:getPlayerByAcId(self.game.mainAcId)
        if player.que < 0 then
            self.mQue:show()
            self:setCountdownTick()
        else
            self:clearCountdownTick()
        end
    elseif self.game.deskPlayStatus == mahjongGame.status.playing then
        self:highlightPlaneByAcId(reenter.CurOpAcId)
        self:clearCountdownTick()
        self:setCountdownVisible(true)

--        log("reenter: " .. table.tostring(reenter.CurOpList))
        local _, needHuHint = self:onOpList(reenter.CurOpList)
        if self.game:hasHuPaiHint() then
            if not self.canChuPai then
                local player = self.game:getPlayerByAcId(self.game.mainAcId)

                if not player.isHu then
                    if #player.hus == 0 then
                        self:computeJiaoLocal()
                    else
                        self:computeJiao(player.hus)
                    end
                end

                if needHuHint then
                    self:showHuPaiHintInfo()
                end
            end
        end
    end

    self:rotatePlanes()
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
    local mahjongCount   = self.game:getTotalCardsCount()
    local markerDir      = self.game:getSeatTypeByAcId(self.game:getMarkerPlayer().acId)
    local playerStartDir = (self.game.dices[1] + self.game.dices[2] + markerDir) % 4 - 1

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
    for dir = playerStartDir, playerStartDir-3, -1 do
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

            if dir == seatType.mine then
                x = (o.x - d) - w
            elseif dir == seatType.left then
                z = (o.z + d) + w
            elseif dir == seatType.right then
                z = (o.z - d) - w
            else
                x = (o.x + d) + w
            end
            
            local p = m:getLocalPosition()
            p:Set(x, y, z)

            m:setLocalPosition(p)
            m:setLocalRotation(r)
            m:setPickabled(false)

            if math.abs(v) > 0.01 then
                m:setShadowMode(mahjong.shadowMode.pa)
            else 
                m:setShadowMode(mahjong.shadowMode.noshadow)
            end

            if visible then
                m:show()
            else
                m:hide()
            end
        end
    end
    local mahjongCount = self.game:getTotalCardsCount()
    for i = 1, self.idleMahjongStart - 1, 1 do
        local mj = self.idleMahjongs[1]
        table.remove(self.idleMahjongs, 1)
        table.insert(self.idleMahjongs, mahjongCount, mj)
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

function mahjongOperation:computeJiaoLocal()
    if not self.game:hasHuPaiHint() then
        return
    end

    if self.game.chuHintComputeHelper then
        local handCntVec, totalCntVec = self.game.chuHintComputeHelper:statisticCount()
        local ret = self.game.chuHintComputeHelper:checkJiao(handCntVec, totalCntVec)
        if #ret == 0 then
            self.huPaiHintInfo = nil
        else
            self.huPaiHintInfo = ret
        end

        if self.huPaiHintInfo then
            self:showHuPaiHintInfo()
        else
            self:hideHuPaiHintInfo()
        end
    end
end

-------------------------------------------------------------------------------
-- 播放骰子动画
-------------------------------------------------------------------------------
function mahjongOperation:playDiceAnim()
    soundManager.playGfx("mahjong", "shaizi")
    self:playAnimation(self.diceRootAnim)
    self:setDices()
end

-------------------------------------------------------------------------------
-- 设置骰子
-------------------------------------------------------------------------------
function mahjongOperation:setDices()
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
    self:setCountdownVisible(true)
    self:highlightPlaneByAcId(self.game.mainAcId)
    self:setCountdownTick()
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
    self:setCountdownVisible(true)
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

        if d.Op == opType.gang.id then
            mahjongs[5] = d.D
        end

        self:putMahjongsToPeng(player.acId, mahjongs, angang)
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
    self:setCountdownTick()
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

        -- local to = Vector3.New(moPaiPos.x, moPaiPos.y, moPaiPos.z)
        -- moPaiPos.y = moPaiPos.y + 0.04
        self.mo:setLocalPosition(moPaiPos)
        -- local mv = tweenPosition.new(self.mo, 0.04, moPaiPos, to, nil)
        -- tweenManager.add(mv)
        -- mv:play()

        self.mo:setLocalRotation(mopaiConfig.rotation)

        if self.mo.class == player.que then
            self.mo:dark()
        else
            self.mo:light()
        end

        self.mo:setPickabled(true)
        self.mo:setShadowMode(mahjong.shadowMode.noshadow)
        self.mo:show()

        self:clearChosedMahjong()
    end
end

function mahjongOperation:sHuToChu(huHint, totalCntVec)
    local ret = {
        jiaoTid = huHint.Hu,
        fan = huHint.Fan,
        left = 4 - totalCntVec[huHint.Hu], 
    }
    return ret
end

function mahjongOperation:generateChuPaiHint(chuHint)
    if not self.game:hasHuPaiHint() then
        return {}
    end
    if not self.game.chuHintComputeHelper then
        return {}
    end

    if json.isNilOrNull(chuHint) then
        return {}
    end
    local ret = {}
    local handCntVec, totalCntVec = self.game.chuHintComputeHelper:statisticCount()
    for _, t in pairs(chuHint) do
        local c = {}
        if json.isNilOrNull(t.Hus) then
            t.Hus = {}
        end
        for _, huHint in pairs(t.Hus) do
            table.insert(c, self:sHuToChu(huHint, totalCntVec))
        end
        if #c > 0 then
            table.insert(ret, { tid = t.Chu, hu = c} )
        end
    end
    return ret
end

-------------------------------------------------------------------------------
-- OpList
-------------------------------------------------------------------------------
function mahjongOperation:onOpList(oplist)
--    log("oplist = " .. table.tostring(oplist))
    local needShowHuPaiHint = false

    if oplist ~= nil then
        local infos = oplist.OpInfos
        local leftTime = oplist.L

        for _, v in pairs(infos) do
            if v.Op == opType.chu.id then
                self.chuPaiHintInfo = self:generateChuPaiHint(v.Chus)
                self:beginChuPai()
            else
                local player = self.game:getPlayerByAcId(self.game.mainAcId)
                needShowHuPaiHint = (self.huPaiHintInfo ~= nil)
            end
        end

        self.mDQTips:hide()
        self:showOperations(infos, leftTime)
        if self.CurOpAcId ~= self.game.mainAcId then
            self:highlightPlaneByAcId(self.game.mainAcId)
            self:setCountdownTick()
        end
    end

    if needShowHuPaiHint then
        self:showHuPaiHintInfo()
    end

    return 0, needShowHuPaiHint
end

-------------------------------------------------------------------------------
-- 可以出牌
-------------------------------------------------------------------------------
function mahjongOperation:beginChuPai()
    self.canChuPai = true

    self:highlightPlaneByAcId(self.game.mainAcId)
    self:setCountdownTick()
    self:setCountdownVisible(true)

    if self.mo == nil then
        local player = self.game:getPlayerByAcId(self.game.mainAcId)
        local mahjongs = self.inhandMahjongs[self.game.mainAcId]
        local moPaiPos = self:getMyInhandMahjongPos(player, #mahjongs)
        moPaiPos.x = moPaiPos.x + mahjong.w * 0.33
        mahjongs[#mahjongs]:setLocalPosition(moPaiPos)
    end

    if self.game:hasHuPaiHint() then
        self:showChuPaiArrow()
    end
end

function mahjongOperation:onDeskPlayStatusChanged()
    if self.game.deskPlayStatus == mahjongGame.status.playing then
        if self.game.markerAcId ~= self.game.mainAcId then
            self:computeJiaoLocal()
        end
        self:highlightPlaneByAcId(self.game.markerAcId)
        self:setCountdownTick()
    end
end

function mahjongOperation:computeJiao(hus)
    if not self.game:hasHuPaiHint() then
        return
    end

    if self.game.chuHintComputeHelper then
        local handCntVec, totalCntVec = self.game.chuHintComputeHelper:statisticCount()
        local c = {}

        if json.isNilOrNull(hus) then
            hus = {}
        end

        for _, huHint in pairs(hus) do
            table.insert(c, self:sHuToChu(huHint, totalCntVec))
        end

        self.huPaiHintInfo = #c > 0 and c or nil

        if self.huPaiHintInfo then
             self:showHuPaiHintInfo()
        else
            self:hideHuPaiHintInfo()
        end
    end
end

function mahjongOperation:getHuPaiHintInfo(id)
    if self.chuPaiHintInfo == nil then
        return nil
    end

    local tid = mahjongType.getMahjongTypeId(id)
    for _, info in pairs(self.chuPaiHintInfo) do
        if info.tid == tid then
            return info.hu
        end
    end

    return nil
end

function mahjongOperation:highlightSelectMahjong(id)
    local id = self.curSelectedMahjong.id
    local tid = mahjongType.getMahjongTypeId(id)

    for _, mahjongs in pairs(self.chuMahjongs) do
        for _, mahjong in pairs(mahjongs) do
            if mahjong.tid == tid then
                mahjong:blue(true)
            end
        end
    end

    for _, lines in pairs(self.pengMahjongs) do
        for _, mahjongs in pairs(lines) do
            for i=1, math.min(4, #mahjongs) do
                local m = mahjongs[i]
                if m.tid == tid then
                    m:blue(true)
                end
            end
        end
    end

    for _, mahjong in pairs(self.huMahjongs) do
        if mahjong.tid == tid then
            mahjong:blue(true)
        end
    end
end

function mahjongOperation:clearSelectMahjong(id)
    local id = self.curSelectedMahjong.id
    local tid = mahjongType.getMahjongTypeId(id)

    for _, mahjongs in pairs(self.chuMahjongs) do
        for _, mahjong in pairs(mahjongs) do
            if mahjong.tid == tid then
                mahjong:blue(false)
            end
        end
    end

    for _, lines in pairs(self.pengMahjongs) do
        for _, mahjongs in pairs(lines) do
            for i=1, math.min(4, #mahjongs) do
                local m = mahjongs[i]
                if m.tid == tid then
                    m:blue(false)
                end
            end
        end
    end

    for _, mahjong in pairs(self.huMahjongs) do
        if mahjong.tid == tid then
            mahjong:blue(false)
        end
    end
end

-------------------------------------------------------------------------------
-- 不能出牌
-------------------------------------------------------------------------------
function mahjongOperation:endChuPai()
    self.canChuPai = false
end

function mahjongOperation:onClickOnMahjong(mj)
    if self.curSelectedMahjong == nil then
        self.curSelectedMahjong = mj
        self.curSelectedMahjong:setSelected(true)
        self:highlightSelectMahjong()
        local huPaiHintInfo = self:getHuPaiHintInfo(mj.id)
        self:showChuPaiHintInfo(huPaiHintInfo, true)
        soundManager.playGfx("mahjong", "chose")
    else
        if self.curSelectedMahjong.id ~= mj.id then
            self.curSelectedMahjong:setSelected(false)
            self:clearSelectMahjong()
            self.curSelectedMahjong = mj
            self.curSelectedMahjong:setSelected(true)
            self:highlightSelectMahjong()
            local huPaiHintInfo = self:getHuPaiHintInfo(mj.id)
            self:showChuPaiHintInfo(huPaiHintInfo, true)
            soundManager.playGfx("mahjong", "chose")
        else
            --出牌
            if self.canChuPai then
                if self:onChosedChuPai() then
                    self.curSelectedMahjong = nil
                end
                self:hideChuPaiHintInfo()
            end
        end
    end
end

function mahjongOperation:clearChosedMahjong()
    if self.curSelectedMahjong ~= nil then
        self:hideChuPaiHintInfo()
        self.curSelectedMahjong:setSelected(false)
        self:clearSelectMahjong()
        self.curSelectedMahjong = nil
    end
end

-------------------------------------------------------------------------------
-- 处理鼠标/手指拖拽
-------------------------------------------------------------------------------
function mahjongOperation:touchHandler(phase, pos)
    local ds = self.game.deskPlayStatus
    if self.game.mode == gameMode.playback or ds < 0 or ds == mahjongGame.status.dingque then
        return
    end

    local camera = GameObjectPicker.instance.camera

    if ds == mahjongGame.status.hsz then
        if phase == touch.phaseType.ended then
            local go = GameObjectPicker.instance:Pick(pos)
            if go ~= nil then
                local inhandMahjongs = self.inhandMahjongs[self.game.mainAcId]
                local selectedMahjong = self:getMahjongByGo(inhandMahjongs, go)
                if self.hasHnzChoosed then
                    self:onClickOnMahjong(selectedMahjong)
                    return
                end

                if self.hnzMahjongs[self.game.mainAcId] == nil then
                    self.hnzMahjongs[self.game.mainAcId] = {}
                end

                local hnzQueue = self.hnzMahjongs[self.game.mainAcId]

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
            else
                if self.hasHnzChoosed then
                    self:clearChosedMahjong()
                end
            end
        end
    else
        if phase == touch.phaseType.began then
            self.isClick = true
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
                if dpos:Magnitude() > 0.000001 then
                    self.isClick = false
                end
            
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
                local isClick = self.isClick
            
                if not self.canChuPai then
                    self.selectedMahjong:setPosition(self.selectedOrgPos)
                    if isClick then
                        self:onClickOnMahjong(self.selectedMahjong)
                    else
                        if self.curSelectedMahjong then
                            self.curSelectedMahjong:setSelected(false)
                            self:clearSelectMahjong()
                            self.curSelectedMahjong = nil
                        end
                    end
                else
                    if isClick then
                        self:onClickOnMahjong(self.selectedMahjong)
                    else
                        if dpos.y < 0.04  then
                            self.selectedMahjong:setPosition(self.selectedOrgPos)
                            self:clearChosedMahjong()
                        else
                            --出牌
                            if not self:onChosedChuPai() then
                                self.selectedMahjong:setPosition(self.selectedOrgPos)
                                self:clearChosedMahjong()
                            end
                        end
                    end
                end
            else
                self:clearChosedMahjong()
            end

            self.selectedMahjong = nil
        end
    end
end

function mahjongOperation:onChosedChuPai()
    local player = self.game:getPlayerByAcId(self.game.mainAcId)
    local id = self.selectedMahjong.id

    if player.que >= 0 then
        local function isQue(mj)
            local typ = mahjongType.getMahjongTypeById(mj.id)
            if typ.class == player.que then
                return true
            end
            return false
        end
        local chuCardType = mahjongType.getMahjongTypeById(id)
        if chuCardType.class ~= player.que then
            if self.mo and isQue(self.mo) then
                return false
            end
            for _, mj in pairs(self.inhandMahjongs[self.game.mainAcId]) do
                if isQue(mj) then
                    return false
                end
            end
        end
    end

    networkManager.chuPai({ id }, function(msg)
        self:relocateInhandMahjongs(self.game.mainAcId)
    end)

    self:clearChosedMahjong()
    self:virtureChu(self.selectedMahjong)

    soundManager.playGfx("mahjong", "chupai")
    playMahjongSound(id, player.sex)

    return true
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
    self:clearCountdownTick()
end

-------------------------------------------------------------------------------
-- 点击“筒”
-------------------------------------------------------------------------------
function mahjongOperation:onTongClickedHandler()
    playButtonClickSound()

    networkManager.dingque(mahjongClass.tong, function(msg)
    end)
    self.mQue:hide()
    self:clearCountdownTick()
end

-------------------------------------------------------------------------------
-- 点击“万”
-------------------------------------------------------------------------------
function mahjongOperation:onWanClickedHandler()
    playButtonClickSound()

    networkManager.dingque(mahjongClass.wan, function(msg)
    end)
    self.mQue:hide()
    self:clearCountdownTick()
end

-------------------------------------------------------------------------------
-- 点击“过”
-------------------------------------------------------------------------------
function mahjongOperation:onGuoClickedHandler()
    playButtonClickSound()

    self.game:guo()
    self:hideOperations()
--    self:hideHuPaiHintInfo()
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
    -- playMahjongOpSound(opType.peng.id, player.sex)

    self.game:peng(self.mPeng.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- “杠”
-------------------------------------------------------------------------------
local function opGang(game, cs)
    local player = game:getPlayerByAcId(game.mainAcId)
    -- playMahjongOpSound(opType.gang.id, player.sex)

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
            sprites[i]:setSprite(mahjongType.getMahjongTypeById(cs[1]).name)

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
    -- playMahjongOpSound(opType.hu.id, player.sex)

    self.game:hu(self.mHu.cs)
    self:hideOperations()
end

-------------------------------------------------------------------------------
-- 出牌
-------------------------------------------------------------------------------
function mahjongOperation:virtureChu(mj)
    self:hideChuPaiArrow()
    mj:setShadowMode(mahjong.shadowMode.yang)

    local acId = self.game.mainAcId
    local dir = self.game:getSeatTypeByAcId(acId)
    local chuMahjongs = self.chuMahjongs[acId]

    local k
    if chuMahjongs == nil then
        k = 0
    else
        k = #chuMahjongs
    end
    local r, p = self:getMahjongChuPos(mj, dir, k + 1)
    mj:setPickabled(false)
    mj:setLocalPosition(p)
    mj:setLocalRotation(r)
    mj:setShadowMode(mahjong.shadowMode.yang)

    local c = mj:getLocalPosition()
    local p = self.chupaiPtr:getLocalPosition()
    p:Set(c.x, c.y + mahjong.z * 0.55 + 0.035, c.z)
    self.chupaiPtr:setLocalPosition(p)
    self.chupaiPtr:show()
    mj:light()

    self:endChuPai()
    self:clearCountdownTick()

    self.virtureChuMahjong = mj
end

function mahjongOperation:onOpDoChu(acId, cards)
    self:hideChuPaiHint()
    self:endChuPai()
    local chu = nil

    if acId == self.game.mainAcId and self.mo ~= nil and cards[1] == self.mo.id then
        self:putMahjongToChu(acId, self.mo)
        chu = self.mo
        if self.virtureChuMahjong and self.virtureChuMahjong.id ~= cards[1] then
            self:relocateInhandMahjongs(acId)
        end
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

    if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        soundManager.playGfx("mahjong", "chupai")
        playMahjongSound(cards[1], player.sex)
    end

    local chuId = cards[1]
    if acId == self.game.mainAcId then
        self:hideChuPaiHintInfo()
        local huPaiHintInfo = self:getHuPaiHintInfo(chuId)
        self.huPaiHintInfo = huPaiHintInfo

        if self.huPaiHintInfo then
             self:showHuPaiHintInfo()
        else
             self:hideHuPaiHintInfo()
        end
        self:hideChuPaiArrow()
    end

    self:relocateInhandMahjongs(acId)
    self:showChuPaiHint(acId, cards[1])
    self.virtureChuMahjong = nil
    self.mDQTips:hide()
end

-------------------------------------------------------------------------------
-- 碰
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoPeng(acId, cards, beAcId, beCard)
    self:clearChosedMahjong()
    self:hideChuPaiHint()
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

    -- if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.peng.id, player.sex)
    -- end
    -- self:computeChuHint()
end

-------------------------------------------------------------------------------
-- 杠
-------------------------------------------------------------------------------
function mahjongOperation:onOpDoGang(acId, cards, beAcId, beCard, t)
    self:clearChosedMahjong()
    self:hideChuPaiHint()
    self:hideChuPaiArrow()
    self:endChuPai()
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
        mahjongs[5] = t

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
                v[5] = t
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
        mahjongs[5] = t

        self:putMahjongsToPeng(acId, mahjongs)
    end

    -- if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.gang.id, player.sex, t)
    -- end
end

-------------------------------------------------------------------------------
-- 胡
-------------------------------------------------------------------------------
local fromType = {
    inhand = 1,
    dianpao = 2,
    qianggang = 3,
}
function mahjongOperation:onOpDoHu(acId, cards, beAcId, beCard, t, ft)
    self:hideChuPaiHint()
    self:hideChuPaiArrow()
    self:hideHuPaiHintInfo()

    local hu = nil
    local detail = opType.hu.detail

    local isFromHand

    if ft == fromType.inhand then
        local inhand = self.inhandMahjongs[acId]

        if acId ~= self.game.mainAcId then
            local m, queue, idx = self:getMahjongFromIdle(beCard)
            swap(inhand, 1, queue, idx)
            table.remove(inhand, 1)

            hu = m
            --如果需要再把牌扣起来
            --
        else
            if self.mo ~= nil then
                hu = self.mo
                self.mo = nil
            else
                for _, mj in pairs(self.inhandMahjongs[acId]) do
                    if mj.id == beCard then
                        hu = mj
                        table.removeItem(self.inhandMahjongs[acId], mj)
                        break
                    end
                end
                self:relocateInhandMahjongs(acId)
            end
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
        if hu == nil then --如果是抢杠，在出牌里面搜不到，要去碰牌里面搜
            local pengMahjongs = self.pengMahjongs[beAcId]
            if pengMahjongs then
                for i, mahjongs in pairs(pengMahjongs) do
                    for k=1, math.min(4, #mahjongs) do 
                        local m = mahjongs[k]
                        if m.id == beCard then
                            hu = m
                            table.remove(mahjongs, k)
                        end
                    end
                end
            end
        end

        if hu == nil then
            --如一炮双响的时候，会出现无法从idle列表中搜索到牌的情况
            --此时，就直接创建一个新的麻将对象
            hu = self:createRedundancyMahjong(beCard)
        end

        if self.chupaiPtr.mahjongId == beCard then
            self.chupaiPtr:hide()
        end
    end
    
    hu:setPickabled(false)
    hu:setShadowMode(mahjong.shadowMode.yang)
    self.huMahjongs[acId] = hu

    local s = self.game:getSeatTypeByAcId(acId)
    local tc = self.seats[s][mahjongGame.cardType.hu]
    hu:setLocalPosition(tc.pos)
    hu:setLocalRotation(tc.rot)

    -- if self.game.mode == gameMode.playback or acId ~= self.game.mainAcId then 
        local player = self.game:getPlayerByAcId(acId)
        playMahjongOpSound(opType.hu.id, player.sex, t)
    -- end
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
    -- return (self.idleMahjongStart <= self.game:getLeftCardsCount()) and self.idleMahjongStart or 1
    return 1
end

function mahjongOperation:getMahjongFromIdleForPlayback(mid)
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
                    return v, h, k
                end
            end
        end
    end
    --从扣起来的换n张里面找
    for acid, h in pairs(self.hnzMahjongs) do
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
-- 从idle列表或者其他玩家手牌中获取一张由mid指定的牌，并将它放在idle列表第一位
-------------------------------------------------------------------------------
function mahjongOperation:getMahjongFromIdle(mid)
    if self.game.mode == gameMode.playback then
        return self:getMahjongFromIdleForPlayback(mid)
    end
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
    --从扣起来的换n张里面找
    for acid, h in pairs(self.hnzMahjongs) do
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
        
    if not appConfig.debug then
        commitError("connot find pai [id = " .. tostring(mid) .. "] from idle.")
    end

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

        table.insert(mahjongs, m)
        self:removeFromIdle()

        if acId == self.game.mainAcId then
            local player = self.game:getPlayerByAcId(acId)
            m:setPickabled(true)
            if m.class == player.que then
                m:dark()
            else
                m:light()
            end
            m:setShadowMode(mahjong.shadowMode.noshadow)
        else
            m:setPickabled(false)
            if self.game.mode == gameMode.playback then
                m:setShadowMode(mahjong.shadowMode.yang)
            else
                m:setShadowMode(mahjong.shadowMode.li)
            end
        end
    end

    self:relocateInhandMahjongs(acId)
end

-------------------------------------------------------------------------------
-- 将麻将m插入到手牌中
-------------------------------------------------------------------------------
function mahjongOperation:insertMahjongToInhand(m)
    m:setPickabled(true)
    m:setShadowMode(mahjong.shadowMode.noshadow)

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
        self:clearChosedMahjong()
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
-- 算自己的碰牌其实位置
-------------------------------------------------------------------------------
function mahjongOperation:computeMyPengStartPos()
    local sceneCamera = UnityEngine.Camera.main
    local inhandCamera = GameObjectPicker.instance.camera

    local seat = self.seats[seatType.mine]
    local o = seat[mahjongGame.cardType.shou][self.game.mode].pos
    o = Vector3.New(o.x - mahjong.w * 0.5, o.y, o.z)
    local scPos = inhandCamera:WorldToScreenPoint(o)

    local pengPos = seat[mahjongGame.cardType.peng].pos
    local cameraPos = sceneCamera.transform.position
    local direct = pengPos - cameraPos
    local project = Vector3.Project(direct, sceneCamera.transform.forward)

    local wpPos = sceneCamera:ScreenToWorldPoint(Vector3.New(scPos.x, scPos.y, project.magnitude))
    seat[mahjongGame.cardType.peng].pos = Vector3.New(wpPos.x + mahjong.w * 0.7, pengPos.y, pengPos.z)
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
    if dir == seatType.mine then
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
        if dir == seatType.mine then
            if self.curSelectedMahjong then
                self.curSelectedMahjong = nil
            end
        end

        local o = self:getMyInhandMahjongPos(player, 1)
        local r = seat[mahjongGame.cardType.shou][self.game.mode].rot

        for k, m in pairs(mahjongs) do
            k = k - 1
            local p = m:getLocalPosition()

            if dir == seatType.mine then
                p:Set(o.x + (mahjong.w * k), o.y, o.z)
                m:setPickabled(true)
            elseif dir == seatType.left then
                p:Set(o.x, o.y, o.z + (mahjong.w * k))
                m:setPickabled(false)
            elseif dir == seatType.right then
                p:Set(o.x, o.y, o.z - (mahjong.w * k))
                m:setPickabled(false)
            else
                p:Set(o.x + (mahjong.w * k), o.y, o.z)
                m:setPickabled(false)
            end

            m:setLocalPosition(p)
            m:setLocalRotation(r)

            if acId == self.game.mainAcId then
                m:setShadowMode(mahjong.shadowMode.noshadow)
            else
                if self.game.mode == gameMode.playback then
                    m:setShadowMode(mahjong.shadowMode.yang)
                else
                    m:setShadowMode(mahjong.shadowMode.li)
                end
            end
        end
    end
end

function mahjongOperation:getMahjongChuPos(mj, dir, idx)
    local seat = self.seats[dir]

    local o = seat[mahjongGame.cardType.chu].pos
    local r = seat[mahjongGame.cardType.chu].rot

    local p = mj:getLocalPosition()
    local cntInRow = 8
    local maxRow = 3
    idx = idx - 1
    if self.game:getTotalPlayerCount() == 2 then
        if dir == seatType.mine then
            o = mineChuPosTwo
        elseif dir == seatType.top then
            o = topChuPosTwo
        end
        cntInRow = 13
    end
    local u = math.floor(idx / cntInRow)
    local c = idx % cntInRow
    local y = (u < maxRow) and o.y or o.y + mahjong.z
    local d = (u % maxRow) * mahjong.h

    if dir == seatType.mine then
        p:Set(o.x + mahjong.w * c, y, o.z - d)
    elseif dir == seatType.left then
        p:Set(o.x - d, y, o.z - mahjong.w * c)
    elseif dir == seatType.right then
        p:Set(o.x + d, y, o.z + mahjong.w * c)
    else
        p:Set(o.x - mahjong.w * c, y, o.z + d)
    end

    return r, p
end
-------------------------------------------------------------------------------
-- 调整出牌位置
-------------------------------------------------------------------------------
function mahjongOperation:relocateChuMahjongs(player)
    local acId = player.acId
    local dir = self.game:getSeatTypeByAcId(acId)

    local chuMahjongs = self.chuMahjongs[acId]

    for k, m in pairs(chuMahjongs) do
        local r, p = self:getMahjongChuPos(m, dir, k)

        m:setPickabled(false)
        m:setLocalPosition(p)
        m:setLocalRotation(r)
        m:setShadowMode(mahjong.shadowMode.yang)
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
        local angang = #mahjongs == 5 and mahjongs[5] == opType.gang.detail.angang or false

        for k = 1, math.min(4, #mahjongs) do 
            local m = mahjongs[k]

            local c = 3 * i + k - 1
            local p = m:getLocalPosition()
            local y = o.y
        
            local isUpon = false
            if k == 4 then -- 杠的第4张牌放在第2张上面
                c = 3 * i + 1
                y = o.y + mahjong.z
                isUpon = true
            end 

            if dir == seatType.mine then
                p:Set(o.x + mahjong.w * c + d, y, o.z)
            elseif dir == seatType.left then
                p:Set(o.x, y, o.z - mahjong.w * c - d)
            elseif dir == seatType.right then
                p:Set(o.x, y, o.z + mahjong.w * c + d)
            else
                p:Set(o.x - mahjong.w * c - d, y, o.z)
            end

            m:setPickabled(false)
            m:setLocalPosition(p)

            if not isUpon then
                if angang then
                    m:setLocalRotation(r.angang)
                    m:setShadowMode(mahjong.shadowMode.pa)
                else
                    m:setLocalRotation(r.default)
                    m:setShadowMode(mahjong.shadowMode.yang)
                end
                lastPengPos = Vector3.New(o.x + mahjong.w * c + d + mahjong.w * 0.5, y, o.z - mahjong.z * 0.5)
            else
                m:setLocalRotation(r.default)
                m:setShadowMode(mahjong.shadowMode.noshadow)
            end
        end
    end

    if dir == seatType.mine then
        self.lastPengPos = lastPengPos
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
    mj:setPickabled(false)
    mj:setShadowMode(mahjong.shadowMode.yang)

    local player = self.game:getPlayerByAcId(acId)
    self:relocateChuMahjongs(player)
end

-------------------------------------------------------------------------------
-- 将mahjong放到出牌区
-------------------------------------------------------------------------------
function mahjongOperation:putMahjongsToPeng(acId, mahjongs, angang)
    if self.pengMahjongs[acId] == nil then
        self.pengMahjongs[acId] = {}
    end

    table.insert(self.pengMahjongs[acId], mahjongs)

    for i=1, math.min(4, #mahjongs) do
        local m = mahjongs[i]
        m:setShadowMode(mahjong.shadowMode.yang)
    end

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
    local config = s[mahjongGame.cardType.huan][self.game.mode]
    local o = config.pos
    local r = config.rot
    
    local m = self.game:getSeatTypeByAcId(acId)
    local c = mahjong.w * (self.hnzCount - 1) / 2

    for k, v in pairs(mahjongs) do
        local p = v:getLocalPosition()

        if m == seatType.mine or m == seatType.top then
            p:Set((k - 1) * mahjong.w - c, o.y, o.z)
        else
            p:Set(o.x, o.y, (k - 1) * mahjong.w - c)
        end

        v:setLocalPosition(p)
        v:setLocalRotation(r)
        v:setPickabled(false)
        v:setShadowMode(mahjong.shadowMode.pa)
    end
end

-------------------------------------------------------------------------------
-- 将当前acid的plane高亮
-------------------------------------------------------------------------------
function mahjongOperation:highlightPlaneByAcId(acId)
    if self.game.markerAcId == nil or acId <= 0 then
        self:darkPlanes()
        self.curPlaneMat = nil
    else
        local base = self.game:getSeatTypeByAcId(self.game.markerAcId)
        local seat = self.game:getSeatTypeByAcId(acId)
        local diff = (seat ~= nil) and (seat - base + 4) % 4 or nil
        self.m_curOPDir = acId
        for s, m in pairs(self.planeMats) do
            if diff ~= nil and s == diff then
                m.mainTexture = panleHighlightTex

                self.curPlaneMat = m
                self.curPlaneToD = true
                self.planeTick = time.realtimeSinceStartup()
            else
                m.mainTexture = panleDarkTex
            end
        end
    end
end

-------------------------------------------------------------------------------
-- 将plane变暗
-------------------------------------------------------------------------------
function mahjongOperation:darkPlanes()
    for _, m in pairs(self.planeMats) do
        m.mainTexture = panleDarkTex
        m.color = Color.white
    end

    self.curPlaneMat = nil
end

-------------------------------------------------------------------------------
-- 创建冗余麻将牌对象
-------------------------------------------------------------------------------
function mahjongOperation:createRedundancyMahjong(mahjongId)
    local m = mahjong.new(mahjongId)
    table.insert(self.redundancyMahjongs, m)

    return m
end 

-------------------------------------------------------------------------------
-- 重置
-------------------------------------------------------------------------------
function mahjongOperation:clear(forceDestroy)
--    log("clear start, idle count = " .. tostring(#self.idleMahjongs))
    self.idleMahjongs = {}

    for _, p in pairs(self.game.players) do
        self.inhandMahjongs[p.acId] = nil
        self.chuMahjongs[p.acId]    = nil
        self.pengMahjongs[p.acId]   = nil
        self.huMahjongs[p.acId]     = nil
        self.hnzMahjongs[p.acId]    = nil
    end

    if forceDestroy then
        for _, m in pairs(self.mahjongs) do
            m:destroy()
        end
        self.mahjongs = {}
    else
        for _, m in pairs(self.mahjongs) do
            m:reset()
            m:hide()
            table.insert(self.idleMahjongs, m)
        end
    end

    for _, m in pairs(self.redundancyMahjongs) do
        m:destroy()
    end
    self.redundancyMahjongs = {}

    self.mo = nil
    self.lastPengPos = nil
    self.selectedMahjong = nil
    self.chupaiPtr:hide()
    self.canChuPai = false
--    log("clear over, idle count = " .. tostring(#self.idleMahjongs))
end

-------------------------------------------------------------------------------
-- 重置
-------------------------------------------------------------------------------
function mahjongOperation:reset()
    self.m_curOPDir = 0
    if self.game.mode == gameMode.normal then
        touch.removeListener()
    end

    self:darkPlanes()
    self:hideChuPaiHint()

    if self.animationManager ~= nil then
        self.animationManager:clear()
        self.animationManager:play()
    end

    eventManager.registerAnimationTrigger("table_plane_down", function()
    end)
    eventManager.registerAnimationTrigger("table_plane_up", function()
    end)

    self.diceRoot:hide()
    self.centerGlass:show()
    self.countdown:hide()

    self.hasHnzChoosed = false
    self:clear(false)

    self.mGang_MS:hide()
    self.mHnz:hide()
    self.mQue:hide()
    self.mDQTips:hide()
    self.mHnzNotify:hide()
    self:hideOperations()

    self:hideChuPaiArrow()
    self:hideHuPaiHintInfo()
    self:hideChuPaiHintInfo()

    self.huPaiHintInfo = nil
end

function mahjongOperation:onCloseAllUIHandler()
    self:close()
end

-------------------------------------------------------------------------------
-- 销毁
-------------------------------------------------------------------------------
function mahjongOperation:onDestroy()
--    log("mahjongOperation:onDestroy")
    if self.game.mode == gameMode.normal then
        touch.removeListener()
    end
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    if self.animationManager ~= nil then
        self.animationManager:stop()
        self.animationManager:clear()
        tweenManager.remove(self.animationManager)
        self.animationManager = nil
    end

    self:clear(true)

    for _, v in pairs(self.diceMats) do
        if v.mainTexture ~= nil then
            textureManager.unload(v.mainTexture)
            v.mainTexture = nil
        end
    end

    for _, m in pairs(self.planeMats) do
        if m.mainTexture ~= nil then
            m.mainTexture = nil
        end
        m.color = Color.white
    end
    self.curPlaneMat = nil

    if panleDarkTex ~= nil then
        textureManager.unload(panleDarkTex)
        panleDarkTex = nil
    end
    if panleHighlightTex ~= nil then
        textureManager.unload(panleHighlightTex)
        panleHighlightTex = nil
    end

    self.diceRoot:show()
    self.centerGlass:show()
    self.countdown:show()
    self.chupaiPtr:show()

    base.onDestroy(self)
end

-------------------------------------------------------------------------------
-- 手牌排序
-------------------------------------------------------------------------------
function mahjongOperation:sortInhand(player, mahjongs)
    if mahjongs == nil then
        return
    end
    if player.acId == self.game.mainAcId then 
        table.bubbleSort(mahjongs, function(a, b)
            if a.class == player.que and b.class ~= player.que then
                return false
            elseif b.class == player.que and a.class ~= player.que then
                return true
            end

            return a.id < b.id
        end)
    else
        if self.game.mode == gameMode.playback then
            table.bubbleSort(mahjongs, function(a, b)
                if a.class == player.que and b.class ~= player.que then
                    return true
                elseif b.class == player.que and a.class ~= player.que then
                    return false
                end

                return a.id > b.id
            end)
        end
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
    self:highlightPlaneByAcId(self.game.mainAcId)
    self:setCountdownVisible(true)
    self:setCountdownTick()
end

-------------------------------------------------------------------------------
-- 通知服务器换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHnzChooseClickedHandler()
    playButtonClickSound()

    local hnzQueue = self.hnzMahjongs[self.game.mainAcId]
    if not hnzQueue or #hnzQueue ~= self.hnzCount then
        showMessageUI(string.format("请先选择%d张同花色的牌", self.hnzCount))
        return
    end

    self.hasHnzChoosed = true
    local data = {}
    for _, v in pairs(self.hnzMahjongs[self.game.mainAcId]) do
        table.insert(data, v.id)
    end
    networkManager.huanNZhang(data)

    local mahjongs = self:decreaseInhandMahjongs(self.game.mainAcId, data)
    self:putMahjongsToHuan(self.game.mainAcId, mahjongs)
    self:clearCountdownTick()

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
-- 
-------------------------------------------------------------------------------
local function getHnzNotifyText(R, playerCount) 
    local text = string.empty

    if playerCount == 4 then
        if R == 1 then
            text = "逆时针交换"
        elseif R == 2 then
            text = "对家交换"
        else
            text = "顺时针交换"
        end
    elseif playerCount == 3 then
        if R == 1 then
            text = "逆时针交换"
        else
            text = "顺时针交换"
        end
    else
        text = "相互交换"
    end

    return text
end

-------------------------------------------------------------------------------
-- 服务器通知确定换N张
-------------------------------------------------------------------------------
function mahjongOperation:onHuanNZhangDo(msg)
    local animation = tweenSerial.new(true)

    animation:add(tweenDelay.new(0.2))
    animation:add(tweenFunction.new(function()
        local text = getHnzNotifyText(msg.R, self.game:getTotalPlayerCount())
        self.mHnzNotifyText:setText(text)
        self.mHnzNotify:show()
    end))
    animation:add(tweenDelay.new(0.7))
    animation:add(tweenFunction.new(function()
        self.mHnzNotify:hide()
    end))
    animation:add(tweenDelay.new(0.2))
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
            if msg.AcId == self.game.mainAcId then
                v:setShadowMode(mahjong.shadowMode.noshadow)
            else
                if self.game.mode == gameMode.playback then
                    m:setShadowMode(mahjong.shadowMode.yang)
                else
                    v:setShadowMode(mahjong.shadowMode.li)
                end
            end
            table.insert(mahjongs, v)
        end
        --重新排序手牌
        self:relocateInhandMahjongs(msg.AcId)

        local tp = tweenParallel.new(true)
        animation:add(tp)

        for _, v in pairs(temp) do
            local from = v:getLocalPosition()
            local to = from:Clone()
            from.y = from.y + mahjong.h * 0.3
            v:setLocalPosition(from)

            local ts = tweenSerial.new(true)
            ts:add(tweenDelay.new(1.0))
            ts:add(tweenPosition.new(v, 0.1, from, to, nil))

            tp:add(ts)
        end
    end))

    self.animationManager:add(animation)
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
    animation:add(tweenDelay.new(0.2))
    animation:add(tweenFunction.new(function()
        local text = getHnzNotifyText(msg.Dos[1].R, self.game:getTotalPlayerCount())
        self.mHnzNotifyText:setText(text)
        self.mHnzNotify:show()
    end))
    animation:add(tweenDelay.new(0.7))
    animation:add(tweenFunction.new(function()
        self.mHnzNotify:hide()
    end))
    animation:add(tweenDelay.new(0.2))
    animation:add(tweenFunction.new(function()
        for _, v in pairs(msg.Dos) do
            local mahjongs = self.inhandMahjongs[v.AcId]
            local temp = {}

            for _, u in pairs(v.I) do
                for _, h in pairs(huanMahjongs) do
                    if h.id == u then
                        table.insert(mahjongs, h)
                        if v.AcId == self.game.mainAcId then
                            h:setShadowMode(mahjong.shadowMode.noshadow)
                            table.insert(temp, h)
                        else
                            if self.game.mode == gameMode.playback then
                                h:setShadowMode(mahjong.shadowMode.yang)
                            else
                                h:setShadowMode(mahjong.shadowMode.li)
                            end
                        end
                        break
                    end
                end
            end
            self:relocateInhandMahjongs(v.AcId)
            
            if v.AcId == self.game.mainAcId then
                local tp = tweenParallel.new(true)
                animation:add(tp)

                for _, m in pairs(temp) do
                    local from = m:getLocalPosition()
                    local to = from:Clone()
                    from.y = from.y + mahjong.h * 0.3
                    m:setLocalPosition(from)

                    local ts = tweenSerial.new(true)
                    ts:add(tweenDelay.new(1.0))
                    ts:add(tweenPosition.new(m, 0.1, from, to, nil))

                    tp:add(ts)
                end
            end
        end
    end))

    self.animationManager:add(animation)
end

function mahjongOperation:showChuPaiHintInfo(info)
    if not self.canChuPai or not info then
        self:hideChuPaiHintInfo()
        return
    end

    local handCntVec, totalCntVec = self.game.chuHintComputeHelper:statisticCount()
    for _, t in pairs(info) do
        t.left = 4 - totalCntVec[t.jiaoTid]
    end

    if self.chuPaiHintUI == nil then
        self.chuPaiHintUI = require ("ui.mahjongDesk.huPaiHint").new(info)
    end

    self.chuPaiHintUI:setInfo(info)
    self.chuPaiHintUI:show()
    self.chuPaiHintUI:setParent(self.mHuPaiHint)
    self.chuPaiHintUI:setAnchoredPosition(Vector2.zero)
end

function mahjongOperation:hideChuPaiHintInfo()
    if self.chuPaiHintUI then
        self.chuPaiHintUI:hide()
    end
end

function mahjongOperation:showHuPaiHintInfo()
    if self.huPaiHintInfo ~= nil then
        local huHintItems = { self.mHuHintA, self.mHuHintB, self.mHuHintC, self.mHuHintD, self.mHuHintE, self.mHuHintF, self.mHuHintG, self.mHuHintH, self.mHuHintI, }

        for _, v in pairs(huHintItems) do
            v:hide()
        end

        local handCntVec, totalCntVec = self.game.chuHintComputeHelper:statisticCount()
        for k, v in pairs(self.huPaiHintInfo) do
            v.left = 4 - totalCntVec[v.jiaoTid]

            local item = huHintItems[k]
            item:setInfo(v)
            item:show()
        end

        self.mHuHintBg:setSize(Vector2.New(95 + 104 * #self.huPaiHintInfo, 130))
        self.mHuHint:show()
    end
end

function mahjongOperation:hideHuPaiHintInfo()
    self.mHuHint:hide()
end

function mahjongOperation:worldToUIPos(pos, node, camera)
    local mainCamera = camera
    local scPos = mainCamera:WorldToScreenPoint(pos)
    scPos.z = math.abs(viewManager.camera.transform.position.z)
    local uiPos = viewManager.camera:ScreenToWorldPoint(scPos)

    local parent = node:getParent()
    local _, uiPos = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(parent.rectTransform, scPos, viewManager.camera, nil)
    return uiPos
end

function mahjongOperation:showChuPaiArrow()
    if not self.canChuPai then
        return
    end
    self:hideHuPaiHintInfo()
    self:hideChuPaiArrow()
    local usedIdx = 1
    if self.chuPaiHintInfo and #self.chuPaiHintInfo > 0 then
        local mjTid = {}
        for _, info in pairs(self.chuPaiHintInfo) do
            mjTid[info.tid] = true
        end
        local acId = self.game.mainAcId
        local inhandMahjongs = self.inhandMahjongs[acId]
        local inhandCamera = GameObjectPicker.instance.camera

        local function showMjAnrrow(mahjong)
            if not mahjong then
                return
            end
            local tid = mahjongType.getMahjongTypeId(mahjong.id)
            if mjTid[tid] then
                local pos = mahjong:getPosition()
                pos.y = pos.y + mahjong.h * 1
                pos = self:worldToUIPos(pos, self.mChuHuHints[usedIdx], inhandCamera)
                self.mChuHuHints[usedIdx]:setAnchoredPosition(pos)
                self.mChuHuHints[usedIdx]:show()
                usedIdx = usedIdx + 1
            end
        end
        for _, mahjong in pairs(inhandMahjongs) do
            showMjAnrrow(mahjong)
        end
        showMjAnrrow(self.mo)
    end
end

function mahjongOperation:hideChuPaiArrow()
    self:hideChuPaiHintInfo()
    for _, v in pairs(self.mChuHuHints) do
        v:hide()
    end
end

return mahjongOperation

--endregion
