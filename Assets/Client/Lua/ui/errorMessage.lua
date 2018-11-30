--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local errorMessage = class("errorMessage", base)

_RES_(errorMessage, "ErrorCommitUI", "ErrorCommitUI")

function errorMessage:onInit()
    self.mQuit:addClickListener(self.onQuitClickedHandler, self)
end

function errorMessage:appendErrorMessage(message)
    local text = string.format("%s\n-----------------------------\n%s", self.mText:getText(), message)
    self.mText:setText(text)
end

function errorMessage:setDebug(debug)
    self.debug = debug
    if debug then
        self.mQuitDesc:setText("拷贝关闭")
    else
        self.mQuitDesc:setText("关闭退出")
    end
end

function errorMessage:onQuitClickedHandler()
    playButtonClickSound()
    if self.debug then
        self.mText:setText("")
        self:close()
        return
    end
    Application.Quit()
end

return errorMessage

--endregion
