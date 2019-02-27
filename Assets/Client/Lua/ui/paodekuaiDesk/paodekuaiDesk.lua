--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.paodekuaiDesk.paodekuaiDeskHeader")

local base = require("ui.desk")
local paodekuaiDesk = class("paodekuaiDesk", base)

_RES_(paodekuaiDesk, "PaodekuaiDeskUI", "DeskUI")

local clockPosition = {
    [seatType.mine]  = Vector3.New( 0,   90, 0),
    [seatType.right] = Vector3.New(-280, 0,  0),
    [seatType.top]   = Vector3.New( 0,   0,  0),
    [seatType.left]  = Vector3.New( 280, 0,  0),
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

    local st = self.game:getSeatTypeByAcId(self.game.curOpAcId)
    self:showClock(st)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:showClock(seat)
    self.mClock:setParent(self.headerParents[seat])
    self.mClock:setLocalPosition(clockPosition[seat])
    self.countdown = COUNTDOWN_SECONDS_C
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
function paodekuaiDesk:onFaPai()
    for k, v in pairs(self.headers) do
        local player = self.game:getPlayerByTurn(k)
        v:setCount(player.zhangShu)
    end
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiDesk:onOpList(msg)

end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiDesk:reset()
    
end

return paodekuaiDesk

--endregion
