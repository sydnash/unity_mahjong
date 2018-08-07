using UnityEngine;

public class UIManager
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private GameObject mCanvas = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static UIManager mInstance = new UIManager();

    /// <summary>
    /// 
    /// </summary>
    public static UIManager instance
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
        GameObject root = GameObject.Find("UIRoot");
#if UNITY_EDITOR
        Debug.Assert(root != null);
#endif
        GameObject.DontDestroyOnLoad(root);

        mCanvas = GameObject.Find("UIRoot/Canvas");
#if UNITY_EDITOR
        Debug.Assert(mCanvas != null, "can't find ui canvas");
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    /// <returns></returns>
    public GameObject Load(string assetPath, string assetName)
    {
        return AssetPoolManager.instance.Alloc(AssetPoolManager.Type.UI, assetPath, assetName) as GameObject;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ui"></param>
    public void Unload(GameObject ui)
    {
#if UNITY_EDITOR
        Debug.Assert(ui != null);
#endif

        AssetPoolManager.instance.Dealloc(AssetPoolManager.Type.UI, ui);
    }

    /// <summary>
    /// 
    /// </summary>
    public GameObject canvas
    {
        get { return mCanvas; }
    }

    #endregion
}
