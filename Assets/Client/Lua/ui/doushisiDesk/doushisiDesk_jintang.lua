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

function doushisiDesk_jintang:setZhuang(acId, zhuang)
end

return doushisiDesk_jintang