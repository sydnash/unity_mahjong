--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local share = class("share", base)

_RES_(share, "ShareUI", "ShareUI")
local imgname = ""

function share:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mHY:addClickListener(self.onHyClickedHandler, self)
    self.mPYQ:addClickListener(self.onPyqClickedHandler, self)
end

function share:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function share:onHyClickedHandler()
    playButtonClickSound()

    if deviceConfig.isAndroid then 
        androidHelper.shareImageWx(imgname, false)
    end
end

function share:onPyqClickedHandler()
    playButtonClickSound()

    if deviceConfig.isAndroid then 
        androidHelper.shareImageWx(imgname, true)
    end
end

return share

--endregion
