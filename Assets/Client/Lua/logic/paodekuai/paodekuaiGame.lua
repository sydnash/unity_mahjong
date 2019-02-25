--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")

local base = require("logic.game")
local paodekuaiGame = class("paodekuaiGame", base)

function paodekuaiGame:ctor(data, playback)
    base.ctor(self, data, playback)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:createOperationUI()
    return require("ui.paodekuaiDesk.paodekuaiOperation").new(self)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function paodekuaiGame:createDeskUI()
    return require("ui.paodekuaiDesk.paodekuaiDesk").new(self)
end

return paodekuaiGame

--endregion
