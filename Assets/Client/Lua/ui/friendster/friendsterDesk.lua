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

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    
    for k, v in pairs(self.slots) do 
        v.add:addClickListener(self.onAddClickedHandler, self)
    end
end

local function destroyDesk(friendsterId, cityType, deskId)
    showWaitingUI(string.format("正在关闭房间[%d]", deskId))

    networkManager.dissolveFriendsterDesk(friendsterId, cityType, deskId, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retcText[msg.RetCode])
            return
        end

        showMessageUI(string.format("房间[%d]已经解散", deskId))
    end)
end

function friendsterDesk:onCloseClickedHandler()
    showMessageUI(string.format("是否确定关闭房间[%d]？", self.data.deskId), 
                  function()
                      destroyDesk(self.data.friendsterId, self.data.cityType, self.data.deskId)
                  end, 
                  function()
                      --
                  end)

    playButtonClickSound()
end

function friendsterDesk:set(data)
    self.data = data

    for k, v in pairs(self.slots) do 
        v.root:hide()
    end
    if self.data ~= nil then
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
                else
                    v.icon:show()
                    v.add:hide()
                    v.icon:setTexture(p.headerUrl)
                end
            end
        end
        
        local detailText = convertConfigToString(self.data.cityType, self.data.gameType, self.data.config, true, true, ",")
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
