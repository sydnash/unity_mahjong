--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--------------------------------------------------------------
--
--------------------------------------------------------------
headerType = {
    td = 1, --3D模型
    wc = 2, --微信头像
}

--------------------------------------------------------------
--
--------------------------------------------------------------
language = {
    mandarin    = string.empty,
    sichuan     = "sc",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
sexType = {
    box  = 1,
    girl = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
retc = {
    ok                              = 0,
    authorFailed                    = 1001,
    kickByOtherLogin                = 1002,
    kickByAlreadyLogout             = 1003,
    kickLongInactive                = 1004,
    enterGSDeskFailed               = 1005,
    enterGSDeskDeskNotFound         = 1006,
    enterGSDeskDeskFull             = 1007,
    enterGSDeskPlaying              = 1008,
    enterGSDeskAlreadyInOtherDesk   = 1009,
    serverIsClosing                 = 1010,
    serverError                     = 1011,
    checkDeskDeskNotFind            = 1012,
    coinNotEnough                   = 1013,
    transferToSelf                  = 1014,
    willClose                       = 1015,
    notSupportGameType              = 1016,
    notInClub                       = 1017,
    playerHasTooMuchClub            = 1018,
    clubIsFull                      = 1019,
    clubNotFound                    = 1020,
    clubPermision                   = 1021,
    clubCoinNotEnough               = 1022,
    playerNotFound                  = 1023,
    clubCardNegative                = 1024,
    clubPlayerInDesk                = 1025,
    applyInfoNotFound               = 1026,
    playerIsAlreadyInClub           = 1027,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
opType = {
    mo   = { id = 0, },
    chu  = { id = 1, },
    chi  = { id = 2, },
    peng = { id = 3, },
    gang = { id = 4, 
             detail = { angang              = 0, 
                        bagangwithmoney     = 1, 
                        bagangwithoutmoney  = 2, 
                        minggang            = 3, 
             } 
    },
    hu = { id = 5, 
           detail = { zimo          = 10, 
                      dianpao       = 11, 
                      qianggang     = 12, 
                      gangshanghua  = 13, 
                      gangshangpao  = 14, 
                      haidilao      = 15,
                      haidipao      = 16, 
           } 
    },
    guo  = { id = 6, },
}

--------------------------------------------------------------
--
--------------------------------------------------------------
chatType = { 
    voice = 0,
    text  = 1,
    emoji = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
signalType = {
    chatText            = 1,
    chatEmoji           = 2,
    cardsChanged        = 3,
--    enterDesk           = 4,
    friendsterMessageOp = 5,
    mail                = 6,
    headerDownloaded    = "header|",
    city                = 8,
    closeAllUI          = 9,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityType = {
    chengdu = 1000,
    jintang = 3,   
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityTypeSID = {
    [cityType.chengdu] = "ChengDu",
    [cityType.jintang] = "JinTang",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
gameType = {
    mahjong = 5,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
gameTypeSID = {
    [gameType.mahjong] = "mahjong",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
friendsterNotifyType = {
    createDesk          = 0,
    deskPlayerChanged   = 1,
    deskStart        	= 2,
    deskDestroy      	= 3,
    deskPlayerEnter  	= 4,
    deskPlayerExit   	= 5,
    cardsChanged       	= 6,
    friendsterDestroy   = 7,
    removeMember    	= 8,
    addMember  	        = 9,
    playerOffline 	    = 10,
    playerOnline  	    = 11,
    applyEnterRequest   = 12,
    playerPlayInClub    = 13,
    playerPlayEndClub   = 14,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
userType = {
    normal      = 0,--普通玩家
    proxy       = 1,--代理
    club        = 2,--仅可开亲友圈
    transfer    = 3,--仅可转账
    operation   = 4,--1 and 2 and 3
}

--------------------------------------------------------------
--
--------------------------------------------------------------
mailStatus = {
    notRead = 0,
    read    = 1,
    claimed = 2,
    deleted = 3,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
errCodeWx = {
    ok         =  0,
    comm       = -1,
    userCancel = -2,
    sentFailed = -3,
    authDenied = -4,
    unsupport  = -5,
    ban        = -6,
}

gameMode = {
    normal   = 1,
    playback = 2,
}

--endregion
