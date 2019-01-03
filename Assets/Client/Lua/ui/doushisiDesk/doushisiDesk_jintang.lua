local base = require ("ui.doushisiDesk.doushisiDesk")
local doushisiDesk_jintang = class("doushisiDesk_jintang", base)

function doushisiDesk_jintang:setDang(acId, dang)
    local st = self.game:getSeatTypeByAcId(acId)
    local header = self.headers[st]
    if dang then
        header:showZhuang()
    else
        header:hideZhuang()
    end
end

function doushisiDesk_jintang:onOpDoDang(acId, isDang)
    if isDang then
        self:playGfx(acId, "zuozhuang")
        self:playSound(acId, opType.doushisi.dang)
    else
        self:playGfx(acId, "huazhuang")
    end
end

function doushisiDesk_jintang:setZhuang(acId, zhuang)
end

function doushisiDesk_jintang:onOpDoHua(acId)
    self:playGfx(acId, "an")
end

return doushisiDesk_jintang