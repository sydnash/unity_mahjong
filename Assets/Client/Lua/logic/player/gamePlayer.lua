--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = class("gamePlayer")

function gamePlayer:ctor(acid)
    self.acId = acid
    self.nickname = string.empty
end

function gamePlayer:loadHeaderTex()
    self:destroy()

    --先显示默认头像
    self.headerTex = textureManager.load(string.empty, "JS_tx_a")
    --同时开始下载真实头像
    downloadIcon(self.headerUrl, function(tex)
        self.headerTex = tex
    end)
end

function gamePlayer:destroy()
    if self.headerTex ~= nil then
        textureManager.unload(self.headerTex, true)
        self.headerTex = nil
    end
end

return gamePlayer

--endregion
