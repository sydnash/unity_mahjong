local doushisi      = require("logic.doushisi.doushisi")
local doushisiType  = require("logic.doushisi.doushisiType")
local doushisiGame  = require("logic.doushisi.doushisiGame")
local touch         = require("logic.touch")
local SpriteRenderer = UnityEngine.SpriteRenderer
local GameObject = UnityEngine.GameObject

local base = require("ui.common.view")
local doushisiOperation = class("doushisiOperation", base)

_RES_(doushisiOperation, "DoushisiDeskUI", "DeskOperationUI")

local opTypeOrder = {
    [opType.doushisi.hu.id]         = 1,
    [opType.doushisi.chi.id]        = 2,
    [opType.doushisi.che.id]        = 3,
    [opType.doushisi.an.id]         = 4,
    [opType.doushisi.hua.id]        = 5,
    [opType.doushisi.baGang.id]     = 6,
    [opType.doushisi.gang.id]       = 7,
    [opType.doushisi.gen.id]        = 8,
    [opType.doushisi.bao.id]        = 9,
    [opType.doushisi.shou.id]       = 10,
    [opType.doushisi.zhao.id]       = 11,
    [opType.doushisi.baoJiao.id]    = 12,
    [opType.doushisi.caiShen.id]    = 13,
    [opType.doushisi.pass.id]       = 14,
    [opType.doushisi.chu.id]        = 15,
}

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function doushisiOperation:ctor(game)
    self.game = game
    base.ctor(self)
end

local btnIconConfig = {
    mHuaIcon = {
        default = "hua",
        [cityType.jintang] = "an",
    },
    mDangIcon = {
        default = "dang",
        [cityType.jintang] = "zuoZhuang",
    },
    mBuDangIcon = {
        default = "buDang",
        [cityType.jintang] = "huaZhuang",
    },
}

local mainCameraParams = {
    position = Vector3.New(1000, 0, -13.43),
    rotation = Quaternion.Euler(0, 0, 0),
    hWidth   = 12.80,
    fov      = 30,
}

local inhandCameraParams = {
    position = Vector3.New(1000, 0, -0.9),
    size = 3.6
}

doushisiOperation.shakepaitime = 0.2

local actionCardHeight = 2.14
local actionCardWidth = 0.72
local actionCardGap = 0.50

local xdStyleActionCardHeight   = 2.97
local xdStyleActionCardWidth    = 1.03
local xdStyleActionCardGap      = 0.50

local actionConfig = {
    [doushisiStyle.traditional] = {w = actionCardWidth, h = actionCardHeight, g = actionCardGap},
    [doushisiStyle.modern]      = {w = xdStyleActionCardWidth, h = xdStyleActionCardHeight, g = xdStyleActionCardGap},
}

local seats = {
    [seatType.mine] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -2.00, -3.93, 0), rot = Quaternion.Euler(0, 0, 0), 
                    rowgap = 0.69, colgap = 0.50, height = 2.14, width = 0.69, scale = 1,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(4.92, -2.87, 0), rot = Quaternion.Euler(0, 0, -135), 
                    colDir = {x = math.cos(135*math.pi/180), y = math.sin(135*math.pi/180)},
                    rowDir = {x = math.cos(45 * math.pi/180),y = math.sin(45 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, -135),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-1.375, -1.068, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = 1},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 90),
                },
        promote = {pos = Vector3.New(-0.00, 0.80, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(-0.00, 0.80, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.right] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 6.15, 0.08, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(3.62, 2.60, 0), rot = Quaternion.Euler(0, 0, -35), 
                    colDir = {x = math.cos(-125*math.pi/180), y = math.sin(-125*math.pi/180)},
                    rowDir = {x = math.cos(-35 * math.pi/180), y = math.sin(-35 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, -35),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(4.90, 2.39, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(3.68, 0.639, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(3.68, 0.639, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.top] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 1.81, 3.33, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -3.38, 2.60, 0), rot = Quaternion.Euler(0, 0, 35),
                    colDir = {x = math.cos(-55*math.pi/180), y = math.sin(-55*math.pi/180)},
                    rowDir = {x = math.cos(125 * math.pi/180), y = math.sin(125 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 35),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-2.06, 2.44, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 90),
                },
        promote = {pos = Vector3.New(0.00, 1.36, 0), rot = Quaternion.Euler(0, 0, 90), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 90)},
        action = {pos = Vector3.New(1.40, 1.36, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.left] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -6.15, 0.08, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -5.58, -2.60, 0), rot = Quaternion.Euler(0, 0, 135),
                    colDir = {x = math.cos(45*math.pi/180), y = math.sin(45*math.pi/180)},
                    rowDir = {x = math.cos(135 * math.pi/180), y = math.sin(135 * math.pi/180)},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 135),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-4.91, 2.41, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.47, colgap = 0.30, cardWidth = 0.48, cardHeight = 0.78,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(-3.71, 0.68, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(-3.71, 0.68, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.14, rotEuler = Vector3.New(0, 0, 0)},
    },
}

local xdStyleseats = {
    [seatType.mine] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -2.00, -3.59, 0), rot = Quaternion.Euler(0, 0, 0), 
                    rowgap = 0.92, colgap = 0.65, height = 1.48, width = 0.96, scale = 1,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(5.552, -1.842, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = -1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-6.079, -2.121, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = 1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(-0.00, 0.80, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(-0.00, 0.80, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.right] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 6.15, 0.08, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = -1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New(5.552, 0.291, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = -1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(5.148, 0.741, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = -1, y = 0},
                    rowDir = {x = 0,y = 1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(3.68, 0.639, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(3.68, 0.639, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.top] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( 1.81, 3.33, 0), rot = Quaternion.Euler(0, 0, 90), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( 0.624, 2.292, 0), rot = Quaternion.Euler(0, 0, 0),
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-0.372, 1.895, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = -1, y = 0},
                    rowDir = {x = 0,y = 1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(0.00, 1.36, 0), rot = Quaternion.Euler(0, 0, 90), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 90)},
        action = {pos = Vector3.New(1.40, 1.36, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
    },
    [seatType.left] = { 
        [doushisiGame.cardType.shou] = { pos = Vector3.New( -6.15, 0.08, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 0, y = -1},
                    rowDir = {x = 1,y = 0},
                    rowgap = 0.47, colgap = 0.30, width = 0.48, height = 0.78, scale = 0.6,
                },
        [doushisiGame.cardType.chu] = { pos = Vector3.New( -6.066, -0.052, 0), rot = Quaternion.Euler(0, 0, 0),
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0, y = -1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        [doushisiGame.cardType.peng] = { pos = Vector3.New(-5.172, 0.594, 0), rot = Quaternion.Euler(0, 0, 0), 
                    colDir = {x = 1, y = 0},
                    rowDir = {x = 0,y = 1},
                    rowgap = 0.32, colgap = 0.45, cardWidth = 0.48, cardHeight = 0.37,
                    rotEuler = Vector3.New(0, 0, 0),
                },
        promote = {pos = Vector3.New(-3.71, 0.68, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
        action = {pos = Vector3.New(-3.71, 0.68, 0), rot = Quaternion.Euler(0, 0, 0), cardHeight = 2.97, rotEuler = Vector3.New(0, 0, 0)},
    },
}

local seatConfig = {
    [doushisiStyle.traditional] = seats,
    [doushisiStyle.modern]      = xdStyleseats,
}

local alignType = {
    min     = 1,
    max     = 2,
    center  = 3,
    percent = 4,
}

local originSafeArea = {
    bottom      = -3.6,
    top         = 3.6,
    right       = 6.4,
    left        = -6.4,
    cx          = 0,
    cy          = 0,
}

local LEFT_CARDS_NUM_POS_Y = 0.34

function doushisiOperation:fix(min, max, nmin, nmax, p, align)
    local r = p
    if align == alignType.min then
        r = (p - min) + nmin
    elseif align == alignType.max then
        r = nmax - (max - p)
    elseif align == alignType.center then
        r = (p - (min + max) * 0.5) + (nmin + nmax) * 0.5
    elseif align == alignType.percent then
        r = ((p - min) / (max - min) * (nmax - nmin)) + nmin
    end
    -- log(string.format("min: %f max: %f nmin: %f nmax: %f p: %f align: %d r:%f", min, max, nmin, nmax, p, align, r))
    return r
end

function doushisiOperation:fixPos(pos, xalign, yalign)
    local x = self:fix(originSafeArea.left, originSafeArea.right, self.safeArea.left, self.safeArea.right, pos.x, xalign)
    local y = self:fix(originSafeArea.bottom, originSafeArea.top, self.safeArea.bottom, self.safeArea.top, pos.y, yalign)
    local ret = Vector3.New(x, y, pos.z)
    return ret
end

function doushisiOperation:alignPos()
    if seatConfig.computed then
        return
    end
    for _, s in pairs(seatConfig) do
        s[seatType.mine][doushisiGame.cardType.shou].pos = self:fixPos(s[seatType.mine][doushisiGame.cardType.shou].pos, alignType.center, alignType.min)
        s[seatType.mine][doushisiGame.cardType.chu].pos = self:fixPos(s[seatType.mine][doushisiGame.cardType.chu].pos, alignType.min, alignType.min)
        s[seatType.mine][doushisiGame.cardType.peng].pos = self:fixPos(s[seatType.mine][doushisiGame.cardType.peng].pos, alignType.center, alignType.min)
        s[seatType.mine].promote.pos = self:fixPos(s[seatType.mine].promote.pos, alignType.center, alignType.min)
        s[seatType.mine].action.pos = self:fixPos(s[seatType.mine].action.pos, alignType.center, alignType.min)

        s[seatType.right][doushisiGame.cardType.shou].pos = self:fixPos(s[seatType.right][doushisiGame.cardType.shou].pos, alignType.max, alignType.min)
        s[seatType.right][doushisiGame.cardType.chu].pos = self:fixPos(s[seatType.right][doushisiGame.cardType.chu].pos, alignType.max, alignType.percent)
        s[seatType.right][doushisiGame.cardType.peng].pos = self:fixPos(s[seatType.right][doushisiGame.cardType.peng].pos, alignType.max, alignType.percent)
        s[seatType.right].promote.pos = self:fixPos(s[seatType.right].promote.pos, alignType.max, alignType.percent)
        s[seatType.right].action.pos = self:fixPos(s[seatType.right].action.pos, alignType.max, alignType.percent)

        s[seatType.left][doushisiGame.cardType.shou].pos = self:fixPos(s[seatType.left][doushisiGame.cardType.shou].pos, alignType.min, alignType.min)
        s[seatType.left][doushisiGame.cardType.chu].pos = self:fixPos(s[seatType.left][doushisiGame.cardType.chu].pos, alignType.min, alignType.percent)
        s[seatType.left][doushisiGame.cardType.peng].pos = self:fixPos(s[seatType.left][doushisiGame.cardType.peng].pos, alignType.min, alignType.percent)
        s[seatType.left].promote.pos = self:fixPos(s[seatType.left].promote.pos, alignType.min, alignType.percent)
        s[seatType.left].action.pos = self:fixPos(s[seatType.left].action.pos, alignType.min, alignType.percent)
        
        s[seatType.top][doushisiGame.cardType.shou].pos = self:fixPos(s[seatType.top][doushisiGame.cardType.shou].pos, alignType.max, alignType.max)
        s[seatType.top][doushisiGame.cardType.chu].pos = self:fixPos(s[seatType.top][doushisiGame.cardType.chu].pos, alignType.min, alignType.max)
        s[seatType.top][doushisiGame.cardType.peng].pos = self:fixPos(s[seatType.top][doushisiGame.cardType.peng].pos, alignType.center, alignType.max)
        s[seatType.top].promote.pos = self:fixPos(s[seatType.top].promote.pos, alignType.center, alignType.max)
        s[seatType.top].action.pos = self:fixPos(s[seatType.top].action.pos, alignType.center, alignType.max)
    end
    seatConfig.computed = true
end

function doushisiOperation:setDoushisiStyle(style)
    if self.game:isPlayback() then
        style = doushisiStyle.traditional
    end
    if actionConfig[style] == nil then
        style = doushisiStyle.traditional
    end
    self.style = style
    self.seats = seatConfig[style]
    self.actionCardGap = actionConfig[style].g
    self.actionCardWidth = actionConfig[style].w
    self.actionCardHeight = actionConfig[style].h
end

function doushisiOperation:onInit()
    --初始化主相机
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
    fixMainCameraParam(mainCameraParams.fov, mainCamera, mainCameraParams.fov)
    local bl = Vector3.New(0, 0, math.abs(mainCamera.transform.position.z))
    local tr = Vector3.New(1, 1, math.abs(mainCamera.transform.position.z))

    local wbl = mainCamera:ViewportToWorldPoint(bl)
    local wtr = mainCamera:ViewportToWorldPoint(tr)

    local safeArea = {}
    safeArea.bottom     = wbl.y
    safeArea.right      = wtr.x - 1000
    safeArea.left       = wbl.x - 1000
    safeArea.top        = wtr.y
    safeArea.cx         = 0
    safeArea.cy         = 0
    self.safeArea       = safeArea

    self:alignPos()

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size
    fixInhandCameraParam(inhandCameraParams.size, camera)

    local inhandCameraT = camera.transform
    inhandCameraT.position = Vector3.New(inhandCameraT.position.x, self.safeArea.bottom + camera.orthographicSize, inhandCameraT.position.z)

    local root = find("doushisi").transform

    self.tableRoot = findChild(root, "table")
    local tbc = gamepref.getTablecloth(gameType.doushisi)
    self:changeBG(tbc)

    self.cardRoot = findChild(root, "changpai_root")
    self.allCards = {}
    self.idleCards = {}
    self.allActionCards = {}
    self.idleActionCards = {}
    self.flyNodes = {}
    self.idleFlyNodes = {}
    self:setDoushisiStyle(gamepref.getTablelayout())
    self.canChuPai = false
    self.dragCard = doushisi.new(0)
    self.dragCard:setLocalScale(Vector3.New(1.2, 1.2, 1.2))
    self.dragCard:setPickabled(true)
    self.dragCard:setColliderEnabled(false)
    self.sortOrder = 0
    --剩余的牌
    self.leftCards = findChild(root, "leftcards")
    self.leftCardsModel = findSpriteRD(self.leftCards.transform, "model/M")
    self.leftCardsNum = findChild(self.leftCards.transform, "num")
    self.leftCardsNumL = findSpriteRD(self.leftCardsNum.transform, "L")
    self.leftCardsNumH = findSpriteRD(self.leftCardsNum.transform, "H")
    self.leftCards:hide()
    
    --初始化按钮
    self.mBuDang:addClickListener(self.onBuDangClickedHandler, self)
    self.mDang:addClickListener(self.onDangClickedHandler, self)
    self.mPass:addClickListener(self.onPassClickedHandler, self)
    self.mChi:addClickListener(self.onChiClickedHandler, self)
    self.mChe:addClickListener(self.onCheClickedHandler, self)
    self.mHua:addClickListener(self.onHuaClickedHandler, self)
    self.mAn:addClickListener(self.onAnClickedHandler, self)
    self.mDeng:addClickListener(self.onDengClickedHandler, self)
    self.mHu:addClickListener(self.onHuClickedHandler, self)

    local cityType = self.game.cityType
    for k, info in pairs(btnIconConfig) do
        local icon = self[k]
        local sp = info[cityType]
        if sp == nil then
            sp = info.default
        end
        icon:setSprite(sp)
    end

    self.opBtns = {
        self.mBuDang,
        self.mDang,
        self.mPass,
        self.mChi,
        self.mChe,
        self.mHua,
        self.mAn,
        self.mDeng,
        self.mHu,
    }
    touch.addListener(self.touchHandler, self)

    self.animationManager = tweenParallel.new(false)
    tweenManager.add(self.animationManager)
    self.animationManager:play()

    self:reset()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function doushisiOperation:changeBG(key)
    if self.tableRoot ~= nil then
        local render = getComponentU(self.tableRoot.gameObject, typeof(SpriteRenderer))
        if render ~= nil then
            local sprite = render.sprite
            if sprite ~= nil then
                textureManager.unload(sprite.texture)
                GameObject.Destroy(sprite)
            end

            local tex = textureManager.load("doushisi/table", key)
            render.sprite = convertTextureToSprite(tex, Vector2.New(0.5, 0.5))
        end
    end
end

function doushisiOperation:worldToUIPos(pos, node)
    local mainCamera = UnityEngine.Camera.main
    local scPos = mainCamera:WorldToScreenPoint(pos)
    scPos.z = math.abs(viewManager.camera.transform.position.z)
    local uiPos = viewManager.camera:ScreenToWorldPoint(scPos)

    local parent = node:getParent()
    local _, uiPos = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(parent.rectTransform, scPos, viewManager.camera, nil)
    return uiPos
end

function doushisiOperation:computeChuPaiHintPos()
    local cfg = self.seats[seatType.mine][doushisiGame.cardType.shou]
    local pos = cfg.pos:Clone()
    local cardLen = cfg.height * 0.5
    
    pos.y = pos.y + cardLen + cfg.colgap * 3
    self.chuPaiLineY = pos.y

    local uiPos = self:worldToUIPos(pos, self.mChuHint)

    local hintPos = self.mChuHint:getAnchoredPosition()
    hintPos.y = uiPos.y
    self.mChuHint:setAnchoredPosition(hintPos)
end

local btn_half = 116 * 0.5
function doushisiOperation:computeOpBtnStartPos()
    local cfg = self.seats[seatType.mine].promote
    local basePos = self.cardRoot:getPosition()

    local x         = basePos.x + cfg.pos.x
    local y         = basePos.y + cfg.pos.y - self.actionCardHeight * 0.5
    local left      = x - self.actionCardWidth * 0.5
    local right     = x + self.actionCardWidth * 0.5

    local leftPos   = Vector3.New(left, y, 0)
    local rightPos  = Vector3.New(right, y, 0)

    leftPos         = self:worldToUIPos(leftPos, self.mHua)
    rightPos        = self:worldToUIPos(rightPos, self.mHua)

    local gap = rightPos.x - leftPos.x
    
    self.btnGap         = gap + btn_half * 2.0
    self.leftPos, self.rightPos = leftPos, rightPos
    self.leftPos.x      = self.leftPos.x - btn_half
    self.leftPos.y      = self.leftPos.y + btn_half
    self.rightPos.x     = self.rightPos.x + btn_half
    self.rightPos.y     = self.rightPos.y + btn_half
end

function doushisiOperation:hideAllOpBtn()
    for _, btn in pairs(self.opBtns) do
        btn:hide()
    end
    self.curShowOpBtns = {}
end

function doushisiOperation:closeAllBtnPanel()
    for _, btn in pairs(self.opBtns) do
        if btn.panel then
            btn.panel:close()
            btn.panel = nil
        end
    end
end

function doushisiOperation:onGameSync()
    self:reset()
    touch.addListener(self.touchHandler, self)

    self:initChuCards()
    self:initChiPengCards()
    self:initInhandCards()
    local reenter = self.game.data.Reenter
    if reenter then
        local deskPlayStatus = self.game.deskPlayStatus
        if deskPlayStatus == doushisiGame.deskPlayStatus.tuiDang then
            if self.game.curOpAcId == self.game.mainAcId then
                self:onDangHandler(reenter.IsMustDang)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.touPai then
            if reenter.TouHint ~= nil then 
                local data = {Cards = {}, HasTY = {}, Op = opType.doushisi.an.id, HasWarning = {}}
                if reenter.TouHint.Tous ~= nil then 
                    for v,k in pairs(reenter.TouHint.Tous) do 
                        table.insert(data.Cards, k.CardsId[1])
                        table.insert(data.HasTY, k.HasTY)
                    end
                end
                data.CanPass = reenter.TouHint.CanPass
                self:onOpListAn(data)
                if data.CanPass then
                    self:onOpListPass()
                end
            elseif reenter.CurOpList ~= nil then
                self:onOpList(reenter.CurOpList)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.playing then
            if reenter.CurOpList ~= nil then
                self:onOpList(reenter.CurOpList)
            end
        elseif deskPlayStatus == doushisiGame.deskPlayStatus.piao then
        end
        if reenter.CurDiPai >= 0 and (reenter.CurOpType == opType.doushisi.chu.id or reenter.CurOpType == opType.doushisi.fan.id) then
            self:promoteChu(self.game.curOpAcId, reenter.CurDiPai, true)
        end
    end

    self:showLeftCards()
    self:updateLeftCardsCount()
end

function doushisiOperation:onFaPai()
    self:resetPai()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
end

function doushisiOperation:onGameStart()
    self:initInhandCards()
    self:initChuCards()
    self:initChiPengCards()
    self:showLeftCards()
    self:updateLeftCardsCount()
    touch.addListener(self.touchHandler, self)
end

---------------------------------------------------------------
--当
---------------------------------------------------------------
function doushisiOperation:onDangHandler(isMustDang)
    self:hideAllOpBtn()
    self:showOpBtn(self.mDang)
    if not isMustDang then
        self:showOpBtn(self.mBuDang)
    end
end

function doushisiOperation:onDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(true)
end

function doushisiOperation:onBuDangClickedHandler()
    self:hideAllOpBtn()
    networkManager.csDang(false)
end

function doushisiOperation:sortOpList(data)
	local compare = function(t1, t2)
		local d1 = opTypeOrder[t1.Op]
		local d2 = opTypeOrder[t2.Op]
		if d1 == nil then d1 = 100 end
		if d2 == nil then d2 = 100 end
		return d1 <= d2
	end
	table.bubbleSort(data.OpInfos, compare)
end

function doushisiOperation:onOpList(opList)
    if opList == nil then
        return
    end
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local leftTime = opList.LeftTime

    self:sortOpList(opList)
    for _, opInfo in pairs(opList.OpInfos) do
        local op = opInfo.Op
        if json.isNilOrNull(opInfo.HasTY) then
            opInfo.HasTY = {}
        end
        if json.isNilOrNull(opInfo.HasWarning) then
            opInfo.HasWarning = {}
        end
        if op == opType.doushisi.hua.id then
            self:onOpListHua(opInfo)
        elseif op == opType.doushisi.chu.id then
            self:onOpListChu(opInfo)
        elseif op == opType.doushisi.chi.id then
            self:onOpListChi(opInfo)
        elseif op == opType.doushisi.che.id then
            self:onOpListChe(opInfo)
        elseif op == opType.doushisi.hu.id then
            self:onOpListHu(opInfo)
        elseif op == opType.doushisi.gang.id then
        elseif op == opType.doushisi.pass.id then
            self:onOpListPass()
        elseif op == opType.doushisi.an.id then
            self:onOpListAn(opInfo)
        elseif op == opType.doushisi.zhao.id then
        elseif op == opType.doushisi.shou.id then
        elseif op == opType.doushisi.bao.id then
        elseif op == opType.doushisi.baGang.id then
            self:onOpListBaGang(opInfo)
        elseif op == opType.doushisi.chiChengSan.id then
            --self:onOpListChiChengSan(opInfo)
        elseif op == opType.doushisi.caiShen.id then
            self:onOpListCaiShen(opInfo)
        elseif op == opType.doushisi.baoJiao.id then
        elseif op == opType.doushisi.gen.id then
        elseif op == opType.doushisi.weiGui.id then
        else
            log("on op list handler: receive not supported handler." .. tostring(op))
        end
    end
    self:relocateOpBtn()
end

function doushisiOperation:onOpListPass()
    self:showOpBtn(self.mPass)
end

function doushisiOperation:showOpBtn(btn, opInfo)
    btn:show()
    btn.opInfo = opInfo
    table.insert(self.curShowOpBtns, btn)

    local total = #self.curShowOpBtns

    local opdist = self.btnGap

    local leftCnt = math.floor(#self.curShowOpBtns / 2)
    local right = leftCnt + 1
    
    local y = self.leftPos.y - 15

    local leftStart     = self.leftPos.x
    local rightStart    = self.rightPos.x

	for i = leftCnt, 1, -1 do
		local diff = (leftCnt - i) * opdist
		local x = leftStart - diff
        --self.curShowOpBtns[i]:setPosition(Vector3.New(x, y, 0))
        self.curShowOpBtns[i]:setAnchoredPosition(Vector2.New(x, y, 0))
	end

	for i = right, #self.curShowOpBtns, 1 do
		local diff = (i - right) * opdist
		local x = rightStart + diff
		--self.curShowOpBtns[i]:setPosition(Vector3.New(x, y, 0))
        self.curShowOpBtns[i]:setAnchoredPosition(Vector2.New(x ,y , 0))
	end
end

function doushisiOperation:relocateOpBtn()
end

function doushisiOperation:onPassClickedHandler()
    local sendData = self:getOpChoseData(opType.doushisi.pass.id)
    networkManager.csOpChose(sendData)
end

function doushisiOperation:showChuHint()
    self.mChuHint:show()
    self.mLine.action = tweenForever.new({
            tweenColor.fadeOut(self.mLine, 0.5),
            tweenColor.fadeIn(self.mLine, 0.5),
        })

    local from  = Vector3.New(0, 0, 45)
    local to    = Vector3.New(0, 0, 1)
    self.mFinger:setLocalRotation(Quaternion.Euler(from.x, from.y, from.z))
    self.mFinger.action = tweenForever.new({
        tweenRotation.new(self.mFinger, 0.5, from, to, nil),
        tweenRotation.new(self.mFinger, 0.5, to, from, nil),
    })
    tweenManager.add(self.mLine.action)
    tweenManager.add(self.mFinger.action)

    self.mLine.action:play()
    self.mFinger.action:play()
end

function doushisiOperation:hideChuHint()
    tweenManager.remove(self.mLine.action)
    tweenManager.remove(self.mFinger.action)
    self.mChuHint:hide()
end

function doushisiOperation:enableAllInhandCards(acId)
    if not self.inhandCards then
        return
    end
    local inhandCards = self.inhandCards[acId]
    if not inhandCards then
        return
    end
    for idx, card in pairs(inhandCards) do
        card:setCanChu(true)
    end
end

function doushisiOperation:enableChu(opInfo)
    self.canChuPai = true
    self:enableAllInhandCards(self.game.mainAcId)
    if not json.isNilOrNull(opInfo.Cards) and #opInfo.Cards > 0 then
        local acId = self.game.mainAcId
        local inhandCards = self.inhandCards[acId]
        for idx, card in pairs(inhandCards) do
            card:setCanChu(false)
        end
        for _, id in pairs(opInfo.Cards) do
            local card = self:findCardFromInhand(self.game.mainAcId, id, false)
            if card then
                card:setCanChu(true)
            end
        end
    end
    self:showChuHint()
end

function doushisiOperation:disableChu()
    self.canChuPai = false
    self:enableAllInhandCards(self.game.mainAcId)

    self:hideChuHint()
end

-----------------------------------------------------------
--chu
-----------------------------------------------------------
function doushisiOperation:virtureChu(card)
    local acId = self.game.mainAcId
    card:hide()
    self:promoteChu(acId, card.id)
    --play sound for card
    local player = self.game:getPlayerByAcId(acId)
    playDoushisiSound(self.game.cityType, card.id, player.sex)
end

function doushisiOperation:onOpListChu(opInfo)
    self:enableChu(opInfo)
end

function doushisiOperation:onOpDoChu(acId, id)
    self:disableChu()

    local card = self:findAndRemoveCard(acId, id)
    self:addCardToChu(acId, card)

    --self:movePromoteCardToChu()
    if self.promoteNode and self.promoteNode.acId ~= acId then
        self:pushBackPromoteNode()
    end
    local isIm = false
    local time = 0.3
    if self.promoteNode and self.promoteNode.id == id then
        card:hide()
        -- return math.max(time, 1.1)
        return 0.5
    end

    self:promoteChu(acId, id, isIm)
    --play sound for card
    local player = self.game:getPlayerByAcId(acId)
    playDoushisiSound(self.game.cityType, id, player.sex)

    -- return math.max(time, 1.1)
    return 0.5
end

function doushisiOperation:opDoChiPengAnHua(acId, delIds, beId, op)
    local info = {
        op = op,
        cards = {}
    }
    if beId then
        local card = self:findAndRemoveCard(acId, beId)
        table.insert(info.cards, card)
    end
    for _, id in pairs(delIds) do
        local card = self:findAndRemoveCard(acId, id)
        table.insert(info.cards, card)
    end
    table.insert(self.chipengCards[acId], info)
    self:relocateChiPengCards(acId)

    return info
end

-----------------------------------------------------------
--hua
-----------------------------------------------------------
function doushisiOperation:onOpListHua(opInfo)
    self:showOpBtn(self.mHua, opInfo)
end

function doushisiOperation:onHuaClickedHandler()
    self:onPanelBtnClick(self.mHua, function(Class)
        return Class.newAnSelPanel(self.mHua.opInfo, function(info)
            self:onHuaChose(info)
        end)
    end)
end

function doushisiOperation:onHuaChose(info)
    local data = self:getOpChoseData(opType.doushisi.hua.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end

function doushisiOperation:onOpDoHua(acId, delIds)
    local info =self:opDoChiPengAnHua(acId, delIds, nil, opType.doushisi.hua.id)
    return self:chiPengAction(acId, info.cards) + 0.1
end

-----------------------------------------------------------
--chi
-----------------------------------------------------------
function doushisiOperation:onOpListChi(opInfo)
    self:showOpBtn(self.mChi, opInfo)
end

function doushisiOperation:onChiClickedHandler()
    self:onPanelBtnClick(self.mChi, function(Class)
        return Class.newChiSelPanel(self.mChi.opInfo, function(info)
            self:onChiChose(info)
        end)
    end)
end

function doushisiOperation:onChiChose(info)
    local data = self:getOpChoseData(opType.doushisi.chi.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end

function doushisiOperation:onOpDoChi(acId, delIds, beId)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.chi.id)
    return self:chiPengAction(acId, info.cards)
end

-----------------------------------------------------------
--che
-----------------------------------------------------------
function doushisiOperation:onOpListChe(opInfo)
    self:showOpBtn(self.mChe, opInfo)
end

function doushisiOperation:onCheClickedHandler()
    local info = self.mChe.opInfo
    local data = self:getOpChoseData(opType.doushisi.che.id, info.Cards[1], info.HasTY[1], nil)
    networkManager.csOpChose(data)
end

function doushisiOperation:onOpDoChe(acId, delIds, beId)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.che.id)
    return self:chiPengAction(acId, info.cards) + 0.1
end

-----------------------------------------------------------
--hu
-----------------------------------------------------------
function doushisiOperation:onOpListHu(opInfo)
    self:showOpBtn(self.mHu, opInfo)
end

function doushisiOperation:onHuClickedHandler()
    local info = self.mHu.opInfo
    local data = self:getOpChoseData(opType.doushisi.hu.id, info.Cards[1])
    networkManager.csOpChose(data)
end

function doushisiOperation:onOpDoHu(acId, id)
    return self:promoteChu(acId, id)
end

-----------------------------------------------------------
--an
-----------------------------------------------------------
function doushisiOperation:onOpListAn(opInfo)
    self:showOpBtn(self.mAn, opInfo)
end

function doushisiOperation:onAnClickedHandler()
    self:onPanelBtnClick(self.mAn, function(Class)
        return Class.newAnSelPanel(self.mAn.opInfo, function(info)
            self:onAnChose(info)
        end)
    end)
end

function doushisiOperation:onAnChose(info)
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local sendData = { Chooses={} }
    local item = {Card = info.c, Num = 3}
    if info.hasTY then
        item.Num = 4
    end
    table.insert(sendData.Chooses, item)
    networkManager.csAnPai(sendData)
end

function doushisiOperation:onOpDoAn(acId, delIds)
    local info = self:opDoChiPengAnHua(acId, delIds, beId, opType.doushisi.an.id)
    return self:chiPengAction(acId, info.cards) + 0.1
end

-----------------------------------------------------------
--ba gang
-----------------------------------------------------------
function doushisiOperation:onOpListBaGang(opInfo)
    self:showOpBtn(self.mDeng, opInfo)
end

function doushisiOperation:onDengClickedHandler()
    self:onPanelBtnClick(self.mDeng, function(Class)
        return Class.newBaGangSelPanel(self.mDeng.opInfo, function(info)
            self:onBaGangChose(info)
        end)
    end)
end

function doushisiOperation:onBaGangChose(info)
    local data = self:getOpChoseData(opType.doushisi.baGang.id, info.c, info.hasTY, nil)
    networkManager.csOpChose(data)
end

function doushisiOperation:onOpDoBaGang(acId, id)
    local card = self:findAndRemoveCard(acId, id)

    local chipengCards = self.chipengCards[acId]
    local findInfo = nil
    for _, info in pairs(chipengCards) do
        if findInfo ~= nil then
            break
        end
        if info.op ~= opType.doushisi.caiShen.id and #info.cards <= 3 then
            if id < 0 or info.cards[1].id < 0 or doushisi.typeId(info.cards[1].id) == doushisi.typeId(id) then
                table.insert(info.cards, card)
                findInfo = info
                break
            end
        end
    end

    self:relocateChiPengCards(acId)

    return self:chiPengAction(acId, {card}) + 0.1
end

-----------------------------------------------------------
--cai shen
-----------------------------------------------------------
function doushisiOperation:onOpListCaiShen(info)
end

function doushisiOperation:onOpDoCaiShen(acId, id)
    local card = self:findAndRemoveCard(acId, id)

    local caiShenInfo
    local chipengCards = self.chipengCards[acId]
    if chipengCards and #chipengCards > 0 and chipengCards[1].op == opType.doushisi.caiShen.id then
        caiShenInfo = chipengCards[1]
    else
        caiShenInfo = {op = opType.doushisi.caiShen.id, cards = {}}
        table.insert(chipengCards, 1, caiShenInfo)
    end
    table.insert(caiShenInfo.cards, card)

    self:relocateChiPengCards(acId)

    local playsound = true
    if self.promoteNode and self.promoteNode.acId == acId and self.promoteNode.id == id then
        playsound = false
    end
    if playsound then
        local player = self.game:getPlayerByAcId(acId)
        playDoushisiSound(self.game.cityType, id, player.sex)
    end

    self:pushBackPromoteNode()
    return self:chiPengAction(acId, {card}, not playsound) + 0.1
end

function doushisiOperation:onPanelBtnClick(btn, createFunc)
    if btn.panel then
        btn.panel:close()
        btn.panel = nil
        return
    end
    self:closeAllBtnPanel()
    local PanelClass = require ("ui.doushisiDesk.chiAnSelPanel")
    local panel = createFunc(PanelClass)
    btn.panel = panel
    panel:show()
    panel:setParent(btn)
    --panel:setLocalPosition(Vector3.New(0, 0, 0))
    panel:setAnchoredPosition(Vector3.New(0, -20, 0))
end

function doushisiOperation:getOpChoseData(op, card, hasTY, baos)
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    local data = {
        Op = op,
        ChoseCard = card,
        HasTY = hasTY,
        BaoTypes = baos,
    }
    return data
end

function doushisiOperation:reset()
    touch.removeListener()
    self:hideLeftCards()
    self:hideAllOpBtn()
    self:closeAllBtnPanel()
    self:disableChu()

    if self.animationManager ~= nil then
        self.animationManager:clear()
        self.animationManager:play()
    end
    self:resetPai()
end

function doushisiOperation:resetPai()
    self:computeChuPaiHintPos()
    self:computeOpBtnStartPos()
    self.dragCard:hide()
    self.idleCards = {}
    self.promoteNode = nil
    for _, card in pairs(self.allCards) do
        card:hide()
        card:setSelected(false)
        card:setPickabled(false)
        table.insert(self.idleCards, card)
    end
    self.idleActionCards = {}
    for _, card in pairs(self.allActionCards) do
        self:pushbackActionCard(card)
    end
    self.idleFlyNodes = {}
    for _, node in pairs(self.flyNodes) do
        self:pushFlyNode(node)
    end
    self.inhandCards = {}
    self.chuCards = {}
    self.chipengCards = {}
end

function doushisiOperation:getCardById(id)
    if #self.idleCards > 0 then
        local card = self.idleCards[#self.idleCards]
        table.remove(self.idleCards, #self.idleCards)
        card:setId(id)
        card:hide()
        return card
    end
    local card = doushisi.new(id)
    table.insert(self.allCards, card)
    card:hide()
    return card
end

function doushisiOperation:getActionCardById(id)
    local card
    if #self.idleActionCards > 0 then
        card = self.idleActionCards[#self.idleActionCards]
        table.remove(self.idleActionCards, #self.idleActionCards)
    else
        card = doushisi.new(id)
        card:setColliderEnabled(false)
        table.insert(self.allActionCards, card)
    end
    card:hide()
    card:setId(id)
    return card
end

function doushisiOperation:pushbackActionCard(card)
    card:hide()
    card:setPickabled(false)
    card:setParent(self.cardRoot)
    table.insert(self.idleActionCards, card)
end

function doushisiOperation:promoteChu(acId, id, im)
    local card = self:findCard(acId, id)
    card:hide()
    local node = self:createFlyNode({id})
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote

    local pos = Vector3.New(cfg.pos.x, cfg.pos.y, cfg.pos.z)
    node:setLocalPosition(pos)
    node:setLocalRotation(cfg.rot)
    node:show()

    if not im then
        local shakeAction = self:getShakeAction(node)
        self.animationManager:add(shakeAction)
        shakeAction:play()
    end

    self.promoteNode = node
    self.promoteNode.acId = acId
    self.promoteNode.id = id

    return self.shakepaitime
end

function doushisiOperation:addCardTo(card, pos, seatType, cardType, rot, scale, parent)
    pos.z = 0
    if parent then
        card:setParent(parent)
    else
        card:setParent(self.cardRoot)
    end
    card:setSelected(false)
    card:setStyle(self.style)
    card:setType(cardType)
    card:fix()
    card:setLocalPosition(pos)
    card:setCanChu(true)
    if rot then
        card:setLocalRotation(rot)
    end
    if scale then
        card:setLocalScale(scale)
    end
    card:show()
    self:topCard(card)
end

function doushisiOperation:onMoPai(acId, ids)
    local time = 0
    for idx, id in pairs(ids) do
        if time > 0 then
            self:callFunctionAfterTime(time * idx - 1, function()
                self:moOnePai(acId, id)
            end)
        else
            time = self:moOnePai(acId, id)
        end
    end
    return time * #ids
end

local poses = {
    [seatType.top]          = { pos = Vector3.New(0, 3.20, 0)},
    [seatType.right]        = { pos = Vector3.New(6.4, 0.2, 0)},
    [seatType.left]         = { pos = Vector3.New(-6.4, 0.2, 0)},
}

function doushisiOperation:moOnePai(acId, id)
    local card = self:getCardById(id)
    table.insert(self.inhandCards[acId], card)
    self:relocateInhandCards(acId)
    
    local st = self.game:getSeatTypeByAcId(acId)
    local pos, order
    local scale = 1
    if acId == self.game.mainAcId or self.game:isPlayback() then
        local cfg = self.seats[st][doushisiGame.cardType.shou]
        pos = card:getLocalPosition()
        pos = Vector3.New(pos.x, pos.y, pos.z)
        order = card:getSortingOrder()
        scale = cfg.scale
    else
        pos = poses[st].pos
        order = 0
    end

    local time = self:movePromoteCardToChu()

    return self:moPaiAction(time, acId, id, pos, order, scale)
end

function doushisiOperation:onFanPai(acId, id)
    local card = self:getCardById(id)
    table.insert(self.chuCards[acId], card)
    self:relocateChuCards(acId)

    local time = self:movePromoteCardToChu()

    card:hide()
    time = self:fanPaiAction(time, acId, id)
    return math.max(time, 1.1)
    -- return time
end

function doushisiOperation:onAnPaiShow(acId, idInfo)
    local chipengCards = self.chipengCards[acId]
    local caishen
    for _, info in pairs(chipengCards) do
        if info.op == opType.doushisi.caiShen.id then
            caishen = info
        else
            for _, c in pairs(info.cards) do
                table.insert(self.idleCards, c)
            end
        end
    end

    chipengCards = {}
    if caishen then table.insert(chipengCards, caishen) end

    for _, ids in pairs(idInfo) do
        local info = {op = opType.doushisi.an.id, cards = {}}
        for _, id in pairs(ids) do
            local card = self:getCardById(id)
            table.insert(info.cards, card)
        end
        table.insert(chipengCards, info)
    end

    self.chipengCards[acId] = chipengCards
    self:relocateChiPengCards(acId)

    if self.promoteNode and self.promoteNode.cards then
        for _, card in pairs(self.promoteNode.cards) do
            self:topCard(card)
        end
    end
    return 0
end

-----------------------------------------------------------
--chu cards op
-----------------------------------------------------------
function doushisiOperation:initChiPengCards()
    for _, player in pairs(self.game.players) do
        self.chipengCards[player.acId] = {}
        local infos = self.chipengCards[player.acId]
        for _, info in pairs(player[doushisiGame.cardType.peng]) do
            local chiPengInfo = {op = info.Op, cards = {}}
            for _, id in pairs(info.Cards) do
                local card = self:getCardById(id)
                table.insert(chiPengInfo.cards, card)
            end
            table.insert(infos, chiPengInfo)
        end
        self:relocateChiPengCards(player.acId)
    end
end

function doushisiOperation:relocateChiPengCards(acId)
    if self.style == doushisiStyle.modern then
        self:relocateChiPengCards_forModern(acId)
        return
    end
    local seatType = self.game:getSeatTypeByAcId(acId)
    local infos = self.chipengCards[acId]

    local startPos = self:getChiPengCardStartPos(seatType)

    local totalCntSincePreGroup = 0
    local colMax = 12
    local row = 0
    local col = 0
    local firstRowCnt = 0
    for pengIdx, info in pairs(infos) do
        if row == 0 then
            if totalCntSincePreGroup + #info.cards > colMax then
                firstRowCnt = totalCntSincePreGroup
                row = 1
            end
        end
        for idx, card in pairs(info.cards) do
            local pos = card:getLocalPosition()
            local pos, rot = self:getChiPengCardPos(startPos, seatType, row, totalCntSincePreGroup + idx - firstRowCnt - 1, pos)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.peng, rot)
            card:setPickabled(false)
        end
        totalCntSincePreGroup = totalCntSincePreGroup + #info.cards
    end
end

function doushisiOperation:relocateChiPengCards_forModern(acId)
    local seatType = self.game:getSeatTypeByAcId(acId)
    local infos = self.chipengCards[acId]
    local cfg = self.seats[seatType][doushisiGame.cardType.peng]
    local rot = cfg.rot
    local startPos = cfg.pos

    local col = 0
    for _, info in pairs(infos) do
        for i = 1, #info.cards, 4 do
            local max = math.min(i + 4, #info.cards)
            for j = i, max do
                local row = max - j
                local card = info.cards[j]
                local pos = card:getLocalPosition()
                local pos = self:getChiPengCardPos(startPos, seatType, row, col, pos)
                self:addCardTo(card, pos, seatType, doushisiGame.cardType.peng, rot)
                card:setPickabled(false)
            end
            col = col + 1
        end
    end
end

function doushisiOperation:getChiPengCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.peng].pos
end

function doushisiOperation:getChiPengCardPos(startPos, seatType, row, col, pos)
    local cfg = self.seats[seatType][doushisiGame.cardType.peng]
    local rsx = startPos.x + row * cfg.rowDir.x * cfg.rowgap
    local rsy = startPos.y + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

-----------------------------------------------------------
--chu cards op
-----------------------------------------------------------
function doushisiOperation:initChuCards()
    for _, player in pairs(self.game.players) do
        self.chuCards[player.acId] = {}
        local cards = self.chuCards[player.acId]
        for _, id in pairs(player[doushisiGame.cardType.chu]) do
            local card = self:getCardById(id)
            table.insert(cards, card)
        end
        self:relocateChuCards(player.acId)
    end
end

function doushisiOperation:addCardToChu(acId, card)
    local cards = self.chuCards[acId]
    table.insert(cards, card)
    self:relocateChuCards(acId)
end

function doushisiOperation:relocateChuCards(acId)
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.chuCards[acId]

    local startPos = self:getChuCardStartPos(seatType)
    for idx, card in pairs(cards) do
        local pos = card:getLocalPosition()
        local pos, rot = self:getChuCardPos(startPos, seatType, idx, pos)
        self:addCardTo(card, pos, seatType, doushisiGame.cardType.chu, rot)
        card:setPickabled(false)
    end
end

function doushisiOperation:getChuCardStartPos(st)
    return self.seats[st][doushisiGame.cardType.chu].pos
end

function doushisiOperation:getRowColForChu(idx)
    local colMax = 7
    if self.style == doushisiStyle.modern then
        colMax = 6
    end
    local row = math.floor((idx - 1) / colMax)
    local col = (idx - 1) % colMax
    return row, col
end

function doushisiOperation:getChuCardPos(startPos, seatType, idx, pos)
    local row, col = self:getRowColForChu(idx)
    local cfg = self.seats[seatType][doushisiGame.cardType.chu]
    local rsx = startPos.x + row * cfg.rowDir.x * cfg.rowgap
    local rsy = startPos.y + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

-----------------------------------------------------------
--inhand cards op
-----------------------------------------------------------
function doushisiOperation:initInhandCards()
    for _, player in pairs(self.game.players) do
        self.inhandCards[player.acId] = {}
        self:initOnePlayerInhandCards(player.acId, player[doushisiGame.cardType.shou])
    end

    self:updateLeftCardsCount()
end

function doushisiOperation:initOnePlayerInhandCards(acId, ids)
    local cards = self.inhandCards[acId]
    for _, id in pairs(ids) do
        if id >= 0 then
            local card = self:getCardById(id)
            table.insert(cards, card)
        end
    end
    self:relocateInhandCards(acId)
end

function doushisiOperation:relocateInhandCards(acId)
    if acId ~= self.game.mainAcId then
        self:relocateOtherInhandCards(acId)
        return
    end
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.inhandCards[acId]
    self.meSortedInhandCards = self:sortInhandCards(cards)

    local startPos = self:getInhandCardStartPos(seatType)
    local z = 0
    for col, cards in pairs(self.meSortedInhandCards) do
        for row, card in pairs(cards) do
            local pos = card:getLocalPosition()
            local pos, rot = self:getInhandCardPos(startPos, seatType, col, row, pos, #cards)
            self:addCardTo(card, pos, seatType, doushisiGame.cardType.shou, rot)
            pos.z = z
            card:setLocalPosition(pos)
            z = z - 0.00001
            card:setPickabled(true)
        end
    end
end

function doushisiOperation:getInhandCardPos(startPos, seatType, col, row, pos, rowHeight)
    local cfg = self.seats[seatType][doushisiGame.cardType.shou]
    local diffx = cfg.rowgap * (col - 1)
    local diffy = cfg.colgap * (rowHeight - row)
    pos.x = startPos.x + diffx
    pos.y = startPos.y + diffy
    return pos, cfg.rot
end

----------------------------------------------------------------------------------
--找牌
----------------------------------------------------------------------------------
function doushisiOperation:findCardFromInhand(acId, id, remove)
    local card = nil
    local inhandCards = self.inhandCards[acId]
    if acId == self.game.mainAcId or self.game:isPlayback() then
        for idx, card in pairs(inhandCards) do
            if id == card.id then
                if remove then
                    table.remove(inhandCards, idx)
                    self:relocateInhandCards(acId)
                end
                return card
            end
        end
    else
        -- if #inhandCards > 0 then
        --     local card = inhandCards[1]
        --     card:setId(id)
        --     if remove then
        --         table.remove(inhandCards, 1)
        --     end
        --     return card
        -- end
    end
    return nil
end

function doushisiOperation:findCardFromChuPai(id, remove)
    for acId, cards in pairs(self.chuCards) do
        for idx, c in pairs(cards) do
            if c.id == id then
                if remove then
                    table.remove(cards, idx)
                    self:relocateChuCards(acId)
                end
                return c
            end
        end
    end
end

function doushisiOperation:findCard(acId, id, remove)
    local pai = self:findCardFromInhand(acId, id, remove)
    if pai == nil then
        pai = self:findCardFromChuPai(id, remove)
    end
    if pai == nil then
        pai = self:getCardById(id)
    end
    return pai
end

function doushisiOperation:findAndRemoveCard(acId, id)
    return self:findCard(acId, id, true)
end

----------------------------------------------------------------------------------
--touch
----------------------------------------------------------------------------------
function doushisiOperation:getInhandCardStartPos(st)
    if st ~= seatType.mine then
        return Vector3.zero
    else
        return self.seats[st][doushisiGame.cardType.shou].pos
    end
end

function doushisiOperation:topCard(card)
    card:setSortingOrder(self.sortOrder)
    self.sortOrder = self.sortOrder + 1
end

function doushisiOperation:showLeftCards()
    self.leftCards:show()
    self.leftCardsModel:show()
    self.leftCardsNum:show()
    self.leftCardsNumL:show()
    self.leftCardsNumH:show()
end

function doushisiOperation:hideLeftCards()
    self.leftCards:hide()
end

function doushisiOperation:updateLeftCardsCount(cnt)
    if cnt == nil then
        cnt = self.game:getLeftCardsCount()
    end

    if cnt <= 0 then
        self.leftCardsModel:hide()
        self.leftCardsNum:hide()
    else
        self.leftCardsModel:show()
        self.leftCardsNum:show()

        local total = self.game:getTotalCardsCount()
        local M = math.max(1, math.floor(10 - 10 * cnt / total))
        self.leftCardsModel:setSprite(tostring(M))

        local L = cnt % 10
        self.leftCardsNumL:setSprite(tostring(L))

        local H = math.floor(cnt / 10)
        if H == 0 then
            self.leftCardsNumH:hide()
            self.leftCardsNumL:setLocalPosition(Vector3.zero)
        else
            self.leftCardsNumH:setSprite(tostring(H))
            self.leftCardsNumL:setLocalPosition(Vector3.New(0.11, 0, 0))
        end

        local y = LEFT_CARDS_NUM_POS_Y - 0.02 * (M - 1)
        self.leftCardsNum:setLocalPosition(Vector3.New(0, y, 0))
    end
end

function doushisiOperation:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    self:reset()
    self:showLeftCards()

    for _, card in pairs(self.allCards) do
        card:destroy()
    end

    for _, card in pairs(self.allActionCards) do
        card:destroy()
    end

    for _, node in pairs(self.flyNodes) do
        GameObject.Destroy(node.gameObject)
    end

    base.onDestroy(self)
end

function doushisiOperation:getCardByGo(go)
    local cards = self.inhandCards[self.game.mainAcId]

    for _, c in pairs(cards) do
        if c.gameObject == go then
            return c
        end
    end

    return nil
end

function doushisiOperation:touchHandler(phase, pos)
    if not self.canChuPai then
        return
    end
    local camera = GameObjectPicker.instance.camera

    if phase == touch.phaseType.began then
        local go = GameObjectPicker.instance:Pick(pos)
        if go ~= nil then
            local clickCard = self:getCardByGo(go)
            if clickCard == nil then
                return
            end
            if not clickCard.canChu then
                return
            end
            local preSelectedCard = self.curSelectdCard
            self.curSelectdCard = clickCard

            self.isClick = true
            if preSelectedCard and preSelectedCard ~= clickCard then
                preSelectedCard:setSelected(false)
            end
            local cardPos = self.curSelectdCard:getLocalPosition()
            if self.curSelectdCard ~= nil then
                local cpos = camera.transform.localPosition
                pos.z = cardPos.z - cpos.z
                self.selectedLastPos = camera:ScreenToWorldPoint(pos)
                self.selectedStartPos = self.selectedLastPos
                self.startMove = false
            end
            self.dragCard:setId(self.curSelectdCard.id)
            self:addCardTo(self.dragCard, cardPos, seatType.mine, doushisiGame.cardType.perfect)
        else
            if self.curSelectdCard then
                self.curSelectdCard:setSelected(false)
                self.curSelectdCard = nil
            end
        end
    elseif phase == touch.phaseType.moved then
        if self.curSelectdCard ~= nil then
            local mpos = self.dragCard:getPosition()
            local cpos = camera.transform.localPosition
            pos.z = mpos.z - cpos.z
            local wpos = camera:ScreenToWorldPoint(pos)
            local dpos = wpos - self.selectedStartPos
            if not self.startMove and dpos:Magnitude() > 0.010 then
                self.isClick = false
                self.startMove = true
            end
        
            if self.startMove then
                local dpos = wpos - self.selectedLastPos
                mpos = Vector3.New(mpos.x + dpos.x, mpos.y + dpos.y, mpos.z)
                self.dragCard:setPosition(mpos)
                self.selectedLastPos = wpos
            end
        end
    else
        self.dragCard:hide()
        if self.curSelectdCard ~= nil then
            if self.isClick then
                if self.curSelectdCard.selected then
                    if self.canChuPai then
                        self.curSelectdCard:setSelected(false)
                        self:onChoseChuPai(self.curSelectdCard)
                        self.curSelectdCard = nil
                    else
                        self.curSelectdCard:setSelected(false)
                        self.curSelectdCard = nil
                    end
                else
                    self.curSelectdCard:setSelected(true)
                end
            else
                self.curSelectdCard:setSelected(false)
                if self.canChuPai then
                    local mpos = self.dragCard:getPosition()
                    local cpos = camera.transform.localPosition
                    pos.z = mpos.z - cpos.z
                    local wpos = camera:ScreenToWorldPoint(pos)
                    if wpos.y > self.chuPaiLineY then
                        self:onChoseChuPai(self.curSelectdCard)
                    end
                end
                self.curSelectdCard = nil
            end
        end
    end
end

function doushisiOperation:onChoseChuPai(card)
    local id = card.id
    local sendData = self:getOpChoseData(opType.doushisi.chu.id, id, nil, nil)
    networkManager.csOpChose(sendData)
    self.canChuPai = false

    self:virtureChu(card)
end

---------------------------------------------------------
--排序
---------------------------------------------------------
function doushisiOperation:getCardType(card)
    return doushisiType.getDoushisiTypeId(card)
end

function doushisiOperation:getCardDescByType(idx)
    return doushisiType.getDoushisiTypeByTypeId(idx)
end

function doushisiOperation:adjustValue(value)
    if value <= 7 then 
        return value 
    end
    return 14 - value
end

function doushisiOperation:sortInhandCards(oripais)
    local cntvec = {}
    for _, pai in ipairs(oripais) do
        local typ = self:getCardType(pai.id)
        if cntvec[typ] == nil then
            local desc = self:getCardDescByType(typ)
            cntvec[typ] = {dianshu = self:getCardDescByType(typ).value, typ = typ, cards = {}}
        end
        table.insert(cntvec[typ].cards, pai)
    end

    --class dian = {dian = 2, cnts = {cnt, cnt}}
    local dianvec = {}
    for i = 0, 23 do
        local cnt = cntvec[i]
        if cnt then
            local dian = cnt.dianshu
            local dian = self:adjustValue(dian)
            if dianvec[dian] == nil then
                dianvec[dian] = {dian = dian, cnts = {}}
            end
            table.insert(dianvec[dian].cnts, cnt)
        end
    end

    local function getDianPaiCnt(dian)
        local paicnt = 0
        for _, cnt in pairs(dian.cnts) do
            paicnt = paicnt + #cnt.cards
        end
        return paicnt
    end
    local function getDianPais(dian)
        local ret = {}
        for _, cnt in pairs(dian.cnts) do
            for _, pai in pairs(cnt.cards) do
                table.insert(ret, pai)
            end
        end
        return ret
    end

    local ret = {}
    for i = 0,7 do
        local dian = dianvec[i]
        if dian then
            local paicnt = getDianPaiCnt(dian)
            if paicnt <= 4 then
                table.insert(ret, getDianPais(dian))
            else
                local tmp = {}
                local preDianShu = -1
                local leftcnt = paicnt
                for _, cnt in pairs(dian.cnts) do
                    local hasProcess = false
                    if #tmp + #cnt.cards <= 4 then
                        local needProcess = false
                        if preDianShu == -1 or cnt.dianshu == preDianShu then
                            needProcess = true
                        end
                        if not needProcess then
                            if #tmp + leftcnt <= 4 then
                                needProcess = true
                            end
                        end

                        if needProcess then
                            for _, pai in pairs(cnt.cards) do
                                table.insert(tmp, pai)
                            end
                            hasProcess = true
                        end
                    end
                    if not hasProcess then
                        table.insert(ret, tmp)
                        tmp = {}
                        for _, pai in pairs(cnt.cards) do
                            table.insert(tmp, pai)
                        end
                    end
                    preDianShu = cnt.dianshu
                    leftcnt = leftcnt - #cnt.cards
                end
                if #tmp > 0 then
                    table.insert(ret, tmp)
                end
            end
        end
    end
    return ret
end

----------------------------------------------------------------------------------------
--动画
----------------------------------------------------------------------------------------
---------------吃 碰 按 滑------------------------
function doushisiOperation:chiPengAction(acId, cards, widthoutScale)
    local ids = {}
    for _, card in pairs(cards) do
        card:hide()
        table.insert(ids, card.id)
    end
    local node = self:createFlyNode(ids)
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].action

    --promote pos
    local x1, y1 = cfg.pos.x, cfg.pos.y

    -- local top = y1 + (SHOUPAI_HEIGHT + SHOUPAI_GAP * (#pais - 1)) * 0.5
    -- if top > safeArea.top then
    --     local diff = top - safeArea.top
    --     y1 = y1 - diff
    -- end

    local cfg = self.seats[st][doushisiGame.cardType.peng]
    local x, y = 0, 0
    for _, card in pairs(cards) do
        local pos = card:getLocalPosition()
        x = x + pos.x
        y = y + pos.y
    end
    x = x / #cards
    y = y / #cards


    local shakeAction, shakeTime = self:getShakeAction(node)
    local flyAction, flyTime = self:getFlyAction(node, x1, y1, x, y, cfg.rotEuler.z, 0.6, nil, 1)
    node:setLocalPosition(Vector3.New(x1, y1, 0))
    node:show()

    if self.style == doushisiStyle.traditional then
        if node.cards and #node.cards == 1 then
            for _, card in pairs(node.cards) do
                card:setSortingOrder(cards[#cards]:getSortingOrder())
            end
        end
    end

    if not widthoutScale then
        self.animationManager:add(shakeAction)
        shakeAction:play()

        local delayAction = self:getDelayAction(shakeTime + 0.1)
        local seqAction = self:getSequenceAction({delayAction, flyAction, tweenFunction.new(function()
            self:pushFlyNode(node)
            self:relocateChiPengCards(acId)
        end)}, true)
        self.animationManager:add(seqAction)
        seqAction:play()

        local added = 0.03 * ((#seqAction.queue + 1) * 2 + 1)
        return shakeTime + flyTime + added
    else
        local seqAction = self:getSequenceAction({flyAction, tweenFunction.new(function()
            self:pushFlyNode(node)
            self:relocateChiPengCards(acId)
        end)})
        self.animationManager:add(seqAction)
        seqAction:play()

        local added = 0.03 * ((#seqAction.queue + 1) * 2 + 1)
        return flyTime + added
    end
end

---------------------摸牌
function doushisiOperation:moPaiAction(time, acId, id, handPos, order, scale)
    if id >= 0 then
        local card = self:findCard(acId, id)
        card:hide()
    end
    local node = self:createFlyNode({id})
    self:setNodeAtCenter(node)

    -- local centerScaleAction, t1 = self:getCenterScaleAction(node)
    -- local delayTime = 0.1
    -- local centerDelayAction = self:getDelayAction(delayTime)

    local startPos = node:getLocalPosition()
    --promote pos
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote
    local x2, y2 = cfg.pos.x, cfg.pos.y

    local r = cfg.rotEuler.z
    local flyAction, flyTime = self:getFlyAction(node, startPos.x, startPos.y, x2, y2, r)
    local delayTime2 = 0.2
    local delayAction2 = self:getDelayAction(delayTime2)
    local flyAction2, flyTime2 = self:getFlyAction(node, x2, y2, handPos.x, handPos.y, nil, scale, nil, 1)
    -- log(string.format( "fly1: %f  fly2: %f fly3: %f", flyTime, delayTime2, flyTime2 ))

    --local sq = self:getSequenceAction({centerScaleAction, centerDelayAction, flyAction, delayAction2, flyAction2, tweenFunction.new(function()
    local sq = self:getSequenceAction({flyAction, delayAction2, flyAction2, tweenFunction.new(function()
        self:pushFlyNode(node)
        self:relocateInhandCards(acId)
    end)})
    if order > 0 then
        if node.cards then
            for _, c in pairs(node.cards) do
                c:setSortingOrder(order)
            end
        end
    end
    if acId == self.game.mainAcId then
        if node.cards then
            for _, c in pairs(node.cards) do
                c:setPickabled(true)
            end
        end
    end

    local function playSq()
        self.animationManager:add(sq)
        sq:play()

        self:updateLeftCardsCount()
    end

    if time > 0 then
        node:hide()
        self:callFunctionAfterTime(time, function()
            node:show()
            playSq()
        end)
    else
        playSq()
    end

    local added = 0.03 * ((3 + 1) * 2 + 1)
    --return t1 + delayTime + flyTime + delayTime2 + flyTime2 + added + time
    return flyTime + delayTime2 + flyTime2 + added + time
end

function doushisiOperation:fanPaiAction(time, acId, id)
    local x1, y1 = self:getCenterFanPaiPos()
    --promote pos
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st].promote
    local x2, y2 = cfg.pos.x, cfg.pos.y

    -- local _, t1 = self:getCenterScaleAction(nil)
    -- local delayTime = 0.05
    local flyTime = self:computeFlyTime(x1, y1, x2, y2)

    local fanFunc = function()
        local node = self:createFlyNode({id})
        self:setNodeAtCenter(node)
        --local centerScaleAction, t1 = self:getCenterScaleAction(node)
        --local centerDelayAction = self:getDelayAction(delayTime)
        local nodePos = node:getLocalPosition()
        local r = cfg.rotEuler.z
        local flyAction, flyTime = self:getFlyAction(node, nodePos.x, nodePos.y, x2, y2, r)
        -- local seqAction = self:getSequenceAction({centerScaleAction, centerDelayAction, flyAction})
        local func = tweenFunction.new(function()
            --play sound for card
            local player = self.game:getPlayerByAcId(acId)
            playDoushisiSound(self.game.cityType, id, player.sex)
        end)
        local seqAction = self:getSequenceAction({flyAction, func})
        self.animationManager:add(seqAction)
        seqAction:play()

        node.acId = acId
        node.chufan = 2
        node.id = id
        self.promoteNode = node

        self:updateLeftCardsCount()
    end
    
    if time > 0 then
        self:callFunctionAfterTime(time, function()
            fanFunc()
        end)
    else
        fanFunc()
    end
    local added = 0.03 * ((1 + 1) * 2 + 1)
    return time + flyTime + added
end

function doushisiOperation:pushBackPromoteNode()
    if self.promoteNode then
        self:pushFlyNode(self.promoteNode)
        self.promoteNode = nil
    end
end

function doushisiOperation:movePromoteCardToChu()
    if self.promoteNode == nil then
        return 0
    end
    local node = self.promoteNode
    self.promoteNode = nil

    local acId = node.acId
    local id = node.id
    local pai = self:findCard(acId, id)
    local st = self.game:getSeatTypeByAcId(acId)
    local cfg = self.seats[st][doushisiGame.cardType.chu]
    local x2, y2 = cfg.pos.x, cfg.pos.y

    --end pos
    local pos = pai:getLocalPosition()
    local x2 = pos.x
    local y2 = pos.y
    --start pos
    local startPos = node:getLocalPosition()
    local flyAction, flyTime = self:getFlyAction(node, startPos.x, startPos.y, x2, y2, cfg.rotEuler.z, 0.6)
    local func = function()
        self:pushFlyNode(node)
        self:relocateChuCards(acId)
    end
    local cb = tweenFunction.new(func)

    local seqAction = self:getSequenceAction({flyAction, cb})
    self.animationManager:add(seqAction)
    seqAction:play()

    return flyTime + 0.1
end

----------------------------------------------------------------------------------------
--base
----------------------------------------------------------------------------------------
function doushisiOperation:callFunctionAfterTime(time, func)
    local delay = self:getDelayAction(time)
    local func = tweenFunction.new(func)
    local se = self:getSequenceAction({delay, func})
    self.animationManager:add(se)
    se:play()
end

function doushisiOperation:getCenterFanPaiPos()
    local x, y = 0, 0
    return x, y + 1.2
end

function doushisiOperation:setNodeAtCenter(node)
    local cx, cy = self:getCenterFanPaiPos()
    node:show()
    node:setLocalPosition(Vector3.New(cx, cy, 0))
    node:setLocalRotation(Quaternion.Euler(0, 0, 90))
    --node:setLocalScale(Vector3.New(0.1, 0.1, 0.1))
end
function doushisiOperation:getCenterScaleAction(node)
    local time = 0.05
    local action 
    if node then
        action = tweenScale.new(node, time, node:getLocalScale(), Vector3.one)
    end
    return action, time
end

function doushisiOperation:getSequenceAction(actions, im)
    im = true
    local t = tweenSerial.new(true, im)
    for _, a in pairs(actions) do
        t:add(a)
    end
    return t
end

function doushisiOperation:getDelayAction(delayTime)
    return tweenDelay.new(delayTime)
end

function doushisiOperation:getShakeAction(node)
    local smax = 1.1
    local sNormal = 1
    local t = self.shakepaitime
    local aMax = tweenScale.new(node, t / 2, Vector3.one, Vector3.New(smax, smax, smax))
    local aNormal = tweenScale.new(node, t / 2, Vector3.New(smax, smax, smax), Vector3.one)
    local action = tweenSerial.new(true)
    action:add(aMax)
    action:add(aNormal)
    return action, t
end

function doushisiOperation:popFlyNode()
    local node = self.idleFlyNodes[1]
    if not node then
        node = GameObject("flynode")
        local base = require("common.object")
        node = base.new(node)
        node:setParent(self.cardRoot)
        table.insert(self.flyNodes, node)
        self:pushFlyNode(node)
    end
    table.remove(self.idleFlyNodes, 1)
    node.cards = nil
    return node
end

function doushisiOperation:pushFlyNode(node)
    node:hide()
    if node.cards then
        for _, card in pairs(node.cards) do
            self:pushbackActionCard(card)
        end
    end
    node.cards = nil
    node:setLocalRotation(Quaternion.Euler(0, 0, 0))
    node:setLocalScale(Vector3.one)
    for _, t in pairs(self.idleFlyNodes) do
        if t == node then
            --printError("repush back node.")
        end
    end
    table.insert(self.idleFlyNodes, node)
end

function doushisiOperation:createFlyNode(ids)
    local cards = {}
    local poses = {}
    local cnt = #ids
    local dis = (cnt - 1) * actionCardGap
    local sy = dis / cnt

    local node = self:popFlyNode()
    for _, id in pairs(ids) do
        local card = self:getActionCardById(id)
        self:addCardTo(card, Vector3.New(0, sy, 0), nil, doushisiGame.cardType.perfect, Vector3.zero, Vector3.one, node)
        table.insert(cards, card)
        sy = sy - actionCardGap
    end
    node.cards = cards
    return node
end

function doushisiOperation:computeFlyTime(x1, y1, x2, y2, time) 
    if time then
        return time
    end
    local d1 = math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2)
    local dis = math.sqrt(d1)
    local speed = 11.40 --pixels per second
    local time = dis / speed
    if time < 0.22 then
        time = 0.22
    end
    if time > 0.26 then
        time = 0.26
    end
    return time
end

function doushisiOperation:getFlyAction(node, x1, y1, x2, y2, r2, s2, r1, s1, time)
    local flyTime = self:computeFlyTime(x1, y1, x2, y2, time)

    local mvaction = tweenPosition.new(node, flyTime, Vector3.New(x1, y1, 0), Vector3.New(x2, y2, 0))
    local actions = {}
    if r2 then
        local rotation = node.transform.localEulerAngles
        if r1 then
            rotation = Vector3.New(0, 0, r1)
        end
        local raction = tweenRotation.new(node, flyTime, rotation, Vector3.New(0, 0, r2))
        table.insert(actions, raction)
    end
    if s2 then
        local scale = node:getLocalScale()
        if s1 then
            scale = Vector3.New(s1, s1, scale.z)
        end
        local saction = tweenScale.new(node, flyTime, scale, Vector3.New(s2, s2, scale.z))
        table.insert(actions, saction)
    end 
    if #actions > 0 then
        table.insert(actions, 1, mvaction)
        local tp = tweenParallel.new(true)
        for _, ac in pairs(actions) do
            tp:add(ac)
        end
        return tp, flyTime
    else
        return mvaction, flyTime
    end
end

function doushisiOperation:onCloseAllUIHandler()
    self:close()
end

---------------------------------------------------------------------------------------------------
--playback
---------------------------------------------------------------------------------------------------
function doushisiOperation:relocateOtherInhandCards(acId)
    if not self.game:isPlayback() then
        return
    end
    local seatType = self.game:getSeatTypeByAcId(acId)
    local cards = self.inhandCards[acId]

    table.bubbleSort(cards, function(t1, t2)
        return t1.id <= t2.id
    end)

    local st = self.game:getSeatTypeByAcId(acId)
    local startPos = self.seats[st][doushisiGame.cardType.shou].pos
    for idx, card in pairs(cards) do
        local pos = card:getLocalPosition()
        local pos, rot = self:computeOtherInhandPos(st, startPos.x, startPos.y, idx, pos)
        self:addCardTo(card, pos, st, doushisiGame.cardType.peng, rot, nil, nil)
    end
end

function doushisiOperation:computeOtherInhandPos(st, sx, sy, idx, pos)
    local cfg = self.seats[st][doushisiGame.cardType.shou]
    local row = 0
    local rowMax = 10
    if idx > 10 then
        row = 1
    end
    local col = (idx - 1) % 10
    local rsx = sx + row * cfg.rowDir.x * cfg.rowgap
    local rsy = sy + row * cfg.rowDir.y * cfg.rowgap
    local x = rsx + col * cfg.colDir.x * cfg. colgap
    local y = rsy + col * cfg.colDir.y * cfg. colgap
    pos.x = x
    pos.y = y
    return pos, cfg.rot
end

return doushisiOperation
