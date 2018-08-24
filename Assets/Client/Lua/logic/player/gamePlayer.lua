--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = class("gamePlayer")

function gamePlayer:ctor(acid)
    self.acId = acid
    self.nickname = string.empty
end

return gamePlayer

--endregion
