using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationEventManager
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Action> mDict = new Dictionary<string, Action>();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AnimationEventManager mInstance = new AnimationEventManager();

    /// <summary>
    /// 
    /// </summary>
    public static AnimationEventManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    /// <param name="callback"></param>
    public void RegisterTrigger(string key, Action callback)
    {
        if (mDict.ContainsKey(key))
        {
            mDict[key] = callback;
        }
        else
        {
            mDict.Add(key, callback);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void OnTrigger(string key)
    {
        if (mDict.ContainsKey(key))
        {
            mDict[key]();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void UnregisterTrigger(string key)
    {
        if (mDict.ContainsKey(key))
        {
            mDict.Remove(key);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Clear()
    {
        mDict.Clear();
    }

    #endregion
}
