--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = require("logic.player.gamePlayer")
local mahjongType = require ("logic.mahjong.mahjongType")

local base = require("logic.mahjong.mahjongGame")
local mahjongGame = class("mahjongGame", base)

-------------------------------------------------------------------------------
-- 构造函数
-------------------------------------------------------------------------------
function mahjongGame:ctor(data, playback)
    base.ctor(self, data, playback)
end

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function mahjongGame:createOperationUI()
    return require("ui.mahjongDesk.mahjongOperation_YaoTongRenYong").new(self)
end

return mahjongGame

--endregion
