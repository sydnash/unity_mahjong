--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = class("gamePlayer")

function gamePlayer:ctor(acid)
    self.acId       = acid
    self.nickname   = string.empty
    self.headerUrl  = string.empty
    self.headerTex  = nil
end

function gamePlayer:loadHeaderTex()
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

function gamePlayer:setMails(data)
    self.mails = {}

    for _, v in pairs(data) do
        self:addMail(v)
    end
end

function gamePlayer:addMail(data)
    local mail = {
        id      = data.Id,
        time    = data.CreateTime,
        title   = data.Title,
        content = data.Msg,
        extra   = table.fromjson(data.ExtraMsg),
    }
    table.insert(self.mails, mail)
end

function gamePlayer:removeMail(mailId)
    for k, v in pairs(self.mails) do
        if v.id == mailId then
            table.remove(self.mails, k)
            break
        end
    end
end

function gamePlayer:destroy()
    if self.headerTex ~= nil then
        textureManager.unload(self.headerTex, true)
        self.headerTex = nil
    end
end

return gamePlayer

--endregion
