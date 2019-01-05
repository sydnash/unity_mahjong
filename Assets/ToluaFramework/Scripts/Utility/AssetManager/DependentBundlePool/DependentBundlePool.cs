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

    // private static DependentBundlePool sThis = null;
    // public static DependentBundlePool Instance()
    // {
    //     if (sThis == null) {
    //         sThis = new DependentBundlePool();
    //     }
    //     return sThis;
    // }

    #endregion

    #region Data

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

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <param name="dependentBundleName"></param>
    /// <param name="checkExists"></param>
    public void Load(string key, string dependentBundleName)
    {
        LoadBundle(dependentBundleName);

        if (!mAssetDict.ContainsKey(key))
        {
            HashSet<string> set = new HashSet<string>();
            set.Add(dependentBundleName);

            mAssetDict.Add(key, set);
        }
        else
        {
            HashSet<string> set = mAssetDict[key];
            set.Add(dependentBundleName);
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
            AssetBundle ab = LoadBundle(LFS.CombinePath(LFS.PATCH_PATH, SUB_PATH), bundleName, true);
            if (ab == null)
            {
                ab = LoadBundle(LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, SUB_PATH), bundleName, false);
            }

            if (ab != null)
            {
                DependentBundle dependentBundle = new DependentBundle();
                mDependentBundleDict.Add(bundleName, dependentBundle);

                dependentBundle.bundle = ab;
                dependentBundle.refCount = 1;
            }

            //Debug.Log("load dependent bundle: " + bundleName);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundlePath"></param>
    /// <param name="bundleName"></param>
    /// <param name="checkExists"></param>
    /// <returns></returns>
    private AssetBundle LoadBundle(string bundlePath, string bundleName, bool checkExists)
    {
        string path = LFS.CombinePath(bundlePath, bundleName);

        if (!checkExists || System.IO.File.Exists(path))
        {
            return AssetBundle.LoadFromFile(path);
        }

        return null;
    }

    #endregion
}
