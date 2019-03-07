--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local deskConfig = require("config.deskConfig")

local base = require("ui.common.panel")
local friendsterDesk = class("friendsterDesk", base)

function friendsterDesk:onInit()
    self.slots = { 
        { root = self.mPlayerA, icon = self.mPlayerA_Icon, add = self.mPlayerA_Add, },
        { root = self.mPlayerB, icon = self.mPlayerB_Icon, add = self.mPlayerB_Add, },
        { root = self.mPlayerC, icon = self.mPlayerC_Icon, add = self.mPlayerC_Add, },
        { root = self.mPlayerD, icon = self.mPlayerD_Icon, add = self.mPlayerD_Add, },
    }

--    self.mClick:addClickListener(self.onClickedHandler, self)
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
end

--function friendsterDesk:onClickedHandler()
--    if self.data ~= nil then
--        playButtonClickSound()


--        local ok, errText = checkGame(self.data.cityType, self.data.gameType)
--        if not ok then
--            showMessageUI(string.format("%s, 可点击确定下载<color=red>天地长牌</color>进入游戏", errText), 
--                          function()
--                              platformHelper.openExplorer("http://www.cdbshy.com")
--                          end,
--                          function()
--                          end)
--            return
--        end


--        local ui = require("ui.deskDetail.deskDetail").new(self.data.cityType, 
--                                                           self.data.gameType,
--                                                           self.data.friendsterId, 
--                                                           self.data.config, 
--                                                           self.canJoin, 
--                                                           self.data.deskId, 
--                                                           self.data.managerAcId)
--        ui:show()
--    end
--end

function friendsterDesk:onCloseClickedHandler()
    showWaitingUI(string.format("正在关闭房间[%d]", self.data.deskId))

    networkManager.dissolveFriendsterDesk(self.data.friendsterId, self.data.cityType, self.data.deskId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI(string.format("房间[%d]已经解散", self.data.deskId))
    end)

    playButtonClickSound()
end

function friendsterDesk:set(data)
    self.data = data

    if self.data ~= nil then
--        log(table.tostring(self.data))
        self.mType:setText(gameName[self.data.cityType].games[self.data.gameType])
        self.mNum:setText(string.format("（第%d/%d局）", self.data.playedCount, self.data.totalCount))
        self:setState(self.data.state)

        for k, v in pairs(self.slots) do 
            if k > self.data.seatCount then
                v.root:hide()
            else
                v.root:show()
                local p = self.data.players[k]

                if p == nil then
                    v.icon:hide()
                    v.add:show()

                    v.add:addClickListener(self.onAddClickedHandler, self)
                else
                    v.icon:show()
                    v.add:hide()
                    v.icon:setTexture(p.headerUrl)
                end
            end
        end
        
--        self.canJoin = (#self.data.players < self.data.seatCount)
        local detailText = convertConfigToString(self.data.cityType, self.data.gameType, self.data.config, false)
        self.mDetailText:setText(detailText)

        if gamepref.player.acId == self.data.managerAcId then
            self.mClose:show()
        else
            self.mClose:hide()
        end
    end
end

function friendsterDesk:setState(state)
    if self.data ~= nil then
        self.data.state = state
        self.mState:setText((state == 1) and "游戏中" or "等待中")
    end
end

function friendsterDesk:onAddClickedHandler()
    playButtonClickSound()
    enterDesk(self.data.cityType, self.data.deskId)
end

return friendsterDesk

--endregion
