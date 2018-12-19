--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.mahjongDesk.mahjongDeskHeader")

local base = require("ui.desk")
local doushisiDesk = class("doushisiDesk", base)

_RES_(doushisiDesk, "DoushisiDeskUI", "DeskUI")

function doushisiDesk:ctor(game)
    self.super.game = game
    self.super.ctor(self)
end

function doushisiDesk:onInit()
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

    self.super.onInit(self)
end

function doushisiDesk:onGameSync()
    self:updateLeftMahjongCount()
    self.super.onGameSync(self)
end

function doushisiDesk:getInvitationInfo()
    local friendsterId = (self.game.friendsterId == nil or self.game.friendsterId <= 0) and string.empty or string.format("亲友圈：%d，", self.game.friendsterId)
    return string.format("%s%s", 
                         friendsterId,
                         getMahjongConfigText(self.game.cityType, self.game.config, false))
end

function doushisiDesk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("peng")
end

function doushisiDesk:onPlayerGang(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("gang")
end

function doushisiDesk:onPlayerHu(acId, t)
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

function doushisiDesk:updateLeftMahjongCount(cnt)
    if cnt == nil then 
        cnt = self.game:getLeftCardsCount()
    end

    self.mLeftCount:setText(tostring(cnt))
end

function doushisiDesk:onDingQueDo(msg)
    for _, v in pairs(msg.Dos) do
        local player = self.game:getPlayerByAcId(v.AcId)
        local seat = self.game:getSeatTypeByAcId(player.acId)
        self.headers[seat]:showDingQue(v.Q)
    end
end

function doushisiDesk:onOpDoChu(acId, cards)
    
end

function doushisiDesk:createSettingUI()
    return require("ui.setting.doushisiSetting").new(self.game)
end

function doushisiDesk:onDestroy()
    self:unregisterHandlers()

    for _, v in pairs(self.headers) do
        v:close()
    end
    self.headers = {}

    self.super.onDestroy(self)
end

return doushisiDesk

--endregion
