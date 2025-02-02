--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongGame = require("logic.mahjong.mahjongGame")

local base = require("ui.common.view")
local location = class("location", base)

_RES_(location, "LocationUI", "LocationUI")

local SAVE_DISTANCE = 500
local COLOR_LINE_GREEN   = Color.New(93  / 255, 191 / 255, 82  / 255, 1)
local COLOR_LINE_RED     = Color.New(224 / 255, 100 / 255, 100 / 255, 1)
local COLOR_TEXT_GREEN   = Color.New(45  / 255, 140 / 255, 35  / 255, 1)
local COLOR_TEXT_RED     = Color.New(214 / 255, 68  / 255, 68  / 255, 1)

local function formatDistance(d)
    return (d < 1000) and string.format("%d 米", math.floor(d)) or string.format("%d 公里", math.floor(d / 1000)) 
end

function location:ctor(game)
    self.game = game
    base.ctor(self)
end

function location:onInit()
    local playerCount = self.game:getTotalPlayerCount()

    self.headers    = {}
    self.distances  = {}

    if playerCount == 4 then
        self.mPanel4:show()
        self.mPanel3:hide()
        self.mPanel2:hide()

        self.headers[seatType.mine]  = { icon = self.mPanel4_IconA, nickname = self.mPanel4_NicknameA, ip = self.mPanel4_IpA }
        self.headers[seatType.right] = { icon = self.mPanel4_IconB, nickname = self.mPanel4_NicknameB, ip = self.mPanel4_IpB }
        self.headers[seatType.top]   = { icon = self.mPanel4_IconC, nickname = self.mPanel4_NicknameC, ip = self.mPanel4_IpC }
        self.headers[seatType.left]  = { icon = self.mPanel4_IconD, nickname = self.mPanel4_NicknameD, ip = self.mPanel4_IpD }
        
        self.distances["01"] = { image = self.mPanel4_AB, text = self.mPanel4_AB_Text }
        self.distances["02"] = { image = self.mPanel4_AC, text = self.mPanel4_AC_Text }
        self.distances["03"] = { image = self.mPanel4_AD, text = self.mPanel4_AD_Text }
        self.distances["12"] = { image = self.mPanel4_BC, text = self.mPanel4_BC_Text }
        self.distances["13"] = { image = self.mPanel4_BD, text = self.mPanel4_BD_Text }
        self.distances["23"] = { image = self.mPanel4_CD, text = self.mPanel4_CD_Text }
    elseif playerCount == 3 then
        self.mPanel4:hide()
        self.mPanel3:show()
        self.mPanel2:hide()

        self.headers[seatType.mine]  = { icon = self.mPanel3_IconA, nickname = self.mPanel3_NicknameA, ip = self.mPanel3_IpA }
        self.headers[seatType.right] = { icon = self.mPanel3_IconB, nickname = self.mPanel3_NicknameB, ip = self.mPanel3_IpB }
        self.headers[seatType.left]  = { icon = self.mPanel3_IconD, nickname = self.mPanel3_NicknameD, ip = self.mPanel3_IpD }
                                                                                                                 
        self.distances["01"] = { image = self.mPanel3_AB, text = self.mPanel3_AB_Text }
        self.distances["03"] = { image = self.mPanel3_AD, text = self.mPanel3_AD_Text }
        self.distances["13"] = { image = self.mPanel3_BD, text = self.mPanel3_BD_Text }
    elseif playerCount == 2 then
        self.mPanel4:hide()
        self.mPanel3:hide()
        self.mPanel2:show()

        self.headers[seatType.mine] = { icon = self.mPanel2_IconA, nickname = self.mPanel2_NicknameA, ip = self.mPanel2_IpA }
        self.headers[seatType.top]  = { icon = self.mPanel2_IconC, nickname = self.mPanel2_NicknameC, ip = self.mPanel2_IpC }
                                                                                                                 
        self.distances["02"] = { image = self.mPanel2_AC, text = self.mPanel2_AC_Text }                       
                               
    end                        

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)

    for _, v in pairs(self.headers) do
        v.icon:hide()
        v.nickname:setText(string.empty)
        v.ip:setText(string.empty)
    end

    for _, v in pairs(self.distances) do
        v.image:setColor(COLOR_LINE_GREEN)
        v.text:setColor(COLOR_TEXT_GREEN)
        v.text:hide()
    end

    self:refreshUI()
end

function location:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function location:refreshUI()
    local players = {}

    for _, v in pairs(self.game.players) do
        local s = self.game:getSeatTypeByAcId(v.acId)
        local header = self.headers[s]

        header.icon:show()
        header.icon:setTexture(v.headerUrl)
        header.nickname:setText(v.nickname)
        header.ip:setText(v.ip)

        players[s] = v
    end

    for i=seatType.mine, seatType.left do
        local a = players[i]
        if a ~= nil then
            for j=i+1, seatType.left do
                local b = players[j]
                if b ~= nil then
                    local k = string.format("%d%d", i, j)
                    local v = self.distances[k]

                    if a.location.status and b.location.status then
                        local d = locationManager.distance(a.location, b.location)
                        v.text:setText(formatDistance(d))
                    else
                        v.text:setText("无法计算距离")
                    end
                    v.text:show()

--                    if d <= SAVE_DISTANCE then
--                        v.image:setColor(COLOR_LINE_GREEN)
--                        v.text:setColor(COLOR_TEXT_GREEN)
--                    else
--                        v.image:setColor(COLOR_LINE_RED)
--                        v.text:setColor(COLOR_TEXT_RED)
--                    end
                end
            end
        end
    end
end

function location:onCloseAllUIHandler()
    self:close()
end

function location:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return location

--endregion
