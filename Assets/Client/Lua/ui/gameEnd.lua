--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local opType = require("const.opType")
local mahjong = require("logic.mahjong.mahjong")
local mahjongGame = require("logic.mahjong.mahjongGame")

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

gameEnd.folder = "GameEndUI"
gameEnd.resource = "GameEndUI"

function gameEnd:ctor(game, datas)
    self.game  = game
    self.datas = datas
    self.pai   = {}

    self.super.ctor(self)
end

function gameEnd:onInit()
    local items = {
        { icon = self.mIconM, nickname = self.mNicknameM, id = self.mIdM, pai = self.mPaiM, score = { s = self.mScoreM_S, n = { self.mScoreM_D, self.mScoreM_C, self.mScoreM_B, self.mScoreM_A }}, fz = self.mFzM, result = self.mResultM, marker = self.mMarkerM, que = self.mQueM, },
        { icon = self.mIconR, nickname = self.mNicknameR, id = self.mIdR, pai = self.mPaiR, score = { s = self.mScoreR_S, n = { self.mScoreR_D, self.mScoreR_C, self.mScoreR_B, self.mScoreR_A }}, fz = self.mFzR, result = self.mResultR, marker = self.mMarkerR, que = self.mQueR, },
        { icon = self.mIconT, nickname = self.mNicknameT, id = self.mIdT, pai = self.mPaiT, score = { s = self.mScoreT_S, n = { self.mScoreT_D, self.mScoreT_C, self.mScoreT_B, self.mScoreT_A }}, fz = self.mFzT, result = self.mResultT, marker = self.mMarkerT, que = self.mQueT, },
        { icon = self.mIconL, nickname = self.mNicknameL, id = self.mIdL, pai = self.mPaiL, score = { s = self.mScoreL_S, n = { self.mScoreL_D, self.mScoreL_C, self.mScoreL_B, self.mScoreL_A }}, fz = self.mFzL, result = self.mResultL, marker = self.mMarkerL, que = self.mQueL, },
    }
    self.items = items

    for _, u in pairs(items) do
        for _, v in pairs(u.score.n) do
            v:hide()
        end

        u.fz:hide()
        u.result:hide()
        u.marker:hide()
        u.que:hide()
    end

    for _, v in pairs(self.datas.players) do
        local item = items[v.seat + 1]

        item.icon:setTexture(v.headerTex)
        item.nickname:setText(v.nickname)
        item.id:setText(string.format("编号:%d", v.acId))

        if v.que ~= nil then
            item.que:setSprite(getMahjongClassName(v.que))
            item.que:show()
        end

        if v.turn == self.game:getMarkerTurn() then
            item.marker:show()
        end

        -- 牌
        local x = 0

        local peng = v[opType.peng.id]
        if peng ~= nil then
            for _, u in pairs(peng) do
                local p = require("ui.gameEnd.gameEndPengPai").new()
                p:setParent(item.pai)
                p:show()
                p:setMahjongId(u[1])
                p:setLocalPosition(Vector3.New(x, 0, 0))

                x = x + p.width + 14
                table.insert(self.pai, p)
            end
        end

        local gang = v[opType.gang.id]
        if gang ~= nil then
            for _, u in pairs(gang) do
                local p = require("ui.gameEnd.gameEndGangPai").new()
                p:setParent(item.pai)
                p:show()
                p:setMahjongId(u[1])
                p:setLocalPosition(Vector3.New(x, 0, 0))

                x = x + p.width + 14
                table.insert(self.pai, p)
            end
        end

        --先把手牌进行排序
        table.sort(v.inhand, function(a, b)
            return a < b
        end)

        for _, u in pairs(v.inhand) do
            local p = require("ui.gameEnd.gameEndPai").new()
            p:setParent(item.pai)
            p:show()
            p:setMahjongId(u)
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width
            table.insert(self.pai, p)
        end

        local hu = v.hu
        if hu ~= nil and hu >= 0 then
            item.result:setSprite("hu")
            item.result:show()

            local p = require("ui.gameEnd.gameEndPai").new()
            p:setParent(item.pai)
            p:show()
            p:setMahjongId(hu)
            p:setLocalPosition(Vector3.New(x + 6, 0, 0))
            p:setHighlight(true)

            table.insert(self.pai, p)
        end

        -- 分数
        local score = math.abs(v.score)
        local sign  = (v.score < 0) and "-" or "+"
        local digit = 1

        item.score.s:setSprite(sign)

        if score == 0 then
            item.score.n[digit]:setSprite("+0")
            item.score.n[digit]:show()
        else
            while score > 0 do
                item.score.n[digit]:setSprite(sign .. tostring(score % 10))
                item.score.n[digit]:show()

                digit = digit + 1
                score = math.floor(score / 10)
            end
        end

        if v.isCreator then
            item.fz:show()
        else
            item.fz:hide()
        end
    end

    local info = string.format("第%d/%d局  房号:%d", self.datas.finishGameCount, self.datas.totalGameCount, self.datas.deskId)
    self.mInfo:setText(info)

    if self.datas.totalGameCount > self.datas.finishGameCount then
        self.mOk:hide()
        self.mNext:show()
    else
        self.mOk:show()
        self.mNext:hide()
    end

    self.mOk:addClickListener(self.onOkClickedHandler, self)
    self.mNext:addClickListener(self.onNextClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)
end

function gameEnd:endAll()
    if self.gameObject ~= nil then
        self.mOk:show()
        self.mNext:hide()
    end
end

function gameEnd:onOkClickedHandler()
    playButtonClickSound()

    local ui = require("ui.gameOver").new(self.game, self.datas)
    ui:show()

    self:close() 
end

function gameEnd:onNextClickedHandler()
    playButtonClickSound()

    self:close()
    self.game:ready(true)  
end

function gameEnd:onShareClickedHandler()
    playButtonClickSound()
end

function gameEnd:onRecordClickedHandler()
    playButtonClickSound()
end

function gameEnd:onDestroy()
    for _, v in pairs(self.items) do
        v.icon:setTexture(nil)
    end

    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil
end

return gameEnd

--endregion
