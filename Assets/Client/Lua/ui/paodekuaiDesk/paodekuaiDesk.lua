--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.paodekuaiDesk.paodekuaiDeskHeader")

local base = require("ui.desk")
local paodekuaiDesk = class("paodekuaiDesk", base)

_RES_(paodekuaiDesk, "PaodekuaiDeskUI", "DeskUI")

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
    local parents = {
        [seatType.mine]  = self.mPlayerM, 
        [seatType.right] = self.mPlayerR,  
        [seatType.top]   = self.mPlayerT, 
        [seatType.left]  = self.mPlayerL, 
    }

    self.headers = {}

    for k, v in pairs(parents) do
        self.headers[k] = header.new(k)
        self.headers[k]:setParent(v)
        self.headers[k]:show()
    end

    self.mClock:hide()

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
