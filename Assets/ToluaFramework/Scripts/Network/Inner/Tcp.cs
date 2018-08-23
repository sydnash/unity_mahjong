using System;
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
    private bool mConnected = false;

    /// <summary>
    /// 
    /// </summary>
    private Action<bool> mConnectCallback = null;

    /// <summary>
    /// 
    /// </summary>
    private Queue<byte[]> mSendMessageQueue = new Queue<byte[]>();

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
    private byte[] mReceivedBuffer = new byte[RECEIVED_BUFFER_SIZE];

    /// <summary>
    /// 
    /// </summary>
    private const int RECEIVED_BUFFER_SIZE = 4 * 1024;

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
    public void Connect(string host, int port, Action<bool> callback)
    {
        try
        {
            mConnectCallback = callback;

            mSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            mSocket.Blocking = false;
            mSocket.Connect(host, port);
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
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
                mSocket.Disconnect(false);
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="msg"></param>
    public void Send(byte[] msg, Action callback)
    {
        mSendMessageQueue.Enqueue(msg);
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
    private void Close()
    {
        mSendMessageQueue.Clear();
        mSendErrorCallbackQueue.Clear();

        Disconnect();
    }

    /// <summary>
    /// 
    /// </summary>
    private void Update()
    {
        if (mSocket == null)
            return;

        if (mSocket.Connected)
        {
            if (!mConnected && mConnectCallback != null)
            {
                mConnectCallback(true);
                mConnected = true;
            }

            //发送数据
            if (mSendMessageQueue.Count > 0)
            {
                byte[] msg = mSendMessageQueue.Dequeue();
                int sentSize = 0;
                SocketError err = SocketError.Success;

                while (sentSize < msg.Length)
                {
                    sentSize += mSocket.Send(msg, sentSize, msg.Length - sentSize, SocketFlags.None, out err);
                    if (err != SocketError.Success)
                    {
                        Logger.LogError(string.Format("tcp send data failed, err = {0}", err));

                        if (mSendErrorCallbackQueue.Count > 0)
                        {
                            Action callback = mSendErrorCallbackQueue.Dequeue();
                            callback();
                        }
                        
                        return;
                    }
                }
            }

            //收取数据
            {
                SocketError err = SocketError.Success;
                int receivedSize = mSocket.Receive(mReceivedBuffer, 0, RECEIVED_BUFFER_SIZE, SocketFlags.None, out err);

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
            if (mConnectCallback != null)
            {
                mConnectCallback(false);
                mConnected = false;
            }
        }
    }

    #endregion
}
