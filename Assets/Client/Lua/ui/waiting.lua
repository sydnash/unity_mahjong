--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local waiting = class("waiting", base)

waiting.folder = "WaitingUI"
waiting.resource = "WaitingUI"

function waiting:onInit()
    self.rotation = tweenRotation.new(self.mCircle, 6000, Vector3.New(0, 0, 0), Vector3.New(0, 0, -432000))
    tweenManager.add(self.rotation)

    self.rotation:play()
end

function waiting:onDestroy()
    self.rotation:stop()
    tweenManager.remove(self.rotation)
end

return waiting

--endregion
