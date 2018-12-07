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
    //private DependentBundlePool mDependentBundlePool = null;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Bundle> mDependentBundles = new Dictionary<string, Bundle>();

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
    private const float UNLOAD_DELAY_TIME = 1f;

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
        List<string> removeKeys = new List<string>();
        float currentTime = Time.realtimeSinceStartup;

        foreach (KeyValuePair<string, Bundle> p in mDependentBundles)
        {
            string key = p.Key;
            Bundle bundle = p.Value;

            if (currentTime - bundle.timestamp > UNLOAD_DELAY_TIME)
            {
                removeKeys.Add(key);
                Debug.Log("unload bundle: " + key);
                bundle.bundle.Unload(false);
            }
        }

        foreach (string key in removeKeys)
        {
            mDependentBundles.Remove(key);
        }

        //foreach (KeyValuePair<string, Bundle> p in mBundles)
        //{
        //    string key = p.Key;
        //    Bundle bundle = p.Value;

        //    if (currentTime - bundle.timestamp >= mUnloadDelayTime)
        //    {
        //        mDependentBundlePool.Unload(key);
        //        Unload(bundle);
        //        willDeleteKeys.Add(key);
        //    }
        //}

        //foreach (string key in willDeleteKeys)
        //{
        //    mBundles.Remove(key);
        //}
    }

    /// <summary>
    /// 
    /// </summary>
    //public DependentBundlePool dependentBundlePool
    //{
    //    set { mDependentBundlePool = value; }
    //    get { return mDependentBundlePool; }
    //}

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
    public void LoadDependentAB(string assetPath, string assetName)
    {
        if (mDependentManifest == null)
            return;

        string target = LFS.CombinePath(mPath, assetPath, assetName);
        string[] dependentNames = mDependentManifest.GetAllDependencies(target);

        foreach (string dependentName in dependentNames)
        {
            if (mDependentBundles.ContainsKey(dependentName))
            {
                mDependentBundles[dependentName].timestamp = Time.realtimeSinceStartup;
            }
            else
            {
                var ab = LoadAssetBundle(LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, SUB_PATH, dependentName), true);
                if (ab == null)
                {
                    ab = LoadAssetBundle(LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, SUB_PATH, dependentName), false);
                }

                Bundle bundle = new Bundle();
                bundle.bundle = ab;
                bundle.timestamp = Time.realtimeSinceStartup;

                mDependentBundles.Add(dependentName, bundle);
            }
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
            ab.Unload(false);
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
        if (!checkExists || System.IO.File.Exists(bundleName))
        {
            Debug.Log("load bundle: " + bundleName);
            return AssetBundle.LoadFromFile(bundleName);
        }

        return null;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundle"></param>
    //private void Unload(Bundle bundle)
    //{
    //    if (bundle.bundle != null)
    //    {
    //        bundle.bundle.Unload(false);
    //        bundle.bundle = null;
    //    }
    //}

    #endregion
}