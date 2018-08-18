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
    private Queue<byte[]> mSendQueue = new Queue<byte[]>();

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
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
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
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="msg"></param>
    public void Send(byte[] msg)
    {
        mSendQueue.Enqueue(msg);
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
        mSendQueue.Clear();

        try
        {
            mSocket.Shutdown(SocketShutdown.Both);
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            //Debug.LogError(ex.Message);
#endif
        }
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
            if (mSendQueue.Count > 0)
            {
                byte[] msg = mSendQueue.Dequeue();
                int sentSize = 0;
                SocketError err = SocketError.Success;

                while (sentSize < msg.Length)
                {
                    sentSize += mSocket.Send(msg, sentSize, msg.Length - sentSize, SocketFlags.None, out err);
                    if (err != SocketError.Success)
                    {
#if UNITY_EDITOR
                        Debug.LogError("tcp send data failed");
#endif
                        return;
                    }
                }
            }

            //收取数据
            {
                SocketError err = SocketError.Success;
                int receivedSize = mSocket.Receive(mReceivedBuffer, 0, RECEIVED_BUFFER_SIZE, SocketFlags.None, out err);

                if (receivedSize > 0 && mReceivedCallback != null)
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
