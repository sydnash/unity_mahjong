local doushisiGame  = require("logic.doushisi.doushisiGame")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local dssOperation = class("dssOperation", base)

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
    }
}

local mainCameraParams = {
    position = Vector3.New(1000, 0, -13.43),
    rotation = Quaternion.Euler(0, 0, 0),
}
function dssOperation:onInit()
    --初始化主相机
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
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
end

return dssOperation
