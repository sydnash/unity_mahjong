using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

/// <summary>
/// 
/// </summary>
public class HttpAsync
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class Request
    {
        public string url;
        public string method;
        public int timeout;
        public string args;

        public Request(string url, string method, int timeout, string args)
        {
            this.url = url;
            this.method = method.ToUpper();
            this.timeout = timeout;
            this.args = args;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private HttpDispatcher mDispatcher = null;

    /// <summary>
    /// 
    /// </summary>
    private Http[] mHttps = null;

    /// <summary>
    /// 
    /// </summary>
    private Thread[] mThreads = null;

    /// <summary>
    /// 
    /// </summary>
    private AutoResetEvent mEvent = new AutoResetEvent(false);

    /// <summary>
    /// 
    /// </summary>
    private volatile bool mWorking = true;

    /// <summary>
    /// 
    /// </summary>
    private Queue<Request> mRequests = new Queue<Request>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Action<byte[], int, bool>> mCallbacks = new Dictionary<string, Action<byte[], int, bool>>();

    /// <summary>
    /// 
    /// </summary>
    public static int nv = 2;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public HttpAsync(HttpDispatcher dispatcher, int threadCount)
    {
        threadCount = Mathf.Clamp(threadCount, 1, 10);

        mHttps = new Http[threadCount];
        mThreads = new Thread[threadCount];

        for (int i = 0; i < threadCount; i++)
        {
            mHttps[i] = new Http();
            mHttps[i].working = mWorking;

            mThreads[i] = new Thread(OnThread);
            mThreads[i].Start(mHttps[i]);
        }

        mDispatcher = dispatcher;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="timeout"></param>
    /// <param name="callback"></param>
    public void AddRequest(string url, string method, int timeout, string args, Action<byte[], int, bool> callback)
    {
        if (string.IsNullOrEmpty(url) || callback == null)
            return;

        lock (mRequests)
        {
            timeout = Mathf.Clamp(timeout, 100, 120 * 1000);
            mRequests.Enqueue(new Request(url, method, timeout, args));
        }

        lock (mCallbacks)
        {
            if (!mCallbacks.ContainsKey(url))
            {
                mCallbacks.Add(url, callback);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Start()
    {
        try
        {
            mEvent.Set();
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            //Logger.LogError(ex.StackTrace);
#endif
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Stop()
    {
        lock (mRequests)
        {
            mRequests.Clear();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Destroy()
    {
        mWorking = false;
       
        foreach (Http http in mHttps)
        {
            http.working = mWorking;
        }

        mEvent.Close();

        lock (mRequests)
        {
            mRequests.Clear();
        }

        lock (mCallbacks)
        {
            mCallbacks.Clear();
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void OnThread(object args)
    {
        Http http = args as Http;

        try
        {
            while (mWorking)
            {
                Request request = NextRequset();
                if (request == null)
                {
                    mEvent.WaitOne(300);
                    continue;
                }

                http.Request(request.url, request.method, request.timeout, request.args, OnDownloaded);
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Logger.LogError(ex.StackTrace);
#endif
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    private Request NextRequset()
    {
        Request requset = null;

        lock (mRequests)
        {
            if (mRequests.Count > 0)
            {
                requset = mRequests.Dequeue();
            }
        }

        return requset;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="bytes"></param>
    /// <param name="size"></param>
    /// <param name="totalSize"></param>
    private void OnDownloaded(string url, byte[] bytes, int totalSize, bool completed)
    {
        lock (mDispatcher)
        {
            Action<byte[], int, bool> callback = null;
            if (mCallbacks.ContainsKey(url))
            {
                callback = mCallbacks[url];
                if (completed)
                {
                    mCallbacks.Remove(url);
                }
            }

            if (callback != null)
            {
                mDispatcher.AddResponse(url, bytes, totalSize, completed, callback);
            }
        }
    }

    #endregion 
}
