--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongGame   = require("logic.mahjong.mahjongGame")
local opType        = require("const.opType")

local base = require("ui.common.view")
local desk = class("desk", base)

desk.folder = "DeskUI"
desk.resource = "DeskUI"

function desk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function desk:onInit()
    local players = { 
        { nickname = self.mNicknameM, score = self.mScoreM, hu = self.mPlayerM_Hu, marker = self.mMarkerM, que = self.mQueM, fz = self.mFzM, gfx = self.mGfxM, gfxAnim = self.mGfxAnimM, },
        { nickname = self.mNicknameR, score = self.mScoreR, p = self.mPlayerR_P, u = self.mPlayerR_U, ready = self.mPlayerR_Ready, hu = self.mPlayerR_Hu, marker = self.mMarkerR, que = self.mQueR, fz = self.mFzR, gfx = self.mGfxR, gfxAnim = self.mGfxAnimR, },
        { nickname = self.mNicknameT, score = self.mScoreT, p = self.mPlayerT_P, u = self.mPlayerT_U, ready = self.mPlayerT_Ready, hu = self.mPlayerT_Hu, marker = self.mMarkerT, que = self.mQueT, fz = self.mFzT, gfx = self.mGfxT, gfxAnim = self.mGfxAnimT, },
        { nickname = self.mNicknameL, score = self.mScoreL, p = self.mPlayerL_P, u = self.mPlayerL_U, ready = self.mPlayerL_Ready, hu = self.mPlayerL_Hu, marker = self.mMarkerL, que = self.mQueL, fz = self.mFzL, gfx = self.mGfxL, gfxAnim = self.mGfxAnimL, },
    }
    self.players = players

    for _, p in pairs(players) do
        p.hu:hide()
        p.marker:hide()
        p.que:hide()
        p.fz:hide()
        p.gfx:hide()

        if p.p ~= nil and p.u ~= nil then
            p.p:hide()

            if playerCount == 4 then
                p.u:show()
            elseif playerCount == 3 then
                if i % 2 == 0 then
                    p.u:show()
                else
                    p.u:hide()
                end
            elseif playerCount == 2 then
                if i % 2 == 0 then
                    p.u:hide()
                else
                    p.u:show()
                end
            end
        end
    end

    self.mDeskID:setText(string.format("房号:%d", self.game.deskId))
    self:updateCurrentGameIndex()
    self.mTime:setText(time.formatTime())
    self:updateLeftMahjongCount()

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatType(v.turn)
        local p = players[s + 1]

        if v.acId ~= gamepref.acId then
            p.p:show()
            p.u:hide()

            self:setReady(v.acId, v.ready)
        end

        p.nickname:setText(v.nickname)
        p.score:setText(string.format("分数:%d", v.score))

        if v.hu ~= nil and v.hu[1].HuCard >= 0 then
            p.hu:show()
        else
            p.hu:hide()
        end

        if v.isCreator then
            p.fz:show()
        else
            p.fz:hide()
        end
    end

    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if playerCount == playerTotalCount then
        self.mInvite:hide()
        self:showMarker()
    else
        self.mInvite:show()
    end

    self.mInvite:addClickListener(self.onInviteClickedHandler, self)
    self.mReady:addClickListener(self.onReadyClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
    self.mSetting:addClickListener(self.onSettingClickedHandler, self)
end

function desk:onInviteClickedHandler()
    playButtonClickSound()
end

function desk:onReadyClickedHandler()
    playButtonClickSound()
    self.game:ready(true)
end

function desk:onCancelClickedHandler()
    playButtonClickSound()
    self.game:ready(false)
end

function desk:onSettingClickedHandler()
    playButtonClickSound()

    local ui = require("ui.setting").new(self.game)
    ui:show()
end

function desk:setReady(acId, ready)
    if acId == gamepref.acId then
        if ready then
            self.mReady:hide()
            self.mCancel:show()
        else
            self.mReady:show()
            self.mCancel:hide()
        end
    else
        local seat = self.game:getSeatTypeByAcId(acId) + 1

        if ready then
            self.players[seat].ready:show()
        else
            self.players[seat].ready:hide()
        end
    end
end

function desk:setNickname(seat, nickname)
    if seat == mahjongGame.seatType.mine then
        self.mNicknameM:setText(nickname)
    elseif seat == mahjongGame.seatType.right then
        self.mNicknameR:setText(nickname)
    elseif seat == mahjongGame.seatType.top then
        self.mNicknameT:setText(nickname)
    else
        self.mNicknameL:setText(nickname)
    end
end

function desk:onGameStart()
    self.mInvite:hide()
    self.mReady:hide()
    self.mCancel:hide()

    for _, v in pairs(self.players) do
        if v.ready ~= nil then
            v.ready:hide()
        end
    end

    self:showMarker()
    self:updateCurrentGameIndex()
end

function desk:reset()
    self.mInvite:hide()
    self.mReady:show()
    self.mCancel:hide()

    for _, v in pairs(self.players) do
        v.hu:hide()

        if v.ready ~= nil then
            v.ready:hide()
            v.marker:hide()
        end
    end
end

function desk:update()
    self.mTime:setText(time.formatTime())
end

function desk:updateCurrentGameIndex()
    local totalGameCount = self.game:getTotalGameCount()
    local leftGameCount = self.game:getLeftGameCount()
    local currentGameIndex = totalGameCount - leftGameCount + 1

    self.mGameCount:setText(string.format("第%d/%d局", currentGameIndex, totalGameCount))
end

function desk:onPlayerEnter(player)
    local playerTotalCount = self.game:getTotalPlayerCount()
    local playerCount = self.game:getPlayerCount()

    if playerCount == playerTotalCount then
        self.mInvite:hide()
    else
        self.mInvite:show()
    end

    local s = self.game:getSeatType(player.turn)
    local p = self.players[s + 1]

    p.p:show()
    p.u:hide()

    p.ready:hide()
    p.nickname:setText(player.nickname)
    p.score:setText(string.format("分数:%d", player.score))
end

function desk:onPlayerExit(turn)
    self.mInvite:show()

    local s = self.game:getSeatType(turn)
    local p = self.players[s + 1]

    p.p:hide()
    p.u:show()
end

function desk:onPlayerPeng(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]
    p.gfx:setSprite("peng")
    p.gfx:show()
    p.gfxAnim:play()
end

function desk:onPlayerGang(acId)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]
    p.gfx:setSprite("gang")
    p.gfx:show()
    p.gfxAnim:play()
end

function desk:onPlayerHu(acId, t)
    local s = self.game:getSeatTypeByAcId(acId)
    local p = self.players[s + 1]

    local detail = opType.hu.detail

    if t == detail.zimo then
        p.gfx:setSprite("zimo")
    else
        p.gfx:setSprite("hu")
    end

    p.hu:show()
    p.gfxAnim:play()
end

function desk:showMarker()
    local marker = self.game:getMarkerTurn()

    if marker ~= nil then
        local seat = self.game:getSeatType(marker) + 1
        self.players[seat].marker:show()
    end
end

function desk:updateLeftMahjongCount(cnt)
    if cnt == nil then 
        cnt = self.game:getLeftMahjongCount()
    end

    self.mLeftCount:setText(tostring(cnt))
end

return desk

--endregion
