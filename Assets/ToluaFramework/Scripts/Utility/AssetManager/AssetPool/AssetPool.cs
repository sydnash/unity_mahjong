using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// 资源池
/// </summary>
public class AssetPool
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private AssetLoader mLoader = null;

    /// <summary>
    /// 
    /// </summary>
    private bool mReference = false;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, ObjectQueue> mQueueDic = new Dictionary<string, ObjectQueue>();

    /// <summary>
    /// 
    /// </summary>
    private float mAliveTime = 2 * 60;

    #endregion

    #region Public

    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="root"></param>
    /// /// <param name="loader"></param>
    public AssetPool(AssetLoader loader, bool reference, float aliveTime = 2 * 60)
    {
        mLoader    = loader;
        mReference = reference;
        mAliveTime = aliveTime;
    }

    /// <summary>
    /// 获取指定名称的对象
    /// </summary>
    /// <param name="assetName">资源名称</param>
    /// <returns></returns>
    public Object Alloc(string assetPath, string assetName)
    {
        Object asset = null;
        string key = AssetLoader.CreateAssetKey(assetPath, assetName);

        if (mQueueDic.ContainsKey(key))
        {
            ObjectQueue queue = mQueueDic[key];
            if (!queue.isEmpty)
            {
                asset = queue.Pop().asset;
            }
            else
            {
                asset = LoadAsset(assetPath, assetName);
            }

            if (asset != null)
            {
                asset.name = key;
            }
        }
        else
        {
            ObjectQueue queue = CreateObjectQueue();
            mQueueDic.Add(key, queue);

            asset = LoadAsset(assetPath, assetName);
            if (asset != null)
            {
                asset.name = key;
            }
        }

        return asset;
    }

    /// <summary>
    /// 预加载
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    public Object Preload(string assetPath, string assetName)
    {
        string key = AssetLoader.CreateAssetKey(assetPath, assetName);
        ObjectQueue queue = mQueueDic.ContainsKey(key) ? mQueueDic[key] : null;

        if (queue == null)
        {
            queue = CreateObjectQueue();
            mQueueDic.Add(key, queue);
        }

        Object asset = LoadAsset(assetPath, assetName);
        if (asset != null)
        {
            asset.name = key;
            queue.Push(asset, Time.realtimeSinceStartup);
        }

        return asset;
    }

    /// <summary>
    /// 将对象放回对象池
    /// </summary>
    /// <param name="asset">资源对象</param>
    public bool Dealloc(Object asset)
    {
        if (asset == null)
            return false;

        string key = asset.name;
        if (mQueueDic.ContainsKey(key))
        {
            ObjectQueue queue = mQueueDic[key];
            queue.Push(asset, Time.realtimeSinceStartup);

            return true;
        }

        Logger.LogWarning(string.Format("[{0}] didn't load from assetpool！", key));
        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (KeyValuePair<string, ObjectQueue> kvp in mQueueDic)
        {
            ObjectQueue queue = kvp.Value;
            queue.DestroyUnused(mAliveTime, mLoader);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public bool reference
    {
        get { return mReference; }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    private ObjectQueue CreateObjectQueue()
    {
        if (mReference)
        {
            return new ReferenceObjectQueue();
        }

        return new InstanceObjectQueue();
    }

    /// <summary>
    /// 加载资源
    /// </summary>
    /// <param name="assetName"></param>
    /// <returns></returns>
    protected Object LoadAsset(string assetPath, string assetName)
    {
        Object asset = mLoader.Load(assetPath, assetName);

        if (asset != null)
        {
            if (!mReference)
            {
                asset = Object.Instantiate(asset);
            }
        }
        else
        {
            Logger.LogError(string.Format("load asset [{0}] failed", LFS.CombinePath(assetPath, assetName)));
        }

        return asset;
    }

    #endregion
}