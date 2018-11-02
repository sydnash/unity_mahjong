using System;
using UnityEngine;

class UpdripsHelper
{
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
    public static void ShareImage(AndroidJavaObject javaObject, string imagePath)
    {
        javaObject.Call("ShareImageSG", imagePath);
    }
}
