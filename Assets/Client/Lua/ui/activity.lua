--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local activity = class("activity", base)

_RES_(activity, "ActivityUI", "ActivityUI")

local list = {
    { name = "范范666", value = 188.8 },
    { name = "ee", value = 188.8 },
    { name = "钱钱", value = 188.8 },
    { name = "红叶", value = 188.8 },
    { name = "珍珍", value = 188.8 },
    { name = "妮娃娃", value = 88.8 },
    { name = "熊猫群主", value = 88.8 },
    { name = "WH", value = 88.8 },
    { name = "恒", value = 88.8 },
    { name = "卖五金的", value = 88.8 },
    { name = "清风徐来", value = 88.8 },
    { name = "原木家私", value = 88.8 },
    { name = "知足常乐", value = 88.8 },
    { name = "盟主", value = 88.8 },
    { name = "小Q", value = 88.8 },
    { name = "zengcueling", value = 88.8 },
    { name = "坦然", value = 28.8 },
    { name = "爱攻AOC", value = 28.8 },
    { name = "笑呵呵", value = 28.8 },
    { name = "王师傅", value = 28.8 },
    { name = "隔壁大叔", value = 28.8 },
    { name = "回归", value = 28.8 },
    { name = "opokg", value = 28.8 },
    { name = "就爱吃火锅", value = 28.8 },
    { name = "婚纱摄影", value = 28.8 },
    { name = "leogjh", value = 28.8 },
    { name = "黄雨门窗", value = 28.8 },
    { name = "及时雨", value = 28.8 },
    { name = "iiriy", value = 28.8 },
    { name = "小叶", value = 28.8 },
    { name = "森林狼", value = 28.8 },
    { name = "\"A~丹~", value = 8.8 },
    { name = "赵春梅", value = 8.8 },
    { name = "王可可", value = 8.8 },
    { name = "橙子", value = 8.8 },
    { name = "CC", value = 8.8 },
    { name = "123", value = 8.8 },
    { name = "阿友", value = 8.8 },
    { name = "爱情合约", value = 8.8 },
    { name = "天天", value = 8.8 },
    { name = "CQ", value = 8.8 },
    { name = "狼", value = 8.8 },
    { name = "刘楠", value = 8.8 },
    { name = "最终", value = 8.8 },
    { name = "流年", value = 8.8 },
    { name = "jkkh", value = 8.8 },
    { name = "华夏灯管", value = 8.8 },
    { name = "世界很大", value = 8.8 },
    { name = "不闻不问", value = 8.8 },
    { name = "心情", value = 8.8 },
    { name = "X—MAN", value = 8.8 },
    { name = "lulu", value = 8.8 },
}

function activity:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTitlebarTabAffiche:addClickListener(self.onTitlebarTabAfficheClickedHandler, self)
    self.mTitlebarTabActivity:addClickListener(self.onTitlebarTabActivityClickedHandler, self)

    self.mTitlebarTabActivity:hide()
    self.mTitlebarTabActivityS:show()
    self.mTitlebarTabAffiche:show()
    self.mTitlebarTabAfficheS:hide()

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
        ["affiche_b"] = self.mAffichePageB,
    }
    self.mAfficheTabA.page = "affiche_a"
    self.mAfficheTabB.page = "affiche_b"

    self.mAfficheTabA:setSelected(false)
    self.mAfficheTabB:setSelected(true)

    self.mAfficheTabA:addChangedListener(self.onAfficheTabChangedHandler, self)
    self.mAfficheTabB:addChangedListener(self.onAfficheTabChangedHandler, self)

    self.rewards = {}
    self.rewardIndex = 1

    for i=1, 7 do
        local tx = findText(self.mAffichePageB.transform, "List/" .. tostring(i))
        table.insert(self.rewards, tx)

        local reward = list[self.rewardIndex]
        tx:setText(string.format("“%s”    获得%.1f元红包", reward.name, reward.value))
        self.rewardIndex = self.rewardIndex + 1
    end

    self.mActivity:show()
    self.mAffiche:hide()

    
    self.timestamp = time.realtimeSinceStartup()

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

function activity:update()
--    local now = time.realtimeSinceStartup()
    local delta = 0.0333--now - self.timestamp

    for _, v in pairs(self.rewards) do
        local pos = v:getLocalPosition()
        pos.y = pos.y + delta * 50
        
        if pos.y >= 175 then
            pos.y = -175
            self.rewardIndex = math.max(1, (self.rewardIndex + 1) % (#list + 1))
            local reward = list[self.rewardIndex]
            v:setText(string.format("“%s”    获得%.1f元红包", reward.name, reward.value))
        end

        v:setLocalPosition(pos)
    end

--    self.timestamp = now
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
