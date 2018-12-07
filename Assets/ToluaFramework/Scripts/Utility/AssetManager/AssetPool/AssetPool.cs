﻿using UnityEngine;
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
    //private DependentBundlePool mDependentBundlePool = new DependentBundlePool();

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
        //mLoader.dependentBundlePool = mDependentBundlePool;

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
        string key = AssetLoader.CreateAssetKey(assetPath, assetName);

        if (mDic.ContainsKey(key))
        {
            ObjectQueue queue = mDic[key];
            if (queue.count > 0)
            {
                mLoader.LoadDependentAB(assetPath, assetName);
                asset = queue.Pop() as Object;
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
            mDic.Add(key, queue);

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
    public Object Preload(string assetPath, string assetName, int maxCount = 1)
    {
        string key = AssetLoader.CreateAssetKey(assetPath, assetName);
        ObjectQueue queue = mDic.ContainsKey(key) ? mDic[key] : null;

        if (queue == null)
        {
            queue = CreateObjectQueue();
            mDic.Add(key, queue);
        }

        if (queue.count < maxCount)
        {
            Object asset = LoadAsset(assetPath, assetName);
            if (asset != null)
            {
                asset.name = key;
                queue.Push(asset);
            }

            return asset;
        }

        return null;
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
        if (mDic.ContainsKey(key))
        {
            ObjectQueue queue = mDic[key];
            queue.Push(asset);

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
            Logger.LogError(string.Format("load asset [{0}] failed", assetName));
        }

        return asset;
    }

    #endregion
}