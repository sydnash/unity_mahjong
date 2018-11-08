--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local share = class("share", base)

_RES_(share, "ShareUI", "ShareUI")

local imageName = "DL_bg"
local thumbSize = 150

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

    if not deviceConfig.isMobile then
        return
    end

    if deviceConfig.isMobile then
        local tex = textureManager.load(string.empty, imageName)

        if tex ~= nil then
            local thumb = getSizedTexture(tex, thumbSize, thumbSize)
            platformHelper.shareImageWx(tex, thumb, false)
            textureManager.unload(tex)
        end
    end
end

function share:onPyqClickedHandler()
    playButtonClickSound()

    if deviceConfig.isMobile then
        local tex = textureManager.load(string.empty, imageName)

        if tex ~= nil then
            local thumb = getSizedTexture(tex, thumbSize, thumbSize)
            platformHelper.shareImageWx(tex, thumb, true)
            textureManager.unload(tex)
        end
    end
end

return share

--endregion
