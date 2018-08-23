using UnityEngine;

public class ModelManager 
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static ModelManager mInstance = new ModelManager();
 
    /// <summary>
    /// 
    /// </summary>
    public static ModelManager instance
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
    public GameObject Load(string assetPath, string assetName)
    {
        return AssetPoolManager.instance.Alloc(AssetPoolManager.Type.Model, assetPath, assetName) as GameObject;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="model"></param>
    public void Unload(GameObject model)
    {
        AssetPoolManager.instance.Dealloc(AssetPoolManager.Type.Model, model);
    }

    #endregion
}
