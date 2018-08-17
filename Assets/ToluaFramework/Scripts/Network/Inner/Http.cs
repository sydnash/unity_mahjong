using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

public class Http : MonoBehaviour
{
    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private static readonly WaitForEndOfFrame WAIT_FOR_END_OF_FRAME = new WaitForEndOfFrame();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static Http mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static Http instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestText(string url, string method, Action<bool, string> callback)
    {
        StartCoroutine(RequestTextCoroutione(url, method.ToUpper(), callback));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestBytes(string url, string method, Action<bool, byte[]> callback)
    {
        StartCoroutine(RequestBytesCoroutione(url, method.ToUpper(), callback));
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

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator RequestTextCoroutione(string url, string method, Action<bool, string> callback)
    {
        bool state = false;
        string text = string.Empty;

        UnityWebRequest www = new UnityWebRequest(url, method);

        www.downloadHandler = new DownloadHandlerBuffer();
        www.SendWebRequest();
        
        while (!www.isDone)
        {
            yield return WAIT_FOR_END_OF_FRAME; 
        }

        if (www.isHttpError || www.isNetworkError)
        {
#if UNITY_EDITOR
            Debug.LogError("Http Error: " + www.error);
#endif
        }
        else
        {
            state = true;
            text = www.downloadHandler.text;
        }

        if (callback != null)
        {
            callback(state, text);
        }

        yield return WAIT_FOR_END_OF_FRAME; 
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator RequestBytesCoroutione(string url, string method, Action<bool, byte[]> callback)
    {
        bool state = false;
        byte[] bytes = null;

        UnityWebRequest www = new UnityWebRequest(url, method);

        www.downloadHandler = new DownloadHandlerBuffer();
        www.SendWebRequest();

        while (!www.isDone)
        {
            yield return WAIT_FOR_END_OF_FRAME;
        }

        if (www.isHttpError || www.isNetworkError)
        {
#if UNITY_EDITOR
            Debug.LogError("Http Error: " + www.error);
#endif
        }
        else
        {
            state = true;
            bytes = www.downloadHandler.data;
        }

        if (callback != null)
        {
            callback(state, bytes);
        }

        yield return WAIT_FOR_END_OF_FRAME;
    }

    #endregion
}

