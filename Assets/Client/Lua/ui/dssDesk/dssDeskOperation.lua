local doushisiGame  = require("logic.doushisi.doushisiGame")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local dssOperation = class("dssOperation", base)
local doushisi = require("logic.doushisi.doushisi")
local doushisiType = require("logic.doushisi.doushisiType")
local touch         = require("logic.touch")

_RES_(dssOperation, "DssDeskUI", "DssOperationUI")

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function dssOperation:ctor(game)
    self.game = game
    self.super.ctor(self)
end

local btnIconConfig = {
    mHuaIcon = {
        default = "hua",
        [cityType.jintang] = an,
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
}
local inhandCameraParams = {
    position = Vector3.New(1000, 0, -0.9),
    size = 3.6
}

dssOperation.seats = {
    [seatType.mine] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -2.49, -5.04, 0), rot = Quaternion.Euler(0, 0, 0), rowgap = 0.72, colgap = 0.50, height = 2.14},
        [doushisiGame.cardType.chu] = { pos = Vector3.New(3.80, -1.32, 0), rot = Quaternion.Euler(0, 0, 225), 
                    colDir = {x = math.cos(135*math.pi/180), y = math.sin(135*math.pi/180)},
                    rowDir = {x = math.cos(45 * math.pi/180),y = math.sin(45 * math.pi/180)},
                    rowgap = 0.50, colgap = 0.34,
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-0.76, -1.53, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = 1},
                    rowgap = 0.50,  colgap = 0.34,
                },
        promote = {pos = Vector3.New(-0.36, -0.55, 0), rot = Quaternion.Euler(0, 0, 0), },
    },
    [seatType.right] = { 
        [doushisiGame.cardType.chu] = { pos = Vector3.New(3.22, 2.04, 0), rot = Quaternion.Euler(0, 0, -35), 
                    colDir = {x = math.cos(-125*math.pi/180), y = math.sin(-125*math.pi/180)},
                    rowDir = {x = math.cos(-35 * math.pi/180), y = math.sin(-35 * math.pi/180)},
                    rowgap = 0.50, colgap = 0.34,
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(4.90, 1.32, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.50,  colgap = 0.34,
                },
        promote = {pos = Vector3.New(3.58, -0.39, 0), rot = Quaternion.Euler(0, 0, 0), },
    },
    [seatType.top] = { 
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -4.49, -1.84, 0), rot = Quaternion.Euler(0, 0, 35),
                    colDir = {x = math.cos(-55*math.pi/180), y = math.sin(-55*math.pi/180)},
                    rowDir = {x = math.cos(125 * math.pi/180), y = math.sin(125 * math.pi/180)},
                    rowgap = 0.50, colgap = 0.34,
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(3.80, -1.32, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.50,  colgap = 0.34,
                },
        promote = {pos = Vector3.New(1.10, 1.09, 0), rot = Quaternion.Euler(0, 0, 90), },
    },
    [seatType.left] = { 
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -4.58, -2.67, 0), rot = Quaternion.Euler(0, 0, 135),
                    colDir = {x = math.cos(45*math.pi/180), y = math.sin(45*math.pi/180)},
                    rowDir = {x = math.cos(135 * math.pi/180), y = math.sin(135 * math.pi/180)},
                    rowgap = 0.50, colgap = 0.34,
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-4.90, 1.32, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.50,  colgap = 0.34,
                },
        promote = {pos = Vector3.New(-3.97, -0.39, 0), rot = Quaternion.Euler(0, 0, 0), },
    },
}

function dssOperation:onInit()
    --初始化主相机
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size

    self.cardRoot = find("changpai/changpai_root")
    self.allCards = {}
    self.idleCards = {}
    self.allActionCards = {}
    self.idleActionCards = {}
    self.style = doushisiStyle.traditional
    self.canChuPai = false
    self.dragCard = doushisi.new(0)
    self.dragCard:setLocalScale(Vector3.New(1.2, 1.2, 1.2))
    self.dragCard:setPickabled(true)
    self.dragCard:setColliderEnabled(false)
    self.sortOrder = 0
    
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

    self:reset()
end

function dssOperation:computeChuPaiHintPos()
    local cfg = self.seats[seatType.mine][doushisiGame.cardType.shou]
    local pos = cfg.pos:Clone()
    local cardLen = cfg.height
    
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

function dssOperation:hideAllOpBtn()
    for _, btn in pairs(self.opBtns) do
        btn:hide()
    end
    self.curShowOpBtns = {}
end

function dssOperation:closeAllBtnPanel()
    for _, btn in pairs(self.opBtns) do
        if btn.panel then
            btn.panel:close()
            btn.pnel = nil
        end
    end
end

function dssOperation:onGameSync()
    self:reset()
    touch.addListener(self.touchHandler, self)

    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
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
        if reenter.CurDiPai >= 0 then
            self:promoteChuFan(self.game.curOpAcId, reenter.CurDiPai)
        end
    end
end

function dssOperation:onFaPai()
    self:resetPai()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
end

function dssOperation:onGameStart()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
    touch.addListener(self.touchHandler, self)
end
---------------------------------------------------------------
--当
---------------------------------------------------------------
function dssOperation:onDangHandler(isMustDang)
    self:hideAllOpBtn()
    self:showOpBtn(self.mDang)
    if not isMustDang then
        self:showOpBtn(self.mBuDang)
    end
end
function dssOperation:onDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(true)
end
function dssOperation:onBuDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(false)
end

function dssOperation:onOpList(opList)
    if opList == nil then
        return
    end
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local leftTime = opList.LeftTime

    for _, opInfo in pairs(opList.OpInfos) do
        local op = opInfo.Op
        if opInfo.HasTY == nil then
            opInfo.HasTY = {}
        end
        if opInfo.HasWarning == nil then
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

function dssOperation:onOpListPass()
    self:showOpBtn(self.mPass)
end

function dssOperation:showOpBtn(btn, opInfo)
    btn:show()
    btn.opInfo = opInfo
    table.insert(self.curShowOpBtns, btn)
end

function dssOperation:relocateOpBtn()
end

function dssOperation:onPassClickedHandler()
    local sendData = self:getOpChoseData(opType.doushisi.pass.id)
    networkManager.csOpChose(sendData)
end

function dssOperation:showChuHint()
    self.mChuHint:show()
    self.mLine.action = tweenForever.new({
            tweenColor.fadeOut(self.mLine, 0.5),
            tweenColor.fadeIn(self.mLine, 0.5),
        })

    local from  = Vector3.New(0, 0, 45)
    local to    = Vector3.New(0, 0, 1)
    self.mFinger.action = tweenForever.new({
        tweenRotation.new(self.mFinger, 0.5, from, to, nil),
        tweenRotation.new(self.mFinger, 0.5, to, from, nil),
    })
    tweenManager.add(self.mLine.action)
    tweenManager.add(self.mFinger.action)

    self.mLine.action:play()
    self.mFinger.action:play()
end
function dssOperation:hideChuHint()
    tweenManager.remove(self.mLine.action)
    tweenManager.remove(self.mFinger.action)
    self.mChuHint:hide()
end

function dssOperation:enableChu()
    self.canChuPai = true
    self:showChuHint()
end
function dssOperation:disableChu()
    self.canChuPai = false
    self:hideChuHint()
end
-----------------------------------------------------------
--chu
-----------------------------------------------------------
function dssOperation:onOpListChu(opInfo)
    self:enableChu()
end
function dssOperation:onOpDoChu(acId, id)
    self:disableChu()

    local card = self:findAndRemoveCard(acId, id)
    self:addCardToChu(acId, card)

    self:removePromoteChuFan()
    self:promoteChuFan(acId, id)
end

function dssOperation:opDoChiPengAnHua(acId, delIds, beId, op)
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
end
-----------------------------------------------------------
--hua
-----------------------------------------------------------
function dssOperation:onOpListHua(opInfo)
    self:showOpBtn(self.mHua, opInfo)
end
function dssOperation:onHuaClickedHandler()
    self:onPanelBtnClick(self.mHua, function(Class)
        return Class.newAnSelPanel(self.mHua.opInfo, function(info)
            self:onHuaChose(info)
        end)
    end)
end
function dssOperation:onHuaChose(info)
    local data = self:getOpChoseData(opType.doushisi.hua.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoHua(acId, delIds)
    self:opDoChiPengAnHua(acId, delIds, nil, opType.doushisi.hua.id)
end

-----------------------------------------------------------
--chi
-----------------------------------------------------------
function dssOperation:onOpListChi(opInfo)
    self:showOpBtn(self.mChi, opInfo)
end
function dssOperation:onChiClickedHandler()
    self:onPanelBtnClick(self.mChi, function(Class)
        return Class.newChiSelPanel(self.mChi.opInfo, function(info)
            self:onChiChose(info)
        end)
    end)
end
function dssOperation:onChiChose(info)
    local data = self:getOpChoseData(opType.doushisi.chi.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoChi(acId, delIds, beId)
    self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.chi.id)
end

-----------------------------------------------------------
--che
-----------------------------------------------------------
function dssOperation:onOpListChe(opInfo)
    self:showOpBtn(self.mChe, opInfo)
end
function dssOperation:onCheClickedHandler()
    local info = self.mChe.opInfo
    local data = self:getOpChoseData(opType.doushisi.che.id, info.Cards[1], info.HasTY[1], nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoChe(acId, delIds, beId)
    self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.che.id)
end

-----------------------------------------------------------
--hu
-----------------------------------------------------------
function dssOperation:onOpListHu(opInfo)
    self:showOpBtn(self.mHu, opInfo)
end
function dssOperation:onHuClickedHandler()
    local data = self:getOpChoseData(opType.doushisi.hu.id)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoHu()
end

-----------------------------------------------------------
--an
-----------------------------------------------------------
function dssOperation:onOpListAn(opInfo)
    self:showOpBtn(self.mAn, opInfo)
end
function dssOperation:onAnClickedHandler()
    self:onPanelBtnClick(self.mAn, function(Class)
        return Class.newAnSelPanel(self.mAn.opInfo, function(info)
            self:onAnChose(info)
        end)
    end)
end
function dssOperation:onAnChose(info)
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
function dssOperation:onOpDoAn(acId, delIds)
    self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.an.id)
end

-----------------------------------------------------------
--ba gang
-----------------------------------------------------------
function dssOperation:onOpListBaGang(opInfo)
    self:showOpBtn(self.mDeng, opInfo)
end
function dssOperation:onDengClickedHandler()
    self:onPanelBtnClick(self.mDeng, function(Class)
        return Class.newBaGangSelPanel(self.mDeng.opInfo, function(info)
            self:onBaGangChose(info)
        end)
    end)
end
function dssOperation:onBaGangChose(info)
    local data = self:getOpChoseData(opType.doushisi.baGang.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoBaGang(acId, id)
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
end

-----------------------------------------------------------
--cai shen
-----------------------------------------------------------
function dssOperation:onOpListCaiShen(info)
end
function dssOperation:onOpDoCaiShen(acId, id)
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
end

function dssOperation:onPanelBtnClick(btn, createFunc)
    if btn.panel then
        btn.panel:close()
        btn.panel = nil
        return
    end
    self:closeAllBtnPanel()
    local PanelClass = require ("ui.dssDesk.chiAnSelPanel")
    local panel = createFunc(PanelClass)
    btn.panel = panel
    panel:show()
    panel:setParent(btn)
    panel:setLocalPosition(Vector3.New(0, 0, 0))
end

function dssOperation:getOpChoseData(op, card, hasTY, baos)
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

function dssOperation:reset()
    touch.removeListener()
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    self:disableChu()

    self:resetPai()
end

function dssOperation:resetPai()
    self:computeChuPaiHintPos()
    self.dragCard:hide()
    self.idleCards = {}
    for _, card in pairs(self.allCards) do
        card:hide()
        card:setSelected(false)
        card:setPickabled(false)
        table.insert(self.idleCards, card)
    end
    self.idleActionCards = {}
    for _, card in pairs(self.allActionCards) do
        card:hide()
        table.insert(self.idleActionCards, card)
    end
    self.inhandCards = {}
    self.chuCards = {}
    self.chipengCards = {}
end

function dssOperation:getCardById(id)
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

function dssOperation:getActionCardById(id)
    local card
    if #self.idleActionCards > 0 then
        card = self.idleActionCards[#self.idleActionCards]
        table.remove(self.idleActionCards, #self.idleActionCards)
    else
        card = doushisi.new(id)
        table.insert(self.allActionCards, card)
    end
    card:hide()
    card:setId(id)
    return card
end

function dssOperation:pushbackActionCard(card)
    card:hide()
    table.insert(self.idleActionCards, card)
end

function dssOperation:promoteChuFan(acId, id)
    local card = self:getActionCardById(id)
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote

    self:addCardTo(card, cfg.pos, st, doushisiGame.cardType.perfect, cfg.rot)
    self.promoteCard = card
    self.promoteCard.acId = acId
end

function dssOperation:removePromoteChuFan()
    if not self.promoteCard then
        return
    end
    self:pushbackActionCard(self.promoteCard)
    self.promoteCard = nil
end

function dssOperation:addCardTo(card, pos, seatType, cardType, rot)
    pos.z = 0
    card:setParent(self.cardRoot)
    card:setSelected(false)
    card:setStyle(self.style)
    card:setType(cardType)
    card:fix()
    card:setLocalPosition(pos)
    if rot then
        card:setRotation(rot)
    end
    card:show()
    self:topCard(card)
end

function dssOperation:onMoPai(acId, ids)
    for _, id in pairs(ids) do
        local card = self:getCardById(id)
        table.insert(self.inhandCards[acId], card)
    end
    self:relocateInhandCards(acId)
    return 2
end

function dssOperation:onFanPai(acId, id)
    local card = self:getCardById(id)
    table.insert(self.chuCards[acId], card)
    self:relocateChuCards(acId)

    self:removePromoteChuFan()
    self:promoteChuFan(acId, id)
    return 2
end

function dssOperation:onAnPaiShow(acId, idInfo)
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
    return 0
end

-----------------------------------------------------------
--chu cards op
-----------------------------------------------------------
function dssOperation:initChiPengCards()
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

function dssOperation:relocateChiPengCards(acId)
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

function dssOperation:getChiPengCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.peng].pos
end

function dssOperation:getChiPengCardPos(startPos, seatType, row, col, pos)
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
function dssOperation:initChuCards()
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

function dssOperation:addCardToChu(acId, card)
    local cards = self.chuCards[acId]
    table.insert(cards, card)
    self:relocateChuCards(acId)
end

function dssOperation:relocateChuCards(acId)
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

function dssOperation:getChuCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.chu].pos
end

function dssOperation:getChuCardPos(startPos, seatType, idx, pos)
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
function dssOperation:initInhandCards()
    for _, player in pairs(self.game.players) do
        self.inhandCards[player.acId] = {}
        local cards = self.inhandCards[player.acId]
        for _, id in pairs(player[doushisiGame.cardType.shou]) do
            local card = self:getCardById(id)
            table.insert(cards, card)
        end
        self:relocateInhandCards(player.acId)
    end
end

function dssOperation:relocateInhandCards(acId)
    if acId ~= self.game.mainAcId then
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
            pos = self:getInhandCardPos(startPos, seatType, col, row, pos, #cards)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.shou)
            pos.z = z
            card:setLocalPosition(pos)
            z = z - 0.00001
            card:setPickabled(true)
        end
    end
end

function dssOperation:getInhandCardPos(startPos, seatType, col, row, pos, rowHeight)
    local cfg = self.seats[seatType][doushisiGame.cardType.shou]
    local diffx = cfg.rowgap * (col - 1)
    local diffy = cfg.colgap * (rowHeight - row)
    pos.x = startPos.x + diffx
    pos.y = startPos.y + diffy
    return pos
end

----------------------------------------------------------------------------------
--找牌
----------------------------------------------------------------------------------
function dssOperation:findCardFromInhand(acId, id, remove)
    local card = nil
    local inhandCards = self.inhandCards[acId]
    if acId ~= self.game.mainAcId then
        if #inhandCards > 0 then
            local card = inhandCards[1]
            card:setId(id)
            if remove then
                table.remove(inhandCards, 1)
            end
            return card
        end
    end
    for idx, card in pairs(inhandCards) do
        if id == card.id then
            if remove then
                table.remove(inhandCards, idx)
                self:relocateInhandCards(acId)
            end
            return card
        end
    end
    return nil
end

function dssOperation:findCardFromChuPai(id, remove)
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

function dssOperation:findCard(acId, id, remove)
    local pai = self:findCardFromInhand(acId, id, remove)
    if pai == nil then
        pai = self:findCardFromChuPai(id, remove)
    end
    if pai == nil then
        pai = self:getCardById(id)
    end
    return pai
end
function dssOperation:findAndRemoveCard(acId, id)
    return self:findCard(acId, id, true)
end
----------------------------------------------------------------------------------
--touch
----------------------------------------------------------------------------------
function dssOperation:getInhandCardStartPos(st)
    if st ~= seatType.mine then
        return Vector3.zero
    else
        return self.seats[st][doushisiGame.cardType.shou].pos
    end
end

function dssOperation:topCard(card)
    card:setSortingOrder(self.sortOrder)
    self.sortOrder = self.sortOrder + 1
end

function dssOperation:onDestroy()
    self:reset()
    for _, card in pairs(self.allCards) do
        card:close()
    end
    self.super.onDestroy(self)
end

function dssOperation:getCardByGo(go)
    local cards = self.inhandCards[self.game.mainAcId]
    for _, c in pairs(cards) do
        if c.gameObject == go then
            return c
        end
    end
    return nil
end

function dssOperation:touchHandler(phase, pos)
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
            log("is click:   is can chu pai : " .. tostring(self.isClick) .. " " .. tostring(self.canChuPai))
            if self.isClick then
                if self.curSelectdCard.selected then
                    if self.canChuPai then
                        eslf:setSelected(false)
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

function dssOperation:onChoseChuPai(card)
    local id = card.id
    local sendData = self:getOpChoseData(opType.doushisi.chu.id, id, nil, nil)
    networkManager.csOpChose(sendData)
    self.canChuPai = false
end

---------------------------------------------------------
--排序
---------------------------------------------------------
function dssOperation:getCardType(card)
    return doushisiType.getDoushisiTypeId(card)
end

function dssOperation:getCardDescByType(idx)
    return doushisiType.getDoushisiTypeByTypeId(idx)
end

function dssOperation:adjustValue(value)
    if value <= 7 then 
        return value 
    end
    return 14 - value
end

function dssOperation:sortInhandCards(oripais)
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
    for i = 1, 23 do
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

return dssOperation
