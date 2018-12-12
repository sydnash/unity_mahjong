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
    /// <param name="callback"></param>
    public void RegisterLoginWXCallback(Action<string> callback)
    {
        WechatHelper.RegisterLoginCallback(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterShareWXCallback(Action<string> callback)
    {
        WechatHelper.RegisterShareCallback(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterInviteSGCallback(Action<string> callback)
    {
        UpdripsHelper.RegisterInviteCallback(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="logined"></param>
    public void SetLogined(bool logined)
    {
        javaObject.Call("SetLogined", logined);
    }

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
    public void LoginWX()
    {
        WechatHelper.Login(javaObject);
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
    public void ShareUrlWX(string title, string desc, string url, Texture2D thumb, bool timeline)
    {
        WechatHelper.ShareUrl(javaObject, title, desc, url, thumb, timeline);
    }

    /// <summary>
    /// 
    /// </summary>
    public void ShareImageWX(Texture2D image, Texture2D thumb, bool timeline)
    {
        WechatHelper.ShareImage(javaObject, image, thumb, timeline);
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
    /// <param name="title"></param>
    /// <param name="description"></param>
    /// <param name="launcherPath"></param>
    /// <param name="param_a"></param>
    /// <param name="param_b"></param>
    /// <param name="androidDownloadUrl"></param>
    /// <param name="iOSDownloadUrl"></param>
    public void ShareInvitationSG(string title, string description, Texture2D tex, string param, string androidDownloadUrl, string iOSDownloadUrl)
    {
        UpdripsHelper.ShareInvitation(javaObject, title, description, tex, param, androidDownloadUrl, iOSDownloadUrl);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="imagePath"></param>
    public void ShareImageSG(Texture2D tex)
    {
        UpdripsHelper.ShareImage(javaObject, tex);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public string GetParamsSG()
    {
        return UpdripsHelper.GetParams(javaObject);
    }
	/// <summary>
	/// Clears the SG invite parameter.
	/// </summary>
	/// <returns>The SG invite parameter.</returns>
	public void ClearSGInviteParam()
	{
		UpdripsHelper.Clear(javaObject);
	}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    public void OnLoginWxHandler(string json)
    {
        if (!string.IsNullOrEmpty(json))
        {
            WechatHelper.OnLoginHandler(json);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="json"></param>
    public void OnShareWxHandler(string json)
    {
        if (!string.IsNullOrEmpty(json))
        {
            WechatHelper.OnShareHandler(json);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="json"></param>
    public void OnInviteSgHandler(string json)
    {
        if (!string.IsNullOrEmpty(json))
        {
            UpdripsHelper.OnInviteHandler(json);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public string GetDeviceId()
    {
        return "";
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    public void OpenExplore(string url)
    {
        
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public void SetToClipboard(string text)
    {
        
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public string GetFromClipboard()
    {
        return "";
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="la1"></param>
    /// <param name="lo1"></param>
    /// <param name="la2"></param>
    /// <param name="lo2"></param>
    /// <returns></returns>
    public float GetDistance(float la1, float lo1, float la2, float lo2)
    {
        return LocationHelper.GetDistance(javaObject, la1, lo1, la2, lo2);
    }

    ///// <summary>
    ///// 
    ///// </summary>
    //public void StartLocation()
    //{
    //    LocationHelper.StartLocation(javaObject);
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    //public void StopLocation()
    //{
    //    LocationHelper.StopLocation(javaObject);
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public bool GetLocationStatus()
    //{
    //    return LocationHelper.GetStatus(javaObject);
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public float GetLocationLatitude()
    //{
    //    return LocationHelper.GetLatitude(javaObject);
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public float GetLocationLongitude()
    //{
    //    return LocationHelper.GetLongitude(javaObject);
    //}

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
