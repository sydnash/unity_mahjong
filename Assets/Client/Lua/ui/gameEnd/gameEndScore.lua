--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local gameEndScore = class("gameEndScore", base)

function gameEndScore:onInit()
    self.n = { self.mC, self.mB, self.mA }
    for _, v in pairs(self.n) do
        v:hide()
    end
end

function gameEndScore:setScore(score)
    local sign  = (score < 0) and "-" or "+"
    self.mS:setSprite(sign)

    local digit = 1
    score = math.abs(score)

    if score == 0 then
        self.n[digit]:setSprite("+0")
        self.n[digit]:show()
    else
        while score > 0 do
            self.n[digit]:setSprite(sign .. tostring(score % 10))
            self.n[digit]:show()

            digit = digit + 1
            score = math.floor(score / 10)
        end
    end
end

return gameEndScore

--endregion
