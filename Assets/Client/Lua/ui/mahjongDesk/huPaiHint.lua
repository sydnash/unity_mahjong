local base = require("ui.common.view")

local huPaiHintItem = class("huPaiHintItem", base)
_RES_(huPaiHintItem, "MahjongDeskUI", "HuPaiHintItem")
function huPaiHintItem:ctor(info, start)
    self.huInfo = info
    self.start = start
    base.ctor(self)
end

function huPaiHintItem:onInit()
    self.items = {self.mA, self.mB}
    for _, t in pairs(self.items) do
        t:hide()
    end
    for i = 1, 2 do
        local idx = self.start + i - 1
        local info = self.huInfo[idx]
        if info then
            log(string.format("===================info:%s : i:%s " , table.tostring(info), i))
            local t = self.items[i]
            t:show()
            t:setInfo(info)
        end
    end
end

local huPaiHint = class("huPaiHint", base)
_RES_(huPaiHint, "MahjongDeskUI", "HuPaiHintUI")

function huPaiHint:ctor(info)
    self.huInfo = info
    base.ctor(self)
end

local singleSize = Vector2.New(322.0, 168.3)
local doubleHeight = 288.4
local add = 195.8
local base = 314.6

function huPaiHint:onInit()
    self.mThis:addClickListener(self.onThisClicked, self)
    local cnt = #self.huInfo
    local size = singleSize
    if cnt > 1 then
        local t = math.ceil(cnt / 2)
        local w = base + add * (t - 1)
        local h = 288.4
        size = Vector2.New(w, h)
    end
    self.mBg:setSize(size)

    self.items = {}
    for i = 1, #self.huInfo, 2 do
        local item = huPaiHintItem.new(self.huInfo, i)
        item:setParent(self.mNode)
        item:show()
        table.insert(self.items, item)
    end
end

function huPaiHint:onThisClicked()
    self:close()
end

function huPaiHint:onDestroy()
    for _, item in pairs(self.items) do
        item:close()
    end
    self.itmes = {}
end

return huPaiHint
