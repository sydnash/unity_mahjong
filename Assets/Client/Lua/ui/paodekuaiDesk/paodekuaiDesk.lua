--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.mahjongDesk.mahjongDeskHeader")

local base = require("ui.desk")
local paodekuaiDesk = class("paodekuaiDesk", base)

_RES_(paodekuaiDesk, "PaodekuaiDeskUI", "DeskUI")

function paodekuaiDesk:ctor(game)
    base.game = game
    base.ctor(self)
end

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

    base.onInit(self)
end

function paodekuaiDesk:reset()
    
end

return paodekuaiDesk

--endregion
