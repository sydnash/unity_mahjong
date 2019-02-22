using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BundleManager
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
        public AssetBundle ab = null;

        /// <summary>
        /// 
        /// </summary>
        public int rc = 0;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ab"></param>
        public Bundle(AssetBundle ab)
        {
            this.ab = ab;
            this.rc = 1;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<int, Bundle> mBundles = new Dictionary<int, Bundle>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, int> mIIDDict = new Dictionary<string, int>();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static BundleManager mInstance = new BundleManager();

    /// <summary>
    /// 
    /// </summary>
    public static BundleManager instance
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
        Bundle bundle = null;

        if (mIIDDict.ContainsKey(bundleName))
        {
            int iid = mIIDDict[bundleName];

            if (mBundles.ContainsKey(iid))
            {
                bundle = mBundles[iid];
                bundle.rc++;
            }
        }

        if (bundle == null) 
        {
            AssetBundle ab = BundleLoader.instance.Load(bundleName);
            if (ab != null)
            {
                bundle = new Bundle(ab);
                int iid = ab.GetInstanceID();

                mIIDDict.Add(bundleName, iid);
                mBundles.Add(iid, bundle);
            }
        }
#if UNITY_EDITOR
        Debug.LogFormat("BundleManager.Load, name = {0}, rc = {1}", bundle.ab.name, bundle.rc);
#endif
        return (bundle == null) ? null : bundle.ab;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ab"></param>
    public void Unload(AssetBundle ab)
    {
        if (ab != null)
        {
            int iid = ab.GetInstanceID();
            Unload(iid);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleName"></param>
    public void Unload(string bundleName)
    {
        if (mIIDDict.ContainsKey(bundleName))
        {
            int iid = mIIDDict[bundleName];
            Unload(iid);
        }
#if UNITY_EDITOR
        else
        {
            Logger.LogError("Can't unload [" + bundleName + "] bundle");
        }
#endif
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="iid"></param>
    private void Unload(int iid)
    {
        if (mBundles.ContainsKey(iid))
        {
            Bundle bundle = mBundles[iid];
#if UNITY_EDITOR
            Debug.LogFormat("BundleManager.Unload, name = {0}, rc = {1}", bundle.ab.name, bundle.rc - 1);
#endif
            bundle.rc = Mathf.Max(0, bundle.rc - 1);
            
            if (bundle.rc == 0)
            {
                mBundles.Remove(iid);
                foreach (KeyValuePair<string, int> kvp in mIIDDict)
                {
                    if (kvp.Value == iid)
                    {
                        mIIDDict.Remove(kvp.Key);
                        break;
                    }
                }

                BundleLoader.instance.Unload(bundle.ab);
            }
        }
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    private BundleManager()
    {

    }

    #endregion
}
