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
    protected AssetLoader mLoader = null;

    /// <summary>
    /// 
    /// </summary>
    private bool mReference = false;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, ObjectQueue> mDic = new Dictionary<string, ObjectQueue>();

    #endregion

    #region Public

    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="root"></param>
    /// /// <param name="loader"></param>
    public AssetPool(AssetLoader loader, bool reference)
    {
        mLoader = loader;
        mReference = reference;
    }

    /// <summary>
    /// 获取指定名称的对象
    /// </summary>
    /// <param name="assetName">资源名称</param>
    /// <returns></returns>
    public Object Alloc(string assetPath, string assetName)
    {
        Object asset = null;

        if (mDic.ContainsKey(assetName))
        {
            ObjectQueue queue = mDic[assetName];
            if (queue.count > 0)
            {
                asset = queue.Pop() as Object;
            }
            else
            {
                asset = LoadAsset(assetPath, assetName, queue);
            }

            if (asset != null)
            {
                queue.activedCount++;
            }
        }
        else
        {
            ObjectQueue queue = CreateObjectQueue();

            asset = LoadAsset(assetPath, assetName, queue);
            mDic.Add(asset.name, queue);

            if (asset != null)
            {
                queue.activedCount++;
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

        string name = asset.name;
        if (mDic.ContainsKey(name))
        {
            ObjectQueue queue = mDic[name];
            queue.Push(asset);
            queue.activedCount--;

            return true;
        }

#if UNITY_EDITOR
        Debug.LogWarningFormat("[{0}] 不是从 assetpool 加载的！", name);
#endif

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        mLoader.Update();
    }

    /// <summary>
    /// 
    /// </summary>
    public bool reference
    {
        get { return mReference; }
    }

    /// <summary>
    /// 
    /// </summary>
    public IEnumerator<string> assetNameEnumerator
    {
        get { return mDic.Keys.GetEnumerator(); }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public int GetAssetActivedCount(string assetName)
    {
        if (mDic.ContainsKey(assetName))
        {
            return mDic[assetName].activedCount;
        }

        return 0;
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
    protected Object LoadAsset(string assetPath, string assetName, ObjectQueue queue)
    {
        Object asset = mLoader.Load(assetPath, assetName);

        if (asset != null)
        {
            if (!mReference)
            {
                asset = Object.Instantiate(asset);
                asset.name = asset.name.Replace("(Clone)", "");
            }
        }
#if UNITY_EDITOR
        else
        {
            Debug.LogErrorFormat("加载资源 [{0}] 失败", assetName);
        }
#endif

        return asset;
    }

    #endregion
}