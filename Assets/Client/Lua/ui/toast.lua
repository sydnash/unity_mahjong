--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local toast = class("toast", base)

_RES_(toast, "ToastUI", "ToastUI")

function toast:ctor(callback)
    base.ctor(self)
    self.callback = callback
end

function toast:onInit()
    
end

function toast:show()
    self.timestamp = time.realtimeSinceStartup()
    base.show(self)
end

function toast:setText(text)
    self.mText:setText(text)
end

function toast:update()
    if time.realtimeSinceStartup() - self.timestamp > 3 then
        self:close()
    end
end

function toast:onDestroy()
    if self.callback ~= nil then
        self.callback()
    end

    base.onDestroy(self)
end

return toast

--endregion
