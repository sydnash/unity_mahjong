using UnityEngine;
using System;
using System.Collections;

public class WINHelper
{
	#region Data

	#endregion

	#region Instance

	/// <summary>
	/// 
	/// </summary>
    private static WINHelper mInstance = new WINHelper();

	/// <summary>
	/// 
	/// </summary>
    public static WINHelper instance
	{
		get { return mInstance; }
	}

	#endregion

	#region PublicWX

	/// <summary>
	/// 
	/// </summary>
	/// <param name="callback"></param>
	public void ChangeWindowTitle(string newTitle)
    {
#if !UNITY_EDITOR && UNITY_STANDALONE_WIN
        WinTitleHelper.ChangeWindowTitle(newTitle);
#endif
    }
	#endregion

}
	