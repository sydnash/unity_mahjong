﻿using System;
using System.Net.Sockets;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class Tcp : MonoBehaviour
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Socket mSocket = null;

    /// <summary>
    /// 
    /// </summary>
    private string mHost = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private int mPort = 0;

    /// <summary>
    /// 
    /// </summary>
    private bool mConnected = false;

    /// <summary>
    /// 
    /// </summary>
    private float mTimeout = 0.5f;

    /// <summary>
    /// 
    /// </summary>
    private float mConnectTimestamp = 0;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool> mConnectCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private float mStartConnectTime = 0;

    /// <summary>
    /// 
    /// </summary>
    private Queue<byte[]> mSendMessageQueue = new Queue<byte[]>();

    /// <summary>
    /// 
    /// </summary>
    private Queue<int> mSendMessageLengthQueue = new Queue<int>();

    /// <summary>
    /// 
    /// </summary>
    private Queue<Action> mSendErrorCallbackQueue = new Queue<Action>();

    /// <summary>
    /// 
    /// </summary>
    private Action<byte[], int> mReceivedCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private byte[] mReceivedBuffer = new byte[BUFFER_SIZE];

    /// <summary>
    /// 
    /// </summary>
    private const int BUFFER_SIZE = 4 * 1024 * 1024;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static Tcp mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static Tcp instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="host"></param>
    /// <param name="port"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    public void Connect(string host, int port, int timeout, Action<bool> callback)
    {
        mHost = host;
        mPort = port;
        timeout = (timeout > 0) ? Mathf.Max(500, timeout) : timeout;
        
        try
        {
            mConnectCallback = callback;
            mTimeout = timeout / 1000.0f;
            mStartConnectTime = Time.realtimeSinceStartup;
            mConnected = false;

            mSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            mSocket.Blocking = false;
            mSocket.SendBufferSize = BUFFER_SIZE;
            mSocket.ReceiveBufferSize = BUFFER_SIZE;
            mSocket.SendTimeout = timeout;
            mSocket.ReceiveTimeout = timeout;

            Connect();
        }
        catch (Exception ex)
        {
            //Logger.LogError(ex.Message);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void Disconnect()
    {
        try
        {
            if (mSocket != null)
            {
                mSocket.Close();
            }

            mSendMessageQueue.Clear();
            mSendMessageLengthQueue.Clear();
            mSendErrorCallbackQueue.Clear();
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }
        finally
        {
            mConnected = false;
            mSocket = null;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="msg"></param>
    public void Send(byte[] msg, int length, Action callback)
    {
        mSendMessageQueue.Enqueue(msg);
        mSendMessageLengthQueue.Enqueue(length);
        mSendErrorCallbackQueue.Enqueue(callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="receivedHandler"></param>
    public void RegisterReceivedCallback(Action<byte[], int> callback)
    {
        mReceivedCallback = callback;
    }

    /// <summary>
    /// 
    /// </summary>
    public void UnregisterReceivedCallback()
    {
        mReceivedCallback = null;
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
        if (mSocket == null)
            return;

        try
        {
            if (mSocket.Connected)
            {
                if (!mConnected)
                {
                    if (mConnectCallback != null)
                    {
                        mConnectCallback(true);
                    }
                    mConnected = true;
                }

                //发送数据
                if (mConnected && mSendMessageQueue.Count > 0 && mSendMessageLengthQueue.Count > 0)
                {
                    byte[] msg = mSendMessageQueue.Dequeue();
                    int length = mSendMessageLengthQueue.Dequeue();
                    Action callback = mSendErrorCallbackQueue.Dequeue();
                    int sentSize = 0;
                    SocketError err = SocketError.Success;

                    while (sentSize < length)
                    {
                        sentSize += mSocket.Send(msg, sentSize, length - sentSize, SocketFlags.None, out err);
                        if (err != SocketError.Success)
                        {
                            callback();
                            Logger.LogError(string.Format("tcp send data failed, err = {0}", err));

                            break;
                        }
                    }
                }

                //收取数据
                if (mConnected && mSocket.Available > 0)
                {
                    SocketError err = SocketError.Success;
                    int receivedSize = mSocket.Receive(mReceivedBuffer, 0, BUFFER_SIZE, SocketFlags.None, out err);

                    if (err != SocketError.Success)
                    {
                        Logger.LogError(string.Format("tcp recv data failed, err = {0}", err));
                        mReceivedCallback(null, -1);
                    }
                    else if (receivedSize > 0 && mReceivedCallback != null)
                    {
                        mReceivedCallback(mReceivedBuffer, receivedSize);
                    }
                }
            }
            else if (mConnected)
            {
                Logger.Log("tcp disconnect");
                if (mConnectCallback != null)
                {
                    mConnectCallback(false);
                }
                mConnected = false;
            }
            else
            {
                if (Time.realtimeSinceStartup - mStartConnectTime < mTimeout)
                {
                    Connect();
                }
                else
                {
                    Logger.Log("tcp connect timeout");
                    Disconnect();

                    if (mConnectCallback != null)
                    {
                        mConnectCallback(false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            //Logger.LogError(ex.Message);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void Connect()
    {
        if (Time.realtimeSinceStartup - mConnectTimestamp > 0.5f)
        {
            mSocket.Connect(mHost, mPort);
            mConnectTimestamp = Time.realtimeSinceStartup;
        }
    }

    #endregion
}
