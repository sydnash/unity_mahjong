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
    private Action<byte[]> mReceivedHandler = null;

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
    /// <param name="receivedHandler"></param>
    public void RegisterReceivedHandler(Action<byte[]> receivedHandler)
    {
        mReceivedHandler = receivedHandler;
    }

    /// <summary>
    /// 
    /// </summary>
    public void UnregisterReceivedHandler()
    {
        mReceivedHandler = null;
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
            //Debug.LogError(ex.Message);
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
                int receivedSize = mSocket.Receive(mReceivedBuffer, 0, RECEIVED_BUFFER_SIZE, SocketFlags.None, out socketState);
                if (socketState != SocketError.Success)
                {
                    return;
                }

                if (receivedSize > 0)
                {
                    byte[] buffer = new byte[receivedSize];
                    Array.Copy(mReceivedBuffer, 0, buffer, 0, receivedSize);

                    lock (mRecevieQueueMutex)
                    {
                        mReceiveQueue.Enqueue(buffer);
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
    private void Update()
    {
        if (mConnectCallback != null)
        {
            if (mIsConnected && !mIsConnectedLastFrame)
            {
                mConnectCallback(true);
            }
            else if (!mIsConnected && mIsConnectedLastFrame)
            {
                mConnectCallback(false);
            }
        }

        mIsConnectedLastFrame = mIsConnected;

        if (mIsConnected)
        {
            byte[] bytes = nextReceivedMessage;
            if (bytes != null && mReceivedHandler != null)
            {
                mReceivedHandler(bytes);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private byte[] nextReceivedMessage
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
}
