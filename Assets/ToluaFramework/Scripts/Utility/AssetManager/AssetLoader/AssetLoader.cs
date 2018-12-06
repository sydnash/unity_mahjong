using System.Collections.Generic;
using UnityEngine;

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
    private DependentBundlePool mDependentBundlePool = null;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Bundle> mBundles = new Dictionary<string, Bundle>();

    /// <summary>
    /// 
    /// </summary>
    private string mPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private float mUnloadDelayTime = 0.5f;

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

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    /// <param name="unloadDelayTime"></param>
    public AssetLoader(string path, float unloadDelayTime = 0.5f)
    {
        mPath = path.ToLower();
        mUnloadDelayTime = Mathf.Max(0.1f, unloadDelayTime);

        string sub = LFS.CombinePath(SUB_PATH, mPath);

        mLocalizedPath = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, sub);
        mDownloadPath  = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  sub);
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
        InitDependentManifest();
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
    /// 
    /// </summary>
    public void Update()
    {
        List<string> willDeleteKeys = new List<string>();
        float currentTime = Time.realtimeSinceStartup;

        foreach (KeyValuePair<string, Bundle> p in mBundles)
        {
            string key = p.Key;
            Bundle bundle = p.Value;

            if (currentTime - bundle.timestamp >= mUnloadDelayTime)
            {
                mDependentBundlePool.Unload(key);
                Unload(bundle);
                willDeleteKeys.Add(key);
            }
        }

        foreach (string key in willDeleteKeys)
        {
            mBundles.Remove(key);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public DependentBundlePool dependentBundlePool
    {
        set { mDependentBundlePool = value; }
        get { return mDependentBundlePool; }
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
    /// 加载依赖资源
    /// </summary>
    /// <param name="assetName"></param>
    private void LoadDependentAB(string assetPath, string assetName)
    {
        if (mDependentManifest == null)
            return;

        string key = CreateAssetKey(assetPath, assetName);

        string target = LFS.CombinePath(mPath, assetPath, assetName);
        string[] dependentNames = mDependentManifest.GetAllDependencies(target);

        foreach (string dependentName in dependentNames)
        {
            dependentBundlePool.Load(assetName, dependentName, key);
        }
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
        }

        return asset;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    /// <param name="checkExists"></param>
    /// <returns></returns>
    private AssetBundle LoadAssetBundle(string bundleName, bool checkExists = false)
    {
        Bundle bundle = null;

        if (!checkExists || System.IO.File.Exists(bundleName))
        {
            if (mBundles.ContainsKey(bundleName))
            {
                bundle = mBundles[bundleName];
            }
            else
            {
                bundle = new Bundle();
                mBundles.Add(bundleName, bundle);
            }

            if (bundle.bundle == null)
            {
                bundle.bundle = AssetBundle.LoadFromFile(bundleName);
            }

            bundle.timestamp = Time.realtimeSinceStartup;
        }

        return (bundle == null) ? null : bundle.bundle;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundle"></param>
    private void Unload(Bundle bundle)
    {
        if (bundle.bundle != null)
        {
            bundle.bundle.Unload(false);
            bundle.bundle = null;
        }
    }

    #endregion
}