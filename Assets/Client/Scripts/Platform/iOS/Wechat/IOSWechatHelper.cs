using System;
using System.Runtime.InteropServices;
using UnityEngine;

public class IOSWechatHelper
{
	public IOSWechatHelper ()
	{
	}

	#region Data

	/// <summary>
	/// 
	/// </summary>
	private static Action<string> mLoginCallback = null;
	private static Action<string> mShareCallback = null;

	#endregion

	public enum WechatShareScene
	{
		WXSceneSession = 0,
		WXSceneTimeline = 1,
		WXSceneFavorite = 2,
	}
		
	#region ImportOBCInterface
	[DllImport("__Internal")]
	static extern void OpenWechat_iOS (string state);
	[DllImport("__Internal")]
	static extern void ShareImage_iOS (int scene, IntPtr ptr, int size, IntPtr ptrThumb, int sizeThumb);
	[DllImport("__Internal")]
	static extern void ShareUrl_iOS (int scene, string url, string title, string content, IntPtr ptrThumb, int sizeThumb);
	[DllImport("__Internal")]
	static extern void ShareText_iOS (int scene, string content);
	#endregion

	#region public 
	/// <summary>
	/// 
	/// </summary>
	/// <param name="callback"></param>
	public static void RegisterLoginCallback(Action<string> callback)
	{
		mLoginCallback = callback;
	}
	public static void RegisterShareCallback(Action<string> callback)
	{
		mShareCallback = callback;
	}
	/// <summary>
	/// 
	/// </summary>
	public static void Login()
	{
		OpenWechat_iOS("app_wechat_loing");
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="text"></param>
	/// <param name="timeline">true:发送到朋友圈；false：</param>
	public static void ShareText(string text, bool timeline)
	{
		ShareText_iOS (getScene (timeline), text);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="title"></param>
	/// <param name="desc"></param>
	/// <param name="url"></param>
	/// <param name="timeline"></param>
	public static void ShareUrl(string title, string desc, string url, Texture2D thumb, bool timeline)
	{
		byte[] thumbData = thumb.EncodeToJPG();

		IntPtr thumbPtr = Marshal.AllocHGlobal (thumbData.Length);
		Marshal.Copy (thumbData, 0, thumbPtr, thumbData.Length);

		ShareUrl_iOS(getScene(timeline), url, title, desc, thumbPtr, thumbData.Length);
	}

	private static int getScene(bool timeline)
	{
		if (timeline) {
			return (int)WechatShareScene.WXSceneTimeline;
		}
		return (int)WechatShareScene.WXSceneSession;
	}
	/// <summary>
	/// 
	/// </summary>
	public static void ShareImage(Texture2D image, Texture2D thumb, bool timeline)
	{
		byte[] imageData = image.EncodeToJPG();
		byte[] thumbData = thumb.EncodeToJPG();

		IntPtr imgPtr = Marshal.AllocHGlobal (imageData.Length);
		Marshal.Copy (imageData, 0, imgPtr, imageData.Length);
		IntPtr thumbPtr = Marshal.AllocHGlobal (thumbData.Length);
		Marshal.Copy (thumbData, 0, thumbPtr, thumbData.Length);

		ShareImage_iOS(getScene(timeline), imgPtr, imageData.Length,  thumbPtr, thumbData.Length);
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

	public static void OnShareHandler(string json)
	{
		Logger.Log ("WX.OnWxShareHandler: json = " + json);
		if (mShareCallback != null)
		{
			mShareCallback(json);
		}
	}

	#endregion
}


