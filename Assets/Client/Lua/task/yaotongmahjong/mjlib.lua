local eye_table = {}
local syz_table = {}
for i = 0,8 do
    eye_table[i] = require(string.format("task.yaotongmahjong.tbl.eye_table_%d", i))
    syz_table[i] = require(string.format("task.yaotongmahjong.tbl.table_%d", i))
end

local function check(eye, tyCnt, key)
    local t = nil
    if eye then
        t = eye_table
    else
        t = syz_table
    end
    local tbl = t[tyCnt]
    if tbl == nil then
        return false
    end
    if tbl[key] == nil then
        return false
    end
    return true
end

local function typeIDToID(tid)
    return 4 * (tid - 1)
end

--------------------------------------------------------------
--
--------------------------------------------------------------
local fanXingType = {
    su                  = 0,
    qingYiSe            = 1,
    qiDui               = 2,
    daDuiZi             = 3,
    jinGouDiao          = 4,
    hunYiSe             = 5,
    jiangDui            = 6,
    yaoJiu              = 7,
    menQing             = 8,
    zhongZhang          = 9,
    jiangQiDui          = 10,
    jiaXinWu            = 11,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
local opType = {
    mo   = { id = 0, },
    chu  = { id = 1, },
    chi  = { id = 2, },
    peng = { id = 3, },
    gang = { id = 4, 
             detail = { angang              = 4, 
                        bagangwithmoney     = 1, 
                        bagangwithoutmoney  = 2, 
                        minggang            = 3, 
	                    zhuanyu             = 32,
                        fanyu               = 33,
             } 
    },
    hu = { id = 5, 
           detail = { zimo          = 10, 
                      dianpao       = 11, 
                      qianggang     = 12, 
                      gangshanghua  = 13, 
                      gangshangpao  = 14, 
                      haidilao      = 15,
                      haidipao      = 16, 
                      tianhu        = 17,
	                  dihu          = 18,
	                  chahuazhu     = 30,
                      chajiao       = 31,
                      bijiao        = 34,
           } 
    },
    guo  = { id = 6 },
    dui  = { id = 8 },
}

local mjlib = {}

mjlib.opType = opType
mjlib.fanXingType = fanXingType
mjlib.TYReplaceId = 200
-------------------------快速检测合法性---------------------------------
local function _splitHu(cards, tyCnt, s, e, chi, hasEyeBefore)
    local key = 0
    local cardsNum = 0
    for i = s, e do
        key = key * 10 + cards[i]
        cardsNum = cardsNum + cards[i]
    end
    if cardsNum == 0 then
        return true, 0, hasEyeBefore
    end
    for i = 0, tyCnt do
        local yu = (cardsNum + i) % 3
        if hasEyeBefore then
            if yu == 0 then
                if check(false, i, key) then
                    return true, i, hasEyeBefore 
                end
            end
        else
            if yu ~= 1 then
                local eye = (yu == 2)
                if check(eye, i, key) then
                    return true, i, eye
                end
            end
        end
    end
    return false, 0, false
end
local function checkOk(cards, tyCnt, hasEyeBefore)
    local ok, useTy, hasEye = _splitHu(cards, tyCnt, 1, 9, true, hasEyeBefore)
    if not ok then
        return false
    end
    tyCnt = tyCnt - useTy
    ok, useTy, hasEye = _splitHu(cards, tyCnt, 10, 18, true, hasEye)
    if not ok then
        return false
    end
    tyCnt = tyCnt - useTy
    ok, useTy, hasEye = _splitHu(cards, tyCnt, 19, 27, true, hasEye)
    if not ok then
        return false
    end
    return true
end
function mjlib.canSYZ(cards, tyCnt)
    return checkOk(cards, tyCnt, true)
end
function mjlib.canHu(cards, tyCnt)
    return checkOk(cards, tyCnt, false)
end

-------------------------------找到胡的所有组合----------------------------
local function findChiPengZu(cards, tyCnt, id)
    ret = newsizedtable(4, 0)
    if cards[id]+tyCnt >= 3 then
        local usedIdCnt = math.min(cards[id], 3)
        table.insert(ret, {
                ty = 3 - usedIdCnt,
                op = opType.peng.id,
                use = {{ id = id, cnt = usedIdCnt }},
                cs = {typeIDToID(id), typeIDToID(id), typeIDToID(id)},
            })
    end

    local remain = (id - 1) % 9
    local base = (id - 1) - remain
    local minIdx = math.max(0, remain - 2)
    local maxIdx = math.min(remain + 2, 8)
    local findId = newsizedtable(2)
    for re = minIdx+1, maxIdx+1 do
        if re+2 > maxIdx+1 then
            break
        end
        for i = re,re+2 do
            local idx = base + i
            if idx ~= id and cards[idx] > 0 then
                table.insert(findId, idx)
            end
        end
        if #findId+tyCnt >= 2 then
            local chipeng =  {
                ty = 2 - #findId,
                op = opType.chi.id,
                cs = {typeIDToID(base + re), typeIDToID(base + re + 1), typeIDToID(base + re + 2)},
                use = newsizedtable(1 + #findId),
            }
            table.insert(chipeng.use, { id = id, cnt = 1 })
            local len = #findId
            for i = 1, len do
                table.insert(chipeng.use, {id = findId[i], cnt = 1})
                findId[i] = nil
            end

            table.insert(ret, chipeng)
        else
            local len = #findId
            for i = 1, len do
                findId[i] = nil
            end
        end
    end


    return ret
end
local function isAllKan(cards, tyCnt, huCs, ret)
    assert(tyCnt >= 0, "tyCnt must gle zero")
    if not mjlib.canSYZ(cards, tyCnt) then
        return
    end
    local findId 
    for i = 1, 27 do
        if cards[i] > 0 then
            findId = i
            break
        end
    end
    if not findId then--找完了
        local tmp = newsizedtable(#huCs.c)
        for i = 1,#huCs.c do
            table.insert(tmp, huCs.c[i])
        end
        local tHucs = {tyLeft = tyCnt, tyDui = huCs.tyDui, c = tmp}
        table.insert(ret.huC, tHucs)
        -- printInfo("not find id, intert a result.%s %d %d", table.tojson(tmp), #tmp,  tyCnt)
        return
    end
    local chiPeng = findChiPengZu(cards, tyCnt, findId)
    if #chiPeng == 0 then
        return
    end
    for _, info in pairs(chiPeng) do
        for _, cardUse in pairs(info.use) do
            cards[cardUse.id] = cards[cardUse.id] - cardUse.cnt
        end
        tyCnt = tyCnt - info.ty
        table.insert(huCs.c, {Cs = info.cs, Op = info.op})

        isAllKan(cards, tyCnt, huCs, ret)

        table.remove(huCs.c)
        for _, cardUse in pairs(info.use) do
            cards[cardUse.id] = cards[cardUse.id] + cardUse.cnt
        end
        tyCnt = tyCnt + info.ty
    end
end
local function findNormalHuComponent(cards, tyCnt, ret)
    local huCs = {tyLeft = 0, tyDui = false, c = {}}
    for i = 1, 27 do
        local isub = 0
        local tysub = 0
        if cards[i] > 0 and cards[i] + tyCnt >= 2 then
            isub = math.min(cards[i], 2)
            tysub = 2 - isub
            cards[i] = cards[i] - isub
            tyCnt = tyCnt - tysub
            table.insert(huCs.c, {Cs = {typeIDToID(i), typeIDToID(i)}, Op = opType.dui.id})

            isAllKan(cards, tyCnt, huCs, ret)

            table.remove(huCs.c)
            cards[i] = cards[i] + isub
            tyCnt = tyCnt + tysub
        end
    end
    if tyCnt >= 2 then
        tysub = 2
        tyCnt = tyCnt - tysub
        table.insert(huCs.c, {Cs = {mjlib.TYReplaceId, mjlib.TYReplaceId}, Op = opType.dui.id})

        isAllKan(cards, tyCnt, huCs, ret)

        table.remove(huCs.c)
        tyCnt = tyCnt + tysub
    end
end
local function find7DuiHuComponent(cards, tyCnt, ret)
    local cnt = 0
    local singleCnt = 0
    for _, v in pairs(cards) do
        cnt = cnt + v
        if v % 2 == 1 then
            singleCnt = singleCnt + 1
        end
    end
    if cnt + tyCnt ~= 14 then
        return false
    end
    if singleCnt > tyCnt then
        return false
    end

    local huCs = {tyDui = false, tyLeft = tyCnt - singleCnt, is7D = true, c = {}}
    for id, v in pairs(cards) do
        if v > 0 then
            local remain = v % 2
            local s = math.floor(v / 2)
            for i = 1,s do
                table.insert(huCs.c, {Op = opType.dui.id, Cs = {typeIDToID(id), typeIDToID(id)}})
            end
            if remain == 1 then
                table.insert(huCs.c, {Op = opType.dui.id, Cs = {typeIDToID(id), typeIDToID(id)}})
            end
        end
    end
    table.insert(ret.huC, huCs)
    return true
end

function mjlib.findHuComponent(cards, tyCnt)
    if not mjlib.canHu(cards, tyCnt) then
        return nil
    end
    local ret = {huC = {}, times = 0}
    findNormalHuComponent(cards, tyCnt, ret)
    find7DuiHuComponent(cards, tyCnt, ret)
    return ret.huC
end

--reutrn huase 1-3  value: 1-9 typ: 1-30
function mjlib.parseMJId(id)
    local tid = math.floor(id / 4)
    local hs = math.floor( tid / 9 )
    local value = tid % 3
    return hs + 1, value + 1, tid + 1
end

return mjlib
