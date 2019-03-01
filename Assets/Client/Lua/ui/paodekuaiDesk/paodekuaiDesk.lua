--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.paodekuaiDesk.paodekuaiDeskHeader")
local helper = require("logic.paodekuai.helper")

local base = require("ui.desk")
local paodekuaiDesk = class("paodekuaiDesk", base)

_RES_(paodekuaiDesk, "PaodekuaiDeskUI", "DeskUI")

local clockPosition = {
    [seatType.mine]  = Vector3.New( 0,    90,  0),
    [seatType.right] = Vector3.New(-170, -24,  0),
    [seatType.top]   = Vector3.New( 0,    0,   0),
    [seatType.left]  = Vector3.New( 170, -24,  0),
}

local COUNTDOWN_SECONDS_C = 15

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:ctor(game)
    base.game = game
    base.ctor(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:onInit()
    self.headerParents = {
        [seatType.mine]  = self.mPlayerM, 
        [seatType.right] = self.mPlayerR,  
--        [seatType.top]   = self.mPlayerT, 
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

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:createSettingUI()
    return require("ui.setting.paodekuaiSetting").new(self.game)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:onGameStart()
    base.onGameStart(self)
    self:syncHeadInfo()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:onGameSync()
    base.onGameSync(self)
    self:showClock(self.game.curOpAcId)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:syncHeadInfo()
    self:updateInhandCardsCount()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:showClock(acId)
    local st = self.game:getSeatTypeByAcId(acId)

    self.mClock:setParent(self.headerParents[st])
    self.mClock:setLocalPosition(clockPosition[st])
    self.countdown = COUNTDOWN_SECONDS_C
    self.clockTimestamp = time.realtimeSinceStartup()
    self.mClockText:setText(tostring(self.countdown))
    self.mClock:show()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:hideClock()
    self.mClock:hide()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:update()
    if self.mClock:getVisibled() and self.countdown > 0 then
        local now = time.realtimeSinceStartup()
        if now - self.clockTimestamp > 0.99999 then
            self.countdown = self.countdown - 1
            self.mClockText:setText(tostring(self.countdown))

            self.clockTimestamp = now
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:onFaPai()
    for k, v in pairs(self.headers) do
        local player = self.game:getPlayerByTurn(k)
        if player ~= nil then
            v:setCount(player.zhangShu)
        end
    end
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiDesk:onOpList(msg)
    local acId = msg.AcId
    for _, v in pairs(msg.OpInfos) do
        if v.Op == opType.paodekuai.chu.id then
            self:showClock(acId)
            if v.DetailTyp == helper.paixing.none then
                for _, h in pairs(self.headers) do
                    h:hideBuChu()
                end
            else
                local st = self.game:getSeatTypeByAcId(acId)
                self.headers[st]:hideBuChu()
            end
        elseif v.Op == opType.paodekuai.buChu.id then
        
        end
    end
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiDesk:onOpDoBuChu(acId)
    local st = self.game:getSeatTypeByAcId(acId)
    self.headers[st]:showBuChu()
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiDesk:updateInhandCardsCount()
    for _, p in pairs(self.game.players) do
        local st = self.game:getSeatTypeByAcId(p.acId)
        local header = self.headers[st]
        header:setCount(p.zhangShu)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:reset()
    for _, h in pairs(self.headers) do
        h:hideBuChu()
        h:setCount(nil)
    end

    self:hideClock()
end

return paodekuaiDesk

--endregion
