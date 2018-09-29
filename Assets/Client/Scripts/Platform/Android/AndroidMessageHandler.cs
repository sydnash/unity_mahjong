using System;
using UnityEngine;

public class AndroidMessageHandler : MonoBehaviour
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AndroidMessageHandler mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static AndroidMessageHandler instance
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
        AndroidHelper.instance.OnLoginWxHandler(json);
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
