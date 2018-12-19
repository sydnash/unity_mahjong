local base = require ("logic.doushisi.doushisiGame")

local doushisiGame_jintang = class("doushisiGame_jintang", base)

function doushisiGame_jintang:onGameEndListener(specialData, datas, totalScores)
    datas.huAcId = specialData.HuAcId
    datas.beHuAcId = specialData.BeHuAcId
    datas.huType = specialData.HuType
    for _, v in pairs(specialData.PlayerInfos) do
        local acId = v.AcId
        local p = self.players[acId]
        local d = {
            acId            = v.AcId, 
            headerUrl       = self.players[p.acId].headerUrl,
            nickname        = p.nickname, 
            score           = v.Score,
            fanShu          = v.Fan,
            fuShu           = v.Fu,
            totalScore      = totalScores[v.AcId], 
            turn            = p.turn, 
            seat            = self:getSeatTypeByAcId(p.acId),
            inhand          = v.ShouPai,
            hu              = v.Hu,
            chiChe          = v.ChiChe,
            isCreator       = self:isCreator(v.AcId),
            isWinner        = false,
            seatType        = self:getSeatTypeByAcId(v.AcId),
            isPiao          = p.isPiao,
            isBao           = p.isBao,
            isMarker        = p.isDang,
            tyReplace       = v.TYReplace,
        }
        if datas.huAcId == d.acId then
            if datas.huType == self.huType.zimo then
                d.huType = "ziMo"
            elseif datas.huType == self.huType.tianhu then
                d.huType = "tianHu"
            elseif datas.huType == self.huType.dibao then
                d.huType = "diBao"
            elseif datas.huType == self.huType.weigui then
                d.huType = "weiGui"
            else
                d.huType = "hu"
            end
        elseif datas.beHuAcId == d.acId then
            if datas.huType == self.huType.dianpao then
                d.huType = "dianPao"
            end
        end
        table.insert(datas.players, d)
    end
    table.sort(datas.players, function(t1, t2)
        return t1.seatType < t2.seatType
    end)
end

return doushisiGame_jintang
