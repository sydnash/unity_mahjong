using System;
using UnityEngine;

public class ChuiNiuHelper
{
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
                                string thumb)
    {
        javaObject.Call("ShareUrlCN", title, desc, url, thumb);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    /// <param name="title"></param>
    /// <param name="imageFile"></param>
    public static void ShareImage(AndroidJavaObject javaObject, string title, string imageFile)
    {
        javaObject.Call("ShareImageCN", title, imageFile);
    }
}
