//using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstanceObjectQueue : ObjectQueue
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Queue<Slot> mQueue = new Queue<Slot>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public override void Push(Object obj, float time)
    {
        mQueue.Enqueue(new Slot(obj, time));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override Slot Pop()
    {
        return (count == 0) ? null : mQueue.Dequeue();
    }

    /// <summary>
    /// 
    /// </summary>
    public override int count
    {
        get { return mQueue.Count; }
    }

    #endregion
}
