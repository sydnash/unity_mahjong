--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local authentication = class("authentication", base)

_RES_(authentication, "AuthenticationUI", "AuthenticationUI")

function authentication:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCommit:addClickListener(self.onCommitClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function authentication:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function authentication:onCommitClickedHandler()
    playButtonClickSound()

    local name = self.mName:getText()
    if string.isNilOrEmpty(name) then
        showMessageUI("请输入真实姓名")
        return
    end

    local sfz = self.mSFZ:getText()
    if string.isNilOrEmpty(sfz) then
        showMessageUI("请输入真实身份证号")
        return
    end

    showMessageUI("实名认证提交成功！")
    self:close()
end

function authentication:onCloseAllUIHandler()
    self:close()
end

function authentication:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return authentication

--endregion
