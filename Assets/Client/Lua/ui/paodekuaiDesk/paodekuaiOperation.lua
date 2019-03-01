--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")
local paodekuai = require("logic.paodekuai.paodekuai")
local touch     = require("logic.touch")
local helper    = require("logic.paodekuai.helper")

local base = require("ui.common.view")
local paodekuaiOperation = class("paodekuaiOperation", base)

_RES_(paodekuaiOperation, "PaodekuaiDeskUI", "DeskOperationUI")

local mainCameraParams = {
    position = Vector3.New(2000, 0, -10),
    rotation = Quaternion.Euler(0, 0, 0),
    hWidth   = 12.80,
}

local inhandCameraParams = {
    position = Vector3.New(2000, 0, -0.9),
    size = 3.6
}

local seats = {
    [seatType.mine] = {
        [pokerType.cardType.shou] = {
            pos = Vector3.New(1.2, -3.15, 0),
            inv = 0.54,
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(0, -1.1, 0),
            inv = 0.36,
        },
    },
    [seatType.right] = {
        [pokerType.cardType.shou] = {
            pos = Vector3.New(0, 0, 0),
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(4, 0.7, 0),
            inv = 0.36,
        },
    },
    [seatType.top] = {
        [pokerType.cardType.shou] = {
            pos = Vector3.New(0, 0, 0),
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(0, 0, 0),
        },
    },
    [seatType.left] = {
        [pokerType.cardType.shou] = {
            pos = Vector3.New(0, 0, 0),
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(-4, 0.7, 0),
            inv = 0.36,
        },
    },
}

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:ctor(game)
    self.game = game
    base.ctor(self)

    self.inhandCards = {}
    self.chuCards = {}
    self.touchedCards = {}
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onInit()
    self.cardRoot = find("paodekuai/poker_root")

    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
    fixMainCameraParam(mainCameraParams.hWidth, mainCamera)
    local bl = Vector3.New(0, 0, math.abs(mainCamera.transform.position.z))
    local tr = Vector3.New(1, 1, math.abs(mainCamera.transform.position.z))

    local wbl = mainCamera:ViewportToWorldPoint(bl)
    local wtr = mainCamera:ViewportToWorldPoint(tr)

    self.safeArea = {}
    self.safeArea.bottom    = wbl.y
    self.safeArea.right     = wtr.x - 1000
    self.safeArea.left      = wbl.x - 1000
    self.safeArea.top       = wtr.y
    self.safeArea.cx        = 0
    self.safeArea.cy        = 0

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size
    fixInhandCameraParam(inhandCameraParams.size, camera)

    local inhandCameraT = camera.transform
    inhandCameraT.position = Vector3.New(inhandCameraT.position.x, self.safeArea.bottom + camera.orthographicSize, inhandCameraT.position.z)
    
    local tbc = gamepref.getTablecloth(gameType.paodekuai)
    self:changeBG(tbc)

    self:hideOpButtons()

    self.mHint:addClickListener(self.onHintClickedHandler, self)
    self.mChu:addClickListener(self.onChuClickedHandler, self)

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:changeBG(key)
    if self.tableRoot == nil then
        self.tableRoot = find("paodekuai/table")
    end

    if self.tableRoot ~= nil then
        local render = getComponentU(self.tableRoot.gameObject, typeof(UnityEngine.SpriteRenderer))
        if render ~= nil then
            local sprite = render.sprite
            if sprite ~= nil then
                textureManager.unload(sprite.texture)
                UnityEngine.GameObject.Destroy(sprite)
            end

            local tex = textureManager.load("poker/table", key)
            render.sprite = convertTextureToSprite(tex, Vector2.New(0.5, 0.5))
        end
    end

    if self.tableRoot_t == nil then
        self.tableRoot_t = find("paodekuai/table_t")
    end

    if self.tableRoot_t ~= nil then
        local render = getComponentU(self.tableRoot_t.gameObject, typeof(UnityEngine.SpriteRenderer))
        if render ~= nil then
            local sprite = render.sprite
            if sprite ~= nil then
                textureManager.unload(sprite.texture)
                UnityEngine.GameObject.Destroy(sprite)
            end

            local tex = textureManager.load("poker/table", key .. "_t")
            render.sprite = convertTextureToSprite(tex, Vector2.New(0.5, 0.5))
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onGameStart()
    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onGameSync()
    self:reset()
    touch.addListener(self.touchHandler, self)

    self:createInhandCards()
    self:createChuCards()

    local reenter = self.game.data.Reenter
    log(table.tostring(reenter))

    local oplist = reenter.CurOpList
    if oplist ~= nil then
        if oplist.AcId == gamepref.player.acId then
            self:showOpButtons()
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onFaPai()
    self:createInhandCards()
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:touchHandler(phase, pos)
    local camera = GameObjectPicker.instance.camera

    if phase == touch.phaseType.began then
        local go = GameObjectPicker.instance:Pick(pos)
        if go ~= nil then
            local card = self:getCardByGo(go)
            if card ~= nil and self.touchedCards[card.id] == nil then
                if card.selected then
                    card:setSelected(false)
                else
                    card:setSelected(true)
                end

                self.touchedCards[card.id] = card
            end
        end
    elseif phase == touch.phaseType.moved then
        local go = GameObjectPicker.instance:Pick(pos)
        if go ~= nil then
            local card = self:getCardByGo(go)
            if card ~= nil and self.touchedCards[card.id] == nil then
                if card.selected then
                    card:setSelected(false)
                else
                    card:setSelected(true)
                end

                self.touchedCards[card.id] = card
            end
        end
    else --phase == touch.phaseType.end
        self.touchedCards = {}
    end
end

-----------------------------------------------------------
-- 初始化手牌
-----------------------------------------------------------
function paodekuaiOperation:createInhandCards()
    for _, player in pairs(self.game.players) do
        self.inhandCards[player.acId] = {}
        self:createOnePlayerInhandCards(player.acId, player[pokerType.cardType.shou])
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:createOnePlayerInhandCards(acId, ids)
    local cards = self.inhandCards[acId]

    for _, id in pairs(ids) do
        if id >= 0 then
            local card = self:createCardById(id)
            card:setPickabled(true)
            table.insert(cards, card)
        end
    end

    self:relocateInhandCards(acId)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:createCardById(id)
    local card = paodekuai.new(id)
    card:setParent(self.cardRoot)

    return card
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:relocateInhandCards(acId)
    if acId == self.game.mainAcId then
        local cards = self.inhandCards[acId]
        self:sortCards(cards)

        local seatType = self.game:getSeatTypeByAcId(acId)
        local startPos = self:getInhandCardStartPos(seatType)
        local interval = self:getInhandCardInterval(seatType)
        local x = startPos.x + ((#cards - 1) * interval + 1.3) * -0.5
        local z = startPos.z
        local order = 0

        for k, card in pairs(cards) do
            local pos = Vector3.New(x + (k - 1) * interval, startPos.y, z)
            card:setLocalPosition(pos)
            z = z - 0.00001

            order = order + 1
            card:setSortingOrder(order)
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:sortCards(cards)
    table.sort(cards, function(a, b)
        local at = pokerType.getPokerTypeById(a.id)
        local bt = pokerType.getPokerTypeById(b.id)

        return (at.value > bt.value)
    end)
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:getInhandCardStartPos(st)
    return seats[st][pokerType.cardType.shou].pos
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:getInhandCardInterval(st)
    return seats[st][pokerType.cardType.shou].inv
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:getChuCardStartPos(st)
    return seats[st][pokerType.cardType.chu].pos
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:getChuCardInterval(st)
    return seats[st][pokerType.cardType.chu].inv
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:getCardByGo(go)
    local cards = self.inhandCards[self.game.mainAcId]

    for _, c in pairs(cards) do
        if c.gameObject == go then
            return c
        end
    end

    return nil
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:createChuCards()
    for _, player in pairs(self.game.players) do
        self.chuCards[player.acId] = {}
        self:createOnePlayerChuCards(player.acId, player[pokerType.cardType.chu])
    end
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:destoryChuCards()
    for _, player in pairs(self.game.players) do
        self:destoryOnePlayerChuCards(player.acId)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:createOnePlayerChuCards(acId, ids)
    if ids ~= nil then
        if self.chuCards[acId] == nil then
            self.chuCards[acId] = {}
        end

        local cards = self.chuCards[acId]

        for _, id in pairs(ids) do
            if id >= 0 then
                local card = self:createCardById(id)
                card:setType(pokerType.cardType.chu)
                card:setPickabled(false)
                card:fix()
                table.insert(cards, card)
            end
        end

        self:relocateChuCards(acId)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:destoryOnePlayerChuCards(acId)
    local cards = self.chuCards[acId]
    if cards ~= nil then
        for _, v in pairs(cards) do
            v:destroy()
        end
        self.chuCards[acId] = {}
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:relocateChuCards(acId)
    local cards = self.chuCards[acId]
    self:sortCards(cards)

    local st = self.game:getSeatTypeByAcId(acId)
    local startPos = self:getChuCardStartPos(st)
    local interval = self:getChuCardInterval(st)
    local order = 0

    if st == seatType.mine then
        local x = startPos.x + ((#cards - 1) * interval + 0) * -0.5
        for k, v in pairs(cards) do
            local pos = Vector3.New(x + (k - 1) * interval, startPos.y, startPos.z)
            v:setLocalPosition(pos)

            order = order + 1
            v:setSortingOrder(order)
        end
    elseif st == seatType.right then
        for i=#cards, 1, -1 do
            local pos = Vector3.New(startPos.x - (i - 1) * interval, startPos.y, startPos.z)
            cards[i]:setLocalPosition(pos)

            order = order + 1
            cards[i]:setSortingOrder(order)
        end
    elseif st == seatType.left then
        for k, v in pairs(cards) do
            local pos = Vector3.New(startPos.x + (k - 1) * interval, startPos.y, startPos.z)
            v:setLocalPosition(pos)

            order = order + 1
            v:setSortingOrder(order)
        end
    end
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:onOpList(msg)
    if msg.AcId == self.game.mainAcId then
        for _, v in pairs(msg.OpInfos) do
            if v.Op == opType.paodekuai.chu.id then
                if v.DetailTyp == helper.paixing.none then
                    self:showOpButtons()
                end
            elseif v.Op == opType.paodekuai.tianGuan.id then

            elseif v.Op == opType.paodekuai.pass.id then

            elseif v.Op == opType.paodekuai.buChu.id then

            else

            end
        end
    end

    self:destoryOnePlayerChuCards(msg.AcId)
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:showOpButtons()
    self.mHint:show()
    self.mChu:show()
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:hideOpButtons()
    self.mHint:hide()
    self.mChu:hide()
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:onHintClickedHandler()
    playButtonClickSound()
end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:onChuClickedHandler()
    playButtonClickSound()

    local inhandCards = self.inhandCards[self.game.mainAcId]
    local selectCards = {}
    for _, v in pairs(inhandCards) do
        if v.selected then
            table.insert(selectCards, v.id)
        end
    end

    if #selectCards == 0 then

    else
        networkManager.pdkChuPai(selectCards, function(msg)
            self:relocateInhandCards(self.game.mainAcId)
        end)
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onOpDoChu(acId, cards)
    if acId == self.game.mainAcId then
        local inhandCards = self.inhandCards[acId]
        for i=#inhandCards, 1, -1 do
            for _, id in pairs(cards) do
                local c = inhandCards[i]
                if (c.id == id) then
                    c:destroy()
                    table.remove(inhandCards, i)
                    break
                end
            end
        end
        self:relocateInhandCards(acId)
    end
    self:createOnePlayerChuCards(acId, cards)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onOpDoBuChu(acId)
    self:destoryOnePlayerChuCards(acId)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:reset()
    touch.removeListener()

    for acId, cards in pairs(self.inhandCards) do
        for _, c in pairs(cards) do
            c:destroy()
        end
        self.inhandCards[acId] = {}
    end

    for acId, cards in pairs(self.chuCards) do
        for _, c in pairs(cards) do
            c:destroy()
        end
        self.chuCards[acId] = {}
    end

    self:hideOpButtons()
end

return paodekuaiOperation

--endregion
