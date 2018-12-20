--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local doushisiGame = require("logic.doushisi.doushisiGame")
local header = require("ui.doushisiDesk.doushisiDeskHeader")

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
    [seatType.top]   = Vector3.New(0, -125, 0), 
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

function doushisiDesk:onGameStart()
    base.onGameStart(self)

    if self.deskStatus == doushisiGame.deskPlayStatus.piao then
        --定漂中
    elseif self.deskStatus == doushisiGame.deskPlayStatus.tuiDang or self.deskStatus == doushisiGame.deskPlayStatus.playing or self.deskStatus == doushisiGame.deskPlayStatus.touPai then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    end
end

function doushisiDesk:onGameSync()
    base.onGameSync(self)

    local st = self.game:getSeatTypeByAcId(self.game.curOpAcId)
    self:showClock(st)
end

function doushisiDesk:onFaPai()
    if self.deskStatus == doushisiGame.deskPlayStatus.piao then
        --定漂中
    elseif self.deskStatus == doushisiGame.deskPlayStatus.tuiDang or self.deskStatus == doushisiGame.deskPlayStatus.playing then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    end
end

function doushisiDesk:onDangNotify(acId, isDang)
    if isDang then
        local markerPlayer = self.game:getMarkerPlayer()
        local markerSeatType = self.game:getSeatTypeByAcId(markerPlayer.acId)
        self:showClock(markerSeatType)
    else
        local player = self.game:getPlayerByAcId(acId)
        local nextPlayerSeatType = (player.seatType + 1) % 4
        self:showClock(nextPlayerSeatType)
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
    log("doushisiDesk:onDeskStatusChanged  status = " .. tostring(self.game.deskStatus))
    if self.game.deskStatus == doushisiGame.deskPlayStatus.playing then
        log("doushisiDesk:onDeskStatusChanged  2222")
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
            --播放倒计时音效
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

return doushisiDesk

--endregion
