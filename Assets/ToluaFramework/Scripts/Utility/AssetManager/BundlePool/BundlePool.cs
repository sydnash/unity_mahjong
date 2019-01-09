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
    private static readonly string SUB_PATH = LFS.CombinePath("Res", LFS.OS_PATH);

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
        AssetBundle bundle = Load(LFS.CombinePath(LFS.PATCH_PATH, SUB_PATH, bundleName), true);
        if (bundle == null)
        {
            bundle = Load(LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, SUB_PATH, bundleName), false);
        }

        return bundle;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ab"></param>
    public void Unload(AssetBundle ab)
    {
        if (ab != null)
        {
            string key = ab.name;

            if (mBundles.ContainsKey(key))
            {
                Bundle bundle = mBundles[key];
                bundle.refCount = Mathf.Max(0, bundle.refCount - 1);

                if (bundle.refCount == 0)
                {
                    bundle.bundle.Unload(false);
                    mBundles.Remove(key);
                }
            }
        }
    }

    #endregion

    #region Pirvate

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundlePath"></param>
    /// <param name="checkExists"></param>
    /// <returns></returns>
    private AssetBundle Load(string bundlePath, bool checkExists)
    {
        Bundle bundle = null;
        
        if (!checkExists || System.IO.File.Exists(bundlePath))
        {
            if (mBundles.ContainsKey(bundlePath))
            {
                bundle = mBundles[bundlePath];
                bundle.refCount++;
            }
            else
            {
                AssetBundle assetBundle = AssetBundle.LoadFromFile(bundlePath);
                assetBundle.name = bundlePath;

                bundle = new Bundle(assetBundle);
                mBundles.Add(bundlePath, bundle);
            }
        }

        return (bundle == null) ? null : bundle.bundle;
    }

    #endregion
}
