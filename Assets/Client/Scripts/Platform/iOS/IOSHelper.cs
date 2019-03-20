using UnityEngine;
using System;
using System.Collections;

public class IOSHelper
{
    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static IOSHelper mInstance = new IOSHelper();

    /// <summary>
    /// 
    /// </summary>
    public static IOSHelper instance
    {
        get { return mInstance; }
    }

    #endregion

    #region PublicWX

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterLoginWXCallback(Action<string> callback)
    {
        IOSWechatHelper.RegisterLoginCallback(callback);
    }

    public void RegisterShareWXCallback(Action<string> callback)
    {
        IOSWechatHelper.RegisterShareCallback(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    public void LoginWX()
    {
        IOSWechatHelper.Login();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <param name="timeline">true:发送到朋友圈；false：</param>
    public void ShareTextWX(string text, bool timeline)
    {
        IOSWechatHelper.ShareText(text, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="timeline"></param>
    public void ShareUrlWX(string title, string desc, string url, Texture2D thumb, bool timeline)
    {
        IOSWechatHelper.ShareUrl(title, desc, url, thumb, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public void ShareImageWX(Texture2D image, Texture2D thumb, bool timeline)
    {
        IOSWechatHelper.ShareImage(image, thumb, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public void OnLoginWxHandler(string json)
    {
        IOSWechatHelper.OnLoginHandler(json);
    }

    public void OnWxShareHandler(string json)
    {
        IOSWechatHelper.OnShareHandler(json);
    }

    #endregion

    #region publicXL
    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterInviteSGCallback(Action<string> callback)
    {
        IOSXLHelper.RegisterInviteCallback(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="logined"></param>
    public void SetLogined(bool logined)
    {
        IOSXLHelper.SetLoginState(logined);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public void ShareTextSG(string text)
    {
        IOSXLHelper.ShareText(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="description"></param>
    /// <param name="launcherPath"></param>
    /// <param name="param_a"></param>
    /// <param name="param_b"></param>
    /// <param name="androidDownloadUrl"></param>
    /// <param name="iOSDownloadUrl"></param>
    public void ShareInvitationSG(string title, string description, Texture2D tex, string param, string androidDownloadUrl, string iOSDownloadUrl)
    {
        IOSXLHelper.ShareInvitation(title, description, tex, param, androidDownloadUrl, iOSDownloadUrl);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="imagePath"></param>
    public void ShareImageSG(Texture2D tex)
    {
        IOSXLHelper.ShareImage(tex);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public string GetParamsSG()
    {
        return IOSXLHelper.GetParams();
    }
    /// <summary>
    /// Clears the SG invite parameter.
    /// </summary>
    /// <returns>The SG invite parameter.</returns>
    public void ClearSGInviteParam()
    {
        IOSXLHelper.Clear();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="json"></param>
    public void OnInviteSgHandler(string json)
    {
        IOSXLHelper.OnInviteHandler(json);
    }

    public string GetDeviceId()
    {
        return UtilsHelper.GetDeviceId();
    }

    public void OpenExplore(string url)
    {
        UtilsHelper.OpenExplore(url);
    }

    public void SetToClipboard(string text)
    {
        UtilsHelper.SetToClipboard(text);
    }

    public string GetFromClipboard()
    {
        return UtilsHelper.GetFromClipboard();
    }

    public float GetDistance(float la1, float lo1, float la2, float lo2)
    {
        return UtilsHelper.GetDistance(la1, lo1, la2, lo2);
    }

    public void StartLocationOnce()
    {
        UtilsHelper.StartLocationOnce();
    }

    public void StartLocationUpdate()
    {
        UtilsHelper.StartLocationUpdate();
    }

    public void StopLocationUpdate()
    {
        UtilsHelper.StopLocationUpdate();
    }

    public void SetLocationUpdateHandler(Action<string> callback)
    {
        UtilsHelper.SetLocationUpdateHandler(callback);
    }

    #endregion

    #region Public CN

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="url"></param>
    /// <param name="thumb"></param>
    public void ShareUrlCN(string title, string desc, string url, string thumb)
    {
        IOSChuiNiuHelper.ShareUrl(title, desc, url, thumb);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="imageFile"></param>
    public void ShareImageCN(string imageFile)
    {
        IOSChuiNiuHelper.ShareImage(imageFile);
    }
    public bool HasInstallCN() {
        return IOSChuiNiuHelper.hasInstall();
    }
    public void ShowDownloadCN() {
        IOSChuiNiuHelper.showDownload();
    }
    public void OpenThirdApp(string p1, string p2) {
        IOSChuiNiuHelper.OpenThirdApp(p1);
    }

    #endregion
}
	