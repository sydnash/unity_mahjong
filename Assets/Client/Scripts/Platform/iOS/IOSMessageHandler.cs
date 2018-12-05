using UnityEngine;
using System.Collections;

public class IOSMessageHandler : MonoBehaviour
{

	#region Instance

	/// <summary>
	/// 
	/// </summary>
	private static IOSMessageHandler mInstance = null;

	/// <summary>
	/// 
	/// </summary>
	public static IOSMessageHandler instance
	{
		get { return mInstance; }
	}

	#endregion

	#region Public

	/// <summary>
	/// 
	/// </summary>
	/// <param name="json"></param>
	public void OnWXLoginCallback(string json)
	{
		IOSHelper.instance.OnLoginWxHandler(json);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="json"></param>
	public void OnXLInviteMsg(string json)
	{
		IOSHelper.instance.OnInviteSgHandler(json);
	}

	public void OnLocationUpdateHandler(string param)
	{
		UtilsHelper.OnLocationUpdate (param);
	}


	public void OnWxShareCallback(string json)
	{
		IOSHelper.instance.OnWxShareHandler (json);
	}
	#endregion

	#region Private

	/// <summary>
	/// 
	/// </summary>
	private void Awake()
	{
		mInstance = this;
		DontDestroyOnLoad(gameObject);
	}

	#endregion
}

