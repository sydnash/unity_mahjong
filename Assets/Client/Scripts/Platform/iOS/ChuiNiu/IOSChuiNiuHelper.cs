using System;
using UnityEngine;
using System.Runtime.InteropServices;

public class IOSChuiNiuHelper
{
    	
	#region ImportOBCInterface
	[DllImport("__Internal")]
	static extern void cnchat_shareimg_ios (string imgPath);
	[DllImport("__Internal")]
	static extern void cnchat_shareurl_ios (string url, string tile, string title, string thumb);
	[DllImport("__Internal")]
	static extern void cnchat_showDownload ();
	[DllImport("__Internal")]
	static extern bool cnchat_isInstall ();
	#endregion
    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="thumb"></param>
    public static void ShareUrl(string title, string desc, string url, string thumb)
    {
        cnchat_shareurl_ios(url, title, desc, thumb);
    }
    

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="imageFile"></param>
    public static void ShareImage(string imageFile)
    {
        cnchat_shareimg_ios(imageFile);
    }

    public static bool hasInstall() {
        return cnchat_isInstall();
    }
    public static void showDownload() {
        cnchat_showDownload();
    }

}