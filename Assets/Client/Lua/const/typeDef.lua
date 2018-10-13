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
    mandarin    = "",
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
opType = {
    mo   = { id = 0, },
    chu  = { id = 1, },
    chi  = { id = 2, },
    peng = { id = 3, },
    gang = { id = 4, 
             detail = { angang              = 0, 
                        bagangwithmoney     = 1, 
                        bagangwithoutmoney  = 1, 
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
    chatTextSignal      = "chatText",
    chatEmojiSignal     = "chatEmoji",
    cardsChangedSignal  = "cardsChanged",
    enterDeskSignal     = "enterDesk",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityType = {
    chengdu     = 1000,
    wenjiang    = 1001,
    pidu        = 1002,
}

--endregion
