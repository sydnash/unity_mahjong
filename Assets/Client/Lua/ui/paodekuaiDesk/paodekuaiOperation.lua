--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")
local paodekuai = require("logic.paodekuai.paodekuai")
local touch     = require("logic.touch")

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
            pos = Vector3.New(-3.7, -3.15, 0),
            inv = 0.54,
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(0, 0, 0),
        },
    },
    [seatType.right] = {
        [pokerType.cardType.shou] = {
            pos = Vector3.New(0, 0, 0),
        },
        [pokerType.cardType.chu] = {
            pos = Vector3.New(0, 0, 0),
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
            pos = Vector3.New(0, 0, 0),
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

    self.mHint:hide()
    self.mChu:hide()

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
    self:initInhandCards()
    self:initChuCards()

    touch.addListener(self.touchHandler, self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onGameSync()
    self:reset()
    touch.addListener(self.touchHandler, self)

    self:initInhandCards()
    self:initChuCards()

    local reenter = self.game.data.Reenter
    log(table.tostring(reenter))
    local lastChupaiInfo = reenter.LastChuPaiInfo
    if lastChupaiInfo ~= nil then
        local cards  = lastChupaiInfo.Cards
        local turn   = lastChupaiInfo.Turn
        local player = self.game:getPlayerByTurn(turn)

        if player.acId == gamepref.player.acId then
            self.mHint:show()
            self.mChu:show()
        end
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:onFaPai()
    self:initInhandCards()
    self:initChuCards()
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
function paodekuaiOperation:initInhandCards()
    for _, player in pairs(self.game.players) do
        self.inhandCards[player.acId] = {}
        self:initOnePlayerInhandCards(player.acId, player[pokerType.cardType.shou])
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:initOnePlayerInhandCards(acId, ids)
    local cards = self.inhandCards[acId]

    for _, id in pairs(ids) do
        if id >= 0 then
            local card = self:createCardById(id)
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
    if acId ~= self.game.mainAcId then
--        self:relocateOtherInhandCards(acId)
        return
    end

    local cards = self.inhandCards[acId]
    self:sortInhandCards(cards)

    local seatType = self.game:getSeatTypeByAcId(acId)
    local startPos = self:getInhandCardStartPos(seatType)
    local interval = self:getInhandCardInterval(seatType)
    local z = startPos.z

    for k, card in pairs(cards) do
        local pos = Vector3.New(startPos.x + (k - 1) * interval, startPos.y, z)
        card:setLocalPosition(pos)
        card:setPickabled(true)

        z = z - 0.00001
    end
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:sortInhandCards(cards)
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
function paodekuaiOperation:initChuCards()

end

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
function paodekuaiOperation:onOpList(msg)
    
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiOperation:reset()
    touch.removeListener()
end

return paodekuaiOperation

--endregion
