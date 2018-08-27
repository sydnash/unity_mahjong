--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

function showMessage(text, confirmCallback, cancelCallback)
    local ui = require("ui.messageBox").new(text, confirmCallback, cancelCallback)
    ui:show()
end

function playButtonClickSound()
    soundManager.playUISound("click")
end

--endregion
