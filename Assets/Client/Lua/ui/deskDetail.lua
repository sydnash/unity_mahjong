--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local deskDetail = class("deskDetail", base)

_RES_(deskDetail, "DeskDetailUI", "DeskDetailUI")

function deskDetail:ctor(cityType, gameType, config)
    self.cityType = cityType
    self.gameType = gameType

    self.config = {}
    for k, v in pairs(config) do
        local c = deskDetailShiftConfig[cityTypeSID[cityType]][gameTypeSID[gameType]][k]
        if c ~= nil then
            self.config[k] = c[v]
        end
    end

    self.super.ctor(self)
end

function deskDetail:onInit()
    local path = string.format("ui.deskDetail.%s.deskDetail_%s", gameTypeSID[self.gameType], cityTypeSID[self.cityType])
    
    self.detail = require(path).new(self.config, false)
    self.detail:setParent(self.mDetailRoot)
    self.detail:show()

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
end

function deskDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function deskDetail:onDestroy()
    if self.detail ~= nil then
        self.detail:close()
        self.detail = nil
    end

    self.super.onDestroy(self)
end

return deskDetail

--endregion
