using System;

public abstract class ObjectQueue
{
    /// <summary>
    /// 
    /// </summary>
    protected int mActivedCount = 0;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public abstract void Push(object obj);

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public abstract object Pop();

    /// <summary>
    /// 
    /// </summary>
    public abstract int count
    {
        get;
    }

    /// <summary>
    /// 
    /// </summary>
    public int activedCount
    {
        set { mActivedCount = value; }
        get { return mActivedCount; }
    }
}
