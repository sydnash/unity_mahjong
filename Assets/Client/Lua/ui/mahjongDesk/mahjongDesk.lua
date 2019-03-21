--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local header = require("ui.mahjongDesk.mahjongDeskHeader")
local sameip = require("ui.sameip")

local base = require("ui.desk")
local mahjongDesk = class("mahjongDesk", base)

_RES_(mahjongDesk, "MahjongDeskUI", "DeskUI")

function mahjongDesk:ctor(game)
    base.game = game
    base.ctor(self)
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
        self.headers[k]:show()
    end

    self.mRule:setText(self.game:convertConfigToString(true, true, " "))
    self:updateLeftMahjongCount()

    base.onInit(self)
    if self.game.mode == gameMode.normal then
        self.mQuicklyStart:show()
    else
        self.mQuicklyStart:hide()
    end
    if self.game.mode == gameMode.normal then
        self.mQuicklyStart:addClickListener(self.onQuicklyStartBtn, self)
        self.mGameScoreDetail:addClickListener(self.onGameScoreDetail, self)
    end
end

function mahjongDesk:onGameScoreDetail()
    local sdui = require("ui.desk.scoreDetail")
    sdui.new(self.game):show()
end

function mahjongDesk:refreshInvitationButtonState()
    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if playerCount == playerTotalCount then
        self.mQuicklyStart:hide()
    else
        if playerTotalCount > 2 then
            self.mQuicklyStart:show()
        else
            self.mQuicklyStart:hide()
        end
    end

    if playerTotalCount == 4 then
        self.mQuicklyStartIcon:setSprite("23ren")
    else
        self.mQuicklyStartIcon:setSprite("2ren")
    end

    if self.game.gameScoreDetail then
        self.mGameScoreDetail:show()
    else
        self.mGameScoreDetail:hide()
    end

    base.refreshInvitationButtonState(self)
end

function mahjongDesk:onGameStart()
    self.mQuicklyStart:hide()
    base.onGameStart(self)
end

function mahjongDesk:onQuicklyStartBtn()
    networkManager.proposerQuicklyStart()
end

function mahjongDesk:onGameSync()
    self:updateLeftMahjongCount()
    base.onGameSync(self)
end

function mahjongDesk:syncPlayerInfo()
    base.syncPlayerInfo(self)
    self:checkPlayersIP()
end

function mahjongDesk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("peng")
end

function mahjongDesk:onPlayerGang(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]
    p:playGfx("gang")

    local detail = opType.gang.detail
    if t == detail.minggang then
        p:playWind()
    elseif t == detail.bagangwithmoney or t == detail.bagangwithoutmoney then
        p:playWind()
    else
        p:playRain()
    end
end

function mahjongDesk:onPlayerHu(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.headers[s]

    local detail = opType.hu.detail

    local name 
    if t == detail.zimo then
        name = "zimo"
        p:playGfx("zimo")
    elseif t == detail.gangshanghua then
        name = "gangshanghua"
        p:playGfx("zimo")
    else
        name = "hu"
        p:playGfx("hu")
    end

    p:showHu(name)
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

function mahjongDesk:createSettingUI()
    return require("ui.setting.mahjongSetting").new(self.game)
end

function mahjongDesk:onPlayerEnter(player)
    base.onPlayerEnter(self, player)
    self:checkPlayersIP()
end

function mahjongDesk:checkPlayersIP()
    local ips = {}
    local hasSameIP = false

    for _, v in pairs(self.game.players) do
        local ip = v.ip

        if ips[ip] == nil then
            ips[ip] = {}
        end

        table.insert(ips[ip], v.nickname)

        if not hasSameIP then
            hasSameIP = #ips[ip] > 1
        end
    end

    if hasSameIP then
        if self.sameIpUI == nil then
            self.sameIpUI = sameip.new(ips)
        end
        self.sameIpUI:show()
    end
end

function mahjongDesk:onDestroy()
    self:unregisterHandlers()

    for _, v in pairs(self.headers) do
        v:close()
    end
    self.headers = {}

    if self.sameIpUI ~= nil then
        self.sameIpUI:close()
    end
    self.sameIpUI = nil

    base.onDestroy(self)
end

return mahjongDesk

--endregion
