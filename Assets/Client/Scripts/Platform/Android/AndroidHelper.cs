using System;
using UnityEngine;

public class AndroidHelper
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private AndroidJavaObject mJavaObject = null;

    /// <summary>
    /// 
    /// </summary>
    private Action<string> mLoginWxCallback = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AndroidHelper mInstance = new AndroidHelper();

    /// <summary>
    /// 
    /// </summary>
    public static AndroidHelper instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="errorMessage"></param>
    public void ShowErrorMessage(string errorMessage)
    {
        javaObject.Call("ShowErrorMessage", errorMessage);
    }

    /// <summary>
    /// 
    /// </summary>
    public void LoginWX(Action<string> callback)
    {
        WechatHelper.Login(javaObject, callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public void ShareTextWX(string text, bool timeline)
    {
        WechatHelper.ShareText(javaObject, text, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="timeline"></param>
    public void ShareUrlWX(string title, string desc, string url, bool timeline)
    {
        WechatHelper.ShareUrl(javaObject, title, desc, url, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public void ShareImageWX(string imagePath, bool timeline)
    {
        WechatHelper.ShareImage(javaObject, imagePath, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public void ShareTextSG(string text)
    {
        UpdripsHelper.ShareText(javaObject, text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="imagePath"></param>
    public void ShareImageSG(string imagePath)
    {
        UpdripsHelper.ShareImage(javaObject, imagePath);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public void OnLoginWxHandler(string json)
    {
        WechatHelper.OnLoginHandler(json);
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
