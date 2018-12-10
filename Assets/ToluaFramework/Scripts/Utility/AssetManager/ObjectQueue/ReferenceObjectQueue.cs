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

    #endregion

    #region Public

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
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override Slot Pop()
    {
        return mReferenceSlot;
    }

    /// <summary>
    /// 
    /// </summary>
    public override int count
    {
        get { return (mReferenceSlot == null) ? 0 : 1; }
    }

    #endregion
}
