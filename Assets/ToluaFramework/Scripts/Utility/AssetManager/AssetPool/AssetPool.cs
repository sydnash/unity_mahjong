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
    private Dictionary<string, ObjectQueue> mQueueDict = new Dictionary<string, ObjectQueue>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<int, string> mIIDDict = new Dictionary<int, string>();

    /// <summary>
    /// 
    /// </summary>
    private float mAliveTime = int.MaxValue;

    #endregion

    #region Public

    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="root"></param>
    /// /// <param name="loader"></param>
    public AssetPool(AssetLoader loader, bool reference, float aliveTime = 5 * 60)
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
        ObjectQueue queue = null;
        string key = LFS.CombinePath(assetPath, assetName);

        if (mQueueDict.ContainsKey(key))
        {
            queue = mQueueDict[key];
        }
        else
        {
            queue = CreateObjectQueue(key);
            mQueueDict.Add(key, queue);
        }

        Object asset = null;

        if (!queue.isEmpty)
        {
            asset = queue.Pop().asset;
        }
        else
        {
            asset = LoadAsset(assetPath, assetName);
            int iid = asset.GetInstanceID();

            if (asset != null && !mIIDDict.ContainsKey(iid))
            {
                mIIDDict.Add(iid, key);
            }
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
        
        int iid = asset.GetInstanceID();
        if (mIIDDict.ContainsKey(iid))
        {
            string key = mIIDDict[iid];
            if (mQueueDict.ContainsKey(key))
            {
                ObjectQueue queue = mQueueDict[key];
                queue.Push(asset, Time.realtimeSinceStartup);

                return true;
            }
        }

        Logger.LogWarning(string.Format("[{0}] didn't load from assetpool！", asset.name));
        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (KeyValuePair<string, ObjectQueue> kvp in mQueueDict)
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
    private ObjectQueue CreateObjectQueue(string key)
    {
        if (mReference)
        {
            return new ReferenceObjectQueue(key);
        }

        return new InstanceObjectQueue(key);
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