using System;
using System.Net.Sockets;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class Tcp
{
    private Socket mSocket = null;

    private bool mIsConnected = false;

    private Queue<string> mSendQueue = new Queue<string>();

    private object mSendQueueMutex = new object();

    private Queue<string> mReceiveQueue = new Queue<string>();

    private object mRecevieQueueMutex = new object();

    /// <summary>
    /// 
    /// </summary>
    /// <param name="host"></param>
    /// <param name="port"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    public bool Connect(string host, int port, Action callback)
    {
        try
        {
            mSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            mSocket.BeginConnect(host, port, OnConnectHandler, callback);
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }

        return true;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    public void Disconnect(Action callback)
    {
        try
        {
            if (mSocket != null)
            {
                mSocket.BeginDisconnect(false, OnDisconnectHandler, callback);
            }
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }
        finally
        {
            mSocket = null;
            mIsConnected = false;

            InvokeCallback(callback);
        }
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
            Debug.LogError(ex.Message);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnConnectHandler(IAsyncResult args)
    {
        try
        {
            Action callback = args.AsyncState as Action;

            if (mSocket != null)
            {
                mSocket.EndConnect(args);
                Open();

                InvokeCallback(callback);
            }
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnDisconnectHandler(IAsyncResult args)
    {
        Action callback = args.AsyncState as Action;

        try
        {
            mSocket.EndDisconnect(args);
            mSocket.Close();
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }
        finally
        {
            mIsConnected = false;
            InvokeCallback(callback);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnSending(object args)
    {
        Socket socket = args as Socket;

        try
        {
            while (mIsConnected)
            {
                string msg = null;

                lock (mSendQueueMutex)
                {
                    if (mSendQueue.Count > 0)
                    {
                        msg = mSendQueue.Dequeue();
                    }
                }

                if (msg != null)
                {
                    byte[] sendBytes = System.Text.Encoding.UTF8.GetBytes(msg);
                    int sentSize = 0;

                    while (sentSize < sendBytes.Length)
                    {
                        sentSize += socket.Send(sendBytes, sentSize, sendBytes.Length - sentSize, SocketFlags.None);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Close();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void OnReceiving(object args)
    {
        Socket socket = args as Socket;

        try
        {
            while (mIsConnected)
            {
                //解析协议
                //...
            }
        }
        catch (Exception ex)
        {
            Close();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    private void InvokeCallback(Action callback)
    {
        if (callback != null)
        {
            callback();
        }
    }
}
