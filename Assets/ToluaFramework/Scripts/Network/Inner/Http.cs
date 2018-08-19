using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using UnityEngine;

public class Http : MonoBehaviour
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class RequestArgs
    {
        /// <summary>
        /// 
        /// </summary>
        public HttpWebRequest request = null;

        /// <summary>
        /// 
        /// </summary>
        public string url = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="url"></param>
        public RequestArgs(HttpWebRequest request, string url)
        {
            this.request = request;
            this.url = url;
        }
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Action<bool, string>> mTextCallbackDict = new Dictionary<string, Action<bool, string>>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Action<bool, byte[]>> mByteCallbackDict = new Dictionary<string, Action<bool, byte[]>>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, byte[]> mResponseDict = new Dictionary<string, byte[]>();

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
        mTextCallbackDict.Add(url, callback);

        HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
        request.Method = method.ToUpper();
        request.BeginGetResponse(OnResponse, new RequestArgs(request, url));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestBytes(string url, string method, Action<bool, byte[]> callback)
    {
        mByteCallbackDict.Add(url, callback);

        HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
        request.Method = method.ToUpper();
        request.BeginGetResponse(OnResponse, new RequestArgs(request, url));
    }

    /// <summary>
    /// 
    /// </summary>
    public void Reset()
    {
        mTextCallbackDict.Clear();
        mByteCallbackDict.Clear();

        lock (mResponseDict)
        {
            mResponseDict.Clear();
        }
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
    private void Update()
    {
        lock (mResponseDict)
        {
            foreach (KeyValuePair<string, byte[]> p in mResponseDict)
            {
                string k = p.Key;
                byte[] v = p.Value;
                //文本回调
                if (mTextCallbackDict.ContainsKey(k))
                {
                    Action<bool, string> callback = mTextCallbackDict[k];

                    if (v != null)
                    {
                        callback(true, Encoding.UTF8.GetString(v));
                    }
                    else
                    {
                        callback(false, string.Empty);
                    }

                    mResponseDict.Remove(k);
                    mTextCallbackDict.Remove(k);

                    break;
                }
                //字节回调
                if (mByteCallbackDict.ContainsKey(k))
                {
                    Action<bool, byte[]> callback = mByteCallbackDict[k];
                    callback(v != null, v);

                    mResponseDict.Remove(k);
                    mByteCallbackDict.Remove(k);

                    break;
                }
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="result"></param>
    private void OnResponse(IAsyncResult result)
    {
        RequestArgs args = result.AsyncState as RequestArgs;

        HttpWebRequest request = args.request;
        string url = args.url;
        HttpWebResponse response = null;

        try
        {
            response = request.EndGetResponse(result) as HttpWebResponse;
            if (response.StatusCode == HttpStatusCode.OK)
            {
                int length = (int)response.ContentLength;
                System.IO.Stream responseStream = response.GetResponseStream();

                byte[] bytes = new byte[length];
                int readSize = 0;

                while (readSize < length)
                {
                    readSize += responseStream.Read(bytes, readSize, length - readSize);
                }

                responseStream.Close();

                lock (mResponseDict)
                {
                    mResponseDict.Add(url, bytes);
                }
            }
            else
            {
                lock (mResponseDict)
                {
                    mResponseDict.Add(url, null);
                }

#if UNITY_EDITOR
                Debug.LogError("http failed: " + response.StatusDescription);
#endif 
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
            lock (mResponseDict)
            {
                mResponseDict.Add(url, null);
            }
        }
        finally
        {
            if (request != null)
            {
                request.Abort();
            }

            if (response != null)
            {
                response.Close();
            }
        }
    }

    #endregion
}

