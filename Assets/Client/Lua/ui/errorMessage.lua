--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local errorMessage = class("errorMessage", base)

_RES_(errorMessage, "ErrorCommitUI", "ErrorCommitUI")

function errorMessage:onInit()
    if not deviceConfig.isMobile then
        self.mCommit:hide()
    end

    self.mQuit:addClickListener(self.onQuitClickedHandler, self)
    self.mCommit:addClickListener(self.onCommitClickedHandler, self)
end

function errorMessage:setErrorMessage(errorMessage)
    self.mText:setText(errorMessage)
end

function errorMessage:onQuitClickedHandler()
    playButtonClickSound()
    Application.Quit()
end

function errorMessage:onCommitClickedHandler()
    playButtonClickSound()
end

return errorMessage

--endregion
