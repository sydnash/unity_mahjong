--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local friendsterDesk = class("friendsterDesk", base)

function friendsterDesk:onInit()
    self.slots = { { root = self.mPlayerA, head = self.mPlayerA_Head, icon = self.mPlayerA_Icon, add = self.mPlayerA_Add, },
                   { root = self.mPlayerB, head = self.mPlayerB_Head, icon = self.mPlayerB_Icon, add = self.mPlayerB_Add, },
                   { root = self.mPlayerC, head = self.mPlayerC_Head, icon = self.mPlayerC_Icon, add = self.mPlayerC_Add, },
                   { root = self.mPlayerD, head = self.mPlayerD_Head, icon = self.mPlayerD_Icon, add = self.mPlayerD_Add, },
    }
end

function friendsterDesk:set(data)
    self.data = data

    if self.data ~= nil then
        self.mNum:setText(string.format("（第%d/%d局）", self.data.playedCount, self.data.totalCount))
        self:setState(self.data.state)

        for k, v in pairs(self.slots) do 
            if k > self.data.seatCount then
                v.root:hide()
            else
                v.root:show()
                local p = self.data.players[k]

                if p == nil then
                    v.head:hide()
                    v.add:show()

                    v.add:addClickListener(self.onAddClickedHandler, self)
                else
                    v.head:show()
                    v.add:hide()
                    v.icon:setTexture(p.headerTex)
                end
            end
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

    local loading = require("ui.loading").new()
    loading:show()

    signalManager.signal(signalType.enterDesk, { cityType = self.data.cityType, deskId = self.data.deskId, loading = loading })
end

function friendsterDesk:onDestroy()
    for _, v in pairs(self.slots) do 
        v.icon:setTexture(nil)
    end

    self.super.onDestroy(self)
end

return friendsterDesk

--endregion
