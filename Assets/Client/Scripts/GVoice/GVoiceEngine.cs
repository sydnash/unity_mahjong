using System;
using gcloud_voice;

public class GVoiceEngine
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private IGCloudVoice mCloudVoice = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool> mApplyMessageKeyCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool, string, string> mUploadedCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool, string, string> mDownloadedCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool, string> mPlayFinishedCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private static readonly string APP_ID = "1332598907";

    /// <summary>
    /// 
    /// </summary>
    private static readonly string APP_KEY = "bea65c58ca56ab39cb79d56b4347f4ff";

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static GVoiceEngine mInstance = new GVoiceEngine();

    /// <summary>
    /// 
    /// </summary>
    public static GVoiceEngine instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public bool Setup(string userID)
    {
        if (mCloudVoice == null)
        {
            mCloudVoice = GCloudVoice.GetEngine();
        }

        if (mCloudVoice != null)
        {
            if (GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.SetAppInfo(APP_ID, APP_KEY, userID) &&
                GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.Init()                              &&
                GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.SetMode(GCloudVoiceMode.Messages))
            {
                mCloudVoice.OnApplyMessageKeyComplete += OnApplyMessageKeyCompletedHandler;
                mCloudVoice.OnUploadReccordFileComplete += OnUploadReccordFileCompletedHandler;
                mCloudVoice.OnDownloadRecordFileComplete += OnDownloadRecordFileCompletedHandler;
                mCloudVoice.OnPlayRecordFilComplete += OnPlayRecordFilCompletedHandler;
                return true;
            }
        }

        mCloudVoice = null;
        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.Poll();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterApplyMessageKeyCallback(Action<bool> callback)
    {
        mApplyMessageKeyCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterUploadedCallback(Action<bool, string, string> callback)
    {
        mUploadedCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    public void RegisterDownloadedCallback(Action<bool, string, string> callback)
    {
        mDownloadedCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterPlayFinishedCallback(Action<bool, string> callback)
    {
        mPlayFinishedCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="timeout"></param>
    public void ApplyMessageKey(int timeout)
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.ApplyMessageKey(timeout);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ms"></param>
    public void SetMaxMessageLength(int ms)
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.SetMaxMessageLength(ms);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public bool StartRecord(string filename)
    {
        if (mCloudVoice != null)
        {
            return (GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.StartRecording(filename));
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public bool StopRecord()
    {
        if (mCloudVoice != null)
        {
            return (GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.StopRecording());
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="timeout"></param>
    /// <returns></returns>
    public void Upload(string filename, int timeout)
    {
        if (mCloudVoice != null)
        {
            // The result of UploadRecordedFile needs to be obtained from callback method: UploadReccordFileCompleteHandler
            int ret = mCloudVoice.UploadRecordedFile(filename, timeout);
            Logger.Log("Upload, ret = " + ret.ToString());
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public bool StartPlay(string filename)
    {
        if (mCloudVoice != null)
        {
            return (GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.PlayRecordedFile(filename));
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public bool StopPlay()
    {
        if (mCloudVoice != null)
        {
            return (GCloudVoiceErr.GCLOUD_VOICE_SUCC == (GCloudVoiceErr)mCloudVoice.StopPlayFile());
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="fileid"></param>
    /// <param name="filename"></param>
    /// <param name="timeout"></param>
    public void Download(string fileid, string filename, int timeout)
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.DownloadRecordedFile(fileid, filename, timeout);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Resume()
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.Resume();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Pause()
    {
        if (mCloudVoice != null)
        {
            mCloudVoice.Pause();
        }
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    private void OnApplyMessageKeyCompletedHandler(IGCloudVoice.GCloudVoiceCompleteCode code)
    {
        if (mApplyMessageKeyCallback != null)
        {
            bool ok = (IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_MESSAGE_KEY_APPLIED_SUCC == code);
            mApplyMessageKeyCallback(ok);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="filepath"></param>
    /// <param name="fileid"></param>
    private void OnUploadReccordFileCompletedHandler(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath, string fileid)
    {
        if (mUploadedCallback != null)
        {
            Logger.Log("OnUploadReccordFileCompletedHandler, code = " + code.ToString());
            bool ok = (IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_UPLOAD_RECORD_DONE == code);
            mUploadedCallback(ok, filepath, fileid);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="filepath"></param>
    /// <param name="fileid"></param>
    private void OnDownloadRecordFileCompletedHandler(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath, string fileid)
    {
        if (mDownloadedCallback != null)
        {
            Logger.Log("OnDownloadRecordFileCompletedHandler, code = " + code.ToString());
            bool ok = (IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_DOWNLOAD_RECORD_DONE == code);
            mDownloadedCallback(ok, filepath, fileid);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="filepath"></param>
    private void OnPlayRecordFilCompletedHandler(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath)
    {
        if (mPlayFinishedCallback != null)
        {
            bool ok = (IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_PLAYFILE_DONE == code);
            mPlayFinishedCallback(ok, filepath);
        }
    }

    #endregion
}
