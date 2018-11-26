--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = class("gamePlayer")
local playHistory = require("logic.player.playHistory")

local urls = {
    [16903] = "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIcqbm2StHBdfNBDWr5H0WYNbQS1qicYp0cl5N3tkIsLFKDXAzURiak94QjOeI23iaxclzIM6GcudwvA/132",
    [16917] = "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0",
    [10002] = "http://wx.qlogo.cn/mmopen/JcDicrZBlREhnNXZRudod9PmibRkIs5K2f1tUQ7lFjC63pYHaXGxNDgMzjGDEuvzYZbFOqtUXaxSdoZG6iane5ko9H30krIbzGv/0",
    [10003] = "http://wx.qlogo.cn/mmopen/UAqwJ95HSLycmQktIqAYuexoytJ3kJzknQ4icJkNpfUvxfqoNRDY2esKQj3YvxXuQacsu9fYKDQ1VUSVBxspic4MwNDTF4Z4zu/0",
}

function gamePlayer:ctor(acid)
    self.acId        = acid
    self.nickname    = string.empty
    self.headerUrl   = string.empty
    self.headerTex   = nil
    self.playHistory = playHistory.new()
    self.friendsterPlayHistories = {}
end

function gamePlayer:loadHeaderTex()
    self:destroy()

    --先显示默认头像
    self.headerTex = textureManager.load(string.empty, "JS_tx_a")
    --同时开始下载真实头像
    self.headerUrl = urls[self.acId]
    if not string.isNilOrEmpty(self.headerUrl) then 
        downloadIcon(self.headerUrl, function(tex)
            if self.headerTex ~= nil then
                textureManager.unload(self.headerTex, false)
                self.headerTex = nil
            end

            self.headerTex = tex

            local signalId = signalType.headerDownloaded .. tostring(self.acId)
            signalManager.signal(signalId, self.headerTex)
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
    if data.Status == mailStatus.deleted then
        return
    end

    local mail = {
        id      = data.Id,
        time    = data.CreateTime,
        title   = data.Title,
        content = data.Msg,
        status  = data.Status,
        extra   = table.fromjson(data.ExtraMsg),
    }

    table.insert(self.mails, mail)
end

function gamePlayer:removeMail(mailId)
    for k, v in pairs(self.mails) do
        if v.id == mailId then
            v.status = mailStatus.deleted
            table.remove(self.mails, k)
            break
        end
    end
end

function gamePlayer:getMail(mailId)
    for _, v in pairs(self.mails) do
        if v.id == mailId then
            return v
        end
    end

    return nil
end

function gamePlayer:destroy()
    if self.headerTex ~= nil then
        textureManager.unload(self.headerTex, false)
        self.headerTex = nil
    end
end

function gamePlayer:getFriendsterPlayHistory(friendsterId)
    local t = self.friendsterPlayHistories[friendsterId]
    if not t then
        t = playHistory.new(friendsterId)
        self.friendsterPlayHistories[friendsterId] = t
    end
    return t
end

return gamePlayer

--endregion
