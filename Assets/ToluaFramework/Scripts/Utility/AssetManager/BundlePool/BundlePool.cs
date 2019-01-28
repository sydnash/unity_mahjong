using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BundlePool
{
    #region Classes

    /// <summary>
    /// 
    /// </summary>
    private class Bundle
    {
        /// <summary>
        /// 
        /// </summary>
        public AssetBundle bundle = null;

        /// <summary>
        /// 
        /// </summary>
        public int refCount = 0;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ab"></param>
        public Bundle(AssetBundle ab)
        {
            this.bundle = ab;
            this.refCount = 1;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Bundle> mBundles = new Dictionary<string, Bundle>();

    /// <summary>
    /// 
    /// </summary>
    private const string SUB_PATH = "Res";

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static BundlePool mInstance = new BundlePool();

    /// <summary>
    /// 
    /// </summary>
    public static BundlePool instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    /// <returns></returns>
    public AssetBundle Load(string bundleName)
    {
        AssetBundle ab = Load(LFS.CombinePath(LFS.PATCH_PATH, SUB_PATH), bundleName, true);
        if (ab == null)
        {
            ab = Load(LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, SUB_PATH), bundleName, false);
        }

        return ab;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ab"></param>
    public void Unload(AssetBundle ab)
    {
        if (ab != null)
        {
            UnloadByName(ab.name);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    public void UnloadByName(string bundleName)
    {
        if (mBundles.ContainsKey(bundleName))
        {
            Bundle bundle = mBundles[bundleName];
#if UNITY_EDITOR
            if (bundle.refCount - 1 == 0)
            {
                Debug.LogWarning("BundlePool.UnloadByName, name = " + bundle.bundle.name + ", ref = " + bundle.refCount.ToString());
            }
            else if (bundle.refCount - 1 < 0)
            {
                Debug.LogError("BundlePool.UnloadByName, name = " + bundle.bundle.name + ", ref = " + bundle.refCount.ToString());
            }
#endif
            bundle.refCount = Mathf.Max(0, bundle.refCount - 1);

            if (bundle.refCount == 0)
            {
                bundle.bundle.Unload(false);
                mBundles.Remove(bundleName);
            }
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

    #region Pirvate

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundlePath"></param>
    /// <param name="checkExists"></param>
    /// <returns></returns>
    private AssetBundle Load(string bundlePath, string bundleName, bool checkExists)
    {
        Bundle bundle = null;
        string path = LFS.CombinePath(bundlePath, bundleName);

        if (!checkExists || System.IO.File.Exists(path))
        {
            if (mBundles.ContainsKey(bundleName))
            {
                bundle = mBundles[bundleName];
                bundle.refCount++;
            }
            else
            {
                AssetBundle ab = AssetBundle.LoadFromFile(path);

                bundle = new Bundle(ab);
                mBundles.Add(ab.name, bundle);
            }
        }

        if (bundle != null)
        {
            //Debug.Log("BundlePool.Load, name = " + bundle.bundle.name + ", ref = " + bundle.refCount.ToString());
        }

        return (bundle == null) ? null : bundle.bundle;
    }

    #endregion
}
