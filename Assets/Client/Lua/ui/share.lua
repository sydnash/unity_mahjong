--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local share = class("share", base)

_RES_(share, "ShareUI", "ShareUI")

local imagePath = "ShareTex"
local imageName = "lobby_share_image"

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

    local tex = textureManager.load(imagePath, imageName)
    if tex ~= nil then
        local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
        platformHelper.shareImageWx(tex, thumb, false)
        textureManager.unload(tex)
    end
end

function share:onPyqClickedHandler()
    playButtonClickSound()

    local tex = textureManager.load(imagePath, imageName)
    if tex ~= nil then
        local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
        platformHelper.shareImageWx(tex, thumb, true)
        textureManager.unload(tex)
    end
end

return share

--endregion
