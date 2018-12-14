local doushisiGame  = require("logic.doushisi.doushisiGame")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local dssOperation = class("dssOperation", base)
local doushisi = require("logic.doushisi.doushisi")
local doushisiType = require("logic.doushisi.doushisiType")

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
    position = Vector3.New(1000, 0, -1343),
    rotation = Quaternion.Euler(0, 0, 0),
}

dssOperation.seats = {
    [seatType.mine] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -249, -353, 0), rot = Quaternion.Euler(0, 0, 0), w = 72, h = 214, hgap = 50 },
    },
    [seatType.right] = { 
    },
    [seatType.top] = { 
    },
    [seatType.left] = { 
    },
}

function dssOperation:onInit()
    --初始化主相机
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation

    self.cardRoot = find("changpai/changpai_root")
    self.allCards = {}
    self.idleCards = {}
    self.style = doushisiStyle.traditional
    
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

    self:reset()
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
    self:initInhandCards()
end

function dssOperation:onFaPai()
end

function dssOperation:onGameStart()
end
---------------------------------------------------------------
--当
---------------------------------------------------------------
function dssOperation:onDangHandler()
    self:hideAllOpBtn()
    self:showOpBtn(self.mBuDang)
    self:showOpBtn(self.mDang)
end
function dssOperation:onDangClickedHandler()
    networkManager.csDang(true)
end
function dssOperation:onBuDangClickedHandler()
    networkManager.csDang(false)
end

function dssOperation:onOpList(opList)
    if opList == nil then
        return
    end
    self:hideAllOpBtn()
    local leftTime = opList.LeftTime

    for _, opInfo in pairs(opList.OpInfos) do
        local op = opInfo.Op
        if opInfo.HasTy == nil then
            opInfo.HasTy = {}
        end
        if op == opType.dss.hua then
            self:onOpListHua(opInfo)
        elseif op == opType.dss.chu then
            self:onOpListChu(opInfo)
        elseif op == opType.dss.chi then
            self:onOpListChi(opInfo)
        elseif op == opType.dss.che then
            self:onOpListChe(opInfo)
        elseif op == opType.dss.hu then
            self:onOpListHu(opInfo)
        elseif op == opType.dss.gang then
        elseif op == opType.dss.pass then
        elseif op == opType.dss.an then
            self:onOpListAn(opInfo)
        elseif op == opType.dss.zhao then
        elseif op == opType.dss.shou then
        elseif op == opType.dss.bao then
        elseif op == opType.dss.baGang then
            self:onOpListBaGang(opInfo)
        elseif op == opType.dss.chiChengSan then
            --self:onOpListChiChengSan(opInfo)
        elseif op == opType.dss.caiShen then
            self:onOpListCaiShen(opInfo)
        elseif op == opType.dss.baoJiao then
        elseif op == opType.dss.gen then
        elseif op == opType.dss.weiGui then
        else
            log("on op do handler: receive not supported handler." .. tostring(op))
        end
    end
    self:relocateOpBtn()
end

function dssOperation:showOpBtn(btn, opInfo)
    btn:show()
    btn.opInfo = opInfo
    table.insert(self.curShowOpBtns, btn)
end

function dssOperation:relocateOpBtn()
end

-----------------------------------------------------------
--chu
-----------------------------------------------------------
function dssOperation:onOpListChu(opInfo)
end

-----------------------------------------------------------
--hua
-----------------------------------------------------------
function dssOperation:onOpListHua(opInfo)
    self:showOpBtn(self.mHua, opInfo)
end
function dssOperation:onHuaClickedHandler()
    local chianSelPanel = require ("ui.dssDesk.dssDeskOperation")
    local panel = chianSelPanel.newAnSelPanel(self.mChi.opInfo, function()
        self:onHuaChose(info)
    end)
    self.mHua.panel = panel
    panel:setParent(self.mHua)
end
function dssOperation:onHuaChose(info)
    local data = self:getOpChoseData(opType.dss.hua, info.Cards[1], info.HasTy[1], nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoHua()
end

-----------------------------------------------------------
--chi
-----------------------------------------------------------
function dssOperation:onOpListChi(opInfo)
    self:showOpBtn(self.mChi, opInfo)
end
function dssOperation:onChiClickedHandler()
    local chianSelPanel = require ("ui.dssDesk.dssDeskOperation")
    local panel = chianSelPanel.newChiSelPanel(self.mChi.opInfo, function()
        self:onChiChose(info)
    end)
    self.mChi.panel = panel
    panel:setParent(self.mChi)
end
function dssOperation:onChiChose(info)
    local data = self:getOpChoseData(opType.dss.chi, info.c, info.hasTy, nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoChi()
end

-----------------------------------------------------------
--che
-----------------------------------------------------------
function dssOperation:onOpListChe(opInfo)
    self:showOpBtn(self.mChe, opInfo)
end
function dssOperation:onCheClickedHandler()
    local info = self.mChe.opInfo
    local data = self:getOpChoseData(opType.dss.che, info.Cards[1], info.HasTy[1], nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoChe()
end

-----------------------------------------------------------
--hu
-----------------------------------------------------------
function dssOperation:onOpListHu(opInfo)
    self:showOpBtn(self.mHu, opInfo)
end
function dssOperation:onHuClickedHandler()
    local data = self:getOpChoseData(opType.dss.hu)
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
    local chianSelPanel = require ("ui.dssDesk.dssDeskOperation")
    local panel = chianSelPanel.newAnSelPanel(self.mChi.opInfo, function()
        self:onAnChose(info)
    end)
    self.mAn.panel = panel
    panel:setParent(self.mAn)
end
function dssOperation:onAnChose(info)
    local sendData = { Chooses={} }
    local item = {Card = info.c, Num = 3}
    if info.hasTy then
        item.Num = 4
    end
    networkManager.csAnPai(sendData)
end
function dssOperation:onOpDoAn()
end

-----------------------------------------------------------
--ba gang
-----------------------------------------------------------
function dssOperation:onOpListBaGang(opInfo)
    self:showOpBtn(self.mAn, opInfo)
end
function dssOperation:onDengClickedHandler()
    local chianSelPanel = require ("ui.dssDesk.dssDeskOperation")
    local panel = chianSelPanel.newBaGangSelPanel(self.mDeng.opInfo, function()
        self:onBaGangChose(info)
    end)
    self.mDeng.panel = panel
    panel:setParent(self.mDeng)
end
function dssOperation:onBaGangChose(info)
    local data = self:getOpChoseData(opType.dss.baGang, info.c, info.hasTy, nil)
    networkManager.csOpChose(data)
end
function dssOperation:onOpDoBaGang()
end

function dssOperation:getOpChoseData(op, card, hasTy, baos)
    local data = {
        Op = op,
        ChoseCard = card,
        HasTy = hasTy,
        BaoTypes = baos,
    }
    return data
end

function dssOperation:reset()
    self:hideAllOpBtn()
    self:closeAllBtnPanel()

    self.idleCards = {}
    for _, card in pairs(self.allCards) do
        card:hide()
        table.insert(self.idleCards, card)
    end
    self.inhandCards = { [seatType.mine] = {}, [seatType.left] = {}, [seatType.right] = {}, [seatType.top] = {} }
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

function dssOperation:addCardTo(card, pos, seatType, cardType)
    card:setStyle(self.style)
    card:setType(cardType)
    card:fix()
    --get rot by cardtype and seattype
    local cfg = self.seats[seatType][cardType]
    card:setLocalPosition(pos)
    card:setParent(self.cardRoot)
    card:show()
end

function dssOperation:initInhandCards()
    for _, player in pairs(self.game.players) do
        local seatType = self.game:getSeatTypeByAcId(player.acId)
        local cards = self.inhandCards[seatType]
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
    local cards = self.inhandCards[seatType]
    self.meSortedInhandCards = self:sortInhandCards(cards)

    local startPos = self:getInhandCardStartPos(seatType)
    for col, cards in pairs(self.meSortedInhandCards) do
        for row, card in pairs(cards) do
            local pos = card:getLocalPosition()
            pos = self:getInhandCardPos(startPos, seatType, col, row, pos, #cards)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.shou)
            self:topNode(node)
        end
    end
end

function dssOperation:topNode(node)
end

function dssOperation:getInhandCardPos(startPos, seatType, col, row, pos, rowHeight)
    local cfg = self.seats[seatType][doushisiGame.cardType.shou]
    local diffx = cfg.w * (col - 1)
    local diffy = cfg.hgap * (rowHeight - row)
    pos.x = startPos.x + diffx
    pos.y = startPos.y + diffy
    return pos
end

function dssOperation:getInhandCardStartPos(st)
    if st ~= seatType.mine then
        return Vector3.zero
    else
        return self.seats[st][doushisiGame.cardType.shou].pos
    end
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
