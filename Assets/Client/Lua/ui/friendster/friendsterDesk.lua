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
    self.cityType = data.GameType
    self.deskId = data.DeskId

    table.sort(data.Players, function(a, b)
        return a == data.Creator
    end)

    self.mNum:setText(string.format("（第%d/%d局）", data.CurJu, data.Config.JuShu))

    if data.CurJu == 0 then
        self.mState:setText("等待中")
    else
        self.mState:setText("游戏中")
    end

    for k, v in pairs(self.slots) do 
        if k > data.SeatCnt then
            v.root:hide()
        else
            v.root:show()
            local p = data.Players[k]

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

function friendsterDesk:onAddClickedHandler()
    playButtonClickSound()

    local loading = require("ui.loading").new()
    loading:show()

    signalManager.signal(signalType.enterDeskSignal, { cityType = self.cityType, deskId = self.deskId, loading = loading })
end

function friendsterDesk:onDestroy()
    for _, v in pairs(self.slots) do 
        v.icon:setTexture(nil)
    end

    self.super.onDestroy(self)
end

return friendsterDesk

--endregion
