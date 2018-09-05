--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

gameEnd.folder = "GameEndUI"
gameEnd.resource = "GameEndUI"

function gameEnd:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function gameEnd:onInit()
    local items = {
        { icon = self.mIconM, nickname = self.mNicknameM, id = self.mIdM, score = { s = self.mScoreM_S, n = { self.mScoreM_D, self.mScoreM_C, self.mScoreM_B, self.mScoreM_A }} },
        { icon = self.mIconR, nickname = self.mNicknameR, id = self.mIdR, score = { s = self.mScoreR_S, n = { self.mScoreR_D, self.mScoreR_C, self.mScoreR_B, self.mScoreR_A }} },
        { icon = self.mIconT, nickname = self.mNicknameT, id = self.mIdT, score = { s = self.mScoreT_S, n = { self.mScoreT_D, self.mScoreT_C, self.mScoreT_B, self.mScoreT_A }} },
        { icon = self.mIconL, nickname = self.mNicknameL, id = self.mIdL, score = { s = self.mScoreL_S, n = { self.mScoreL_D, self.mScoreL_C, self.mScoreL_B, self.mScoreL_A }} },
    }

    for _, u in pairs(items) do
        for _, v in pairs(u.score.n) do
            v:hide()
        end
    end

    self.mNext:addClickListener(self.onNextClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)

    for _, v in pairs(self.game.players) do
        local index = self.game:getSeatType(v.turn) + 1
        local item = items[index]

        item.nickname:setText(v.nickname)
        item.id:setText("编号:" .. tostring(v.acId))

        local score = math.abs(v.score)
        local sign  = (v.score < 0) and "-" or "+"
        local digit = 1

        item.score.s:setSprite(sign)

        while score > 0 do
            item.score.n[digit]:setSprite(sign .. tostring(score % 10))
            item.score.n[digit]:show()

            digit = digit + 1
            score = math.floor(score / 10)
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

return gameEnd

--endregion
