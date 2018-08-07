using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 
/// </summary>
public class AudioChannel
{
    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private Transform mRoot = null;

    /// <summary>
    /// 
    /// </summary>
    private int mCapacity = 1;

    /// <summary>
    /// 
    /// </summary>
    private float mVolume = 1.0f;

    /// <summary>
    /// 
    /// </summary>
    private List<Audio> mAudioList = new List<Audio>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="capacity"></param>
    public AudioChannel(Transform root, int capacity = 1)
    {
        mRoot = root;
        mCapacity = Mathf.Max(1, capacity);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="audioName"></param>
    /// <param name="type"></param>
    public void Play(string audioName, Audio.PlayMode playMode = Audio.PlayMode.Once)
    {
        if (string.IsNullOrEmpty(audioName)) 
            return;

        if (mAudioList.Count < mCapacity)
        {
            Audio audio = new Audio(mRoot, audioName, playMode);
            audio.volume = mVolume;
            mAudioList.Add(audio);

            audio.Play();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Stop()
    {
        foreach (Audio audio in mAudioList)
        {
            audio.Stop();
        }

        mAudioList.Clear();
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (Audio audio in mAudioList)
        {
            audio.Update();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public float volume
    {
        set
        {
            mVolume = Mathf.Clamp01(value);

            foreach (Audio audio in mAudioList)
            {
                audio.volume = mVolume;
            }
        }
        get { return mVolume; }
    }

    #endregion
}
