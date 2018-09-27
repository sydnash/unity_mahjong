using System;
using UnityEngine;

public class JavaMessageHandler : MonoBehaviour
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static JavaMessageHandler mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static JavaMessageHandler instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="json"></param>
    public void OnLoginWxHandler(string json)
    {
        WechatHelper.instance.OnLoginHandler(json);
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;
        DontDestroyOnLoad(gameObject);
    }

    #endregion
}
