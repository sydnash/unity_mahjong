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
    --
    self.activityPages = {
        ["activity_a"] = self.mActivityPageA,
        ["activity_b"] = self.mActivityPageB,
    }
    self.mActivityTabA.page = "activity_a"
    self.mActivityTabB.page = "activity_b"

    self.mActivityTabA:setSelected(false)
    self.mActivityTabB:setSelected(true)

    self.mActivityTabA:addChangedListener(self.onActivityTabChangedHandler, self)
    self.mActivityTabB:addChangedListener(self.onActivityTabChangedHandler, self)
    --
    self.affichePages = {
        ["affiche_a"] = self.mAffichePageA,
        --["affiche_b"] = self.mAffichePageB,
    }
    self.mAfficheTabA.page = "affiche_a"
    --self.mAfficheTabB.page = "affiche_b"

    self.mAfficheTabA:setSelected(true)
    --self.mAfficheTabB:setSelected(true)
    self.mAfficheTabB:hide()

    self.mAfficheTabA:addChangedListener(self.onAfficheTabChangedHandler, self)
    --self.mAfficheTabB:addChangedListener(self.onAfficheTabChangedHandler, self)

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

function activity:onActivityTabChangedHandler(sender, selected, clicked)
    if selected then
        if clicked then
            playButtonClickSound()
        end

        for k, v in pairs(self.activityPages) do
            if k == sender.page then
                v:show()
            else
                v:hide()
            end
        end
    end
end

function activity:onAfficheTabChangedHandler(sender, selected, clicked)
    if selected then
        if clicked then
            playButtonClickSound()
        end

        for k, v in pairs(self.affichePages) do
            if k == sender.page then
                v:show()
            else
                v:hide()
            end
        end
    end
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
