--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameOver = class("gameOver", base)

gameOver.folder = "GameOverUI"
gameOver.resource = "GameOverUI"

function gameOver:ctor(game, datas)
    self.game  = game
    self.datas = datas
    self.super.ctor(self)
end

function gameOver:onInit()
    local items = {
        { icon = self.mIconA, nickname = self.mNicknameA, id = self.mIdA, score = { s = self.mScoreA_S, n = { self.mScoreA_A, self.mScoreA_B, self.mScoreA_C, self.mScoreA_D, }, }, winnerFlag = self.mWinnerFlagA, fz = self.mFzA, },
        { icon = self.mIconB, nickname = self.mNicknameB, id = self.mIdB, score = { s = self.mScoreB_S, n = { self.mScoreB_A, self.mScoreB_B, self.mScoreB_C, self.mScoreB_D, }, }, winnerFlag = self.mWinnerFlagB, fz = self.mFzB, },
        { icon = self.mIconC, nickname = self.mNicknameC, id = self.mIdC, score = { s = self.mScoreC_S, n = { self.mScoreC_A, self.mScoreC_B, self.mScoreC_C, self.mScoreC_D, }, }, winnerFlag = self.mWinnerFlagC, fz = self.mFzC, },
        { icon = self.mIconD, nickname = self.mNicknameD, id = self.mIdD, score = { s = self.mScoreD_S, n = { self.mScoreD_A, self.mScoreD_B, self.mScoreD_C, self.mScoreD_D, }, }, winnerFlag = self.mWinnerFlagD, fz = self.mFzD, },
    }

    self.mDeskId:setText("房号:" .. tostring(self.datas.deskId))
    self.mFinishCount:setText("已打" .. tostring(self.datas.finishGameCount) .. "/" .. tostring(self.datas.totalGameCount) .. "局")
    self.mDateTime:setText(time.formatDateTime())

    for k, v in pairs(self.datas.players) do
        local item = items[k + 1]

        item.nickname:setText(v.nickname)
        item.id:setText("编号:" .. tostring(v.acId))

        if v.isWinner then
            item.winnerFlag:show()
        else
            item.winnerFlag:hide()
        end

        if v.isCreator then
            item.fz:show()
        else
            item.fz:hide()
        end

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

    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
end

function gameOver:onConfirmClickedHandler()
    playButtonClickSound()

    self.game:exitGame() 
    self:close()
end

function gameOver:onShareClickedHandler()
    playButtonClickSound()
end

return gameOver

--endregion
