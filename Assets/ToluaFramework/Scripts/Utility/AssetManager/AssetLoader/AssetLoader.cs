using System.Collections.Generic;
using UnityEngine;

using LoadedBundlePool = System.Collections.Generic.Dictionary<string, UnityEngine.AssetBundle>;

/// <summary>
/// 资源加载器
/// </summary>
public class AssetLoader
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private string mPath = string.Empty;

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
    private static readonly string[] postfix = { ".prefab", ".jpg", ".png", ".mp3", ".wav", ".anim" };
#endif

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    /// <param name="unloadDelayTime"></param>
    public AssetLoader(string path)
    {
        mPath = path;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public Object Load(string assetPath, string assetName)
    {
#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        string path = LFS.CombinePath(LFS.CombinePath("Assets/Client/_Resources", mPath), assetPath, assetName);
        foreach (string pf in postfix)
        {
            string filename = path + pf;
            if (System.IO.File.Exists(filename))
            {
                return UnityEditor.AssetDatabase.LoadMainAssetAtPath(filename);
            }
        }
        return null;
#else
        LoadDependentAB(assetPath, assetName);

        AssetBundle bundle = LoadAB(LFS.CombinePath(mPath, assetPath, assetName));
        if (bundle != null)
        {
            Object asset = bundle.LoadAsset(assetName);
            return asset;
        }

        return null;
#endif
    }

    /// <summary>
    /// 加载依赖资源
    /// </summary>
    /// <param name="assetName"></param>
    public string LoadDependentAB(string assetPath, string assetName)
    {
        string path = LFS.CombinePath(mPath, assetPath, assetName);
        DependentBundleManager.instance.Load(path);

        return path;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void UnloadDependentAB(string key)
    {
        key = LFS.CombinePath(mPath, key);
        DependentBundleManager.instance.Unload(key);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundlePath"></param>
    /// <returns></returns>
    public AssetBundle LoadAB(string bundlePath)
    {
        return BundleManager.instance.Load(bundlePath);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ab"></param>
    public void UnloadAB(AssetBundle ab)
    {
        BundleManager.instance.Unload(ab);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="asset"></param>
    public void UnloadAB(string key)
    {
        if (!key.StartsWith(mPath))
        {
            key = LFS.CombinePath(mPath, key);
        }
        BundleManager.instance.Unload(key);
    }

    #endregion
}