﻿using System;
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
        public int timeout;

        public Request(string url, int timeout)
        {
            this.url = url;
            this.timeout = timeout;
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
    private Thread[] mThreads = null;

    /// <summary>
    /// 
    /// </summary>
    private AutoResetEvent mEvent = new AutoResetEvent(false);

    /// <summary>
    /// 
    /// </summary>
    private Queue<Request> mRequests = new Queue<Request>();

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Action<byte[], int, bool>> mCallbacks = new Dictionary<string, Action<byte[], int, bool>>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public HttpAsync(HttpDispatcher dispatcher, int threadCount)
    {
        mThreads = new Thread[Mathf.Clamp(threadCount, 1, 10)];

        for (int i = 0; i < mThreads.Length; i++)
        {
            mThreads[i] = new Thread(OnThread);
            mThreads[i].Start();
        }

        mDispatcher = dispatcher;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="timeout"></param>
    /// <param name="callback"></param>
    public void AddRequest(string url, int timeout, Action<byte[], int, bool> callback)
    {
        if (string.IsNullOrEmpty(url) || callback == null)
            return;

        lock (mRequests)
        {
            timeout = Mathf.Clamp(timeout, 100, 120 * 1000);
            mRequests.Enqueue(new Request(url, timeout));
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
        mEvent.Close();

        foreach (Thread thread in mThreads)
        {
            thread.Abort();
        }

        mRequests.Clear();
        mCallbacks.Clear();
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void OnThread()
    {
        Http http = new Http();

        try
        {
            while (true)
            {
                Request request = NextRequset();
                if (request == null)
                {
                    mEvent.WaitOne();
                    continue;
                }

                http.Request(request.url, "GET", request.timeout, OnDownloaded);
            }
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
