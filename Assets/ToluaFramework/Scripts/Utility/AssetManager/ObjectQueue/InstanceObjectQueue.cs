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
    /// <param name="key"></param>
    public InstanceObjectQueue(string key)
    {
        mKey = key;
    }

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
        return isEmpty ? null : mQueue.Dequeue();
    }

    /// <summary>
    /// 
    /// </summary>
    public override void DestroyUnused(float time, AssetLoader loader)
    {
        if (isEmpty) return;

        List<Slot> used = new List<Slot>();
        List<Slot> unused = new List<Slot>();

        int c = mQueue.Count;

        while(!isEmpty)
        {
            Slot s = Pop();

            if (Time.realtimeSinceStartup - s.timestamp >= time)
            {
                Debug.LogWarning("DestroyUnused, unused name = " + s.asset.name);
                unused.Add(s);
            }
            else
            {
                Debug.LogWarning("DestroyUnused, used name = " + s.asset.name);
                used.Add(s);
            }
        }

        foreach (Slot s in used)
        {
            mQueue.Enqueue(s);
        }

        Debug.LogWarningFormat("DestroyUnused, {0} + {1} = {2}", mQueue.Count, unused.Count, c);

        foreach(Slot s in unused)
        {
            loader.UnloadDependentAB(mKey);
            GameObject.Destroy(s.asset);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public override bool isEmpty
    {
        get { return mQueue.Count == 0; }
    }

    #endregion
}
