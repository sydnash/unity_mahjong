using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DependentBundleManager
{
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

    /// <summary>
    /// 
    /// </summary>
    private static DependentBundleManager mInstance = new DependentBundleManager();

    /// <summary>
    /// 
    /// </summary>
    public static DependentBundleManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    /// <param name="assetName"></param>
    public void Load(string assetName)
    {
#if UNITY_EDITOR
        Debug.Log("DependentBundleManager.Load, key = " + assetName);
#endif
        InitDependentManifest();

        string[] dependentNames = mDependentManifest.GetAllDependencies(assetName);
        foreach (string dependentName in dependentNames)
        {
#if UNITY_EDITOR
            Debug.Log("      DependentBundleManager.Load, dependent = " + dependentName);
#endif
            AssetBundle ab = BundleManager.instance.Load(dependentName);
            if (ab != null)
            {
                if (!mAssetDict.ContainsKey(assetName))
                {
                    HashSet<string> set = new HashSet<string>();
                    set.Add(dependentName);

                    mAssetDict.Add(assetName, set);
                }
                else
                {
                    HashSet<string> set = mAssetDict[assetName];
                    set.Add(dependentName);
                }
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    public void Unload(string key)
    {
#if UNITY_EDITOR
        Debug.Log("DependentBundleManager.Unload, key = " + key);
#endif
        if (mAssetDict.ContainsKey(key))
        {
            HashSet<string> dependentBundleNames = mAssetDict[key];
            foreach (string dependentName in dependentBundleNames)
            {
#if UNITY_EDITOR
                Debug.Log("      DependentBundleManager.Unload, dependent = " + dependentName);
#endif
                BundleManager.instance.Unload(dependentName);
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

        AssetBundle ab = BundleManager.instance.Load("Res");
        mDependentManifest = ab.LoadAsset<AssetBundleManifest>(ASSETBUNDLE_MANIFEST);
    }

    #endregion
}
