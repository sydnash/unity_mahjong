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
        public Action<byte[]> callback = null;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="url"></param>
        public RequestArgs(string url, 
                           string method, 
                           int timeout, 
                           Action<byte[]> callback)
        {
            this.url        = url;
            this.method     = method.ToUpper();
            this.timeout    = timeout;
            this.callback   = callback;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class ResponseArgs
    {
        /// <summary>
        /// 
        /// </summary>
        public string url;

        /// <summary>
        /// 
        /// </summary>
        public byte[] bytes;

        /// <summary>
        /// 
        /// </summary>
        public Action<byte[]> callback;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="callback"></param>
        public ResponseArgs(string url,
                            byte[] bytes,
                            Action<byte[]> callback)
        {
            this.url        = url;
            this.bytes      = bytes;
            this.callback   = callback;
        }
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private Thread[] mThreads = new Thread[10];

    /// <summary>
    /// 
    /// </summary>
    private AutoResetEvent mEvent = new AutoResetEvent(false);

    /// <summary>
    /// 
    /// </summary>
    private Queue<RequestArgs> mRequestQueue = new Queue<RequestArgs>();

    /// <summary>
    /// 
    /// </summary>
    private Queue<ResponseArgs> mResponseQueue = new Queue<ResponseArgs>();

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
    public void RequestBytes(string url, string method, int timeout, Action<byte[]> callback)
    {
        lock (mRequestQueue)
        {
            mRequestQueue.Enqueue(new RequestArgs(url, method, timeout, callback));
        }
        mEvent.Set();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestTexture(string url, Action<Texture2D, byte[]> callback)
    {
        StartCoroutine(LoadTextureCoroutine(url, callback));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestFile(string url, Action<string> callback)
    {
        StartCoroutine(LoadFileCoroutine(url, callback));
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

        for (int i=0; i<5; i++)
        {
            mThreads[i] = new Thread(OnRequest);
            mThreads[i].Start();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void Update()
    {
        ResponseArgs args = null;

        lock (mResponseQueue)
        {
            if (mResponseQueue.Count > 0)
            {
                args = mResponseQueue.Dequeue();
            }
        }

        if (args != null)
        {
            byte[] bytes = args.bytes;
            Action<byte[]> callback = args.callback;

            callback(bytes);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void OnDestroy()
    {
        mEvent.Close();

        foreach (Thread t in mThreads)
        {
            t.Abort();
        }

        mRequestQueue.Clear();
        mResponseQueue.Clear();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="obj"></param>
    private void OnRequest()
    {
        while (true)
        {
            RequestArgs args = null;

            lock (mRequestQueue)
            {
                if (mRequestQueue.Count > 0)
                {
                    args = mRequestQueue.Dequeue();
                }
            }

            if (args != null)
            {
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
                        AddReqponse(args.url, null, args.callback);
                    }
                    else
                    {
                        request.Method = args.method;
                        request.Timeout = args.timeout;
                        request.ReadWriteTimeout = args.timeout;
                        HttpWebResponse response = request.GetResponse() as HttpWebResponse;

                        OnResponse(response, args.url, args.callback);
                    }
                }
                catch (Exception ex)
                {
                    AddReqponse(args.url, null, args.callback);
                    Logger.LogError(ex.Message + "\n" + ex.StackTrace);
                }
                finally
                {
                    request.Abort();
                }
            }

            if (mRequestQueue.Count == 0)
            {
                //挂起线程
                mEvent.WaitOne();
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="result"></param>
    private void OnResponse(HttpWebResponse response, string url, Action<byte[]> callback)
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
                AddReqponse(url, bytes, callback);
            }
            else
            {
                AddReqponse(url, null, callback);
                Logger.LogError("http failed: " + response.StatusDescription);
            }
        }
        catch (Exception ex)
        {
            AddReqponse(url, null, callback);
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
    private void AddReqponse(string url, byte[] bytes, Action<byte[]> callback)
    {
        lock (mResponseQueue)
        {
            mResponseQueue.Enqueue(new ResponseArgs(url, bytes, callback));
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    /// <returns></returns>
    private IEnumerator LoadTextureCoroutine(string url, Action<Texture2D, byte[]> callback)
    {
        WWW www = new WWW(url);

        while (!www.isDone)
        {
            yield return new WaitForEndOfFrame();
        }

        if (string.IsNullOrEmpty(www.error))
        {
            callback(www.texture, www.bytes);
        }
        else
        {
            callback(null, null);
        }

        yield return new WaitForEndOfFrame();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator LoadFileCoroutine(string url, Action<string> callback)
    {
        WWW www = new WWW(url);

        while (!www.isDone)
        {
            yield return new WaitForEndOfFrame();
        }

        if (string.IsNullOrEmpty(www.error))
        {
            callback(www.text);
        }
        else
        {
            callback(string.Empty);
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

