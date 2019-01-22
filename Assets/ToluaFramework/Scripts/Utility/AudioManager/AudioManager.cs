using UnityEngine;

/// <summary>
/// 
/// </summary>
public class AudioManager
{
    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private AudioChannel mBGMChannel = null;

    /// <summary>
    /// 
    /// </summary>
    private AudioChannel mUIChannel = null; 

    /// <summary>
    /// 
    /// </summary>
    private AudioChannel mGfxChannel = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AudioManager mInstance = new AudioManager();

    /// <summary>
    /// 
    /// </summary>
    public static AudioManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public void Setup()
    {
        Transform root = null;

        GameObject go = GameObject.Find("AudioManager");
        if (go != null)
        {
            GameObject.DontDestroyOnLoad(go);
            root = go.transform;
        }

        Initialize(root);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    public void PlayBGM(string audioPath, string audioName)
    {
        mBGMChannel.Play(audioPath, audioName, Audio.PlayMode.Loop);
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopBGM()
    {
        mBGMChannel.Stop();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    public void PlayUI(string audioPath, string audioName)
    {
        mUIChannel.Play(audioPath, audioName, Audio.PlayMode.Once);
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopUI()
    {
        mUIChannel.Stop();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    public void PlayGfx(string audioPath, string audioName)
    {
        mGfxChannel.Play(audioPath, audioName, Audio.PlayMode.Once);
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopGfx()
    {
        mGfxChannel.Stop();
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopAll()
    {
        StopBGM();
        StopUI();
        StopGfx();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <param name="volume"></param>
    public void SetBGMVolume(float volume)
    {
        mBGMChannel.volume = volume;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    public float GetBGMVolume()
    {
        return mBGMChannel.volume;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="volume"></param>
    public void SetSFXVolume(float volume)
    {
        mUIChannel.volume = volume;
        mGfxChannel.volume = volume;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    public float GetSFXVolume()
    {
        return mUIChannel.volume;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        if (mBGMChannel != null)
        {
            mBGMChannel.Update();
        }
        if (mUIChannel != null)
        {
            mUIChannel.Update();
        }
        if (mGfxChannel != null)
        {
            mGfxChannel.Update();
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private AudioManager()
    {

    }

    /// <summary>
    /// 初始化
    /// </summary>
    private void Initialize(Transform root)
    {
        mBGMChannel   = new AudioChannel(root, 1);
        mUIChannel    = new AudioChannel(root, 3);
        mGfxChannel   = new AudioChannel(root, 5);

        mBGMChannel.volume = 0.1f;
        mUIChannel.volume  = 0.1f;
        mGfxChannel.volume = 0.1f;
    }

    #endregion
}
