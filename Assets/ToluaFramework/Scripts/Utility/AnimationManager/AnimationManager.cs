using UnityEngine;

public class AnimationManager
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AnimationManager mInstance = new AnimationManager();

    /// <summary>
    /// 
    /// </summary>
    public static AnimationManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public void Setup()
    {

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public AnimationClip Load(string assetPath, string assetName)
    {
        return AssetPoolManager.instance.Alloc(AssetPoolManager.Type.AnimationClip, assetPath, assetName) as AnimationClip;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="clip"></param>
    public void Unload(AnimationClip clip)
    {
#if UNITY_EDITOR
        Debug.Assert(clip != null);
#endif

        AssetPoolManager.instance.Dealloc(AssetPoolManager.Type.AnimationClip, clip);
    }

    #endregion
}
