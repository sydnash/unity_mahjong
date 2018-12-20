local doushisi      = require("logic.doushisi.doushisi")
local doushisiType  = require("logic.doushisi.doushisiType")
local doushisiGame  = require("logic.doushisi.doushisiGame")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local doushisiOperation = class("doushisiOperation", base)

_RES_(doushisiOperation, "DoushisiDeskUI", "DeskOperationUI")

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function doushisiOperation:ctor(game)
    self.game = game
    base.ctor(self)
end

local btnIconConfig = {
    mHuaIcon = {
        default = "hua",
        [cityType.jintang] = "an",
    },
    mDangIcon = {
        default = "dang",
        [cityType.jintang] = "zuoZhuang",
    },
    mBuDangIcon = {
        default = "buDang",
        [cityType.jintang] = "huaZhuang",
    },
}

local mainCameraParams = {
    position = Vector3.New(1000, 0, -13.43),
    rotation = Quaternion.Euler(0, 0, 0),
    hWidth   = 12.80,
}
local inhandCameraParams = {
    position = Vector3.New(1000, 0, -0.9),
    size = 3.6
}

local actionCardGap = 0.50
doushisiOperation.shakepaitime = 0.3
doushisiOperation.actionCardHeight = 2.14
doushisiOperation.actionCardWidth = 0.72

local seats = {
    [seatType.mine] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -2.49, -3.93, 0), rot = Quaternion.Euler(0, 0, 0), 
                    rowgap = 0.69, colgap = 0.50, height = 2.14, width = 0.69, scale = 1,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(3.80, -1.32, 0), rot = Quaternion.Euler(0, 0, -135), 
                    colDir = {x = math.cos(135*math.pi/180), y = math.sin(135*math.pi/180)},
                    rowDir = {x = math.cos(45 * math.pi/180),y = math.sin(45 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, -135),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-0.76, -1.53, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = 1},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 90),
                },
        promote = {pos = Vector3.New(-0.36, -0.55, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.right] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 6.15, -0.30, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(3.22, 2.04, 0), rot = Quaternion.Euler(0, 0, -35), 
                    colDir = {x = math.cos(-125*math.pi/180), y = math.sin(-125*math.pi/180)},
                    rowDir = {x = math.cos(-35 * math.pi/180), y = math.sin(-35 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, -35),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(4.90, 1.32, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(3.58, -0.39, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.top] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 3.10, 2.63, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -4.49, 1.52, 0), rot = Quaternion.Euler(0, 0, 35),
                    colDir = {x = math.cos(-55*math.pi/180), y = math.sin(-55*math.pi/180)},
                    rowDir = {x = math.cos(125 * math.pi/180), y = math.sin(125 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 35),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-0.76, 1.52, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 90),
                },
        promote = {pos = Vector3.New(1.10, 1.09, 0), rot = Quaternion.Euler(0, 0, 90), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 90)},
    },
    [seatType.left] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -6.15, -0.30, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -4.58, -2.67, 0), rot = Quaternion.Euler(0, 0, 135),
                    colDir = {x = math.cos(45*math.pi/180), y = math.sin(45*math.pi/180)},
                    rowDir = {x = math.cos(135 * math.pi/180), y = math.sin(135 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 135),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-4.90, 1.32, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(-3.97, -0.39, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
}

local alignType = {
    min     = 1,
    max     = 2,
    center  = 3,
    percent = 4,
}
local originSafeArea = {
    bottom      = -3.6,
    top         = 3.6,
    right       = 6.4,
    left        = -6.4,
    cx          = 0,
    cy          = 0,
}

function doushisiOperation:fix(min, max, nmin, nmax, p, align)
    local r = p
    if align == alignType.min then
        r = (p - min) + nmin
    elseif align == alignType.max then
        r = nmax - (max - p)
    elseif align == alignType.center then
        r = (p - (min + max) * 0.5) + (nmin + nmax) * 0.5
    elseif align == alignType.percent then
        r = ((p - min) / (max - min) * (nmax - nmin)) + nmin
    end
    return r
end

function doushisiOperation:fixPos(pos, xalign, yalign)
    local x = self:fix(originSafeArea.left, originSafeArea.right, self.safeArea.left, self.safeArea.right, pos.x, xalign)
    local y = self:fix(originSafeArea.bottom, originSafeArea.top, self.safeArea.bottom, self.safeArea.top, pos.y, yalign)
    local ret = Vector3.New(x, y, pos.z)
    return ret
end

function doushisiOperation:alignPos()
    self.seats = seats
    if seats.computed then
        return
    end
    seats.computed = true
    self.seats[seatType.mine][doushisiGame.cardType.shou].pos = self:fixPos(seats[seatType.mine][doushisiGame.cardType.shou].pos, alignType.min, alignType.min)
    self.seats[seatType.mine][doushisiGame.cardType.chu].pos = self:fixPos(seats[seatType.mine][doushisiGame.cardType.chu].pos, alignType.min, alignType.min)
    self.seats[seatType.mine][doushisiGame.cardType.peng].pos = self:fixPos(seats[seatType.mine][doushisiGame.cardType.peng].pos, alignType.max, alignType.min)
    self.seats[seatType.mine].promote.pos = self:fixPos(seats[seatType.mine].promote.pos, alignType.center, alignType.min)

    self.seats[seatType.right][doushisiGame.cardType.shou].pos = self:fixPos(seats[seatType.right][doushisiGame.cardType.shou].pos, alignType.min, alignType.min)
    self.seats[seatType.right][doushisiGame.cardType.chu].pos = self:fixPos(seats[seatType.right][doushisiGame.cardType.chu].pos, alignType.min, alignType.percent)
    self.seats[seatType.right][doushisiGame.cardType.peng].pos = self:fixPos(seats[seatType.right][doushisiGame.cardType.peng].pos, alignType.min, alignType.percent)
    self.seats[seatType.right].promote.pos = self:fixPos(seats[seatType.right].promote.pos, alignType.min, alignType.percent)

    self.seats[seatType.left][doushisiGame.cardType.shou].pos = self:fixPos(seats[seatType.left][doushisiGame.cardType.shou].pos, alignType.max, alignType.min)
    self.seats[seatType.left][doushisiGame.cardType.chu].pos = self:fixPos(seats[seatType.left][doushisiGame.cardType.chu].pos, alignType.max, alignType.percent)
    self.seats[seatType.left][doushisiGame.cardType.peng].pos = self:fixPos(seats[seatType.left][doushisiGame.cardType.peng].pos, alignType.max, alignType.percent)
    self.seats[seatType.left].promote.pos = self:fixPos(seats[seatType.left].promote.pos, alignType.max, alignType.percent)
    
    self.seats[seatType.top][doushisiGame.cardType.shou].pos = self:fixPos(seats[seatType.top][doushisiGame.cardType.shou].pos, alignType.max, alignType.max)
    self.seats[seatType.top][doushisiGame.cardType.chu].pos = self:fixPos(seats[seatType.top][doushisiGame.cardType.chu].pos, alignType.min, alignType.max)
    self.seats[seatType.top][doushisiGame.cardType.peng].pos = self:fixPos(seats[seatType.top][doushisiGame.cardType.peng].pos, alignType.min, alignType.max)
    self.seats[seatType.top].promote.pos = self:fixPos(seats[seatType.top].promote.pos, alignType.center, alignType.max)
end

function doushisiOperation:onInit()
    --初始化主相机
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
    fixMainCameraParam(mainCameraParams.hWidth, mainCamera)
    local bl = Vector3.New(0, 0, math.abs(mainCamera.transform.position.z))
    local tr = Vector3.New(1, 1, math.abs(mainCamera.transform.position.z))

    local wbl = mainCamera:ViewportToWorldPoint(bl)
    local wtr = mainCamera:ViewportToWorldPoint(tr)

    local safeArea = {}
    safeArea.bottom     = wbl.y
    safeArea.right      = wtr.x - 1000
    safeArea.left       = wbl.x - 1000
    safeArea.top        = wtr.y
    safeArea.cx         = 0
    safeArea.cy         = 0
    self.safeArea       = safeArea

    self:alignPos()

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size
    fixInhandCameraParam(inhandCameraParams.size, camera)

    local inhandCameraT = camera.transform
    inhandCameraT.position = Vector3.New(inhandCameraT.position.x, self.safeArea.bottom + camera.orthographicSize, inhandCameraT.position.z)

    self.cardRoot = find("doushisi/changpai_root")
    self.allCards = {}
    self.idleCards = {}
    self.allActionCards = {}
    self.idleActionCards = {}
    self.flyNodes = {}
    self.idleFlyNodes = {}
    self.style = doushisiStyle.traditional
    self.canChuPai = false
    self.dragCard = doushisi.new(0)
    self.dragCard:setLocalScale(Vector3.New(1.2, 1.2, 1.2))
    self.dragCard:setPickabled(true)
    self.dragCard:setColliderEnabled(false)
    self.sortOrder = 0
    --剩余的牌
    self.leftCards = find("doushisi/leftcards")
    local m = findChild(self.leftCards.transform, "model/M")
    self.leftCardsModel = getComponentU(m.gameObject, typeof(SpriteRD))
    local l = findChild(self.leftCards.transform, "num/L")
    local h = findChild(self.leftCards.transform, "num/H")
    self.leftCardsNumL = getComponentU(l.gameObject, typeof(SpriteRD))
    self.leftCardsNumH = getComponentU(h.gameObject, typeof(SpriteRD))
    self.leftCards:hide()
    
    --初始化按钮
    self.mBuDang:addClickListener(self.onBuDangClickedHandler, self)
    self.mDang:addClickListener(self.onDangClickedHandler, self)
    self.mPass:addClickListener(self.onPassClickedHandler, self)
    self.mChi:addClickListener(self.onChiClickedHandler, self)
    self.mChe:addClickListener(self.onCheClickedHandler, self)
    self.mHua:addClickListener(self.onHuaClickedHandler, self)
    self.mAn:addClickListener(self.onAnClickedHandler, self)
    self.mDeng:addClickListener(self.onDengClickedHandler, self)
    self.mHu:addClickListener(self.onHuClickedHandler, self)

    local cityType = self.game.cityType
    for k, info in pairs(btnIconConfig) do
        local icon = self[k]
        local sp = info[cityType]
        if sp == nil then
            sp = info.default
        end
        icon:setSprite(sp)
    end

    self.opBtns = {
        self.mBuDang,
        self.mDang,
        self.mPass,
        self.mChi,
        self.mChe,
        self.mHua,
        self.mAn,
        self.mDeng,
        self.mHu,
    }
    touch.addListener(self.touchHandler, self)

    self.animationManager = tweenParallel.new(false)
    tweenManager.add(self.animationManager)
    self.animationManager:play()

    self:reset()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function doushisiOperation:computeChuPaiHintPos()
    local cfg = self.seats[seatType.mine][doushisiGame.cardType.shou]
    local pos = cfg.pos:Clone()
    local cardLen = cfg.height * 0.5
    
    pos.y = pos.y + cardLen + cfg.colgap * 3
    self.chuPaiLineY = pos.y

    local mainCamera = UnityEngine.Camera.main
    local scPos = mainCamera:WorldToScreenPoint(pos)

    scPos.z = viewManager.camera.transform.position.z
    local uiPos = viewManager.camera:ScreenToWorldPoint(scPos)

    local hintPos = self.mChuHint:getPosition()
    hintPos.y = uiPos.y
    self.mChuHint:setPosition(hintPos)
end

function doushisiOperation:hideAllOpBtn()
    for _, btn in pairs(self.opBtns) do
        btn:hide()
    end
    self.curShowOpBtns = {}
end

function doushisiOperation:closeAllBtnPanel()
    for _, btn in pairs(self.opBtns) do
        if btn.panel then
            btn.panel:close()
            btn.panel = nil
        end
    end
end

function doushisiOperation:onGameSync()
    self:reset()
    touch.addListener(self.touchHandler, self)

    self:initChuCards()
    self:initChiPengCards()
    self:initInhandCards()
    local reenter = self.game.data.Reenter
    if reenter then
        local deskPlayStatus = self.game.deskStatus
        if deskPlayStatus == doushisiGame.deskPlayStatus.tuiDang then
            if self.game.curOpAcId == self.game.mainAcId then
                self:onDangHandler(reenter.IsMustDang)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.touPai then
            if reenter.TouHint ~= nil then 
                local data = {Cards = {}, HasTY = {}, Op = opType.doushisi.an.id, HasWarning = {}}
                if reenter.TouHint.Tous ~= nil then 
                    for v,k in pairs(reenter.TouHint.Tous) do 
                        table.insert(data.Cards, k.CardsId[1])
                        table.insert(data.HasTY, k.HasTY)
                    end
                end
                data.CanPass = reenter.TouHint.CanPass
                if data.CanPass then
                    self:onOpListPass()
                end
                self:onOpListAn(data)
            elseif reenter.CurOpList ~= nil then
                self:onOpList(reenter.CurOpList)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.playing then
            if reenter.CurOpList ~= nil then
                self:onOpList(reenter.CurOpList)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.piao then
        end
        if reenter.CurDiPai >= 0 and (reenter.CurOpType == opType.doushisi.chu.id or reenter.CurOpType == opType.doushisi.fan.id) then
            self:promoteChu(self.game.curOpAcId, reenter.CurDiPai, true)
        end
    end

    self:showLeftCards()
    self:updateLeftCardsCount()
end

function doushisiOperation:onFaPai()
    self:resetPai()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
end

function doushisiOperation:onGameStart()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
    touch.addListener(self.touchHandler, self)
end
---------------------------------------------------------------
--当
---------------------------------------------------------------
function doushisiOperation:onDangHandler(isMustDang)
    self:hideAllOpBtn()
    self:showOpBtn(self.mDang)
    if not isMustDang then
        self:showOpBtn(self.mBuDang)
    end
end
function doushisiOperation:onDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(true)
end
function doushisiOperation:onBuDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(false)
end

function doushisiOperation:onOpList(opList)
    if opList == nil then
        return
    end
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local leftTime = opList.LeftTime

    for _, opInfo in pairs(opList.OpInfos) do
        local op = opInfo.Op
        if isNilOrNull(opInfo.HasTY) then
            opInfo.HasTY = {}
        end
        if isNilOrNull(opInfo.HasWarning) then
            opInfo.HasWarning = {}
        end
        if op == opType.doushisi.hua.id then
            self:onOpListHua(opInfo)
        elseif op == opType.doushisi.chu.id then
            self:onOpListChu(opInfo)
        elseif op == opType.doushisi.chi.id then
            self:onOpListChi(opInfo)
        elseif op == opType.doushisi.che.id then
            self:onOpListChe(opInfo)
        elseif op == opType.doushisi.hu.id then
            self:onOpListHu(opInfo)
        elseif op == opType.doushisi.gang.id then
        elseif op == opType.doushisi.pass.id then
            self:onOpListPass()
        elseif op == opType.doushisi.an.id then
            self:onOpListAn(opInfo)
        elseif op == opType.doushisi.zhao.id then
        elseif op == opType.doushisi.shou.id then
        elseif op == opType.doushisi.bao.id then
        elseif op == opType.doushisi.baGang.id then
            self:onOpListBaGang(opInfo)
        elseif op == opType.doushisi.chiChengSan.id then
            --self:onOpListChiChengSan(opInfo)
        elseif op == opType.doushisi.caiShen.id then
            self:onOpListCaiShen(opInfo)
        elseif op == opType.doushisi.baoJiao.id then
        elseif op == opType.doushisi.gen.id then
        elseif op == opType.doushisi.weiGui.id then
        else
            log("on op list handler: receive not supported handler." .. tostring(op))
        end
    end
    self:relocateOpBtn()
end

function doushisiOperation:onOpListPass()
    self:showOpBtn(self.mPass)
end

function doushisiOperation:showOpBtn(btn, opInfo)
    btn:show()
    btn.opInfo = opInfo
    table.insert(self.curShowOpBtns, btn)
end

function doushisiOperation:relocateOpBtn()
end

function doushisiOperation:onPassClickedHandler()
    local sendData = self:getOpChoseData(opType.doushisi.pass.id)
    networkManager.csOpChose(sendData)
end

function doushisiOperation:showChuHint()
    self.mChuHint:show()
    self.mLine.action = tweenForever.new({
            tweenColor.fadeOut(self.mLine, 0.5),
            tweenColor.fadeIn(self.mLine, 0.5),
        })

    local from  = Vector3.New(0, 0, 45)
    local to    = Vector3.New(0, 0, 1)
    self.mFinger:setLocalRotation(from)
    self.mFinger.action = tweenForever.new({
        tweenRotation.new(self.mFinger, 0.5, from, to, nil),
        tweenRotation.new(self.mFinger, 0.5, to, from, nil),
    })
    tweenManager.add(self.mLine.action)
    tweenManager.add(self.mFinger.action)

    self.mLine.action:play()
    self.mFinger.action:play()
end
function doushisiOperation:hideChuHint()
    tweenManager.remove(self.mLine.action)
    tweenManager.remove(self.mFinger.action)
    self.mChuHint:hide()
end

function doushisiOperation:enableChu()
    self.canChuPai = true
    self:showChuHint()
end
function doushisiOperation:disableChu()
    self.canChuPai = false
    self:hideChuHint()
end
-----------------------------------------------------------
--chu
-----------------------------------------------------------
function doushisiOperation:virtureChu(card)
    local acId = self.game.mainAcId
    card:hide()
    self:promoteChu(acId, card.id)
end

function doushisiOperation:onOpListChu(opInfo)
    self:enableChu()
end
function doushisiOperation:onOpDoChu(acId, id)
    self:disableChu()

    local card = self:findAndRemoveCard(acId, id)
    self:addCardToChu(acId, card)

    --self:movePromoteCardToChu()
    if self.promoteNode and self.promoteNode.acId ~= acId then
        self:pushBackPromoteNode()
    end
    local isIm = false
    if self.promoteNode and self.promoteNode.id == id then
        card:hide()
        return 1.2
    end

    self:promoteChu(acId, id, isIm)
    return 1.2
end

function doushisiOperation:opDoChiPengAnHua(acId, delIds, beId, op)
    local info = {
        op = op,
        cards = {}
    }
    if beId then
        local card = self:findAndRemoveCard(acId, beId)
        table.insert(info.cards, card)
    end
    for _, id in pairs(delIds) do
        local card = self:findAndRemoveCard(acId, id)
        table.insert(info.cards, card)
    end
    table.insert(self.chipengCards[acId], info)
    self:relocateChiPengCards(acId)

    return info
end
-----------------------------------------------------------
--hua
-----------------------------------------------------------
function doushisiOperation:onOpListHua(opInfo)
    self:showOpBtn(self.mHua, opInfo)
end
function doushisiOperation:onHuaClickedHandler()
    self:onPanelBtnClick(self.mHua, function(Class)
        return Class.newAnSelPanel(self.mHua.opInfo, function(info)
            self:onHuaChose(info)
        end)
    end)
end
function doushisiOperation:onHuaChose(info)
    local data = self:getOpChoseData(opType.doushisi.hua.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function doushisiOperation:onOpDoHua(acId, delIds)
    local info =self:opDoChiPengAnHua(acId, delIds, nil, opType.doushisi.hua.id)
    return self:chiPengAction(acId, info.cards)
end

-----------------------------------------------------------
--chi
-----------------------------------------------------------
function doushisiOperation:onOpListChi(opInfo)
    self:showOpBtn(self.mChi, opInfo)
end
function doushisiOperation:onChiClickedHandler()
    self:onPanelBtnClick(self.mChi, function(Class)
        return Class.newChiSelPanel(self.mChi.opInfo, function(info)
            self:onChiChose(info)
        end)
    end)
end
function doushisiOperation:onChiChose(info)
    local data = self:getOpChoseData(opType.doushisi.chi.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function doushisiOperation:onOpDoChi(acId, delIds, beId)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.chi.id)
    return self:chiPengAction(acId, info.cards)
end

-----------------------------------------------------------
--che
-----------------------------------------------------------
function doushisiOperation:onOpListChe(opInfo)
    self:showOpBtn(self.mChe, opInfo)
end
function doushisiOperation:onCheClickedHandler()
    local info = self.mChe.opInfo
    local data = self:getOpChoseData(opType.doushisi.che.id, info.Cards[1], info.HasTY[1], nil)
    networkManager.csOpChose(data)
end
function doushisiOperation:onOpDoChe(acId, delIds, beId)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.che.id)
    return self:chiPengAction(acId, info.cards)
end

-----------------------------------------------------------
--hu
-----------------------------------------------------------
function doushisiOperation:onOpListHu(opInfo)
    self:showOpBtn(self.mHu, opInfo)
end
function doushisiOperation:onHuClickedHandler()
    local info = self.mHu.opInfo
    local data = self:getOpChoseData(opType.doushisi.hu.id, info.Cards[1])
    networkManager.csOpChose(data)
end
function doushisiOperation:onOpDoHu(acId, id)
    self:promoteChu(acId, id)
end

-----------------------------------------------------------
--an
-----------------------------------------------------------
function doushisiOperation:onOpListAn(opInfo)
    self:showOpBtn(self.mAn, opInfo)
end
function doushisiOperation:onAnClickedHandler()
    self:onPanelBtnClick(self.mAn, function(Class)
        return Class.newAnSelPanel(self.mAn.opInfo, function(info)
            self:onAnChose(info)
        end)
    end)
end
function doushisiOperation:onAnChose(info)
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local sendData = { Chooses={} }
    local item = {Card = info.c, Num = 3}
    if info.hasTY then
        item.Num = 4
    end
    table.insert(sendData.Chooses, item)
    networkManager.csAnPai(sendData)
end
function doushisiOperation:onOpDoAn(acId, delIds)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.an.id)
    return self:chiPengAction(acId, info.cards)
end

-----------------------------------------------------------
--ba gang
-----------------------------------------------------------
function doushisiOperation:onOpListBaGang(opInfo)
    self:showOpBtn(self.mDeng, opInfo)
end
function doushisiOperation:onDengClickedHandler()
    self:onPanelBtnClick(self.mDeng, function(Class)
        return Class.newBaGangSelPanel(self.mDeng.opInfo, function(info)
            self:onBaGangChose(info)
        end)
    end)
end
function doushisiOperation:onBaGangChose(info)
    local data = self:getOpChoseData(opType.doushisi.baGang.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function doushisiOperation:onOpDoBaGang(acId, id)
    local card = self:findAndRemoveCard(acId, id)

    local chipengCards = self.chipengCards[acId]
    local findInfo = nil
    for _, info in pairs(chipengCards) do
        if findInfo ~= nil then
            break
        end
        if info.op ~= opType.doushisi.caiShen.id and #info.cards <= 3 then
            if id < 0 or info.cards[1].id < 0 or doushisi.typeId(info.cards[1].id) == doushisi.typeId(id) then
                table.insert(info.cards, card)
                findInfo = info
                break
            end
        end
    end

    self:relocateChiPengCards(acId)

    return self:chiPengAction(acId, {card})
end

-----------------------------------------------------------
--cai shen
-----------------------------------------------------------
function doushisiOperation:onOpListCaiShen(info)
end
function doushisiOperation:onOpDoCaiShen(acId, id)
    local card = self:findAndRemoveCard(acId, id)

    local caiShenInfo
    local chipengCards = self.chipengCards[acId]
    if chipengCards and #chipengCards > 0 and chipengCards[1].op == opType.doushisi.caiShen.id then
        caiShenInfo = chipengCards[1]
    else
        caiShenInfo = {op = opType.doushisi.caiShen.id, cards = {}}
        table.insert(chipengCards, 1, caiShenInfo)
    end
    table.insert(caiShenInfo.cards, card)

    self:relocateChiPengCards(acId)

    return self:chiPengAction(acId, {card})
end

function doushisiOperation:onPanelBtnClick(btn, createFunc)
    if btn.panel then
        btn.panel:close()
        btn.panel = nil
        return
    end
    self:closeAllBtnPanel()
    local PanelClass = require ("ui.doushisiDesk.chiAnSelPanel")
    local panel = createFunc(PanelClass)
    btn.panel = panel
    panel:show()
    panel:setParent(btn)
    panel:setLocalPosition(Vector3.New(0, 0, 0))
end

function doushisiOperation:getOpChoseData(op, card, hasTY, baos)
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local data = {
        Op = op,
        ChoseCard = card,
        HasTY = hasTY,
        BaoTypes = baos,
    }
    return data
end

function doushisiOperation:reset()
    touch.removeListener()
    self:hideLeftCards()
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    self:disableChu()

    if self.animationManager ~= nil then
        self.animationManager:clear()
        self.animationManager:play()
    end
    self:resetPai()
end

function doushisiOperation:resetPai()
    self:computeChuPaiHintPos()
    self.dragCard:hide()
    self.idleCards = {}
    self.promoteNode = nil
    for _, card in pairs(self.allCards) do
        card:hide()
        card:setSelected(false)
        card:setPickabled(false)
        table.insert(self.idleCards, card)
    end
    self.idleActionCards = {}
    for _, card in pairs(self.allActionCards) do
        self:pushbackActionCard(card)
    end
    self.idleFlyNodes = {}
    for _, node in pairs(self.flyNodes) do
        self:pushFlyNode(node)
    end
    self.inhandCards = {}
    self.chuCards = {}
    self.chipengCards = {}
end

function doushisiOperation:getCardById(id)
    if #self.idleCards > 0 then
        local card = self.idleCards[#self.idleCards]
        table.remove(self.idleCards, #self.idleCards)
        card:setId(id)
        card:hide()
        return card
    end
    local card = doushisi.new(id)
    table.insert(self.allCards, card)
    card:hide()
    return card
end

function doushisiOperation:getActionCardById(id)
    local card
    if #self.idleActionCards > 0 then
        card = self.idleActionCards[#self.idleActionCards]
        table.remove(self.idleActionCards, #self.idleActionCards)
    else
        card = doushisi.new(id)
        card:setColliderEnabled(false)
        table.insert(self.allActionCards, card)
    end
    card:hide()
    card:setId(id)
    return card
end

function doushisiOperation:pushbackActionCard(card)
    card:hide()
    card:setPickabled(false)
    card:setParent(self.cardRoot)
    table.insert(self.idleActionCards, card)
end

function doushisiOperation:promoteChu(acId, id, im)
    local card = self:findCard(acId, id)
    card:hide()
    local node = self:createFlyNode({id})
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote

    local pos = Vector3.New(cfg.pos.x, cfg.pos.y, cfg.pos.z)
    node:setLocalPosition(pos)
    node:setLocalRotation(cfg.rot)
    node:show()

    if not im then
        local shakeAction = self:getShakeAction(node)
        self.animationManager:add(shakeAction)
        shakeAction:play()
    end

    self.promoteNode = node
    self.promoteNode.acId = acId
    self.promoteNode.id = id

    return self.shakepaitime
end

function doushisiOperation:addCardTo(card, pos, seatType, cardType, rot, scale, parent)
    pos.z = 0
    if parent then
        card:setParent(parent)
    else
        card:setParent(self.cardRoot)
    end
    card:setSelected(false)
    card:setStyle(self.style)
    card:setType(cardType)
    card:fix()
    card:setLocalPosition(pos)
    if rot then
        card:setLocalRotation(rot)
    end
    if scale then
        card:setLocalScale(scale)
    end
    card:show()
    self:topCard(card)
end

function doushisiOperation:onMoPai(acId, ids)
    local time = 0
    for idx, id in pairs(ids) do
        if time > 0 then
            self:callFunctionAfterTime(time * idx - 1, function()
                self:moOnePai(acId, id)
            end)
        else
            time = self:moOnePai(acId, id)
        end
    end
    return time * #ids
end

local poses = {
    [seatType.top]          = { pos = Vector3.New(0, 5.17, 0)},
    [seatType.right]        = { pos = Vector3.New(9, 0.2, 0)},
    [seatType.left]         = { pos = Vector3.New(-9, 0.2, 0)},
}
function doushisiOperation:moOnePai(acId, id)
    local card = self:getCardById(id)
    table.insert(self.inhandCards[acId], card)
    self:relocateInhandCards(acId)
    
    local st = self.game:getSeatTypeByAcId(acId)
    local pos, order
    local scale = 1
    if acId == self.game.mainAcId or self.game:isPlayback() then
        local cfg = self.seats[st][doushisiGame.cardType.shou]
        pos = card:getLocalPosition()
        pos = Vector3.New(pos.x, pos.y, pos.z)
        order = card:getSortingOrder()
        scale = cfg.scale
    else
        pos = poses[st].pos
        order = 0
    end

    local time = self:movePromoteCardToChu()

    return self:moPaiAction(time, acId, id, pos, order, scale)
end

function doushisiOperation:onFanPai(acId, id)
    local card = self:getCardById(id)
    table.insert(self.chuCards[acId], card)
    self:relocateChuCards(acId)

    local time = self:movePromoteCardToChu()

    card:hide()
    time = self:fanPaiAction(time, acId, id)
    return math.max(time, 1.2)
end

function doushisiOperation:onAnPaiShow(acId, idInfo)
    local chipengCards = self.chipengCards[acId]
    local caishen
    for _, info in pairs(chipengCards) do
        if info.op == opType.doushisi.caiShen.id then
            caishen = info
        else
            for _, c in pairs(info.cards) do
                table.insert(self.idleCards, c)
            end
        end
    end

    chipengCards = {}
    if caishen then table.insert(chipengCards, caishen) end

    for _, ids in pairs(idInfo) do
        local info = {op = opType.doushisi.an.id, cards = {}}
        for _, id in pairs(ids) do
            local card = self:getCardById(id)
            table.insert(info.cards, card)
        end
        table.insert(chipengCards, info)
    end

    self:relocateChiPengCards(acId)

    if self.promoteNode and self.promoteNode.cards then
        for _, card in pairs(self.promoteNode.cards) do
            self:topCard(card)
        end
    end
    return 0
end

-----------------------------------------------------------
--chu cards op
-----------------------------------------------------------
function doushisiOperation:initChiPengCards()
    for _, player in pairs(self.game.players) do
        self.chipengCards[player.acId] = {}
        local infos = self.chipengCards[player.acId]
        for _, info in pairs(player[doushisiGame.cardType.peng]) do
            local chiPengInfo = {op = info.Op, cards = {}}
            for _, id in pairs(info.Cards) do
                local card = self:getCardById(id)
                table.insert(chiPengInfo.cards, card)
            end
            table.insert(infos, chiPengInfo)
        end
        self:relocateChiPengCards(player.acId)
    end
end

function doushisiOperation:relocateChiPengCards(acId)
    local seatType = self.game:getSeatTypeByAcId(acId)
    local infos = self.chipengCards[acId]

    local startPos = self:getChiPengCardStartPos(seatType)

    local totalCntSincePreGroup = 0
    local colMax = 12
    local row = 0
    local col = 0
    local firstRowCnt = 0
    for pengIdx, info in pairs(infos) do
        if row == 0 then
            if totalCntSincePreGroup + #info.cards > colMax then
                firstRowCnt = totalCntSincePreGroup
                row = 1
            end
        end
        for idx, card in pairs(info.cards) do
            local pos = card:getLocalPosition()
            local pos, rot = self:getChiPengCardPos(startPos, seatType, row, totalCntSincePreGroup + idx - firstRowCnt - 1, pos)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.peng, rot)
            card:setPickabled(false)
        end
        totalCntSincePreGroup = totalCntSincePreGroup + #info.cards
    end
end

function doushisiOperation:getChiPengCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.peng].pos
end

function doushisiOperation:getChiPengCardPos(startPos, seatType, row, col, pos)
    local cfg = self.seats[seatType][doushisiGame.cardType.peng]
    local rsx = startPos.x + row * cfg.rowDir.x * cfg.rowgap
    local rsy = startPos.y + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

-----------------------------------------------------------
--chu cards op
-----------------------------------------------------------
function doushisiOperation:initChuCards()
    for _, player in pairs(self.game.players) do
        self.chuCards[player.acId] = {}
        local cards = self.chuCards[player.acId]
        for _, id in pairs(player[doushisiGame.cardType.chu]) do
            local card = self:getCardById(id)
            table.insert(cards, card)
        end
        self:relocateChuCards(player.acId)
    end
end

function doushisiOperation:addCardToChu(acId, card)
    local cards = self.chuCards[acId]
    table.insert(cards, card)
    self:relocateChuCards(acId)
end

function doushisiOperation:relocateChuCards(acId)
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.chuCards[acId]

    local startPos = self:getChuCardStartPos(seatType)
    for idx, card in pairs(cards) do
        local pos = card:getLocalPosition()
        local pos, rot = self:getChuCardPos(startPos, seatType, idx, pos)
        self:addCardTo(card, pos, seatType, doushisiGame.cardType.chu, rot)
        card:setPickabled(false)
    end
end

function doushisiOperation:getChuCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.chu].pos
end

function doushisiOperation:getChuCardPos(startPos, seatType, idx, pos)
    local colMax = 7
    local row = math.floor((idx - 1) / colMax)
    local col = (idx - 1) % 7

    local cfg = self.seats[seatType][doushisiGame.cardType.chu]
    local rsx = startPos.x + row * cfg.rowDir.x * cfg.rowgap
    local rsy = startPos.y + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

-----------------------------------------------------------
--inhand cards op
-----------------------------------------------------------
function doushisiOperation:initInhandCards()
    for _, player in pairs(self.game.players) do
        self.inhandCards[player.acId] = {}
        self:initOnePlayerInhandCards(player.acId, player[doushisiGame.cardType.shou])
    end

    self:updateLeftCardsCount()
end

function doushisiOperation:initOnePlayerInhandCards(acId, ids)
    local cards = self.inhandCards[acId]
    for _, id in pairs(ids) do
        if id >= 0 then
            local card = self:getCardById(id)
            table.insert(cards, card)
        end
    end
    self:relocateInhandCards(acId)
end

function doushisiOperation:relocateInhandCards(acId)
    if acId ~= self.game.mainAcId then
        self:relocateOtherInhandCards(acId)
        return
    end
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.inhandCards[acId]
    self.meSortedInhandCards = self:sortInhandCards(cards)

    local startPos = self:getInhandCardStartPos(seatType)
    local z = 0
    for col, cards in pairs(self.meSortedInhandCards) do
        for row, card in pairs(cards) do
            local pos = card:getLocalPosition()
            local pos, rot = self:getInhandCardPos(startPos, seatType, col, row, pos, #cards)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.shou, rot)
            pos.z = z
            card:setLocalPosition(pos)
            z = z - 0.00001
            card:setPickabled(true)
        end
    end
end

function doushisiOperation:getInhandCardPos(startPos, seatType, col, row, pos, rowHeight)
    local cfg = self.seats[seatType][doushisiGame.cardType.shou]
    local diffx = cfg.rowgap * (col - 1)
    local diffy = cfg.colgap * (rowHeight - row)
    pos.x = startPos.x + diffx
    pos.y = startPos.y + diffy
    return pos, cfg.rot
end

----------------------------------------------------------------------------------
--找牌
----------------------------------------------------------------------------------
function doushisiOperation:findCardFromInhand(acId, id, remove)
    local card = nil
    local inhandCards = self.inhandCards[acId]
    if acId == self.game.mainAcId or self.game:isPlayback() then
        for idx, card in pairs(inhandCards) do
            if id == card.id then
                if remove then
                    table.remove(inhandCards, idx)
                    self:relocateInhandCards(acId)
                end
                return card
            end
        end
    else
        -- if #inhandCards > 0 then
        --     local card = inhandCards[1]
        --     card:setId(id)
        --     if remove then
        --         table.remove(inhandCards, 1)
        --     end
        --     return card
        -- end
    end
    return nil
end

function doushisiOperation:findCardFromChuPai(id, remove)
    for acId, cards in pairs(self.chuCards) do
        for idx, c in pairs(cards) do
            if c.id == id then
                if remove then
                    table.remove(cards, idx)
                    self:relocateChuCards(acId)
                end
                return c
            end
        end
    end
end

function doushisiOperation:findCard(acId, id, remove)
    local pai = self:findCardFromInhand(acId, id, remove)
    if pai == nil then
        pai = self:findCardFromChuPai(id, remove)
    end
    if pai == nil then
        pai = self:getCardById(id)
    end
    return pai
end
function doushisiOperation:findAndRemoveCard(acId, id)
    return self:findCard(acId, id, true)
end
----------------------------------------------------------------------------------
--touch
----------------------------------------------------------------------------------
function doushisiOperation:getInhandCardStartPos(st)
    if st ~= seatType.mine then
        return Vector3.zero
    else
        return self.seats[st][doushisiGame.cardType.shou].pos
    end
end

function doushisiOperation:topCard(card)
    card:setSortingOrder(self.sortOrder)
    self.sortOrder = self.sortOrder + 1
end

function doushisiOperation:showLeftCards()
    self.leftCards:show()
end

function doushisiOperation:hideLeftCards()
    self.leftCards:hide()
end

function doushisiOperation:updateLeftCardsCount(cnt)
    if cnt == nil then
        cnt = self.game:getLeftCardsCount()
    end
    log("left cards = " .. tostring(cnt))

    local total = self.game:getTotalCardsCount()
    local M = tostring(math.floor((cnt / total) * 10))
    self.leftCardsModel.spriteName = M

    local L = tostring(cnt % 10)
    local H = tostring(math.floor(cnt / 10))
    self.leftCardsNumL.spriteName = L
    self.leftCardsNumH.spriteName = H
end

function doushisiOperation:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self:reset()
    self:showLeftCards()

    for _, card in pairs(self.allCards) do
        card:destroy()
    end

    for _, card in pairs(self.allActionCards) do
        card:destroy()
    end

    for _, node in pairs(self.flyNodes) do
        GameObject.Destroy(node.gameObject)
    end

    base.onDestroy(self)
end

function doushisiOperation:getCardByGo(go)
    local cards = self.inhandCards[self.game.mainAcId]

    for _, c in pairs(cards) do
        if c.gameObject == go then
            return c
        end
    end

    return nil
end

function doushisiOperation:touchHandler(phase, pos)
    if not self.canChuPai then
        return
    end
    local camera = GameObjectPicker.instance.camera

    if phase == touch.phaseType.began then
        local go = GameObjectPicker.instance:Pick(pos)
        if go ~= nil then
            local clickCard = self:getCardByGo(go)
            if clickCard == nil then
                return
            end
            local preSelectedCard = self.curSelectdCard
            self.curSelectdCard = clickCard

            self.isClick = true
            if preSelectedCard and preSelectedCard ~= clickCard then
                preSelectedCard:setSelected(false)
            end
            local cardPos = self.curSelectdCard:getLocalPosition()
            if self.curSelectdCard ~= nil then
                local cpos = camera.transform.localPosition
                pos.z = cardPos.z - cpos.z
                self.selectedLastPos = camera:ScreenToWorldPoint(pos)
            end
            self.dragCard:setId(self.curSelectdCard.id)
            self:addCardTo(self.dragCard, cardPos, seatType.mine, doushisiGame.cardType.perfect)
        else
            if self.curSelectdCard then
                self.curSelectdCard:setSelected(false)
                self.curSelectdCard = nil
            end
        end
    elseif phase == touch.phaseType.moved then
        if self.curSelectdCard ~= nil then
            local mpos = self.dragCard:getPosition()
            local cpos = camera.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedLastPos
            if dpos:Magnitude() > 0.001 then
                self.isClick = false
            end
        
            mpos = Vector3.New(mpos.x + dpos.x, mpos.y + dpos.y, mpos.z)
            self.dragCard:setPosition(mpos)
            self.selectedLastPos = wpos
        end
    else
        self.dragCard:hide()
        if self.curSelectdCard ~= nil then
            if self.isClick then
                if self.curSelectdCard.selected then
                    if self.canChuPai then
                        self.curSelectdCard:setSelected(false)
                        self:onChoseChuPai(self.curSelectdCard)
                        self.curSelectdCard = nil
                    else
                        self.curSelectdCard:setSelected(false)
                        self.curSelectdCard = nil
                    end
                else
                    self.curSelectdCard:setSelected(true)
                end
            else
                self.curSelectdCard:setSelected(false)
                if self.canChuPai then
                    local mpos = self.dragCard:getPosition()
                    local cpos = camera.transform.localPosition
                    pos.z = mpos.z - cpos.z
                    local wpos = camera:ScreenToWorldPoint(pos)
                    if wpos.y > self.chuPaiLineY then
                        self:onChoseChuPai(self.curSelectdCard)
                    end
                end
                self.curSelectdCard = nil
            end
        end
    end
end

function doushisiOperation:onChoseChuPai(card)
    local id = card.id
    local sendData = self:getOpChoseData(opType.doushisi.chu.id, id, nil, nil)
    networkManager.csOpChose(sendData)
    self.canChuPai = false

    self:virtureChu(card)
end

---------------------------------------------------------
--排序
---------------------------------------------------------
function doushisiOperation:getCardType(card)
    return doushisiType.getDoushisiTypeId(card)
end

function doushisiOperation:getCardDescByType(idx)
    return doushisiType.getDoushisiTypeByTypeId(idx)
end

function doushisiOperation:adjustValue(value)
    if value <= 7 then 
        return value 
    end
    return 14 - value
end

function doushisiOperation:sortInhandCards(oripais)
    local cntvec = {}
    for _, pai in ipairs(oripais) do
        local typ = self:getCardType(pai.id)
        if cntvec[typ] == nil then
            local desc = self:getCardDescByType(typ)
            cntvec[typ] = {dianshu = self:getCardDescByType(typ).value, typ = typ, cards = {}}
        end
        table.insert(cntvec[typ].cards, pai)
    end

    --class dian = {dian = 2, cnts = {cnt, cnt}}
    local dianvec = {}
    for i = 0, 23 do
        local cnt = cntvec[i]
        if cnt then
            local dian = cnt.dianshu
            local dian = self:adjustValue(dian)
            if dianvec[dian] == nil then
                dianvec[dian] = {dian = dian, cnts = {}}
            end
            table.insert(dianvec[dian].cnts, cnt)
        end
    end

    local function getDianPaiCnt(dian)
        local paicnt = 0
        for _, cnt in pairs(dian.cnts) do
            paicnt = paicnt + #cnt.cards
        end
        return paicnt
    end
    local function getDianPais(dian)
        local ret = {}
        for _, cnt in pairs(dian.cnts) do
            for _, pai in pairs(cnt.cards) do
                table.insert(ret, pai)
            end
        end
        return ret
    end

    local ret = {}
    for i = 0,7 do
        local dian = dianvec[i]
        if dian then
            local paicnt = getDianPaiCnt(dian)
            if paicnt <= 4 then
                table.insert(ret, getDianPais(dian))
            else
                local tmp = {}
                local preDianShu = -1
                local leftcnt = paicnt
                for _, cnt in pairs(dian.cnts) do
                    local hasProcess = false
                    if #tmp + #cnt.cards <= 4 then
                        local needProcess = false
                        if preDianShu == -1 or cnt.dianshu == preDianShu then
                            needProcess = true
                        end
                        if not needProcess then
                            if #tmp + leftcnt <= 4 then
                                needProcess = true
                            end
                        end

                        if needProcess then
                            for _, pai in pairs(cnt.cards) do
                                table.insert(tmp, pai)
                            end
                            hasProcess = true
                        end
                    end
                    if not hasProcess then
                        table.insert(ret, tmp)
                        tmp = {}
                        for _, pai in pairs(cnt.cards) do
                            table.insert(tmp, pai)
                        end
                    end
                    preDianShu = cnt.dianshu
                    leftcnt = leftcnt - #cnt.cards
                end
                if #tmp > 0 then
                    table.insert(ret, tmp)
                end
            end
        end
    end
    return ret
end

----------------------------------------------------------------------------------------
--动画
----------------------------------------------------------------------------------------
---------------吃 碰 按 滑------------------------
function doushisiOperation:chiPengAction(acId, cards)
    local ids = {}
    for _, card in pairs(cards) do
        card:hide()
        table.insert(ids, card.id)
    end
    local node = self:createFlyNode(ids)
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote

    --promote pos
    local x1, y1 = cfg.pos.x, cfg.pos.y

    -- local top = y1 + (SHOUPAI_HEIGHT + SHOUPAI_GAP * (#pais - 1)) * 0.5
    -- if top > safeArea.top then
    --     local diff = top - safeArea.top
    --     y1 = y1 - diff
    -- end

    local cfg = self.seats[st][doushisiGame.cardType.peng]
    local x, y = 0, 0
    for _, card in pairs(cards) do
        local pos = card:getLocalPosition()
        x = x + pos.x
        y = y + pos.y
    end
    x = x / #cards
    y = y / #cards

    local delayTime = 0.15

    local shakeAction, shakeTime = self:getShakeAction(node)
    local delayAction = self:getDelayAction(delayTime)
    local flyAction, flyTime = self:getFlyAction(node, x1, y1, x, y, cfg.rotEuler.z, 0.6, nil, 1)
    node:setLocalPosition(Vector3.New(x1, y1, 0))
    node:show()

    if node.cards and #node.cards == 1 then
        for _, card in pairs(node.cards) do
            card:setSortingOrder(cards[#cards]:getSortingOrder())
        end
    end

    local seqAction = self:getSequenceAction({shakeAction, delayAction, flyAction, tweenFunction.new(function()
        self:pushFlyNode(node)
        self:relocateChiPengCards(acId)
    end)})
    self.animationManager:add(seqAction)
    seqAction:play()

    local added = 0.03 * ((#seqAction.queue + 1) * 2 + 1)
    return shakeTime + delayTime + flyTime + added
end

---------------------摸牌
function doushisiOperation:moPaiAction(time, acId, id, handPos, order, scale)
    if id >= 0 then
        local card = self:findCard(acId, id)
        card:hide()
    end
    local node = self:createFlyNode({id})
    self:setNodeAtCenter(node)

    local centerScaleAction, t1 = self:getCenterScaleAction(node)
    local delayTime = 0.1
    local centerDelayAction = self:getDelayAction(delayTime)

    local startPos = node:getLocalPosition()
    --promote pos
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote
    local x2, y2 = cfg.pos.x, cfg.pos.y

    local r = 0
    local flyAction, flyTime = self:getFlyAction(node, startPos.x, startPos.y, x2, y2, cfg.rotEuler.z)
    local delayTime2 = 0.2
    local delayAction2 = self:getDelayAction(delayTime2)
    local flyAction2, flyTime2 = self:getFlyAction(node, x2, y2, handPos.x, handPos.y, nil, scale, nil, 1)

    local sq = self:getSequenceAction({centerScaleAction, centerDelayAction, flyAction, delayAction2, flyAction2, tweenFunction.new(function()
        self:pushFlyNode(node)
        self:relocateInhandCards(acId)
    end)})
    if order > 0 then
        if node.cards then
            for _, c in pairs(node.cards) do
                c:setSortingOrder(order)
            end
        end
    end
    if acId == self.game.mainAcId then
        if node.cards then
            for _, c in pairs(node.cards) do
                c:setPickabled(true)
            end
        end
    end

    local function playSq()
        self.animationManager:add(sq)
        sq:play()

        self:updateLeftCardsCount()
    end

    if time > 0 then
        self:callFunctionAfterTime(time, function()
            playSq()
        end)
    else
        playSq()
    end

    local added = 0.03 * ((5 + 1) * 2 + 1)
    return t1 + delayTime + flyTime + delayTime2 + flyTime2 + added + time
end

function doushisiOperation:fanPaiAction(time, acId, id)
    local x1, y1 = self:getCenterFanPaiPos()
    --promote pos
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote
    local x2, y2 = cfg.pos.x, cfg.pos.y

    local _, t1 = self:getCenterScaleAction(nil)
    local delayTime = 0.1
    local flyTime = self:computeFlyTime(x1, y1, x2, y2)

    local fanFunc = function()
        local node = self:createFlyNode({id})
        self:setNodeAtCenter(node)
        local centerScaleAction, t1 = self:getCenterScaleAction(node)
        local centerDelayAction = self:getDelayAction(delayTime)
        local nodePos = node:getLocalPosition()
        local r = 0
        local flyAction, flyTime = self:getFlyAction(node, nodePos.x, nodePos.y, x2, y2, r)
        local seqAction = self:getSequenceAction({centerScaleAction, centerDelayAction, flyAction})
        self.animationManager:add(seqAction)
        seqAction:play()

        node.acId = acId
        node.chufan = 2
        node.id = id
        self.promoteNode = node

        self:updateLeftCardsCount()
    end
    
    if time > 0 then
        self:callFunctionAfterTime(time, function()
            fanFunc()
        end)
    else
        fanFunc()
    end
    local added = 0.03 * ((3 + 1) * 2 + 1)
    return time + flyTime + t1 + delayTime + added
end
function doushisiOperation:pushBackPromoteNode()
    if self.promoteNode then
        self:pushFlyNode(self.promoteNode)
        self.promoteNode = nil
    end
end
function doushisiOperation:movePromoteCardToChu()
    if self.promoteNode == nil then
        return 0
    end
    local node = self.promoteNode
    self.promoteNode = nil

    local acId = node.acId
    local id = node.id
    local pai = self:findCard(acId, id)
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st][doushisiGame.cardType.chu]
    local x2, y2 = cfg.pos.x, cfg.pos.y

    --end pos
    local pos = pai:getLocalPosition()
    local x2 = pos.x
    local y2 = pos.y
    --start pos
    local startPos = node:getLocalPosition()
    local flyAction, flyTime = self:getFlyAction(node, startPos.x, startPos.y, x2, y2, cfg.rotEuler.z, 0.6)
    local func = function()
        self:pushFlyNode(node)
        self:relocateChuCards(acId)
    end
    local cb = tweenFunction.new(func)

    local seqAction = self:getSequenceAction({flyAction, cb})
    self.animationManager:add(seqAction)
    seqAction:play()

    return flyTime
end

----------------------------------------------------------------------------------------
--base
----------------------------------------------------------------------------------------
function doushisiOperation:callFunctionAfterTime(time, func)
    local delay = self:getDelayAction(time)
    local func = tweenFunction.new(func)
    local se = self:getSequenceAction({delay, func})
    self.animationManager:add(se)
    se:play()
end
function doushisiOperation:getCenterFanPaiPos()
    local x, y = 0, 0
    return x, y + 0.1
end
function doushisiOperation:setNodeAtCenter(node)
    local cx, cy = self:getCenterFanPaiPos()
    node:show()
    node:setLocalPosition(Vector3.New(cx, cy, 0))
    node:setLocalRotation(Quaternion.Euler(0, 0, 90))
    node:setLocalScale(Vector3.New(0.1, 0.1, 0.1))
end
function doushisiOperation:getCenterScaleAction(node)
    local time = 0.05
    local action 
    if node then
        action = tweenScale.new(node, time, node:getLocalScale(), Vector3.one)
    end
    return action, time
end
function doushisiOperation:getSequenceAction(actions)
    local t = tweenSerial.new(true)
    for _, a in pairs(actions) do
        t:add(a)
    end
    return t
end
function doushisiOperation:getDelayAction(delayTime)
    return tweenDelay.new(delayTime)
end
function doushisiOperation:getShakeAction(node)
    local smax = 1.2
    local sNormal = 1
    local t = self.shakepaitime
    local aMax = tweenScale.new(node, t / 2, Vector3.one, Vector3.New(1.2, 1.2, 1.2))
    local aNormal = tweenScale.new(node, t / 2, Vector3.New(1.2, 1.2, 1.2), Vector3.one)
    local action = tweenSerial.new(true)
    action:add(aMax)
    action:add(aNormal)
    return action, t
end
function doushisiOperation:popFlyNode()
    local node = self.idleFlyNodes[1]
    if not node then
        node = GameObject("flynode")
        local base = require("common.object")
        node = base.new(node)
        node:setParent(self.cardRoot)
        table.insert(self.flyNodes, node)
        self:pushFlyNode(node)
    end
    table.remove(self.idleFlyNodes, 1)
    node.cards = nil
    return node
end
function doushisiOperation:pushFlyNode(node)
    node:hide()
    if node.cards then
        for _, card in pairs(node.cards) do
            self:pushbackActionCard(card)
        end
    end
    node.cards = nil
    node:setLocalRotation(Quaternion.Euler(0, 0, 0))
    node:setLocalScale(Vector3.one)
    for _, t in pairs(self.idleFlyNodes) do
        if t == node then
            printError("repush back node.")
        end
    end
    table.insert(self.idleFlyNodes, node)
end
function doushisiOperation:createFlyNode(ids)
    local cards = {}
    local poses = {}
    local cnt = #ids
    local dis = (cnt - 1) * actionCardGap
    local sy = dis / cnt

    local node = self:popFlyNode()
    for _, id in pairs(ids) do
        local card = self:getActionCardById(id)
        self:addCardTo(card, Vector3.New(0, sy, 0), nil, doushisiGame.cardType.perfect, Vector3.zero, Vector3.one, node)
        table.insert(cards, card)
        sy = sy - actionCardGap
    end
    node.cards = cards
    return node
end
function doushisiOperation:computeFlyTime(x1, y1, x2, y2) 
    local d1 = math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2)
    local dis = math.sqrt(d1)
    local speed = 13.00 --pixels per second
    local time = dis / speed
    if time < 0.25 then
        time = 0.25
    end
    return time
end
function doushisiOperation:getFlyAction(node, x1, y1, x2, y2, r2, s2, r1, s1)
    local flyTime = self:computeFlyTime(x1, y1, x2, y2)

    local mvaction = tweenPosition.new(node, flyTime, Vector3.New(x1, y1, 0), Vector3.New(x2, y2, 0))
    local actions = {}
    if r2 then
        local rotation = node.transform.localEulerAngles
        if r1 then
            rotation = Vector3.New(0, 0, r1)
        end
        local raction = tweenRotation.new(node, flyTime, rotation, Vector3.New(0, 0, r2))
        table.insert(actions, raction)
    end
    if s2 then
        local scale = node:getLocalScale()
        if s1 then
            scale = Vector3.New(s1, s1, scale.z)
        end
        local saction = tweenScale.new(node, flyTime, scale, Vector3.New(s2, s2, scale.z))
        table.insert(actions, saction)
    end 
    if #actions > 0 then
        table.insert(actions, 1, mvaction)
        local tp = tweenParallel.new(true)
        for _, ac in pairs(actions) do
            tp:add(ac)
        end
        return tp, flyTime
    else
        return mvaction, flyTime
    end
end

function doushisiOperation:onCloseAllUIHandler()
    self:close()
end

---------------------------------------------------------------------------------------------------
--playback
---------------------------------------------------------------------------------------------------
function doushisiOperation:relocateOtherInhandCards(acId)
    if not self.game:isPlayback() then
        return
    end
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.inhandCards[acId]

    table.bubbleSort(cards, function(t1, t2)
        return t1.id <= t2.id
    end)

    local st = self.game:getSeatTypeByAcId(acId)
    local startPos = self.seats[st][doushisiGame.cardType.shou].pos
    for idx, card in pairs(cards) do
        local pos = card:getLocalPosition()
        local pos, rot = self:computeOtherInhandPos(st, startPos.x, startPos.y, idx, pos)
        self:addCardTo(card, pos, st, doushisiGame.cardType.peng, rot, nil, nil)
    end
end
function doushisiOperation:computeOtherInhandPos(st, sx, sy, idx, pos)
    local cfg = self.seats[st][doushisiGame.cardType.shou]
    local row = 0
    local rowMax = 10
    if idx > 10 then
        row = 1
    end
    local col = (idx - 1) % 10
    local rsx = sx + row * cfg.rowDir.x * cfg.rowgap
    local rsy = sy + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

return doushisiOperation
