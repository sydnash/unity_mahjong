﻿using System.Collections;
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

    /// <summary>
    /// 
    /// </summary>
    private Queue<Audio> mUnusedAudios = new Queue<Audio>();

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
    public void Play(string audioPath, string audioName, Audio.PlayMode playMode = Audio.PlayMode.Once)
    {
        if (string.IsNullOrEmpty(audioName)) 
            return;

        if (mAudioList.Count < mCapacity)
        {
            Audio audio = null;

            if (mUnusedAudios.Count > 0)
            {
                audio = mUnusedAudios.Dequeue();
            }
            else
            {
                audio = new Audio(mRoot);
            }
            
            audio.volume = mVolume;
            mAudioList.Add(audio);

            audio.Play(audioPath, audioName, playMode);
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
            mUnusedAudios.Enqueue(audio);
        }

        mAudioList.Clear();
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        for (int i = mAudioList.Count - 1; i >= 0; i--)
        {
            Audio audio = mAudioList[i];
            audio.Update();

            if (audio.finished)
            {
                mAudioList.RemoveAt(i);
                mUnusedAudios.Enqueue(audio);
            }
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
