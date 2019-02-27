--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local doushisiGame = require("logic.doushisi.doushisiGame")
local header = require("ui.doushisiDesk.doushisiDeskHeader")
local doushisiGame = require("logic.doushisi.doushisiGame")

local base = require("ui.desk")
local doushisiDesk = class("doushisiDesk", base)

_RES_(doushisiDesk, "DoushisiDeskUI", "DeskUI")

local gfxConfig = {
    [opType.doushisi.an] = {
        default = "an",
    },
    [opType.doushisi.baGang] = {
        default = "gang",
    },
    [opType.doushisi.bao] = {
        default = "bao",
    },
    [opType.doushisi.baoJiao] = {
        default = "baojiao",
    },
    [opType.doushisi.caiShen] = {
        default = "caishen",
    },
    [opType.doushisi.che] = {
        default = "che",
    },
    [opType.doushisi.chi] = {
        default = "chi",
    },
    [opType.doushisi.chiChengSan] = {
        default = "chichengsan",
    },
    [opType.doushisi.dang] = {
        default = "dang",
    },
    [opType.doushisi.gang] = {
        default = "gang",
    },
    [opType.doushisi.gen] = {
        default = "gen",
    },
    [opType.doushisi.hu] = {
        default = "hu",
    },
    [opType.doushisi.hua] = {
        default = "hua",
    },
    [opType.doushisi.shou] = {
        default = "shou",
    },
    [opType.doushisi.weiGui] = {
        default = "weigui",
    },
    [opType.doushisi.zhao] = {
        default = "zhao",
    },
}

local COUNTDOWN_SECONDS_C = 20

local clockPosition = {
    [seatType.mine]  = Vector3.New(0, 125, 0), 
    [seatType.right] = Vector3.New(-250, -125, 0), 
    [seatType.top]   = Vector3.New(120, -125, 0), 
    [seatType.left]  = Vector3.New(259, -125, 0),
}

function doushisiDesk:ctor(game)
    base.game = game
    base.ctor(self)
end

function doushisiDesk:onInit()
    self.headerParents = {
        [seatType.mine]  = self.mPlayerM, 
        [seatType.right] = self.mPlayerR, 
        [seatType.top]   = self.mPlayerT, 
        [seatType.left]  = self.mPlayerL, 
    }

    self.headers = {}

    for k, v in pairs(self.headerParents) do
        self.headers[k] = header.new(k)
        self.headers[k]:setParent(v)
        self.headers[k]:show()
    end

    self:hideClock()

    base.onInit(self)
end

function doushisiDesk:onFaPai()
    if self.game.deskPlayStatus == doushisiGame.deskPlayStatus.piao then
        --定漂中
    elseif self.game.deskPlayStatus == doushisiGame.deskPlayStatus.tuiDang or self.game.deskPlayStatus == doushisiGame.deskPlayStatus.playing or self.game.deskPlayStatus == doushisiGame.deskPlayStatus.touPai then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    end
end

function doushisiDesk:onMoPai(acId)
    local st = self.game:getSeatTypeByAcId(acId)
    self:showClock(st)
end

function doushisiDesk:onFanPai(acId)
    local st = self.game:getSeatTypeByAcId(acId)
    self:showClock(st)
end

function doushisiDesk:onDeskStatusChanged()
    if self.game.deskPlayStatus == doushisiGame.deskPlayStatus.playing then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    end
end

function doushisiDesk:onPlayerGfx(acId, opid)
    local st = self.game:getSeatTypeByAcId(acId)
    local hd = self.headers[st]

    local opc = gfxConfig[opid]
    local gfx = opc[self.game.cityType] or opc.default

    hd:playGfx(gfx)
end

function doushisiDesk:onOpDoChu(acId, cards)
end

function doushisiDesk:setDang(acId, dang)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if dang then
        header:showDang()
    else
        header:hideDang()
    end
end

function doushisiDesk:setPiao(acId, piao)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if piao then
        header:showPiao()
    else
        header:hidePiao()
    end
end

function doushisiDesk:setZhuang(acId, zhuang)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if zhuang then
        header:showZhuang()
    else
        header:hideZhuang()
    end
end

function doushisiDesk:setXiao(acId, xiao)
    local header = self:getHeaderByAcId(acId)
    if xiao then
        header:showXiao()
    else
        header:hideXiao()
    end
end

function doushisiDesk:setBao(acId, bao)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if bao then
        header:showBao()
    else
        header:hideBao()
    end
end

function doushisiDesk:createSettingUI()
    return require("ui.setting.doushisiSetting").new(self.game)
end

function doushisiDesk:showClock(seat)
    self.mClock:setParent(self.headerParents[seat])
    self.mClock:setLocalPosition(clockPosition[seat])
    self.countdown = COUNTDOWN_SECONDS_C
    self.mClockText:setText(tostring(self.countdown))
    self.mClock:show()
end

function doushisiDesk:hideClock()
    self.mClock:hide()
end

function doushisiDesk:updateClock()
    if not self.mClock:getVisibled() then
        return 
    end

    local now = time.realtimeSinceStartup()

    if now - self.updateTimestamp >= 1.0 then
        self.countdown = math.max(0, self.countdown - 1)
        self.mClockText:setText(tostring(self.countdown))

        if self.countdown > 0 and self.countdown <= 5 then
            --playClockTimerSound()
        end
    end
end

function doushisiDesk:update()
    self:updateClock()
    base.update(self)
end

function doushisiDesk:onDestroy()
    self:unregisterHandlers()

    for _, v in pairs(self.headers) do
        v:close()
    end
    self.headers = {}

    base.onDestroy(self)
end

function doushisiDesk:onGameStart()
    base.onGameStart(self)
    self:syncHeadInfo()

    if self.game.deskPlayStatus == doushisiGame.deskPlayStatus.piao then
        --定漂中
    elseif self.game.deskPlayStatus == doushisiGame.deskPlayStatus.tuiDang or self.game.deskPlayStatus == doushisiGame.deskPlayStatus.playing or self.game.deskPlayStatus == doushisiGame.deskPlayStatus.touPai then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    end
end

function doushisiDesk:onGameSync()
    base.onGameSync(self)

    local reenter = self.game.data.Reenter
    self:syncHeadInfo()

    local st = self.game:getSeatTypeByAcId(self.game.curOpAcId)
    self:showClock(st)
end

function doushisiDesk:syncHeadInfo()
    for _, p in pairs(self.game.players) do
        self:setDang(p.acId, p.isDang)
        self:setBao(p.acId, p.isBao)
        self:setPiao(p.acId, p.isPiao)
        self:setZhuang(p.acId, p.isMarker)
        self:setXiao(p.acId, p.isXiao)
        local st = self.game:getSeatTypeByAcId(p.acId)
        local header = self.headers[st]
        header:setFuShu(p.fuShu)
        header:setCount(p.zhangShu)
    end
end

function doushisiDesk:setFuShu(acId, fuShu)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    header:setFuShu(fuShu)
end

function doushisiDesk:updateInhandCardCount(acId)
    local p = self.game:getPlayerByAcId(acId)
    local st = self.game:getSeatTypeByAcId(p.acId)
    local header = self.headers[st]
    header:setCount(p.zhangShu)
end

function doushisiDesk:onDangNotifyHandler(acId, dang)
    self:onOpDoDang(acId, dang)
    self:setDang(acId, dang)

    if dang then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    else
        local st = self.game:getSeatTypeByAcId(acId)
        local nextPlayerSeatType = self:getNextSeat(st)
        self:showClock(nextPlayerSeatType)
    end

    return 0.7
end

function doushisiDesk:getNextSeat(st)
    local nt = st
    for i = 1, 4 do
        nt = (nt + 1) % 4
        if self.headers[nt] then
            return nt
        end
    end
    return nt
end

function doushisiDesk:getHeaderByAcId(acId)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    return header
end

local withoutCPZTContrl = {
    hu          = true,
    zuozhuang   = true,
    dang        = true,
    budang      = true,
    huazhuang   = true,
    weigui      = true,
}

function doushisiDesk:playGfx(acId, name)
    local header = self:getHeaderByAcId(acId)
    if not withoutCPZTContrl[name] and not gamepref.getChiPengZiTi() then
        return
    end
    header:playGfx(name)
end

function doushisiDesk:playSound(acId, optype)
    local player = self.game:getPlayerByAcId(acId)
    playDoushisiOpSound(self.game.cityType, optype, player.sex) 
end

function doushisiDesk:onOpList(msg)
    local mine = self.game:getSeatTypeByAcId(self.game.mainAcId)
    self:showClock(mine)
end

function doushisiDesk:onOpDoHu(acId)
    self:playGfx(acId, "hu")
    self:playSound(acId, opType.doushisi.hu)
end
function doushisiDesk:onOpDoDang(acId, isDang)
    if isDang then
        self:playGfx(acId, "dang")
        self:playSound(acId, opType.doushisi.dang)
    else
        self:playGfx(acId, "budang")
        self:playSound(acId, opType.doushisi.budang)
    end
end
function doushisiDesk:onOpDoChe(acId)
    self:playGfx(acId, "peng")
    self:playSound(acId, opType.doushisi.che)
end
function doushisiDesk:onOpDoChi(acId)
    self:playGfx(acId, "chi")
    self:playSound(acId, opType.doushisi.chi)
end
function doushisiDesk:onOpDoAn(acId)
    self:playGfx(acId, "an")
    self:playSound(acId, opType.doushisi.an)
end
function doushisiDesk:onOpDoHua(acId)
    self:playGfx(acId, "hua")
    self:playSound(acId, opType.doushisi.hua)
end
function doushisiDesk:onOpDoBaGang(acId)
    self:playGfx(acId, "deng")
    self:playSound(acId, opType.doushisi.baGang)
end
function doushisiDesk:onOpDoBao(acId)
    self:playGfx(acId, "bao")
    self:playSound(acId, opType.doushisi.bao)
end
function doushisiDesk:onOpDoWeiGui(acId)
    self:playGfx(acId, "weigui")
    self:playSound(acId, opType.doushisi.weiGui)
end

return doushisiDesk

--endregion
