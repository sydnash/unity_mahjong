--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local gameEndItem = class("gameEndItem", base)

function gameEndItem:onInit()
    self.pai = {}
    self:reset()
end

function gameEndItem:setPlayerInfo(player)
    self.mIcon:setTexture(player.headerTex)
    self.mNickname:setText(player.nickname)
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.score)

    if player.que ~= nil then
        self.mQue:setSprite(getMahjongClassName(player.que))
        self.mQue:show()
    end

    if player.hu ~= nil and player.hu >= 0 then
        self.mResult:show()
    end

    if player.isCreator then
        self.mFz:show()
    end

    if player.isMarker then
        self.mZhuang:show()
    end

    local x = 0

    local peng = player[opType.peng.id]
    if peng ~= nil then
        for _, u in pairs(peng) do
            local p = require("ui.gameEnd.gameEndPengPai").new()
            p:setParent(self.mPai)
            p:show()
            p:setMahjongId(u[1])
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width + 14
            table.insert(self.pai, p)
        end
    end

    local gang = player[opType.gang.id]
    if gang ~= nil then
        for _, u in pairs(gang) do
            local p = require("ui.gameEnd.gameEndGangPai").new()
            p:setParent(self.mPai)
            p:show()
            p:setMahjongId(u[1])
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width + 14
            table.insert(self.pai, p)
        end
    end

    --先把手牌进行排序
    table.sort(player.inhand, function(a, b)
        return a < b
    end)

    for _, u in pairs(player.inhand) do
        local p = require("ui.gameEnd.gameEndPai").new()
        p:setParent(self.mPai)
        p:show()
        p:setMahjongId(u)
        p:setLocalPosition(Vector3.New(x, 0, 0))

        x = x + p.width
        table.insert(self.pai, p)
    end

    local hu = player.hu
    if hu ~= nil and hu >= 0 then
        self.mResult:setSprite("hu")
        self.mResult:show()

        local p = require("ui.gameEnd.gameEndPai").new()
        p:setParent(self.mPai)
        p:show()
        p:setMahjongId(hu)
        p:setLocalPosition(Vector3.New(x + 6, 0, 0))
        p:setHighlight(true)

        table.insert(self.pai, p)
    end
end

function gameEndItem:reset()
    self.mFz:hide()
    self.mResult:hide()
    self.mQue:hide()
    self.mZhuang:hide()
end

function gameEndItem:onDestroy()
    self.mIcon:setTexture(nil)

    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil

    self.super.onDestroy(self)
end

return gameEndItem

--endregion
