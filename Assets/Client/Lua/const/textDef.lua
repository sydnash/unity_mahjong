--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local retc = require("network.retc")

retcText = {
    [retc.Ok]                              = "成功",
    [retc.AuthorFailed]                    = "授权失败",
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
    [retc.NotInClub]                       = "您不是亲友圈的成员",
    [retc.PlayerHasTooMuchClub]            = "",
    [retc.ClubIsFull]                      = "亲友圈已经满员了",
    [retc.ClubNotFound]                    = "没有找到指定的亲友圈",
    [retc.ClubPermision]                   = "您没有亲友圈的权限",
    [retc.ClubCoinNotEnough]               = "",
    [retc.PlayerNotFound]                  = "",
    [retc.ClubCardNegative]                = "",
    [retc.ClubPlayerInDesk]                = "",
    [retc.ApplyInfoNotFound]               = "",
    [retc.PlayerIsAlreadyInClub]           = "",
}

cityName = {
    [cityType.chengdu]  = "成都",
    [cityType.wenjiang] = "温江", 
    [cityType.pidu]     = "郫都",
}

--endregion
