local mahjongGame   = require("logic.dss.dssGame")
local touch         = require("logic.touch")

local base = require("ui.common.view")
local dssOperation = class("dssOperation", base)

_RES_(dssOperation, "DssDeskUI", "DssOperationUI")
