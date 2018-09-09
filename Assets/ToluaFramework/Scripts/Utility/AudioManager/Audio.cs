using UnityEngine;

/// <summary>
/// 
/// </summary>
public class Audio
{
    #region Enum

    /// <summary>
    /// 
    /// </summary>
    public enum PlayMode
    {
        /// <summary>
        /// 
        /// </summary>
        Once,

        /// <summary>
        /// 
        /// </summary>
        Loop,
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private AudioSource mAudioSource = null;

    /// <summary>
    /// 
    /// </summary>
    private AudioClip mAudioClip = null;

    /// <summary>
    /// 
    /// </summary>
    private PlayMode mPlayMode = PlayMode.Once;

    /// <summary>
    /// 
    /// </summary>
    private float mTimestamp = 0;

    /// <summary>
    /// 
    /// </summary>
    private bool mFinished = true;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    /// <param name="playMode"></param>
    public Audio(Transform root)
    {
        GameObject go = new GameObject("AudioSource");
        mAudioSource = go.AddComponent<AudioSource>();

        if (root != null)
        {
            go.transform.SetParent(root);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Play(string audioPath, string audioName, PlayMode playMode = PlayMode.Once)
    {
        mAudioClip = AssetPoolManager.instance.Alloc(0, audioPath, audioName) as AudioClip;
        if (mAudioClip != null)
        {
            mPlayMode = playMode;

            mAudioSource.clip = mAudioClip;
            mAudioSource.loop = (mPlayMode == PlayMode.Loop);
            mAudioSource.Play();

            mFinished = false;
        }

        mTimestamp = Time.realtimeSinceStartup;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Stop()
    {
        if (mAudioSource != null)
        {
            mAudioSource.Stop();
            mAudioSource.clip = null;
        }

        if (mAudioClip != null)
        {
            AssetPoolManager.instance.Dealloc(0, mAudioClip);
            mAudioClip = null;
        }

        mFinished = true;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        if (mAudioSource == null || mAudioClip  == null || mPlayMode == PlayMode.Loop) 
            return;

        if (Time.realtimeSinceStartup - mTimestamp > mAudioClip.length)
        {
            Stop();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public float volume
    {
        set { mAudioSource.volume = Mathf.Clamp01(value); }
        get { return mAudioSource.volume; }
    }

    /// <summary>
    /// 
    /// </summary>
    public bool finished
    {
        get { return mFinished; }
    }

    #endregion
}
