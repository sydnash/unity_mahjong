--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local sameip = class("sameip", base)

function sameip:ctor(data)
    self.data = data
    base.ctor(self)
end

function sameip:onInit()

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
