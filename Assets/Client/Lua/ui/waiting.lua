--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local waiting = class("waiting", base)

_RES_(waiting, "WaitingUI", "WaitingUI")

function waiting:ctor(text)
    self.text = string.isNilOrEmpty(text) and "请稍候..." or text
    self.super.ctor(self)
end

function waiting:onInit()
    self.rotation = tweenRotation.new(self.mCircle, 60000, Vector3.New(0, 0, 0), Vector3.New(0, 0, -4320000))
    tweenManager.add(self.rotation)

    self.rotation:play()
    self:setText(self.text)
end

function waiting:setText(text)
    self.text = text
    self.mText:setText(self.text)
end

function waiting:onDestroy()
    self.rotation:stop()
    tweenManager.remove(self.rotation)

    self.super.onDestroy(self)
end

return waiting

--endregion
