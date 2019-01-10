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
        mDownloadPath = LFS.CombinePath(LFS.PATCH_PATH, sub);
    }

    private static readonly string[] postfix = { ".prefab", ".jpg", ".png", ".mp3", ".wav", ".anim" };

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public Object Load(string assetPath, string assetName)
    {
        assetPath = assetPath.ToLower();
        assetName = assetName.ToLower();

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        //return Resources.Load(LFS.CombinePath(mPath, assetPath, assetName));
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

        AssetBundle bundle = LoadAB(assetPath, assetName);
        if (bundle != null)
        {
            Object asset = bundle.LoadAsset(assetName);
            UnloadAB(bundle); //Unity 2017.2中会引发crash，故屏蔽之

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
        string key = CreateAssetKey(assetPath, assetName);
        string target = LFS.CombinePath(mPath, assetPath, assetName);

        DependentBundlePool.instance.Load(key, target);

        return key;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void UnloadDependentAB(string key)
    {
        DependentBundlePool.instance.Unload(key);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundlePath"></param>
    /// <returns></returns>
    public AssetBundle LoadAB(string bundlePath)
    {
        return BundlePool.instance.Load(bundlePath);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public AssetBundle LoadAB(string assetPath, string assetName)
    {
        return LoadAB(LFS.CombinePath(mPath, assetPath, assetName));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ab"></param>
    public void UnloadAB(AssetBundle ab)
    {
        BundlePool.instance.Unload(ab);
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {

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
}