using System;
using System.Collections;
using UnityEngine;

public class HttpDownload : MonoBehaviour
{
    #region Enum

    /// <summary>
    /// 
    /// </summary>
    public enum StatusCode
    {
        OK,     //
        TIMEOUT,//
        ERROR,  //
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private static readonly WaitForEndOfFrame WAIT_FOR_END_OF_FRAME = new WaitForEndOfFrame();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public void Download(string url, Action<StatusCode, string, object> callback, object args)
    {
        StartCoroutine(DownloadCoroutine(url, callback, args));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="urls"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public void DownloadAny(string[] urls, Action<StatusCode, string, object> callback, object args)
    {
        StartCoroutine(DownloadAnyCoroutine(urls, callback, args));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="urls"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public void DownloadAll(string[] urls, Action<StatusCode, string, byte[], object> callback, object args)
    {
        StartCoroutine(DownloadAllCoroutine(urls, callback, args));
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    /// <returns></returns>
    private IEnumerator DownloadCoroutine(string url, Action<StatusCode, string, object> callback, object args)
    {
        WWW www = new WWW(url);
        bool error = isError(www);

        while (!www.isDone && !error)
        {
            error = isError(www);
            yield return WAIT_FOR_END_OF_FRAME;
        }

        if (error)
        {
#if UNITY_EDITOR
            Debug.LogError("http error: " + www.error);
#endif
            callback(StatusCode.ERROR, string.Empty, args);
        }
        else
        {
            callback(StatusCode.OK, www.text, args);
        }

        yield return new WaitForEndOfFrame();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="urls"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    /// <returns></returns>
    private IEnumerator DownloadAnyCoroutine(string[] urls, Action<StatusCode, string, object> callback, object args)
    {
        bool error = false;

        foreach (string url in urls)
        {
            WWW www = new WWW(url);

            while (!www.isDone)
            {
                yield return WAIT_FOR_END_OF_FRAME;
            }

            error = isError(www);

            if (!error)
            {
                callback(StatusCode.OK, www.text, args);
                break;
            }
        }

        if (error)
        {
            callback(StatusCode.ERROR, string.Empty, args);
        }

        yield return new WaitForEndOfFrame();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="urls"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    /// <returns></returns>
    private IEnumerator DownloadAllCoroutine(string[] urls, Action<StatusCode, string, byte[], object> callback, object args)
    {
        foreach (string url in urls)
        {
            WWW www = new WWW(url);

            while (!www.isDone)
            {
                yield return WAIT_FOR_END_OF_FRAME;
            }

            bool error = isError(www);

            if (error)
            {
#if UNITY_EDITOR
                Debug.LogError("http error: " + www.error + "  [" + url + "]");
#endif
                callback(StatusCode.ERROR, url, null, args);
                break;
            }
            else
            {
                callback(StatusCode.OK, url, www.bytes, args);
            }
        }

        yield return WAIT_FOR_END_OF_FRAME;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="www"></param>
    /// <returns></returns>
    private bool isError(WWW www)
    {
        return !string.IsNullOrEmpty(www.error);
    }

    #endregion
}
