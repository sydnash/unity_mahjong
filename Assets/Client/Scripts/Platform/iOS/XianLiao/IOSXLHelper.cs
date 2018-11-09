using System;
using System.Runtime.InteropServices;
using UnityEngine;


public class IOSXLHelper
{
	public IOSXLHelper ()
	{
	}

	#region Data

	/// <summary>
	/// 
	/// </summary>
	private static Action<string> mInviteCallback = null;

	#endregion

	#region ImportOBCInterface
	[DllImport("__Internal")]
	static extern void ShareXLText(string content);
	[DllImport("__Internal")]
	static extern void ShareXLImg(IntPtr ptr, int size);
	[DllImport("__Internal")]
	static extern void InviteXL(string token, string roomid, string title, string text, string imgUrl, IntPtr ptr, int size, string androidUrl, string iosUrl);
	[DllImport("__Internal")]
	static extern void SetLoginState_XL(int state);
	[DllImport("__Internal")]
	static extern void ClearXLInviteParam();
	[DllImport("__Internal")]
	static extern string GetXLInviteParam();
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
	public static void ShareText(string text)
	{
		ShareText (text);
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
	public static void ShareInvitation(string title, string description, Texture2D image, string param, string androidDownloadUrl, string iOSDownloadUrl)
	{
		byte[] imageData = image.EncodeToJPG();

		IntPtr imgPtr = Marshal.AllocHGlobal (imageData.Length);
		Marshal.Copy (imageData, 0, imgPtr, imageData.Length);

		InviteXL ("", param, title, description, "", imgPtr, imageData.Length, androidDownloadUrl, iOSDownloadUrl);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="javaObject"></param>
	/// <param name="imagePath"></param>
	public static void ShareImage(Texture2D image)
	{
		byte[] imageData = image.EncodeToJPG();

		IntPtr imgPtr = Marshal.AllocHGlobal (imageData.Length);
		Marshal.Copy (imageData, 0, imgPtr, imageData.Length);

		ShareXLImg(imgPtr, imageData.Length);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="javaObject"></param>
	public static string GetParams()
	{
		return GetXLInviteParam ();
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="javaObject"></param>
	public static void Clear()
	{
		ClearXLInviteParam ();
	}

	public static void SetLoginState(bool login) 
	{
		SetLoginState_XL (login ? 1 : 0);
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


