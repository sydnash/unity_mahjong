using UnityEngine;
using System;
using System.Collections;

public class IOSHelper
{
	#region Data

	#endregion

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

	#endregion


}
	