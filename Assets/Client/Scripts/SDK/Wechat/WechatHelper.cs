using System;
using UnityEngine;

public class WechatHelper
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private AndroidJavaObject mJavaObject = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<string> mLoginCallback = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static WechatHelper mInstance = new WechatHelper();

    /// <summary>
    /// 
    /// </summary>
    public static WechatHelper instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public 

    

    /// <summary>
    /// 
    /// </summary>
    public void Login(Action<string> callback)
    {
        mLoginCallback = callback;
        javaObject.Call("LoginWX");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public void ShareText(string text, bool timeline)
    {
        javaObject.Call("ShareTextWx", text, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="timeline"></param>
    public void ShareUrl(string title, string desc, string url, bool timeline)
    {
        javaObject.Call("ShareUrlWx", title, desc, url, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public void ShareImage(string imagePath, bool timeline)
    {
        javaObject.Call("ShareImageWx", imagePath, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public void OnLoginHandler(string json)
    {
        Logger.Log("WX.OnLoginHandler, json = " + json);
        if (mLoginCallback != null)
        {
            mLoginCallback(json);
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private AndroidJavaObject javaObject
    {
        get
        {
            if (mJavaObject == null)
            {
                using (AndroidJavaClass javaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
                {
                    mJavaObject = javaClass.GetStatic<AndroidJavaObject>("currentActivity");
                }
            }

            return mJavaObject;
        }
    }

    #endregion
}
