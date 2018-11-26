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
        huanNZhangChoose            = "CmdType.fly.CS.MJHSZChose",
        opChoose                    = "CmdType.fly.CS.MJOPChose",
        exitDesk                    = "CmdType.fly.CS.ExitGSDesk",
        exitVote                    = "CmdType.fly.CS.ExitVote",
        dpChoose                    = "CmdType.fly.CS_MJDQChose",
        chatMessage                 = "CmdType.fly.CS.ChatMsg",
        queryFriendsterList         = "CmdType.fly.CS_GetClubList",
        createFriendster            = "CmdType.fly.CS.CreateClub",
        dissolveFriendster          = "CmdType.fly.CS.DeleteClub",
        joinFriendster              = "CmdType.fly.CS.ApplyEnterClub",
        exitFriendster              = "CmdType.fly.CS_ExitClub",
        queryFriendsterMembers      = "CmdType.fly.CS_GetClubPlayerList",
        queryFriendsterDesks        = "CmdType.fly.CS_GetClubDeskList",
        queryFriendsterInfo         = "CmdType.fly.CS.CheckClubInfo",
        queryAcId                   = "CmdType.fly.CS.CheckAcId",
        addAcIdToFriendster         = "CmdType.fly.CS_InviteIntoClub",
        deleteAcIdFromFriendster    = "CmdType.fly.CS_KickOutClub",
        depositToFriendsterBank     = "CmdType.fly.CS.TopUpToClub",
        takeoutFromFriendsterBank   = "CmdType.fly.CS.WithdrawFromClub",
        queryFriendsterStatistics   = "CmdType.fly.CS_GetClubDeskHistory",
        replyFriendsterRequest      = "CmdType.fly.CS.ManageApplyRequest",
        mailOp                      = "CmdType.fly.CS.MailOp",
        proposerQuicklyStart        = "CmdType.fly.CS.ProposerQuicklyStart",
        quicklyStartChose           = "CmdType.fly.CS.QuicklyStartChose",
        syncLocation                = "CmdType.fly.CS.SyncLocation",
        transferCards               = "CmdType.fly.CS_TransferCoin",
        getPlayHistory              = "CmdType.fly.CS.GetDeskHistory",
        getPlayHistoryDetail        = "CmdType.fly.CS.GetDeskHistoryDetail",
        getClubPlayHistoryDetail    = "CmdType.fly.CS.ClubGetDeskHistoryDetail",
        sharePlayHistory            = "CmdType.fly.CS.ShareHistory",
        getSharePlayHistory         = "CmdType.fly.CS.GetShareHistory",
        setClubDeskPayed            = "CmdType.fly.CS.ClubDeskPayed",
        modifyFriendsterDesc        = "CmdType.fly.CS_ModifyClubDesc",
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
        huanNZhangHint              = "CmdType.fly.SC.MJHSZHint",
        huanNZhangChoose            = "CmdType.fly.SC.MJHSZChose",
        huanNZhangDo                = "CmdType.fly.SC.MJHSZDo",
        oplist                      = "CmdType.fly.SC.MJOPList",
        opDo                        = "CmdType.fly.SC.MJOPDo",
        mopai                       = "CmdType.fly.SC.MJMoPai",
        clear                       = "CmdType.fly.SC.DSSClear",
        exitDesk                    = "CmdType.fly.SC.ExitGSDesk",
        otherExitDesk               = "CmdType.fly.SC.OtherExitDesk",
        notifyConnectStatus         = "CmdType.fly.SC.NotifyConnectStatus",
        notifyExitVote              = "CmdType.fly.SC.NotifyExitVote",
        notifyExitVoteFailed        = "CmdType.fly.SC.NotifyExitVoteFailed",
        exitVote                    = "CmdType.fly.SC.ExitVote",
        gameEnd                     = "CmdType.fly.SC.GameEnd",
        dqHint                      = "CmdType.fly.SC_MJDQHint",
        dqDo                        = "CmdType.fly.SC.MJDQDo",
        chatMessage                 = "CmdType.fly.SC.ChatMsg",
        notifyFriendster            = "CmdType.fly.SC_NotifyClubInfo",
        mail                        = "CmdType.fly.SC.Mail",
        quicklyStartNotify          = "CmdType.fly.SC.QuicklyStartNotify",
        quicklyStartEndNotify       = "CmdType.fly.SC.QuicklyStartEndNotify",
        quicklyStartChose           = "CmdType.fly.SC.QuicklyStartChose",
        transferCards               = "CmdType.fly.SC_TransferCoin",
        notifyPropertyChange        = "CmdType.fly.SC.NotifyPropertyChange",
        getPlayHistory              = "CmdType.fly.SC.GetDeskHistory",
        getPlayHistoryDetail        = "CmdType.fly.SC.GetDeskHistoryDetail",
        getClubPlayHistoryDetail    = "CmdType.fly.SC.ClubGetDeskHistoryDetail",
        getClubPlayHistory          = "CmdType.fly.SC_GetClubDeskHistory",
    },
}


--endregion
