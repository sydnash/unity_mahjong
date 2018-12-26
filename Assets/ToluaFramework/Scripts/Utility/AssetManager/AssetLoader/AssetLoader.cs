using System.Collections.Generic;
using UnityEngine;

using LoadedBundlePool = System.Collections.Generic.Dictionary<string, UnityEngine.AssetBundle>;

/// <summary>
/// 资源加载器
/// </summary>
public class AssetLoader
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class Bundle
    {
        /// <summary>
        /// 
        /// </summary>
        public float timestamp = 0;

        /// <summary>
        /// 
        /// </summary>
        public AssetBundle bundle = null;
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static AssetBundleManifest mDependentManifest = null;

    /// <summary>
    /// 
    /// </summary>
    private DependentBundlePool mDependentBundlePool = DependentBundlePool.Instance();

    /// <summary>
    /// 
    /// </summary>
    private LoadedBundlePool mLoadedBundlePool = new LoadedBundlePool();

    /// <summary>
    /// 
    /// </summary>
    private float mLoadedTimestamp = 0;

    /// <summary>
    /// 
    /// </summary>
    private string mPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private string mLocalizedPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private string mDownloadPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private static readonly string SUB_PATH = LFS.CombinePath("Res", LFS.OS_PATH);

    /// <summary>
    /// 
    /// </summary>
    private const string ASSETBUNDLE_MANIFEST = "AssetBundleManifest";

    /// <summary>
    /// 
    /// </summary>
    private const float UNLOAD_DELAY_TIME = 0.5f;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    /// <param name="unloadDelayTime"></param>
    public AssetLoader(string path)
    {
        mPath = path.ToLower();
        string sub = LFS.CombinePath(SUB_PATH, mPath);

        mLocalizedPath = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, sub);
        mDownloadPath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, sub);

#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        InitDependentManifest();
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    /// <param name="checkExists"></param>
    /// <returns></returns>
    public AssetBundle LoadAssetBundle(string bundleName, bool checkExists = false)
    {
        AssetBundle bundle = null;

        if (!checkExists || System.IO.File.Exists(bundleName))
        {
            if (mLoadedBundlePool.ContainsKey(bundleName))
            {
                bundle = mLoadedBundlePool[bundleName];
            }
            else
            {
                bundle = AssetBundle.LoadFromFile(bundleName);
                mLoadedBundlePool.Add(bundleName, bundle);
            }
        }

        return bundle;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public Object Load(string assetPath, string assetName)
    {
        string name = LFS.CombinePath(assetPath.ToLower(), assetName.ToLower());

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        Object asset = Resources.Load(LFS.CombinePath(mPath, name));
#else
        LoadDependentAB(assetPath, assetName);

        Object asset = Load(LFS.CombinePath(mDownloadPath, name), assetName, true);
        if (asset == null)
        {
            asset = Load(LFS.CombinePath(mLocalizedPath, name), assetName, false);
        }
#endif

        return asset;
    }

    /// <summary>
    /// 加载依赖资源
    /// </summary>
    /// <param name="assetName"></param>
    public void LoadDependentAB(string assetPath, string assetName)
    {
        if (mDependentManifest == null)
            return;

        string key = CreateAssetKey(assetPath, assetName);

        string target = LFS.CombinePath(mPath, assetPath, assetName);
        string[] dependentNames = mDependentManifest.GetAllDependencies(target);

        foreach (string dependentName in dependentNames)
        {
            mDependentBundlePool.Load(key, dependentName);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void UnloadDependencies(string key)
    {
        mDependentBundlePool.Unload(key);
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        //在这里卸载bundle是因为：
        //   Unity2017.2版本中同步加载asset之后马上卸载bundle会引发crash
        if (Time.realtimeSinceStartup - mLoadedTimestamp > UNLOAD_DELAY_TIME)
        {
            foreach (KeyValuePair<string, AssetBundle> ab in mLoadedBundlePool)
            {
                ab.Value.Unload(false);
            }
            mLoadedBundlePool.Clear();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public static string CreateAssetKey(string assetPath, string assetName)
    {
        return LFS.CombinePath(assetPath, assetName).Replace("/", "|");
    }

    #endregion

    #region Private

    /// <summary>
    /// 加载 manifest
    /// </summary>
    private void InitDependentManifest()
    {
        if (mDependentManifest != null)
            return;

        string dependencies = LFS.CombinePath(SUB_PATH, LFS.OS_PATH);

        Object asset = Load(LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, dependencies), ASSETBUNDLE_MANIFEST, true);
        if (asset == null)
        {
            asset = Load(LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, dependencies), ASSETBUNDLE_MANIFEST, false);
        }

        mDependentManifest = asset as AssetBundleManifest;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <returns></returns>
    private Object Load(string bundleName, string assetName, bool checkExists = false)
    {
        Object asset = null;

        AssetBundle ab = LoadAssetBundle(bundleName, checkExists);
        if (ab != null)
        {
            asset = ab.LoadAsset(assetName);
            //ab.Unload(false);  Unity 2017.2中会引发crash，故屏蔽之
            mLoadedTimestamp = Time.realtimeSinceStartup;
        }

        return asset;
    }

    #endregion
}