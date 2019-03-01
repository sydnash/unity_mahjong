--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")

local base = require("ui.common.view")
local gameEndItem = class("gameEndItem", base)

_RES_(gameEndItem, "GameEndUI/PaoDeKuai", "GameEndItem")

local color = {
    meId            = hexColorToColor("e2d488ff"),
    otherId         = hexColorToColor("88c3e2ff"),
}

function gameEndItem:onInit()
    self.pai = {}
    self:reset()
end

function gameEndItem:setPlayerInfo(player)
    self.mHeader:setTexture(player.headerUrl)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.score)

    if player.acId == gamepref.player.acId then
        self.mBGL:setSprite("me")
        self.mBGR:setSprite("me")
        self.mNickname:setColor(color.meId)
        self.mId:setColor(color.meId)
    else
        self.mBGL:setSprite("other")
        self.mBGR:setSprite("other")
        self.mNickname:setColor(color.otherId)
        self.mId:setColor(color.otherId)
    end

    if player.isCreator then
        self.mFz:show()
    end

    --先把手牌进行排序
    if not json.isNilOrNull(player.inhand) then
        table.sort(player.inhand, function(a, b)
            local at = pokerType.getPokerTypeById(a)
            local bt = pokerType.getPokerTypeById(b)

            return (at.value > bt.value)
        end)

        local x = 0
        for _, id in pairs(player.inhand) do
            local p = require("ui.gameEnd.paodekuai.gameEndPai").new(id)
            p:setParent(self.mPai)
            p:show()
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width * 0.3
            table.insert(self.pai, p)
        end
    end
end

function gameEndItem:reset()
    self.mFz:hide()
end

function gameEndItem:onDestroy()
    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil

    base.onDestroy(self)
end

return gameEndItem

--endregion
