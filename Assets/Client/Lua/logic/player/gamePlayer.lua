--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gamePlayer = class("gamePlayer")
local playHistory = require("logic.player.playHistory")

function gamePlayer:ctor(acid)
    self.acId        = acid
    self.nickname    = string.empty
    self.headerUrl   = string.empty
    self.playHistory = playHistory.new()
    self.friendsterPlayHistories = {}
end

function gamePlayer:setMails(data)
    if data ~= nil then
        self.mails = {}

        for _, v in pairs(data) do
            self:addMail(v)
        end
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

function gamePlayer:getFriendsterPlayHistory(friendsterId)
    local history = self.friendsterPlayHistories[friendsterId]
    if history == nil then
        history = playHistory.new(friendsterId)
        self.friendsterPlayHistories[friendsterId] = history
    end

    return history
end

function gamePlayer:destroy()
    
end

return gamePlayer

--endregion
