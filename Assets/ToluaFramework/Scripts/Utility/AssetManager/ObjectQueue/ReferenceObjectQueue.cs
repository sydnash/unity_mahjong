using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 
/// </summary>
public class ReferenceObjectQueue : ObjectQueue
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Slot mReferenceSlot = null;

    /// <summary>
    /// 引用计数
    /// </summary>
    private int mReferenceAcc = 0;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public ReferenceObjectQueue(string key)
    {
        mKey = key;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public override void Push(Object obj, float time)
    {
        if (mReferenceSlot == null)
        {
            mReferenceSlot = new Slot(obj, time);
        }
        else
        {
            mReferenceSlot.timestamp = time;
        }

        mReferenceAcc = Mathf.Max(0, mReferenceAcc - 1);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override Slot Pop()
    {
        mReferenceAcc++;
        return mReferenceSlot;
    }

    /// <summary>
    /// 
    /// </summary>
    public override void DestroyUnused(float time, AssetLoader loader)
    {
        if (mReferenceAcc > 0 || isEmpty)
            return;

        if (Time.realtimeSinceStartup - mReferenceSlot.timestamp >= time)
        {
            loader.UnloadDependentAB(mKey);
            mReferenceSlot = null;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public override bool isEmpty
    {
        get { return mReferenceSlot == null; }
    }

    #endregion
}
