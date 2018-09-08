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
    self.game = game
    self.datas = datas
    self.pai = {}

    self.super.ctor(self)
end

function gameEnd:onInit()
    local items = {
        { icon = self.mIconM, nickname = self.mNicknameM, id = self.mIdM, pai = self.mPaiM, score = { s = self.mScoreM_S, n = { self.mScoreM_D, self.mScoreM_C, self.mScoreM_B, self.mScoreM_A }} },
        { icon = self.mIconR, nickname = self.mNicknameR, id = self.mIdR, pai = self.mPaiR, score = { s = self.mScoreR_S, n = { self.mScoreR_D, self.mScoreR_C, self.mScoreR_B, self.mScoreR_A }} },
        { icon = self.mIconT, nickname = self.mNicknameT, id = self.mIdT, pai = self.mPaiT, score = { s = self.mScoreT_S, n = { self.mScoreT_D, self.mScoreT_C, self.mScoreT_B, self.mScoreT_A }} },
        { icon = self.mIconL, nickname = self.mNicknameL, id = self.mIdL, pai = self.mPaiL, score = { s = self.mScoreL_S, n = { self.mScoreL_D, self.mScoreL_C, self.mScoreL_B, self.mScoreL_A }} },
    }

    for _, u in pairs(items) do
        for _, v in pairs(u.score.n) do
            v:hide()
        end
    end

    self.mNext:addClickListener(self.onNextClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)

    for _, v in pairs(self.datas) do
        local item = items[v.seat + 1]

        item.nickname:setText(v.nickname)
        item.id:setText("编号:" .. tostring(v.acId))

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
            local p = require("ui.gameEnd.gameEndPai").new(hu)
            p:setParent(item.pai)
            p:show()
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
    end
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
    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil
end

return gameEnd

--endregion
