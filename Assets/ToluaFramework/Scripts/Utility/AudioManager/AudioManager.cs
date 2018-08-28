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

    /// <summary>
    /// 
    /// </summary>
    private AudioChannel mVoiceChannel = null;

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
    /// <param name="audioName"></param>
    public void PlayVoice(string audioPath, string audioName)
    {
        mVoiceChannel.Play(audioPath, audioName, Audio.PlayMode.Once);
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopVoice()
    {
        mVoiceChannel.Stop();
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopAll()
    {
        StopBGM();
        StopUI();
        StopGfx();
        StopVoice();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <param name="volume"></param>
    public void SetBGMVolume(float volume)
    {
        volume = Mathf.Clamp01(volume);
        mBGMChannel.volume = volume;

        PlayerPrefs.SetFloat("AUDIO_BGM_VOLUME", volume);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    public float GetBGMVolume()
    {
        return PlayerPrefs.HasKey("AUDIO_BGM_VOLUME") ? PlayerPrefs.GetFloat("AUDIO_BGM_VOLUME") : 0.6f;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="volume"></param>
    public void SetSEVolume(float volume)
    {
        volume = Mathf.Clamp01(volume);

        mUIChannel.volume = volume;
        mGfxChannel.volume = volume;
        mVoiceChannel.volume = volume;

        PlayerPrefs.SetFloat("AUDIO_SE_VOLUME", volume);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    public float GetSEVolume()
    {
        return PlayerPrefs.HasKey("AUDIO_SE_VOLUME") ? PlayerPrefs.GetFloat("AUDIO_SE_VOLUME") : 0.8f;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Save()
    {
        PlayerPrefs.Save();
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        mBGMChannel.Update();
        mUIChannel.Update();
        mGfxChannel.Update();
        mVoiceChannel.Update();
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
        mUIChannel    = new AudioChannel(root, 2);
        mGfxChannel   = new AudioChannel(root, 5);
        mVoiceChannel = new AudioChannel(root, 3);

        SetBGMVolume(GetBGMVolume());
        SetSEVolume(GetSEVolume());

        Save();
    }

    #endregion
}
