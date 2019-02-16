using System;
using UnityEngine;

public class BundleLoader
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static readonly string mPatchPath = LFS.CombinePath(LFS.PATCH_PATH, "Res");

    /// <summary>
    /// 
    /// </summary>
    private static readonly string mLocalPath = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res");


    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static BundleLoader mInstance = new BundleLoader();

    /// <summary>
    /// 
    /// </summary>
    public static BundleLoader instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public AssetBundle Load(string path)
    {
        AssetBundle ab = LoadFromFile(LFS.CombinePath(mPatchPath, path), true);
        if (ab == null)
        {
            ab = LoadFromFile(LFS.CombinePath(mLocalPath, path), false);
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
            ab.Unload(false);
        }
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    /// <param name="checkExist"></param>
    /// <returns></returns>
    private AssetBundle LoadFromFile(string path, bool checkExist)
    {
        if (!checkExist || System.IO.File.Exists(path))
        {
            return AssetBundle.LoadFromFile(path);
        }

        return null;
    }

    #endregion
}
