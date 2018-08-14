using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class NetworkManager : MonoBehaviour
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Lua mLua = new Lua();

    /// <summary>
    /// 
    /// </summary>
    private Tcp mTcp = new Tcp();

    /// <summary>
    /// 
    /// </summary>
    private const int INT_BYTES_COUNT = sizeof(int);

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static NetworkManager mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static NetworkManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestText(string url, string form, Action<bool, string> callback)
    {
        Http.instance.RequestText(url, form, callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="callback"></param>
    public void RequestBytes(string url, string form, Action<bool, byte[]> callback)
    {
        Http.instance.RequestBytes(url, form, callback);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="host"></param>
    /// <param name="port"></param>
    /// <param name="callback"></param>
    public void Connect(string host, int port, Action<bool> callback)
    {
        mTcp.Connect(host, port, callback);
    }

    /// <summary>
    /// 
    /// </summary>
    public void Disconnect()
    {
        mTcp.Disconnect();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="data"></param>
    public void Send(string data)
    {
        byte[] msg = BuildMessage(data);
        mTcp.Send(msg);
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;
        mLua.Require("network/network");
    }

    /// <summary>
    /// 
    /// </summary>
    private void Update()
    {
        mTcp.Update();
        byte[] msg = mTcp.nextReceivedMessage;

        if (msg != null && msg.Length > 0)
        {
            int length = BitConverter.ToInt32(msg, 0);
            if (msg.Length != length)
            {
#if UNITY_EDITOR
                Debug.LogError("");
#endif
                return;
            }

            byte[] contentBytes = new byte[length - INT_BYTES_COUNT];
            Array.Copy(msg, INT_BYTES_COUNT, contentBytes, 0, contentBytes.Length);
            byte[] bytes = Base64.Decrypt(contentBytes);
            string decrypt = AES.Decrypt(bytes);

            int checksumLength = 32;
            int dataLength = decrypt.Length - checksumLength;

            string data = decrypt.Substring(0, dataLength);
            string checkSum = decrypt.Substring(dataLength, checksumLength);

            if (MD5.GetHash(data) != checkSum)
            {
#if UNITY_EDITOR
                Debug.LogError("");
#endif
                return;
            }

            DispatchMessage(data);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    private byte[] BuildMessage(string data)
    {
        data += MD5.GetHash(data);
        byte[] contentBytes = AES.Encrypt(data);
        contentBytes = Base64.Encrypt(contentBytes);
        byte[] lengthBytes = BitConverter.GetBytes(contentBytes.Length);

        byte[] msg = new byte[contentBytes.Length + lengthBytes.Length];
        Array.Copy(lengthBytes, 0, msg, 0, lengthBytes.Length);
        Array.Copy(contentBytes, 0, msg, lengthBytes.Length, contentBytes.Length);

        return msg;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="data"></param>
    private void DispatchMessage(string data)
    {
        mLua.CallFunction<string>("dispatch", data);
    }

    #endregion
}
