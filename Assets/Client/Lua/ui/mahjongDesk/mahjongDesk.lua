--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.mahjongDesk.mahjongDeskHeader")

local base = require("ui.desk")
local mahjongDesk = class("mahjongDesk", base)

_RES_(mahjongDesk, "MahjongDeskUI", "DeskUI")

function mahjongDesk:ctor(game)
    self.super.game = game
    self.super.ctor(self)
end

function mahjongDesk:onInit()
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
    end

    self.super.onInit(self)
end

function mahjongDesk:onGameSync()
    self:updateLeftMahjongCount()
    self.super.onGameSync(self)
end

function mahjongDesk:getInvitationInfo()
    local friendsterId = (self.game.friendsterId == nil or self.game.friendsterId <= 0) and string.empty or string.format("亲友圈：%d", self.game.friendsterId)
    return string.format("%s，%s", 
                         friendsterId,
                         getMahjongConfigText(self.game.cityType, self.game.config, false))
end

function mahjongDesk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("peng")
end

function mahjongDesk:onPlayerGang(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("gang")
end

function mahjongDesk:onPlayerHu(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]

    local detail = opType.hu.detail

    if t == detail.zimo then
        p:playGfx("zimo")
    else
        p:playGfx("hu")
    end

    p:setHu(true)
end

function mahjongDesk:updateLeftMahjongCount(cnt)
    if cnt == nil then 
        cnt = self.game:getLeftCardsCount()
    end

    self.mLeftCount:setText(tostring(cnt))
end

function mahjongDesk:onDingQueDo(msg)
    for _, v in pairs(msg.Dos) do
        local player = self.game:getPlayerByAcId(v.AcId)
        local seat = self.game:getSeatTypeByAcId(player.acId)
        self.headers[seat]:showDingQue(v.Q)
    end
end

function mahjongDesk:onOpDoChu(acId, cards)
    
end

function mahjongDesk:onDestroy()
    self:unregisterHandlers()
    self.super.onDestroy(self)
end

return mahjongDesk

--endregion
