using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// 资源池管理器
/// </summary>
public class AssetPoolManager
{
    #region Data

    /// <summary>
    /// 资源池列表
    /// </summary>
    private Dictionary<string, AssetPool> mPools = new Dictionary<string, AssetPool>();

    /// <summary>
    /// 
    /// </summary>
    private Transform mRoot = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AssetPoolManager mInstance = new AssetPoolManager();

    /// <summary>
    /// 实例
    /// </summary>
    public static AssetPoolManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public void Setup()
    {
        GameObject go = GameObject.Find("AssetManager");
        if (go != null)
        {
            GameObject.DontDestroyOnLoad(go);
            mRoot = go.transform;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetType"></param>
    /// <param name="assetPath"></param>
    /// <param name="isRefrence"></param>
    /// <returns></returns>
    public AssetPool AddPool(string assetType, string assetPath, bool isRefrence)
    {
        if (mPools.ContainsKey(assetType))
        {
            return null;
        }

        AssetPool pool = new AssetPool(new AssetLoader(assetPath), isRefrence);
        mPools.Add(assetType, pool);

        return pool;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetType"></param>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <param name="maxCount"></param>
    public void Preload(string assetType, string assetPath, string assetName)
    {
        AssetPool pool = mPools[assetType];
#if UNITY_EDITOR
        Debug.AssertFormat(pool != null, "can't find pool of assetType:[{0}]", assetType);
#endif
        Object o = pool.Preload(assetPath, assetName);

        GameObject go = o as GameObject;
        if (go != null)
        {
            go.SetActive(false);
            go.transform.SetParent(mRoot, false);
        }
    }

    /// <summary>
    /// 从指定的pool中获取固有名称的资源对象
    /// </summary>
    /// <param name="type">pool类型</param>
    /// <param name="assetName">资源名称</param>
    /// <returns></returns>
    public Object Alloc(string assetType, string assetPath, string assetName)
    {
        AssetPool pool = mPools[assetType];
#if UNITY_EDITOR
        Debug.AssertFormat(pool != null, "can't find pool of assetType:[{0}]", assetType);
#endif
        Object o = pool.Alloc(assetPath, assetName);

        GameObject go = o as GameObject;
        if (go != null)
        {
            go.transform.SetParent(null, false);
        }

        return o;
    }

    /// <summary>
    /// 将资源对象放回指定的pool中
    /// </summary>
    /// <param name="type">pool类型</param>
    /// <param name="asset">资源对象</param>
    public bool Dealloc(string assetType, Object asset)
    {
        AssetPool pool = mPools[assetType];
        bool success = pool.Dealloc(asset);

        if (success && mRoot != null)
        {
            GameObject go = asset as GameObject;
            if (go != null)
            {
                go.SetActive(false);
                go.transform.SetParent(mRoot, false);
            }
        }

        return success;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (KeyValuePair<string, AssetPool> kvp in mPools)
        {
            kvp.Value.Update();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void UnloadUnused()
    {
        Resources.UnloadUnusedAssets();
    }

    #endregion

    #region Private

    /// <summary>
    /// 初始化
    /// </summary>
    private AssetPoolManager()
    {
    }

    #endregion
}