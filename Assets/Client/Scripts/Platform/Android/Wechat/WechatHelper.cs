using System;
using UnityEngine;

public class WechatHelper
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static Action<string> mLoginCallback = null;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public static void RegisterLoginCallback(Action<string> callback)
    {
        mLoginCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    public static void Login(AndroidJavaObject javaObject)
    {
        javaObject.Call("LoginWX");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public static void ShareText(AndroidJavaObject javaObject, string text, bool timeline)
    {
        javaObject.Call("ShareTextWX", text, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="timeline"></param>
    public static void ShareUrl(AndroidJavaObject javaObject, 
                                string title, 
                                string desc, 
                                string url, 
                                Texture2D thumb, 
                                bool timeline)
    {
        byte[] thumbData = thumb.EncodeToJPG();
        javaObject.Call("ShareUrlWX", title, desc, url, thumbData, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void ShareImage(AndroidJavaObject javaObject, Texture2D image, Texture2D thumb, bool timeline)
    {
        byte[] imageData = image.EncodeToJPG();
        byte[] thumbData = thumb.EncodeToJPG();
        javaObject.Call("ShareImageWX", imageData, thumbData, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public static void OnLoginHandler(string json)
    {
        Logger.Log("WX.OnLoginHandler, json = " + json);
        if (mLoginCallback != null)
        {
            mLoginCallback(json);
        }
    }

    #endregion
}
