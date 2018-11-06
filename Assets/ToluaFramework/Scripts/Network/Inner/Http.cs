using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Net.Security;
using System.Threading;
using System.Security.Cryptography.X509Certificates;
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
    private Dictionary<string, Action<bool, Texture2D, byte[]>> mTextureCallbackDict = new Dictionary<string, Action<bool, Texture2D, byte[]>>();

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
        if (mTextCallbackDict.ContainsKey(url))
        {
            mTextCallbackDict[url] = callback;
        }
        else
        {
            mTextCallbackDict.Add(url, callback);
        }

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
        if (mByteCallbackDict.ContainsKey(url))
        {
            mByteCallbackDict[url] = callback;
        }
        else
        {
            mByteCallbackDict.Add(url, callback);
        }

        Thread thread = new Thread(OnRequest);
        thread.Start(new RequestArgs(url, method, timeout));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestTexture(string url, Action<bool, Texture2D, byte[]> callback)
    {
        if (mTextureCallbackDict.ContainsKey(url))
        {
            mTextureCallbackDict[url] = callback;
        }
        else
        {
            mTextureCallbackDict.Add(url, callback);
        }
        
        StartCoroutine(LoadTextureCoroutine(url));
    }

    /// <summary>
    /// 
    /// </summary>
    public void Reset()
    {
        mTextCallbackDict.Clear();
        mByteCallbackDict.Clear();
        mTextureCallbackDict.Clear();

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
               
                if (mTextCallbackDict.ContainsKey(k))//文本回调
                {
                    Action<bool, string> callback = mTextCallbackDict[k];

                    mResponseDict.Remove(k);
                    mTextCallbackDict.Remove(k);

                    if (v != null)
                    {
                        callback(true, Encoding.UTF8.GetString(v));
                    }
                    else
                    {
                        callback(false, string.Empty);
                    }

                    break;
                }
                else if (mByteCallbackDict.ContainsKey(k))//字节回调
                {
                    Action<bool, byte[]> callback = mByteCallbackDict[k];

                    mResponseDict.Remove(k);
                    mByteCallbackDict.Remove(k);

                    callback(v != null, v);
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

        if (args.url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
        {
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            request.ProtocolVersion = HttpVersion.Version10;
        }

        try
        {
            if (request == null)
            {
                AddReqponse(args.url);
            }
            else
            {
                request.Method = args.method;
                request.Timeout = args.timeout;
                request.ReadWriteTimeout = args.timeout;
                HttpWebResponse response = request.GetResponse() as HttpWebResponse;

                OnResponse(response, args.url);
            }
        }
        catch (Exception ex)
        {
            AddReqponse(args.url);
            Logger.LogError(ex.Message + "\n" + ex.StackTrace);
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
                AddReqponse(url, bytes);
            }
            else
            {
                AddReqponse(url);
                Logger.LogError("http failed: " + response.StatusDescription);
            }
        }
        catch (Exception ex)
        {
            AddReqponse(url);
            Logger.LogError(ex.Message + "\n" + ex.StackTrace);
        }
        finally
        {
            if (response != null)
            {
                response.Close();
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    private void AddReqponse(string url, byte[] bytes = null)
    {
        lock (mResponseDict)
        {
            mResponseDict.Add(url, bytes);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    /// <returns></returns>
    private IEnumerator LoadTextureCoroutine(string url)
    {
        WWW www = new WWW(url);

        while (!www.isDone)
        {
            yield return new WaitForEndOfFrame();
        }

        if (mTextureCallbackDict.ContainsKey(url))
        {
            Action<bool, Texture2D, byte[]> callback = mTextureCallbackDict[url];

            if (string.IsNullOrEmpty(www.error))
            {
                callback(true, www.texture, www.bytes);
            }
            else
            {
                callback(false, null, null);
            }

            mTextureCallbackDict.Remove(url);
        }

        yield return new WaitForEndOfFrame();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="certificate"></param>
    /// <param name="chain"></param>
    /// <param name="errors"></param>
    /// <returns></returns>
    private static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        return true; //总是接受  
    }
    #endregion
}

