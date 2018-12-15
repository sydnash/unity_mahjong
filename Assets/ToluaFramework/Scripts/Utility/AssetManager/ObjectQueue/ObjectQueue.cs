using UnityEngine;

public abstract class ObjectQueue
{
    /// <summary>
    /// 
    /// </summary>
    public class Slot
    {
        /// <summary>
        /// 
        /// </summary>
        public Object asset;

        /// <summary>
        /// 
        /// </summary>
        public float timestamp;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="t"></param>
        public Slot(Object o, float t)
        {
            asset = o;
            timestamp = t;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    public abstract void Push(Object obj, float time);

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public abstract Slot Pop();

    /// <summary>
    /// 
    /// </summary>
    public abstract void DestroyUnused(float time, AssetLoader loader);

    /// <summary>
    /// 
    /// </summary>
    public abstract bool isEmpty
    {
        get;
    }
}
