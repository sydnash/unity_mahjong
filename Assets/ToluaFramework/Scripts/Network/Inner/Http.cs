using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Threading;
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
        public string url = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        public string method = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        public int timeout = 2 * 60 * 1000;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="url"></param>
        public RequestArgs(string url, string method, int timeout)
        {
            this.url = url;
            this.method = method.ToUpper();
            this.timeout = timeout;
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
    public void RequestText(string url, string method, int timeout, Action<bool, string> callback)
    {
        mTextCallbackDict.Add(url, callback);

        Thread thread = new Thread(OnRequest);
        thread.Start(new RequestArgs(url, method, timeout));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestBytes(string url, string method, int timeout, Action<bool, byte[]> callback)
    {
        mByteCallbackDict.Add(url, callback);

        Thread thread = new Thread(OnRequest);
        thread.Start(new RequestArgs(url, method, timeout));
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
    /// <param name="obj"></param>
    private void OnRequest(object obj)
    {
        RequestArgs args = obj as RequestArgs;
        HttpWebRequest request = WebRequest.Create(args.url) as HttpWebRequest;

        try
        {
            request.Method = args.method;
            request.Timeout = args.timeout;
            request.ReadWriteTimeout = args.timeout;
            HttpWebResponse response = request.GetResponse() as HttpWebResponse;

            OnResponse(response, args.url);
        }
        catch (Exception ex)
        {
            lock (mResponseDict)
            {
                mResponseDict.Add(args.url, null);
            }

            Logger.LogError(ex.Message);
        }
        finally
        {
            request.Abort();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="result"></param>
    private void OnResponse(HttpWebResponse response, string url)
    {
        try
        {
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

                Logger.LogError("http failed: " + response.StatusDescription);
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);

            lock (mResponseDict)
            {
                mResponseDict.Add(url, null);
            }
        }
        finally
        {
            if (response != null)
            {
                response.Close();
            }
        }
    }

    #endregion
}

