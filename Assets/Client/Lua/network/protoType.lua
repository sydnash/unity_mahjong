--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

return {
    -- heart beat
    hb = "CmdType.fly.Ping",
    -- client to server
    cs = {
        reconnect                   = "CmdType.fly.CS.Reconnect",
        loginHs                     = "CmdType.fly.CS.LoginHs",
        createDesk                  = "CmdType.fly.CS.CreateDesk",
        checkDesk                   = "CmdType.fly.CS.CheckDesk",
        enterGSDesk                 = "CmdType.fly.CS.EnterGSDesk",
        ready                       = "CmdType.fly.CS.Ready",
        opChoose                    = "CmdType.fly.CS.MJOPChose",
        exitDesk                    = "CmdType.fly.CS.ExitGSDesk",
        exitVote                    = "CmdType.fly.CS.ExitVote",
        dpChoose                    = "CmdType.fly.CS_MJDQChose",
        chatMessage                 = "CmdType.fly.CS.ChatMsg",
        queryFriendsterList         = "CmdType.fly.CS_GetClubList",
        createFriendster            = "CmdType.fly.CS.CreateClub",
        queryFriendsterMembers      = "CmdType.fly.CS_GetClubPlayerList",
        queryFriendsterDesks        = "CmdType.fly.CS_GetClubDeskList",
        queryFriendsterInfo         = "CmdType.fly.CS.CheckClubInfo",
        queryAcId                   = "CmdType.fly.CS.CheckAcId",
        addAcIdToFriendster         = "CmdType.fly.CS_InviteIntoClub",
        deleteAcIdFromFriendster    = "CmdType.fly.CS_KickOutClub",
    },
    -- server to client
    sc = {
        loginHs                     = "CmdType.fly.SC.LoginHs",
        createDesk                  = "CmdType.fly.SC.CreateDesk",
        checkDesk                   = "CmdType.fly.SC.CheckDesk",
        enterGSDesk                 = "CmdType.fly.SC.EnterGSDesk",
        ready                       = "CmdType.fly.SC.Ready",
        otherEnterDesk              = "CmdType.fly.SC.OtherEnterDesk",
        start                       = "CmdType.fly.SC.MJStart",
        fapai                       = "CmdType.fly.SC.MJFaPai",
        oplist                      = "CmdType.fly.SC.MJOPList",
        opDo                        = "CmdType.fly.SC.MJOPDo",
        mopai                       = "CmdType.fly.SC.MJMoPai",
        clear                       = "CmdType.fly.SC.DSSClear",
        exitDesk                    = "CmdType.fly.SC.ExitGSDesk",
        otherExitDesk               = "CmdType.fly.SC.OtherExitDesk",
        notifyExitVote              = "CmdType.fly.SC.NotifyExitVote",
        notifyExitVoteFailed        = "CmdType.fly.SC.NotifyExitVoteFailed",
        exitVote                    = "CmdType.fly.SC.ExitVote",
        gameEnd                     = "CmdType.fly.SC.GameEnd",
        dqHint                      = "CmdType.fly.SC_MJDQHint",
        dqDo                        = "CmdType.fly.SC.MJDQDo",
        chatMessage                 = "CmdType.fly.SC.ChatMsg",
    },
}

--endregion
