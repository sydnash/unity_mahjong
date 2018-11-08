using System;
using UnityEngine;

class UpdripsHelper
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static Action<string> mInviteCallback = null;

    #endregion

    #region Public 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public static void RegisterInviteCallback(Action<string> callback)
    {
        mInviteCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public static void ShareText(AndroidJavaObject javaObject, string text)
    {
        javaObject.Call("ShareTextSG", text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    /// <param name="title"></param>
    /// <param name="description"></param>
    /// <param name="launcherPath"></param>
    /// <param name="param_a"></param>
    /// <param name="param_b"></param>
    /// <param name="androidDownloadUrl"></param>
    /// <param name="iOSDownloadUrl"></param>
    public static void ShareInvitation(AndroidJavaObject javaObject, string title, string description, Texture2D image, string param, string androidDownloadUrl, string iOSDownloadUrl)
    {
        byte[] imageData = image.EncodeToJPG();
        javaObject.Call("ShareInvitationSG", title, description, imageData, param, androidDownloadUrl, iOSDownloadUrl);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    /// <param name="imagePath"></param>
    public static void ShareImage(AndroidJavaObject javaObject, Texture2D image)
    {
        byte[] imageData = image.EncodeToJPG();
        javaObject.Call("ShareImageSG", imageData);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    public static string GetParams(AndroidJavaObject javaObject)
    {
        return javaObject.Call<string>("GetParams");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    public static void Clear(AndroidJavaObject javaObject)
    {
        javaObject.Call("Clear");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="json"></param>
    public static void OnInviteHandler(string json)
    {
        Logger.Log("SG.OnInviteHandler, json = " + json);
        if (mInviteCallback != null)
        {
            mInviteCallback(json);
        }
    }

    #endregion
}
