--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local retc = require("network.retc")

return {
    [retc.Ok]                              = "成功",
    [retc.AuthorFailed]                    = "",
    [retc.KickByOtherLogin]                = "",
    [retc.KickByAlreadyLogout]             = "",
    [retc.KickLongInactive]                = "",
    [retc.EnterGSDeskFailed]               = "进入房间失败",
    [retc.EnterGSDeskDeskNotFound]         = "没有找到房间",
    [retc.EnterGSDeskDeskFull]             = "房间已经满员",
    [retc.EnterGSDeskPlaying]              = "房间正在打牌中",
    [retc.EnterGSDeskAlreadyInOtherDesk]   = "您已经在另外一个房间中",
    [retc.ServerIsClosing]                 = "",
    [retc.ServerError]                     = "",
    [retc.CheckDeskDeskNotFind]            = "",
    [retc.CoinNotEnough]                   = "",
    [retc.TransferToSelf]                  = "",
    [retc.WillClose]                       = "",
    [retc.NotSupportGameType]              = "",
    [retc.NotInClub]                       = "",
    [retc.PlayerHasTooMuchClub]            = "",
    [retc.ClubIsFull]                      = "",
    [retc.ClubNotFound]                    = "",
    [retc.ClubPermision]                   = "",
    [retc.ClubCoinNotEnough]               = "",
    [retc.PlayerNotFound]                  = "",
    [retc.ClubCardNegative]                = "",
    [retc.ClubPlayerInDesk]                = "",
    [retc.ApplyInfoNotFound]               = "",
    [retc.PlayerIsAlreadyInClub]           = "",
}

--endregion
