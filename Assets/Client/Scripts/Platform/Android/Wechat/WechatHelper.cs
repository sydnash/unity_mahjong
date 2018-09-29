﻿using System;
using UnityEngine;

public class WechatHelper
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static Action<string> mLoginWxCallback = null;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public static void Login(AndroidJavaObject javaObject, Action<string> callback)
    {
        mLoginWxCallback = callback;
        javaObject.Call("LoginWX");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public static void ShareText(AndroidJavaObject javaObject, string text, bool timeline)
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
    public static void ShareUrl(AndroidJavaObject javaObject, string title, string desc, string url, bool timeline)
    {
        javaObject.Call("ShareUrlWx", title, desc, url, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void ShareImage(AndroidJavaObject javaObject, string imagePath, bool timeline)
    {
        javaObject.Call("ShareImageWx", imagePath, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public static void OnLoginHandler(string json)
    {
        Logger.Log("WX.OnLoginHandler, json = " + json);
        if (mLoginWxCallback != null)
        {
            mLoginWxCallback(json);
        }
    }

    #endregion
}
