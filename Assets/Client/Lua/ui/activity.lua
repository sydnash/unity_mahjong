--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local activity = class("activity", base)

_RES_(activity, "ActivityUI", "ActivityUI")

function activity:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTitlebarTabAffiche:addClickListener(self.onTitlebarTabAfficheClickedHandler, self)
    self.mTitlebarTabActivity:addClickListener(self.onTitlebarTabActivityClickedHandler, self)

    self.mTitlebarTabActivity:hide()
    self.mTitlebarTabActivityS:show()
    self.mTitlebarTabAffiche:show()
    self.mTitlebarTabAfficheS:hide()

    self.mActivity:show()
    self.mAffiche:hide()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function activity:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function activity:onTitlebarTabActivityClickedHandler()
    self.mTitlebarTabActivity:hide()
    self.mTitlebarTabActivityS:show()
    self.mTitlebarTabAffiche:show()
    self.mTitlebarTabAfficheS:hide()

    self.mActivity:show()
    self.mAffiche:hide()

    playButtonClickSound()
end

function activity:onTitlebarTabAfficheClickedHandler()
    self.mTitlebarTabActivity:show()
    self.mTitlebarTabActivityS:hide()
    self.mTitlebarTabAffiche:hide()
    self.mTitlebarTabAfficheS:show()

    self.mActivity:hide()
    self.mAffiche:show()

    playButtonClickSound()
end

function activity:onCloseAllUIHandler()
    self:close()
end

function activity:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return activity

--endregion
