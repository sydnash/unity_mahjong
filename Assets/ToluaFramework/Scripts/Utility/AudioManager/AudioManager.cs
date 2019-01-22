using System.Collections.Generic;
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
    private Transform mRoot = null;

    /// <summary>
    /// 
    /// </summary>
    private AudioChannel mGfxChannel = null;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, AudioChannel> mChannels = new Dictionary<string, AudioChannel>();

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
    /// <param name="channelName"></param>
    /// <param name="capacity"></param>
    /// <returns></returns>
    public AudioChannel AddChannel(string channelName, int capacity)
    {
        if (mChannels.ContainsKey(channelName))
        {
            return mChannels[channelName];
        }

        AudioChannel channel = new AudioChannel(root, capacity);
        channel.volume = 0.1f;
        mChannels.Add(channelName, channel);

        return channel;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    public void Play(string channelName, string audioPath, string audioName, bool loop)
    {
        if (mChannels.ContainsKey(channelName))
        {
            AudioChannel channel = mChannels[channelName];
            channel.Play(audioPath, audioName, loop ? Audio.PlayMode.Loop : Audio.PlayMode.Once);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Stop(string channelName)
    {
        if (mChannels.ContainsKey(channelName))
        {
            AudioChannel channel = mChannels[channelName];
            channel.Stop();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void StopAll()
    {
        foreach (KeyValuePair<string, AudioChannel> kvp in mChannels)
        {
            AudioChannel channel = kvp.Value;
            channel.Stop();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <param name="volume"></param>
    public void SetVolume(string channelName, float volume)
    {
        if (mChannels.ContainsKey(channelName))
        {
            AudioChannel channel = mChannels[channelName];
            channel.volume = volume;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    public float GetVolume(string channelName)
    {
        if (mChannels.ContainsKey(channelName))
        {
            AudioChannel channel = mChannels[channelName];
            return channel.volume;
        }

        return -1;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (KeyValuePair<string, AudioChannel> kvp in mChannels)
        {
            AudioChannel channel = kvp.Value;
            channel.Update();
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
    /// 
    /// </summary>
    private Transform root
    {
        get
        {
            if (mRoot == null)
            {
                GameObject go = GameObject.Find("AudioManager");
                if (go != null)
                {
                    GameObject.DontDestroyOnLoad(go);
                    mRoot = go.transform;
                }
            }

            return mRoot;
        }
    }

    #endregion
}
