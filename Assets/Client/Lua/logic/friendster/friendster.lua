--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local friendster = class("friendster")

function friendster:ctor(id)
    self.id                 = id
    self.name               = string.empty
    self.headerUrl          = string.empty
    self.headerTex          = nil
    self.cards              = 0
    self.maxMemberCount     = 0
    self.curMemberCount     = 0
    self.applyCode          = 0
    self.managerAcId        = 0
    self.managerNickname    = string.empty
end

function friendster:loadHeaderTex()
    self:destroy()

    --先显示默认头像
    self.headerTex = textureManager.load(string.empty, "JS_tx_a")
    --同时开始下载真实头像
    if not string.isNilOrEmpty(self.headerUrl) then 
        downloadIcon(self.headerUrl, function(tex)
            if self.headerTex ~= nil then
                textureManager.unload(self.headerTex, false)
            end
            self.headerTex = tex
        end)
    end
end

function friendster:destroy()
    if self.headerTex ~= nil then
        textureManager.unload(self.headerTex, true)
        self.headerTex = nil
    end
end

return friendster

--endregion
