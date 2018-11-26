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
end

function errorMessage:appendErrorMessage(errorMessage)
    local text = string.format("%s\n-----------------------------\n%s", self.mText:getText(), errorMessage)
    self.mText:setText(text)
end

function errorMessage:onQuitClickedHandler()
    playButtonClickSound()
    Application.Quit()
end

return errorMessage

--endregion
