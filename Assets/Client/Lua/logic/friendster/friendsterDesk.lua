--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local friendsterDesk = class("friendsterDesk")

function friendsterDesk:ctor(data)
    self.deskId = data.DeskId
    self.cityType = data.GameType
    self.seatCount = data.SeatCnt
    self.state = data.Status

    self.config = table.fromjson(data.Config)
    self.gameType = self.config.Game
    self.totalCount = self.config.JuShu
    self.playedCount = data.CurJu

    self.players = {}
    self.playerCount = 0
end

function friendsterDesk:addPlayer(player)
    for _, p in pairs(self.players) do
        if p.acId == acId then return end
    end

    table.insert(self.players, player)
    self.playerCount = self.playerCount + 1
end

function friendsterDesk:removePlayer(acId)
    for k, p in pairs(self.players) do
        if p.acId == acId then
            table.remove(self.players, k)
            break
        end
    end

    self.playerCount = self.playerCount - 1
end

return friendsterDesk

--endregion
