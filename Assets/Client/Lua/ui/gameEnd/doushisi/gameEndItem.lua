--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEndItem = class("gameEndItem", base)
local doushisiType = require("logic.doushisi.doushisiType")

_RES_(gameEndItem, "GameEndUI/DouShiSi", "GameEndItem")

function gameEndItem:onInit()
    self.pai = {}
    self:reset()
end


local color = {
    meId            = hexColorToColor("e2d488ff"),
    otherId         = hexColorToColor("88c3e2ff"),
    meFanFu         = hexColorToColor("f4e592ff"),
    otherFanFu      = hexColorToColor("92d1f2ff"),
}

function gameEndItem:setPlayerInfo(player)
    self.mHeader:setTexture(player.headerUrl)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.score)
    self.mFanFu:setText(player.fuShu .. "福 " .. player.fanShu .. "番")


    if player.huType then
        self.mResult:show()
        self.mResult:setSprite(player.huType)
    end

    local icons = {}
    table.insert(icons, self.mBGL)
    table.insert(icons, self.mBGR)
    if player.isCreator then
        self.mFz:show()
    end

    if player.isMarker then
        self.mZhuang:show()
        table.insert(icons, self.mZhuang)
    end
    if player.isDang then
        self.mDang:show()
        table.insert(icons, self.mDang)
    end
    if player.isPiao then
        self.mPiao:show()
        table.insert(icons, self.mPiao)
    end
    if player.isBao then
        self.mBao:show()
        table.insert(icons, self.mBao)
    end

    if player.acId == gamepref.player.acId then
        for _, v in pairs(icons) do
            v:setSprite("me")
        end
        self.mNickname:setColor(color.meId)
        self.mId:setColor(color.meId)
        self.mFanFu:setColor(color.meFanFu)
    else
        for _, v in pairs(icons) do
            v:setSprite("other")
        end
        self.mNickname:setColor(color.otherId)
        self.mId:setColor(color.otherId)
        self.mFanFu:setColor(color.otherFanFu)
    end

    self:initPai(player)
end

local gap = 42
local shouChiGap = 14

function gameEndItem:initPai(p)
    if p.tyReplace then
        self.tyReplace = p.tyReplace
        self.tyUsedIdx = 1
    end
    table.removeItem(p.inhand, p.hu)
    local tmp = p.inhand
    p.inhand = {}
    for _, v in pairs(tmp) do
        local nid, has = self:getTYReplace(v)
        table.insert(p.inhand, {id = nid, has = has})
    end

    table.bubbleSort(p.inhand, function(t1, t2)
        return t1.id <= t2.id
    end)

    local nt = {}
    local pt = {}
    while true do
        if #p.inhand == 0 then
            break
        end
        local t1 = p.inhand[1]
        local v1 = doushisiType.getDoushisiTypeById(t1.id).value
        if v1 >= 8 then
            break
        end
        table.removeItem(p.inhand, t1)
        local find = false
        for i = #p.inhand,1,-1 do
            local t2 = p.inhand[i]
            local v2 = doushisiType.getDoushisiTypeById(t2.id).value
            if v2 + v1 == 14 then
                find = true
                table.insert(nt, t1)
                table.insert(nt, t2)
                table.removeItem(p.inhand, t2)
                break
            end
        end
        if not find then
            table.insert(pt, t1)
        end
    end
    self.nextPos = 0
    for i = 1, #nt, 2 do
        local t = {nt[i], nt[i + 1]}
        self:addInhandCards(t)
    end
    for i = 1, #pt do
        local t = {pt[i]}
        self:addInhandCards(t)
    end
    for i = 1, #p.inhand do
        local t = {p.inhand[i]}
        self:addInhandCards(t)
    end
    self.nextPos = self.nextPos + shouChiGap
    if p.hu >= 0 then
        local nid, has = self:getTYReplace(p.hu)
        local t = { {id = nid, has = has} }
        self:addInhandCards(t)
    end
    self.nextPos = self.nextPos + shouChiGap
    if not isNilOrNull(p.chiChe) then
        for _, v in pairs(p.chiChe) do
            self:addChiChe(v)
        end
    end
end

function gameEndItem:addInhandCards(ids)
    local pai = self:createPai(ids)
    pai:setLocalPosition(Vector3.New(self.nextPos, 5, 0))
    self.nextPos = self.nextPos + gap
end

function gameEndItem:addChiChe(v)
    for i = 1, #v.Cards, 3 do
        local t = {}
        for j = i, i + 3 do
            if j <= #v.Cards then
                table.insert(t, {id = v.Cards[j]})
            end
        end
        local pai = self:createPai(t)
        pai:setLocalPosition(Vector3.New(self.nextPos, 5, 0))
        self.nextPos = self.nextPos + gap
    end
end

function gameEndItem:createPai(ids)
    local pai = require ("ui.gameEnd.doushisi.gameEndPai").new()
    pai:setIds(ids)
    pai:show()
    pai:setParent(self.mPai)
    table.insert(self.pai, pai)
    return pai
end

local tystart = 22 * 4
local tyend = 22 * 4 + 3
function gameEndItem:getTYReplace(id)
    if self.tyUsedIdx then
        if id >= tystart and id <= tyend then
            if self.tyReplace then
                if self.tyUsedIdx <= #self.tyReplace then
                    local replace = self.tyReplace[self.tyUsedIdx]
                    self.tyUsedIdx = self.tyUsedIdx + 1
                    return replace * 4, true
                end
            end
        end
    end
    return id, false
end

function gameEndItem:reset()
    self.mFz:hide()
    self.mResult:hide()
    self.mZhuang:hide()
    self.mPiao:hide()
    self.mDang:hide()
    self.mBao:hide()
end

function gameEndItem:onDestroy()
    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil

    self.super.onDestroy(self)
end

return gameEndItem

--endregion
