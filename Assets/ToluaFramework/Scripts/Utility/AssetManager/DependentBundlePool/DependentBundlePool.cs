using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DependentBundlePool
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class DependentBundle
    {
        /// <summary>
        /// 
        /// </summary>
        public AssetBundle bundle = null;

        /// <summary>
        /// 
        /// </summary>
        public int refCount = 0;
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
    private Dictionary<string, HashSet<string>> mAssetDict = new Dictionary<string, HashSet<string>>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, DependentBundle> mDependentBundleDict = new Dictionary<string, DependentBundle>();

    /// <summary>
    /// 
    /// </summary>
    private static readonly string SUB_PATH = LFS.CombinePath("Res", LFS.OS_PATH);

    /// <summary>
    /// 
    /// </summary>
    private const string ASSETBUNDLE_MANIFEST = "AssetBundleManifest";

    #endregion

    #region Instance

    private static DependentBundlePool mInstance = new DependentBundlePool();

    public static DependentBundlePool instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <param name="dependentBundleName"></param>
    /// <param name="checkExists"></param>
    public void Load(string key, string assetName)
    {
        InitDependentManifest();

        string[] dependentNames = mDependentManifest.GetAllDependencies(assetName);

        foreach (string dependentName in dependentNames)
        {
            LoadBundle(dependentName);

            if (!mAssetDict.ContainsKey(key))
            {
                HashSet<string> set = new HashSet<string>();
                set.Add(dependentName);

                mAssetDict.Add(key, set);
            }
            else
            {
                HashSet<string> set = mAssetDict[key];
                set.Add(dependentName);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    public void Reload(string key)
    {
        if (mAssetDict.ContainsKey(key))
        {
            HashSet<string> set = mAssetDict[key];

            foreach (string bundleName in set)
            {
                LoadBundle(bundleName);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    public void Unload(string key)
    {
        if (mAssetDict.ContainsKey(key))
        {
            HashSet<string> dependentBundleNames = mAssetDict[key];

            foreach (string bundleName in dependentBundleNames)
            {
                if (mDependentBundleDict.ContainsKey(bundleName))
                {
                    DependentBundle dependentBundle = mDependentBundleDict[bundleName];
                    dependentBundle.refCount--;

                    if (dependentBundle.refCount == 0 && dependentBundle.bundle != null)
                    {
                        //Debug.Log("unload dependent bundle: " + bundleName);
                        dependentBundle.bundle.Unload(false);
                        mDependentBundleDict.Remove(bundleName);
                    }
                }
            }
        }
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

        string dependencies = LFS.OS_PATH;// LFS.CombinePath(SUB_PATH, LFS.OS_PATH);
        AssetBundle ab = BundlePool.instance.Load(dependencies);

        mDependentManifest = ab.LoadAsset<AssetBundleManifest>(ASSETBUNDLE_MANIFEST);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    private void LoadBundle(string bundleName)
    {
        if (mDependentBundleDict.ContainsKey(bundleName))
        {
            DependentBundle dependentBundle = mDependentBundleDict[bundleName];
            dependentBundle.refCount++;
        }
        else
        {
            AssetBundle ab = BundlePool.instance.Load(bundleName);

            if (ab != null)
            {
                DependentBundle dependentBundle = new DependentBundle();
                dependentBundle.bundle = ab;
                dependentBundle.refCount = 1;

                mDependentBundleDict.Add(bundleName, dependentBundle);
            }

            //Debug.Log("load dependent bundle: " + bundleName);
        }
    }

    #endregion
}
