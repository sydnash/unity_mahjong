using System;
using System.Collections;
using System.Collections.Generic;

public class InstanceObjectQueue : ObjectQueue
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Queue<object> mQueue = new Queue<object>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public override void Push(object obj)
    {
        mQueue.Enqueue(obj);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override object Pop()
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
