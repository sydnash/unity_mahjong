local helper        = class("helper")
local mahjongType   = require ("logic.mahjong.mahjongType")

function helper:setQue(que)
    self.que = que
end

------------
-- 每种牌的个数的数组（2个1条， 就是{[0] = 2}
-- 返回：空table表示没有叫 如果有叫  { {jiao = id, fan = 5, component = {{1,2,3}, {4,5,6} } }, {jiao = id, fan = 2}  }
------------
function helper:checkJiao(cntVec)
    for id, v in pairs(cntVec) do
        if v > 0 then
            desc = mahjongType.getMahjongTypeByTypeId(id)
            if desc.class == cntVec then
                return {}
            end
        end
    end
    --测试每一个牌是否可以胡
end

function helper:isHu(cntVec, mahjong)
    local id  
end

function helper:checkChuPaiHint(cntVec)
end

function helper:computeFanXing()
end

function helper:getFanShu()
end

function helper:cardsToCntVec()
end

return helper
