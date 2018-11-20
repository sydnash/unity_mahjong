using System;
using System.Runtime.InteropServices;
using UnityEngine;

public class UtilsHelper
{
	public UtilsHelper ()
	{
	}

	#region Data

	/// <summary>
	/// 
	/// </summary>
	private static Action<string> mLocationUpdateHandler = null;
	#endregion

	#region ImportOBCInterface
	[DllImport("__Internal")]
	static extern string getDeviceId ();
	[DllImport("__Internal")]
	static extern void startInsall (string ipapath);
	[DllImport("__Internal")]
	static extern void openExplore (string url);
	[DllImport("__Internal")]
	static extern string getExternalStorageDir ();
	[DllImport("__Internal")]
	static extern bool isExternalStorageDirAccessable ();
	[DllImport("__Internal")]
	static extern void setToClipboard (string text);
	[DllImport("__Internal")]
	static extern string getFromClipboard ();
	[DllImport("__Internal")]
	static extern float getDistance (float latitude1, float longitude1, float latitude2, float longitude2);
	[DllImport("__Internal")]
	static extern void startLocationOnce ();
	[DllImport("__Internal")]
	static extern void startLocationUpdate ();
	[DllImport("__Internal")]
	static extern void stopLocationUpdate ();
	#endregion

	#region public
	public static string GetDeviceId() {
		return getDeviceId ();
	}
	public static void OpenExplore(string url) {
		openExplore(url);
	}
	public static void SetToClipboard(string text) {
		setToClipboard(text);
	}
	public static string GetFromClipboard() {
		return getFromClipboard ();
	}
	public static float GetDistance(float la1, float lo1, float la2, float lo2) {
		return getDistance(la1, lo1, la2, lo2);
	}
	public static void StartLocationOnce() {
		startLocationOnce ();
	}
	public static void StartLocationUpdate() {
		startLocationUpdate ();
	}
	public static void StopLocationUpdate() {
		stopLocationUpdate ();
	}
	public static void OnLocationUpdate(string param) {
		Logger.Log("utils.onlocationupdate, json = " + param);
		if (mLocationUpdateHandler != null)
		{
			mLocationUpdateHandler(param);
		}
	}
	public static void SetLocationUpdateHandler(Action<string> callback) {
		mLocationUpdateHandler = callback;
	}

	#endregion
}

