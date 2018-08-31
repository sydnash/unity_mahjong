--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local login = class("login", base)

login.folder = "LoginUI"
login.resource = "LoginUI"

function login:onInit()
    self.mWechatLogin:hide()
    self.mGuestLogin:addClickListener(self.onGuestLoginClickedHandler, self)
    self.mAgreement:addChangedListener(self.onAgreementChangedHandler, self)
end

function login:onGuestLoginClickedHandler()
    playButtonClickSound()

    self.mWechatLogin:setInteractabled(false)
    self.mGuestLogin:setInteractabled(false)

    local waiting = require("ui.waiting").new()
    waiting:show()

    networkManager.login(function(ok, msg)
        waiting:close()

        self.mWechatLogin:setInteractabled(true)
        self.mGuestLogin:setInteractabled(true)

        if not ok then
            log("login failed")
            showMessage("网络繁忙，请稍后再试")
            return
        end

        if msg.RetCode ~= retc.Ok then
            log(retText[msg.RetCode])
            return
        end

        log("login succssfully, acid = " .. tostring(msg.AcId) .. ", nickname = " .. msg.Nickname)

        local loading = require("ui.loading").new()
        loading:show()

        local deskInfo = msg.DeskInfo

        if deskInfo == nil or deskInfo.DeskId == 0 then
            sceneManager.load("LobbyScene", function(completed, progress)
                loading:setProgress(progress)

                if completed then
                    local lobby = require("ui.lobby").new()
                    lobby:show()

                    loading:close()
                end
            end)
        else -- 如有在房间内则跳过大厅直接进入房间
            local cityType = deskInfo.GameType
            local deskId = deskInfo.DeskId

            networkManager.checkDesk(cityType, deskId, function(ok, msg)
                if not ok then
                    log("check desk error")
                    loading:close()
                    showMessage("网络繁忙，请稍后再试")
                    return
                end

                loading:setProgress(0.2)

                networkManager.enterDesk(cityType, deskId, function(ok, msg)
                    if not ok then
                        log("enter desk error")
                        loading:close()
                        showMessage("网络繁忙，请稍后再试")
                        return
                    end

                    if msg.RetCode ~= retc.Ok then
                        loading:close()
                        log(retcText[msg.RetCode])
                        return
                    end

                    loading:setProgress(0.4)

                    sceneManager.load("MahjongScene", function(completed, progress)
                        loading:setProgress(0.4 + 0.6 * progress)

                        if completed then
                            msg.Reenter = table.fromjson(msg.Reenter)
                            msg.Config = table.fromjson(msg.Config)

                            local desk = require("logic.mahjong.mahjongGame").new(msg)
                            loading:close()
                        end
                    end)
                end)
            end)
        end

        self:close()
    end)
end

function login:onAgreementChangedHandler(selected)
    self.mWechatLogin:setInteractabled(selected)
    self.mGuestLogin:setInteractabled(selected)
end

return login

--endregion
