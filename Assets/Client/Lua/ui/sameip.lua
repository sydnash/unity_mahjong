--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local sameip = class("sameip", base)

_RES_(sameip, "SameIPUI", "SameIPUI")

function sameip:ctor(data)
    self.data = data
    base.ctor(self)
end

function sameip:onInit()
    local text = string.empty

    for _, v in pairs(self.data) do
        local ps = string.empty
        for _, u in pairs(v) do
            ps = ps .. string.format("\"%s\" ", u)
        end

        if not string.isNilOrEmpty(text) then
            text = text .. "\n"
        end
        text = text .. string.format("%s为同一IP地址", ps)
    end

    self.mText:setText(text)
end

function sameip:show()
    base.show(self)
    self.mAnim:play()
end

function sameip:hide()
    self.mAnim:stop()
    base.hide(self)
end

function sameip:onDestroy()
    self.mAnim:stop()
    base.onDestroy(self)
end

return sameip

--endregion
