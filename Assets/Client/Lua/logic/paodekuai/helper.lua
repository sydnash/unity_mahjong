--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")

local helper = {}

helper.CardArray = pokerType.c

function helper.cardDesc(id)
	return helper.CardArray[id]
end

local Card2Value = 15
local CardXiaoWangValue = 16
local CardDaWangValue = 17
local CardHuaHuaValue = 18

local function hasNotLianCard(vec)
    if vec[Card2Value].cnt > 0 then
		return true
	end

	if vec[CardXiaoWangValue].cnt > 0 then
		return true
    end

	if vec[CardDaWangValue].cnt > 0 then
		return true
    end

	if vec[CardHuaHuaValue].cnt > 0 then
		return true
    end

	return false
end

local	PDKPaiXingNone            = -1
local	PDKPaiXingDanZhang        = 0
local	PDKPaiXingDuiZi           = 1
local	PDKPaiXingSanZhang        = 2
local	PDKPaiXingSanDaiYi        = 3
local	PDKPaiXingSanDaiEr        = 4
local	PDKPaiXingLianZi          = 5
local	PDKPaiXingLianDui         = 6
local	PDKPaiXingFeiJi           = 7
local	PDKPaiXingFeiJiDaiChiBang = 8
local	PDKPaiXingZhaDan          = 9
local	PDKPaiXingSiDaiEr         = 10
local	PDKPaiXingSiDaiSan        = 11
local	PDKPaiXingSiDaiYi         = 12

local paixing = {
    none              = PDKPaiXingNone,
    danZhang          = PDKPaiXingDanZhang,
    duiZi             = PDKPaiXingDuiZi,
    sanZhang          = PDKPaiXingSanZhang,
    sanDaiYi          = PDKPaiXingSanDaiYi,
    sanDaiEr          = PDKPaiXingSanDaiEr,
    lianZi            = PDKPaiXingLianZi,
    lianDui           = PDKPaiXingLianDui,
    feiJi             = PDKPaiXingFeiJi,
    feiJiDaiChiBang   = PDKPaiXingFeiJiDaiChiBang,
    zhaDan            = PDKPaiXingZhaDan,
    siDaiEr           = PDKPaiXingSiDaiEr,
    siDaiSan          = PDKPaiXingSiDaiSan,
    siDaiYi           = PDKPaiXingSiDaiYi,
}
helper.paixing = paixing

----------------------------------------------------------------
--按照value分类手牌 返回一个 {cnt = 3, ids= {0, 1}, v = v} 的数组
----------------------------------------------------------------
local function classifyShouPai(shouPai)
    local vec = {}
    for i = 1, 20 do
        vec[i] = {cnt = 0, ids = {}, v = i}
    end
    for _, pai in ipairs(shouPai) do
        local id = pai.id
        local desc = helper.cardDesc(id)
        local v = desc.value
        if vec[v] == nil then
            vec[v] = {cnt = 0, ids = {}, v = v}
        end
        local info = vec[v]
        info.cnt = info.cnt + 1
        table.insert(info.ids, id)
    end
    return vec
end

helper.classifyShouPai = classifyShouPai

local function classifyIds(ids)
    local vec = {}
    for i = 1, 20 do
        vec[i] = {cnt = 0, ids = {}, v = i}
    end
    for _, id in ipairs(ids) do
        local desc = helper.cardDesc(id)
        local v = desc.value
        if vec[v] == nil then
            vec[v] = {cnt = 0, ids = {}, v = v}
        end
        local info = vec[v]
        info.cnt = info.cnt + 1
        table.insert(info.ids, id)
    end
    return vec
end

local function findPXMax(cs, cnt)
	local vec = classifyIds(cs)
	local value1 = 0
    local liancnt = 0
    local tmp = {}
    local pre = -1
	for v, t in ipairs(vec) do
        if t.cnt == cnt then
            if pre == -1 then
                table.insert(tmp, {v = v, lc = 1})
            elseif v - pre == 1 then
                tmp[#tmp].v = v
                tmp[#tmp].lc = tmp[#tmp].lc + 1
            elseif v - pre > 1 then
                table.insert(tmp, {v = v, lc = 1})
            end
            pre = v
		end
    end
    for _, info in ipairs(tmp) do
        if info.lc >= liancnt then
            value1 = info.v
            liancnt = info.lc
        end
    end
	return value1, liancnt
end
helper.findPXMax = findPXMax

local function compaireDaXiao(ori, cur, cnt)
	local value1, _ = findPXMax(ori, cnt)
	local value2, _ = findPXMax(cur, cnt)
	return value2 > value1
end
helper.compaireDaXiao = compaireDaXiao

local function findZhaDan(shouPai)
    local ret = {}
    local vec = classifyShouPai(shouPai)
    for _, v in ipairs(vec) do
        if v.cnt == 4 then
            table.insert(ret, v.ids)
        end
    end
    return ret
end

local function isInExcepts(v, excepts)
    local pos = table.indexOf(excepts, v)
    if not pos then return false end
    return true
end
helper.isInExcepts = isInExcepts

local function findSingle(vec, cnt, excepts)
    local ret = {}
    for v, info in ipairs(vec) do
        if info.cnt == 1 and not isInExcepts(v, excepts) then
            table.insert(ret, info.ids[1])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
        end
    end
    if cnt == 0 then return ret end
    for v, info in ipairs(vec) do
        if info.cnt == 2 and not isInExcepts(v, excepts) then
            table.insert(ret, info.ids[1])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[2])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
        end
    end
    if cnt == 0 then return ret end
    for v, info in ipairs(vec) do
        if info.cnt == 3 and not isInExcepts(v, excepts) then
            table.insert(ret, info.ids[1])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[2])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[3])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
        end
    end
    if cnt == 0 then return ret end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and not isInExcepts(v, excepts) then
            table.insert(ret, info.ids[1])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[2])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[3])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
            table.insert(ret, info.ids[4])
            cnt = cnt - 1
            if cnt <= 0 then
                break
            end
        end
    end
    return ret
end
helper.findSingle = findSingle

local function addZhaDan(ret, zhadan)
    for _, t in ipairs(zhadan) do
        table.insert(ret, t)
    end
    return ret
end

local cardDesc = helper.cardDesc
local danzhang = {}
function danzhang.check(ids) 
    if #ids == 1 then
        return true
    end
    return false
end

function danzhang.compair(ori, cur) 
	if #ori ~= #cur then
		return false
	end
	local desc1 = cardDesc(ori[1])
	local desc2 = cardDesc(cur[1])
	return desc2.value > desc1.value
end

function danzhang.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    local ret = {}
    local vec = classifyShouPai(shouPai)

    local v1 = cardDesc(ori[1]).value
    for v, info in ipairs(vec) do
        if info.cnt == 1 and v > v1 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 2 and v > v1 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 3 and v > v1 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            table.insert(ret, {info.ids[1]})
        end
    end

    addZhaDan(ret, zhadan)
    return ret
end

local duizi = {}
function duizi.check(ids)
    if #ids ~= 2 then
		return false
	end
	if cardDesc(ids[1]).value == cardDesc(ids[2]).value then
		return true
	end
	return false
end

function duizi.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	local desc1 = cardDesc(ori[1])
	local desc2 = cardDesc(cur[1])
	return desc2.value > desc1.value
end

function duizi.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    local ret = {}
    local vec = classifyShouPai(shouPai)

    local v1 = cardDesc(ori[1]).value

    for v, info in ipairs(vec) do
        if info.cnt == 2 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 3 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2]})
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local sanzhang = {}
function sanzhang.check(ids)
    if #ids ~= 3 then
		return false
	end
    local v1 = cardDesc(ids[1]).value
    for i = 2,3 do
        local v = cardDesc(ids[i]).value
        if v ~= v1 then
            return false
        end
	end
	return true
end

function sanzhang.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	local desc1 = cardDesc(ori[1])
	local desc2 = cardDesc(cur[1])
	return desc2.value > desc1.value
end

function sanzhang.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    local ret = {}
    local vec = classifyShouPai(shouPai)

    local v1 = cardDesc(ori[1]).value

    for v, info in ipairs(vec) do
        if info.cnt == 3 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2], info.ids[3]})
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2], info.ids[3]})
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local sandaiyi = {}
function sandaiyi.check(ids)
    if #ids ~= 4 then
		return false
	end
    local vec = classifyIds(ids)
    for _, info in ipairs(vec) do
        if info.cnt == 3 then
            return true
        end
	end
	return false
end

function sandaiyi.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 3)
end

function sandaiyi.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
        return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1 = findPXMax(ori, 3)

    for v, info in ipairs(vec) do
        if info.cnt == 3 and v > v1 then
            if spcnt - info.cnt >= 1 then
                local dayi = findSingle(vec, 1, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], dayi[1]})
            end
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            if spcnt - info.cnt >= 1 then
                local dayi = findSingle(vec, 1, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], dayi[1]})
            end
        end
    end

    addZhaDan(ret, zhadan)
    return ret
end

local sandaier = {}
function sandaier.check(ids)
    if #ids ~= 5 then
		return false
	end
    local vec = classifyIds(ids)
    for _, info in ipairs(vec) do
        if info.cnt == 3 then
            return true
        end
	end
	return false
end

function sandaier.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 3)
end

function sandaier.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1 = findPXMax(ori, 3)

    for v, info in ipairs(vec) do
        if info.cnt == 3 and v > v1 then
            if spcnt - info.cnt >= 2 then
                local dayi = findSingle(vec, 2, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], dayi[1], dayi[2]})
            end
        end
    end
    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            if spcnt - info.cnt >= 2 then
                local dayi = findSingle(vec, 2, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], dayi[1], dayi[2]})
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local lianzi = {}
function lianzi.check(ids, minCnt)
    minCnt = minCnt or 3
    if #ids < minCnt then
		return false
	end
    local vec = classifyIds(ids)
    if hasNotLianCard(vec) then
        return false
    end

    local pre = 0
    for v, info in ipairs(vec) do
        if info.cnt > 1 then
            return false
        end
        if info.cnt == 1 then
            if pre == 0 then
                pre = v
            elseif v - pre == 1 then
                pre = v
            else
                return false
            end
        end
	end
	return true
end

function lianzi.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 1)
end

function lianzi.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    vec[Card2Value].cnt = 0
    local v1, liancnt = findPXMax(ori, 1)

    local lianzi = {}
    local pre = 0 
    for v, info in ipairs(vec) do
        if info.cnt >= 1 then
            if v - pre ~= 1 then
                lianzi = {}
            end
            pre = v
            table.insert(lianzi, info)
            if v > v1 and #lianzi >= liancnt then
                local one = {}
                for i = #lianzi, #lianzi - liancnt + 1, -1 do
                    table.insert(one, lianzi[i].ids[1])
                end
                table.insert(ret, one)
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local liandui = {}
function liandui.check(ids, minCnt)
    minCnt = minCnt or 2
    if #ids < minCnt * 2 then
		return false
	end
    local vec = classifyIds(ids)
    if hasNotLianCard(vec) then
        return false
    end

    local pre = 0
    for v, info in ipairs(vec) do
        if info.cnt ~= 0 and info.cnt ~= 2 then
            return false
        end
        if info.cnt == 2 then
            if pre == 0 then
                pre = v
            elseif v - pre == 1 then
                pre = v
            else
                return false
            end
        end
	end
	return true
end

function liandui.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 2)
end

function liandui.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    vec[Card2Value].cnt = 0
    local v1, liancnt = findPXMax(ori, 2)

    local lianzi = {}
    local pre = 0 
    for v, info in ipairs(vec) do
        if info.cnt >= 2 then
            if v - pre ~= 1 then
                lianzi = {}
            end
            pre = v
            table.insert(lianzi, info)
            if v > v1 and #lianzi >= liancnt then
                local one = {}
                for i = #lianzi, #lianzi - liancnt + 1, -1 do
                    table.insert(one, lianzi[i].ids[1])
                    table.insert(one, lianzi[i].ids[2])
                end
                table.insert(ret, one)
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local sansun = {}
function sansun.check(ids, minCnt)
    minCnt = minCnt or 2
    if #ids < minCnt * 3 then
		return false
	end
    local vec = classifyIds(ids)
    if hasNotLianCard(vec) then
        return false
    end

    local pre = 0
    for v, info in ipairs(vec) do
        if info.cnt ~= 0 and info.cnt ~= 3 then
            return false
        end
        if info.cnt == 3 then
            if pre == 0 then
                pre = v
            elseif v - pre == 1 then
                pre = v
            else
                return false
            end
        end
	end
	return true
end

function sansun.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 3)
end

function sansun.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan(zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    vec[Card2Value].cnt = 0
    local v1, liancnt = findPXMax(ori, 3)

    local lianzi = {}
    local pre = 0 
    for v, info in ipairs(vec) do
        if info.cnt >= 3 then
            if v - pre ~= 1 then
                lianzi = {}
            end
            pre = v
            table.insert(lianzi, info)
            if v > v1 and #lianzi >= liancnt then
                local one = {}
                for i = #lianzi, #lianzi - liancnt + 1, -1 do
                    table.insert(one, lianzi[i].ids[1])
                    table.insert(one, lianzi[i].ids[2])
                    table.insert(one, lianzi[i].ids[3])
                end
                table.insert(ret, one)
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local feijichibang = {}
function feijichibang.check(ids, minCnt)
    if #ids < 10 then
		return false
    end
	local cnt = #ids
	if cnt%5 ~= 0 then
		return false
    end
	local threeCnt = math.floor(cnt / 5)

    local vec = classifyIds(ids)
    if hasNotLianCard(vec) then
        return false
    end

    local threevec = {}
    for _, info in ipairs(vec) do
        if info.cnt == 3 and info.v ~= Card2Value and info.v ~= CardXiaoWangValue and info.v ~= CardDaWangValue and info.v ~= CardHuaHuaValue then
            table.insert(threevec, info)
        end
	end

	if #threevec < threeCnt then
		return false
    end

	local pre = threevec[1].v
	local lcnt = 1
	for i = 2, #threevec do
		if threevec[i].v-pre > 1 then
			if lcnt >= threeCnt then
				return true
			else 
				lcnt = 1
				pre = threevec[i].v
            end
		else 
			pre = threevec[i].v
			lcnt = lcnt + 1
        end
    end
	if lcnt >= threeCnt then
		return true
    end
	return false
end

function feijichibang.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 3)
end

function feijichibang.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1, liancnt = findPXMax(ori, 3)
    liancnt = math.floor(#ori / 5)

    local lianzi = {}
    local pre = 0 
    for v, info in ipairs(vec) do
        if info.cnt >= 3 then
            if v - pre ~= 1 then
                lianzi = {}
            end
            pre = v
            table.insert(lianzi, info)
            if v > v1 and #lianzi >= liancnt then
                local one = {}
                local needCnt = 0
                local except = {}
                for i = #lianzi, #lianzi - liancnt + 1, -1 do
                    table.insert(one, lianzi[i].ids[1])
                    table.insert(one, lianzi[i].ids[2])
                    table.insert(one, lianzi[i].ids[3])
                    table.insert(except, lianzi[i].v)
                    needCnt = needCnt + lianzi[i].cnt
                end
                if #shouPai - needCnt >= 2 * liancnt then
                    local result = findSingle(vec, 2 * liancnt, except)
                    for _, id in ipairs(result) do
                        table.insert(one, id)
                    end
                    table.insert(ret, one)
                end
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local zhadan = {}
function zhadan.check(ids)
    if #ids ~= 4 then
		return false
	end
    local v1 = cardDesc(ids[1]).value
    for i = 2,4 do
        local v = cardDesc(ids[i]).value
        if v ~= v1 then
            return false
        end
	end
	return true
end

function zhadan.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	local desc1 = cardDesc(ori[1])
	local desc2 = cardDesc(cur[2])
	return desc2.value > desc1.value
end

function zhadan.findMax(ori, shouPai)
    local vec = classifyShouPai(shouPai)

    local v1 = cardDesc(ori[1]).value
    local ret = {}

    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], info.ids[4]})
        end
    end
    return ret
end

local sidaiyi = {}
function sidaiyi.check(ids)
    if #ids ~= 5 then
		return false
	end
    local vec = classifyIds(ids)
    for _, info in ipairs(vec) do
        if info.cnt == 4 then
            return true
        end
	end
	return false
end

function sidaiyi.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 4)
end

function sidaiyi.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1 = findPXMax(ori, 4)

    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            if spcnt - info.cnt >= 1 then
                local dayi = findSingle(vec, 1, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], info.ids[4], dayi[1]})
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local sidaier = {}
function sidaier.check(ids)
    if #ids ~= 6 then
		return false
	end
    local vec = classifyIds(ids)
    for _, info in ipairs(vec) do
        if info.cnt == 4 then
            return true
        end
	end
	return false
end

function sidaier.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 4)
end

function sidaier.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return addZhaDan({}, zhadan)
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1 = findPXMax(ori, 4)

    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            if spcnt - info.cnt >= 2 then
                local dayi = findSingle(vec, 2, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], info.ids[4], dayi[1], dayi[2]})
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local sidaisan = {}
function sidaisan.check(ids)
    if #ids ~= 7 then
		return false
	end
    local vec = classifyIds(ids)
    for _, info in ipairs(vec) do
        if info.cnt == 4 then
            return true
        end
	end
	return false
end

function sidaisan.compair(ori, cur)
	if #ori ~= #cur then
		return false
	end
	return compaireDaXiao(ori, cur, 4)
end
function sidaisan.findMax(ori, shouPai)
    local zhadan = findZhaDan(shouPai)
    if #shouPai < #ori then
		return zhadan
	end
    local ret = {}
    local spcnt = #shouPai

    local vec = classifyShouPai(shouPai)
    local v1 = findPXMax(ori, 4)

    for v, info in ipairs(vec) do
        if info.cnt == 4 and v > v1 then
            if spcnt - info.cnt >= 3 then
                local dayi = findSingle(vec, 3, {v})
                table.insert(ret, {info.ids[1], info.ids[2], info.ids[3], info.ids[4], dayi[1]}, dayi[2], dayi[3])
            end
        end
    end
    addZhaDan(ret, zhadan)
    return ret
end

local checker = class("checker")

function checker:ctor(lianziMinCnt, lianduiMinCnt)
    self.m_lianziMinCnt = lianziMinCnt
    self.m_lianduiMinCnt = lianduiMinCnt
    self.m_checkerlist = {
        [PDKPaiXingDanZhang] = danzhang,
        [PDKPaiXingDuiZi]    = duizi,
        [PDKPaiXingSanZhang] = sanzhang,
        [PDKPaiXingSanDaiYi] = sandaiyi,
        [PDKPaiXingSanDaiEr] = sandaier,
        [PDKPaiXingLianZi]   = lianzi,
        [PDKPaiXingLianDui]  = liandui,
        [PDKPaiXingFeiJi]    = sansun,
        [PDKPaiXingFeiJiDaiChiBang] = feijichibang,
        [PDKPaiXingZhaDan] = zhadan,
        [PDKPaiXingSiDaiEr] = sidaier,
        [PDKPaiXingSiDaiSan] = sidaisan,
        [PDKPaiXingSiDaiYi]  = sidaiyi,
    }
end

function checker:getPX(ids)
    for k, v in pairs(self.m_checkerlist) do
        local minCnt  = nil
        if k == PDKPaiXingLianZi then
            minCnt = self.m_lianziMinCnt
        end
        if k == PDKPaiXingLianDui then
            minCnt = self.m_lianduiMinCnt
        end
        if v.check(ids, minCnt) then
            return k
        end
    end
    return PDKPaiXingNone
end

function checker:findMax(px, ori, shoupai)
    local t = self.m_checkerlist[px]
    if t == nil then    
        return {}
    end
    return t.findMax(ori, shoupai)
end

function checker:compair(px, ori, cur)
    local t = self.m_checkerlist[px]
    if t == nil then    
        return false
    end
    return t.compair(ori, cur)
end

helper.checker = checker

local function findMaxIdInShouPai(shouPai)
    local v = -1
    local id = -1
    for _, pai in pairs(shouPai) do
        local curv = cardDesc(pai.id).value
        if v < curv then
            v = curv
            id = pai.id
        end
    end
    return id
end
helper.findMaxIdInShouPai = findMaxIdInShouPai

--不需要啥 直接出单张
local function autoChoseForNoneType(chuOpInfo, shouPai)
    if chuOpInfo.MustCard >= 0 then
        return {{chuOpInfo.MustCard}}
    end
    if chuOpInfo.NeedMaxD then
        local maxid = findMaxIdInShouPai(shouPai)
        return {{maxid}}
    end
    local vec = classifyShouPai(shouPai)
    local ret = {}
    for _, info in ipairs(vec) do
        if info.cnt == 1 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for _, info in ipairs(vec) do
        if info.cnt == 2 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for _, info in ipairs(vec) do
        if info.cnt == 3 then
            table.insert(ret, {info.ids[1]})
        end
    end
    for _, info in ipairs(vec) do
        if info.cnt == 4 then
            table.insert(ret, {info.ids[1]})
        end
    end
    return ret
end
helper.autoChoseForNoneType = autoChoseForNoneType

--返回可以出牌的组合数组
function helper.autoChose(chuOpInfo, shouPai, checker) 
	--如果typ为none，则选单张，如果必须出最大的，就自动选最大的
    if chuOpInfo.DetailTyp == PDKPaiXingNone then
        return autoChoseForNoneType(chuOpInfo, shouPai)
    end
    if chuOpInfo.DetailTyp == PDKPaiXingDanZhang and chuOpInfo.NeedMaxD then
        return autoChoseForNoneType(chuOpInfo, shouPai)
    end

	--如果typ不为none，在手牌中选择符合要求的牌组合
    return checker:findMax(chuOpInfo.DetailTyp, chuOpInfo.Cards, shouPai)
end

local valuevec = {
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8",
    [9] = "9",
    [10] = "10",
    [11] = "J",
    [12] = "Q",
    [13] = "K",
    [14] = "A",
    [15] = "2",
}

local colorvec = {
    [pokerType.color.heiTao]    = "黑桃",
    [pokerType.color.hongTao]   = "红桃",
    [pokerType.color.meiHua]    = "梅花",
    [pokerType.color.fangKuai]  = "方块",
}

local function cardToString(id)
    local desc = cardDesc(id)

    if id <= 51 then
        return colorvec[desc.Color] .. valuevec[desc.value]
    end

    if id == 52 then
        return "小王"
    end

    if id == 53 then
        return "大王"
    end

    return "花"
end
helper.cardToString = cardToString

--检查当前选中的牌是否符合出牌要求
function helper.checkChosePai(chuOpInfo, chosePais, shouPai, checker, notsupportpxs)
	--检查是否包含必出牌
    if #chosePais == 0 then
        return false, "请选择要出的牌"
    end
    local ids = chosePais
    if chuOpInfo.MustCard >= 0 then
        if not isInExcepts(chuOpInfo.MustCard, ids) then
            return false, "必须包含牌" .. cardToString(chuOpInfo.MustCard)
        end
    end
    
    local px = checker:getPX(ids)
    if chuOpInfo.DetailTyp == PDKPaiXingNone then
        if isInExcepts(px, notsupportpxs) then
            return false, "不支持的牌型"
        end
        if px == PDKPaiXingDanZhang and chuOpInfo.NeedMaxD then
            local maxid = findMaxIdInShouPai(shouPai)
            local maxv = cardDesc(maxid).value
            if cardDesc(ids[1]).value ~= maxv then
                return false, "必须出手中最大的单张"
            end
        end
        return true, px
    elseif chuOpInfo.DetailTyp == PDKPaiXingDanZhang and chuOpInfo.NeedMaxD then
        if px == PDKPaiXingZhaDan then
            return true, PDKPaiXingZhaDan
        end
        if #ids ~= 1 then 
            return false, "请选择正确的牌型."
        end
        local maxid = findMaxIdInShouPai(shouPai)
        local maxv = cardDesc(maxid).value
        if cardDesc(ids[1]).value ~= maxv then
            return false, "必须出手中最大的单张"
        end
        return true, PDKPaiXingDanZhang
    else
        if px == PDKPaiXingZhaDan and chuOpInfo.DetailTyp ~= PDKPaiXingZhaDan then
            return true, px
        end
        if chuOpInfo.DetailTyp ~= px then
            return false, "请选择正确的牌型"
        end
        if not checker:compair(chuOpInfo.DetailTyp, chuOpInfo.Cards, ids) then
            return false, "出牌必须比上家大"
        end
        return true, px
    end
    assert(false)
end

function helper.getChuPaiSound(cards, px, lastPx)
    local dani = "pdk_dani"

    if px == PDKPaiXingDanZhang then
        return "one_" .. cardDesc(cards[1]).value
    elseif px == PDKPaiXingDuiZi then
        return "double_" .. cardDesc(cards[1]).value
    elseif px == PDKPaiXingSanZhang then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sanzhang"
    elseif px == PDKPaiXingZhaDan then
        return "bomb"
    elseif px == PDKPaiXingSiDaiYi then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sidaiyi"
    elseif px == PDKPaiXingSiDaiEr then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sidaier"
    elseif px == PDKPaiXingSanDaiYi then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sandaiyi"
    elseif px == PDKPaiXingSanDaiEr then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sandaier"
    elseif px == PDKPaiXingSiDaiSan then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "sidaisan"
    elseif px == PDKPaiXingFeiJi then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "feiji"
    elseif px == PDKPaiXingLianZi then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "lianzi"
    elseif px == PDKPaiXingLianDui then
        if lastPx ~= PDKPaiXingNone then
            return dani
        end
        return "liandui"
    end

    return ""
end

return helper

--endregion
