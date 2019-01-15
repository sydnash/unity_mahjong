using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HttpDispatcher : MonoBehaviour
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class Response
    {
        public string url;
        public byte[] bytes;
        public int size;
        public int totalSize;
        public bool completed;
        public Action<byte[], int, bool> callback;

        public Response(string url, byte[] bytes, int totalSize, bool completed, Action<byte[], int, bool> callback)
        {
            this.url = url;
            this.bytes = bytes;
            this.totalSize = totalSize;
            this.completed = completed;
            this.callback = callback;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Queue<Response> mResponses = new Queue<Response>();

    /// <summary>
    /// 
    /// </summary>
    private List<HttpAsync> mHttpAsyncs = new List<HttpAsync>();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static HttpDispatcher mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static HttpDispatcher instance
    {
        get { return mInstance; }
    }

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;
        DontDestroyOnLoad(this);
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="threadCount"></param>
    /// <returns></returns>
    public HttpAsync CreateHttpAsync(int threadCount)
    {
        HttpAsync async = new HttpAsync(this, threadCount);
        mHttpAsyncs.Add(async);

        return async;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="async"></param>
    public void DestroyHttpAsync(HttpAsync async)
    {
        if (async != null)
        {
            async.Destroy();
            mHttpAsyncs.Remove(async);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="bytes"></param>
    /// <param name="size"></param>
    /// <param name="totalSize"></param>
    /// <param name="callback"></param>
    public void AddResponse(string url, byte[] bytes, int totalSize, bool completed, Action<byte[], int, bool> callback)
    {
        Response response = new Response(url, bytes, totalSize, completed, callback);

        lock (mResponses)
        {
            mResponses.Enqueue(response);
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Update()
    {
        Response response = null;
        lock (mResponses)
        {
            if (mResponses.Count > 0)
            {
                response = mResponses.Dequeue();
            }
        }

        if (response != null)
        {
            Action<byte[], int, bool> callback = response.callback;
            callback(response.bytes, response.totalSize, response.completed);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void OnDestroy()
    {
        foreach (HttpAsync async in mHttpAsyncs)
        {
            async.Destroy();
        }
        mHttpAsyncs.Clear();
    }

    #endregion
}
