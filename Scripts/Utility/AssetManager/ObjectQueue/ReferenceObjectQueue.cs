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
    private object mReferenceObject = null;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public override void Push(object obj)
    {
        if (mReferenceObject == null)
        {
            mReferenceObject = obj;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override object Pop()
    {
        return mReferenceObject;
    }

    /// <summary>
    /// 
    /// </summary>
    public override int count
    {
        get { return (mReferenceObject == null) ? 0 : 1; }
    }

    #endregion
}
