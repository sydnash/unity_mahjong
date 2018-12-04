--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local authentication = class("authentication", base)

_RES_(authentication, "AuthenticationUI", "AuthenticationUI")

function authentication:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCommit:addClickListener(self.onCommitClickedHandler, self)
    self.mName:addChangedListener(self.onNameChangedHandler, self)
    self.mSFZ:addChangedListener(self.onSfzChangedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    self:refreshUI()
end

function authentication:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function authentication:onNameChangedHandler(name)
    self:refreshUI()
end

function authentication:onSfzChangedHandler(sfz)
    self:refreshUI()
end

function authentication:onCommitClickedHandler()
    showMessageUI("实名认证提交成功！")
    self:close()

    playButtonClickSound()
end

function authentication:refreshUI()
    local name = self.mName:getText()
    local sfz = self.mSFZ:getText()

    if string.isNilOrEmpty(name) or string.isNilOrEmpty(sfz) then
        self.mCommit:setInteractabled(false)
        self.mCommitText:setSprite("disable")
    else
        self.mCommit:setInteractabled(true)
        self.mCommitText:setSprite("enable")
    end
end

function authentication:onCloseAllUIHandler()
    self:close()
end

function authentication:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return authentication

--endregion
