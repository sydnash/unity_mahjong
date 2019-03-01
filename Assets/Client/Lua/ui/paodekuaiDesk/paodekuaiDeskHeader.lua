--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.deskHeader")
local paodekuaiDeskHeader = class("paodekuaiDeskHeader", base)

local res = {
    [seatType.mine]  = "DeskHeaderM",
    [seatType.right] = "DeskHeaderR",
    [seatType.top]   = "DeskHeaderT",
    [seatType.left]  = "DeskHeaderL",
}

function paodekuaiDeskHeader:ctor(seatType)
    _RES_(self, "PaodekuaiDeskUI", res[seatType])
    base.ctor(self)

    self.mCountN:hide()
end

function paodekuaiDeskHeader:setPlayerInfo(player)
    base.setPlayerInfo(self, player)

    if player ~= nil then
        self:setCount(player.zhangShu)
    else
        self:setCount(nil)
        self:hide()
    end
end

function paodekuaiDeskHeader:setCount(cnt)
    if cnt == nil then
        self.mCountN:hide()
    else
        self.mCountN:show()
        self.mCount:setText(tostring(cnt))
    end
end

function paodekuaiDeskHeader:showBuChu()
    self.mGfx:setSprite("buchu")
    self.mGfx:show()
end

function paodekuaiDeskHeader:hideBuChu()
    self.mGfx:hide()
end

return paodekuaiDeskHeader

--endregion
