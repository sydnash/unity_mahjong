--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

NETWORK_IS_BUSY = "网络繁忙，请稍后再试"

retcText = {
    [retc.ok]                              = "成功",
    [retc.authorFailed]                    = "授权失败",
    [retc.kickByOtherLogin]                = "帐号在别的地方登录，请重新登录",
    [retc.kickByAlreadyLogout]             = "已经退出登录，请重新登录",
    [retc.kickLongInactive]                = "登录失效，请重新登录",
    [retc.enterGSDeskFailed]               = "进入房间失败",
    [retc.enterGSDeskDeskNotFound]         = "没有找到房间",
    [retc.enterGSDeskDeskFull]             = "房间已经满员",
    [retc.enterGSDeskPlaying]              = "房间正在打牌中",
    [retc.enterGSDeskAlreadyInOtherDesk]   = "您已经在另外一个房间中",
    [retc.serverIsClosing]                 = "服务器正在维护",
    [retc.serverError]                     = "网络异常",
    [retc.checkDeskDeskNotFind]            = "桌子不存在",
    [retc.coinNotEnough]                   = "金币不足",
    [retc.transferToSelf]                  = "不能转账给自己",
    [retc.willClose]                       = "服务器即将出现",
    [retc.notSupportGameType]              = "玩家不在亲友圈",
    [retc.notInClub]                       = "您不是亲友圈的成员",
    [retc.playerHasTooMuchClub]            = "玩家亲友圈数量达到上限",
    [retc.clubIsFull]                      = "亲友圈已经满员了",
    [retc.clubNotFound]                    = "没有找到指定的亲友圈",
    [retc.clubPermision]                   = "您没有亲友圈的权限",
    [retc.clubCoinNotEnough]               = "亲友圈金币不足",
    [retc.playerNotFound]                  = "玩家没有找到",
    [retc.clubCardNegative]                = "亲友圈房卡不足",
    [retc.clubPlayerInDesk]                = "亲友圈还有玩家正在游戏",
    [retc.applyInfoNotFound]               = "申请信息已经不存在",
    [retc.playerIsAlreadyInClub]           = "玩家已经在亲友圈",
}

cityName = {
    [cityType.chengdu] = "成都",
    [cityType.jintang] = "金堂",
}

mailGiftName = {
    ["jiangquan"] = "奖券",
}

errTextWx = {
    [errCodeWx.comm]       = "通用错误",
    [errCodeWx.userCancel] = "用户已取消",
    [errCodeWx.sentFailed] = "发送失败",
    [errCodeWx.authDenied] = "系统拒绝授权",
    [errCodeWx.unsupport]  = "微信平台不支持",
    [errCodeWx.ban]        = "被微信平台禁止",
}

--endregion
