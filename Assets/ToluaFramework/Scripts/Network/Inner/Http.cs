using System;
using System.Collections;
using System.Text;
using UnityEngine;

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
        get 
        { 
            if (mInstance == null)
            {
                GameObject go = GameObject.Find("NetworkManager/Http");
                mInstance = go.GetComponent<Http>();
            }

            return mInstance; 
        }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestText(string url, string form, Action<bool, string> callback)
    {
        if (form == null || string.IsNullOrEmpty(form))
        {
            StartCoroutine(RequestTextCoroutione(url, null, callback));
        }
        else
        {
            byte[] bytes = Encoding.UTF8.GetBytes(form);
            StartCoroutine(RequestTextCoroutione(url, bytes, callback));
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestBytes(string url, string form, Action<bool, byte[]> callback)
    {
        if (form == null || string.IsNullOrEmpty(form))
        {
            StartCoroutine(RequestBytesCoroutione(url, null, callback));
        }
        else
        {
            byte[] bytes = Encoding.UTF8.GetBytes(form);
            StartCoroutine(RequestBytesCoroutione(url, bytes, callback));
        }
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator RequestTextCoroutione(string url, byte[] form, Action<bool, string> callback)
    {
        bool state = false;
        string text = string.Empty;

        WWW www = new WWW(url, form);

        while (!www.isDone)
        {
            yield return WAIT_FOR_END_OF_FRAME; 
        }

        string error = www.error;

        if (string.IsNullOrEmpty(error))
        {
            state = true;
            text = www.text;
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
    private IEnumerator RequestBytesCoroutione(string url, byte[] form, Action<bool, byte[]> callback)
    {
        bool state = false;
        byte[] bytes = null;

        WWW www = new WWW(url, form);

        while (!www.isDone)
        {
            yield return WAIT_FOR_END_OF_FRAME;
        }

        string error = www.error;

        if (string.IsNullOrEmpty(error))
        {
            state = true;
            bytes = www.bytes;
        }

        if (callback != null)
        {
            callback(state, bytes);
        }

        yield return WAIT_FOR_END_OF_FRAME;
    }

    #endregion
}

