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
    private const int BUFFER_SIZE = 2 * 1024 * 1024;

    #endregion

    #region Public

    public enum TcpError {
        Success                                 = 0,
        CatchException                          = -1000,
        NormalError                             = -1,
        SendNotSuccess                          = -2,
        ReceiveZeroLen                          = -3,
        ReceiveNotSuccessAndNotWouldBlock       = -4,
    }

    public Tcp()
    {
        mSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        mSocket.Blocking = false;
        mSocket.SendBufferSize = BUFFER_SIZE;
        mSocket.ReceiveBufferSize = BUFFER_SIZE;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="host"></param>
    /// <param name="port"></param>
    /// <returns></returns>
    public int Connect(string host, int port)
    {
        try {
            if (mSocket.Connected)
            {
                return (int)TcpError.Success;
            }
            mSocket.Connect(host, port);
            if (mSocket.Connected)
            {
                return (int)TcpError.Success;
            }
            return (int)TcpError.NormalError;
        } catch(Exception e) {
            return (int)TcpError.CatchException;
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
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }
        finally
        {
            mSocket = null;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="msg"></param>
    public int Send(byte[] msg, int length)
    {
        try {
            int sentSize = 0;
            SocketError err = SocketError.Success;

            while (sentSize < length)
            {
                sentSize += mSocket.Send(msg, sentSize, length - sentSize, SocketFlags.None, out err);
                if (err != SocketError.Success)
                {
                    return (int)TcpError.SendNotSuccess;
                }
            }
            return (int)TcpError.Success;
        } catch {
            return (int)TcpError.NormalError;
        }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="buffer"></param>
    /// <returns></returns>
    public int Receive(byte[] buffer)
    {
        try {
            SocketError err = SocketError.Success;
            int receivedSize = mSocket.Receive(buffer, 0, buffer.Length, SocketFlags.None, out err);

            if (err == SocketError.Success && receivedSize == 0)
            {
                return (int)TcpError.ReceiveZeroLen;
            } 
            else if (err != SocketError.Success && err != SocketError.WouldBlock)
            {
                return (int)TcpError.ReceiveNotSuccessAndNotWouldBlock;
            }
            else if (receivedSize > 0)
            {
                return receivedSize;
            }
            return (int)TcpError.Success;
        } catch {
            return (int)TcpError.CatchException;
        }
    }

    #endregion
}
