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

        key = key.ToLower();
        string[] dependentNames = mDependentManifest.GetAllDependencies(assetName);

        foreach (string dependentName in dependentNames)
        {
            AssetBundle ab = BundlePool.instance.Load(dependentName);
            if (ab != null)
            {
                if (!mAssetDict.ContainsKey(key))
                {
                    HashSet<string> set = new HashSet<string>();
                    set.Add(ab.name);

                    mAssetDict.Add(key, set);
                }
                else
                {
                    HashSet<string> set = mAssetDict[key];
                    set.Add(ab.name);
                }
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    public void Reload(string key)
    {
        key = key.ToLower();

        if (mAssetDict.ContainsKey(key))
        {
            HashSet<string> set = mAssetDict[key];

            foreach (string bundleName in set)
            {
                BundlePool.instance.Load(bundleName);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    public void Unload(string key)
    {
        key = key.ToLower();

        if (mAssetDict.ContainsKey(key))
        {
            HashSet<string> dependentBundleNames = mAssetDict[key];

            foreach (string bundleName in dependentBundleNames)
            {
                BundlePool.instance.UnloadByName(bundleName);
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

        AssetBundle ab = BundlePool.instance.Load("Res");
        mDependentManifest = ab.LoadAsset<AssetBundleManifest>(ASSETBUNDLE_MANIFEST);
    }

    #endregion
}
