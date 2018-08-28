using UnityEngine;

public class TextureManager
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static TextureManager mInstance = new TextureManager();

    /// <summary>
    /// 
    /// </summary>
    public static TextureManager instance
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
    public Texture Load(string assetPath, string assetName)
    {
        return AssetPoolManager.instance.Alloc(AssetPoolManager.Type.Texture, assetPath, assetName) as Texture;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="tex"></param>
    public void Unload(Texture tex)
    {
#if UNITY_EDITOR
        Debug.Assert(tex != null);
#endif

        AssetPoolManager.instance.Dealloc(AssetPoolManager.Type.Texture, tex);
    }

    #endregion
}
