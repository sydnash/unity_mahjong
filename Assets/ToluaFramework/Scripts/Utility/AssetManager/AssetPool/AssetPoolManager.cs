using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// 资源池管理器
/// </summary>
public class AssetPoolManager
{
    #region Enum

    /// <summary>
    /// AssetPool类型
    /// </summary>
    public enum Type
    {
        /// <summary>
        /// 模型
        /// </summary>
        Model = 0,

        /// <summary>
        /// 界面
        /// </summary>
        UI,

        /// <summary>
        /// 贴图
        /// </summary>
        Texture,

        /// <summary>
        /// 音效
        /// </summary>
        Audio,

        /// <summary>
        /// 
        /// </summary>
        End
    }

    #endregion

    #region Data

    /// <summary>
    /// 资源池列表
    /// </summary>
    private AssetPool[] mPools = new AssetPool[(int)Type.End];

    /// <summary>
    /// 
    /// </summary>
    private Transform mRoot = null;

    /// <summary>
    /// 
    /// </summary>
    private readonly static string[] mAssetPath = { "Model",
                                                    "UI",
                                                    "Texture",
                                                    "Sound",
                                                  };

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
    /// 从指定的pool中获取固有名称的资源对象
    /// </summary>
    /// <param name="type">pool类型</param>
    /// <param name="assetName">资源名称</param>
    /// <returns></returns>
    public Object Alloc(Type type, string assetPath, string assetName)
    {
        AssetPool pool = mPools[(int)type];
        return pool.Alloc(assetPath, assetName);
    }

    /// <summary>
    /// 将资源对象放回指定的pool中
    /// </summary>
    /// <param name="type">pool类型</param>
    /// <param name="asset">资源对象</param>
    public bool Dealloc(Type type, Object asset)
    {
        AssetPool pool = mPools[(int)type];
        bool success = pool.Dealloc(asset);

        if (success && (type == Type.Model || type == Type.UI) && mRoot != null)
        {
            GameObject go = asset as GameObject;
            go.transform.SetParent(mRoot, false);
        }

        return success;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (AssetPool pool in mPools)
        {
            pool.Update();
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
        mPools[(int)Type.Model]     = new AssetPool(new AssetLoader(mAssetPath[(int)Type.Model]),   false);
        mPools[(int)Type.UI]        = new AssetPool(new AssetLoader(mAssetPath[(int)Type.UI]),      false);
        mPools[(int)Type.Texture]   = new AssetPool(new AssetLoader(mAssetPath[(int)Type.Texture]), false);
        mPools[(int)Type.Audio]     = new AssetPool(new AssetLoader(mAssetPath[(int)Type.Audio]),   true);
    }

    #endregion
}