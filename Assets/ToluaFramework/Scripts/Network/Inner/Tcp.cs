using System;
using System.Net.Sockets;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class Tcp
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Socket mSocket = null;

    /// <summary>
    /// 
    /// </summary>
    private bool mIsConnected = false;

    /// <summary>
    /// 
    /// </summary>
    private bool mIsConnectedLastFrame = false;

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
    private object mSendQueueMutex = new object();

    /// <summary>
    /// 
    /// </summary>
    private Queue<byte[]> mReceiveQueue = new Queue<byte[]>();

    /// <summary>
    /// 
    /// </summary>
    private object mRecevieQueueMutex = new object();

    /// <summary>
    /// 
    /// </summary>
    private const int INT_BYTES_COUNT = sizeof(int);

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
            mSocket.BeginConnect(host, port, OnConnectHandler, callback);
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
            mIsConnected = false;
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
                mSocket.BeginDisconnect(false, OnDisconnectHandler, null);
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }
        finally
        {
            mIsConnected = false;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="msg"></param>
    public void Send(byte[] msg)
    {
        lock (mSendQueueMutex)
        {
            mSendQueue.Enqueue(msg);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        if (mIsConnected && !mIsConnectedLastFrame)
        {
            InvokeCallback(mConnectCallback, true);
        }
        else if (!mIsConnected && mIsConnectedLastFrame)
        {
            InvokeCallback(mConnectCallback, false);
        }

        mIsConnectedLastFrame = mIsConnected;
    }

    /// <summary>
    /// 
    /// </summary>
    public byte[] nextReceivedMessage
    {
        get 
        {
            lock (mRecevieQueueMutex)
            {
                return (mReceiveQueue.Count == 0) ? null : mReceiveQueue.Dequeue();
            }
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Open()
    {
        mIsConnected = true;

        Thread sendingThread = new Thread(OnSending);
        sendingThread.Start(mSocket);

        Thread receivingThread = new Thread(OnReceiving);
        receivingThread.Start(mSocket);
    }

    /// <summary>
    /// 
    /// </summary>
    private void Close()
    {
        mIsConnected = false;

        lock (mSendQueueMutex)
        {
            mSendQueue.Clear();
        }

        lock (mRecevieQueueMutex)
        {
            mReceiveQueue.Clear();
        }

        try
        {
            mSocket.Shutdown(SocketShutdown.Both);
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
    /// <param name="args"></param>
    private void OnConnectHandler(IAsyncResult args)
    {
        Action<bool> callback = args.AsyncState as Action<bool>;

        try
        {
            if (mSocket != null)
            {
                mSocket.EndConnect(args);
                Open();

                mIsConnected = true;
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
            mIsConnected = false;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnDisconnectHandler(IAsyncResult args)
    {
        try
        {
            mSocket.EndDisconnect(args);
            mSocket.Close();
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }
        finally
        {
            mIsConnected = false;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnSending(object args)
    {
        try
        {
            SocketError socketState = SocketError.Success;

            while (mIsConnected)
            {
                byte[] msg = nextSendMessage;

                if (msg != null)
                {
                    int sentSize = 0;

                    while (sentSize < msg.Length)
                    {
                        sentSize += mSocket.Send(msg, sentSize, msg.Length - sentSize, SocketFlags.None, out socketState);
                        if (socketState != SocketError.Success)
                        {
                            return;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }
        finally
        {
            Close();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private byte[] nextSendMessage
    {
        get
        {
            lock (mSendQueueMutex)
            {
                return (mSendQueue.Count == 0) ? null : mSendQueue.Dequeue();
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnReceiving(object args)
    {
        try
        {
            SocketError socketState = SocketError.Success;

            while (mIsConnected)
            {
                int receivedSize = 0;
                //协议长度
                byte[] lengthBytes = new byte[INT_BYTES_COUNT];
                while (receivedSize < INT_BYTES_COUNT)
                {
                    receivedSize += mSocket.Receive(lengthBytes, 0, lengthBytes.Length, SocketFlags.None, out socketState);
                }
                //协议内容+校验码
                int size = BitConverter.ToInt32(lengthBytes, 0) - INT_BYTES_COUNT;
                byte[] msg = new byte[size];

                receivedSize = 0;

                while (receivedSize < size)
                {
                    receivedSize += mSocket.Receive(msg, receivedSize, size - receivedSize, SocketFlags.None, out socketState);
                    if (socketState != SocketError.Success)
                    {
                        return;
                    }
                }
                //进入接收消息队列
                lock (mRecevieQueueMutex)
                {
                    mReceiveQueue.Enqueue(msg);
                }
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }
        finally
        {
            Close();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    private void InvokeCallback(Action<bool> callback, bool args)
    {
        if (callback != null)
        {
            callback(args);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    /// <param name="state"></param>
    /// <param name="text"></param>
    private void InvokeCallback(Action<SocketError, string> callback, SocketError state, string text)
    {
        if (callback != null)
        {
            callback(state, text);
        }
    }

    #endregion
}
