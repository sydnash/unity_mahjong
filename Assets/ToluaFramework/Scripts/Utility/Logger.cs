using System;
using System.IO;
using UnityEngine;

public static class Logger
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    public static bool debug = false;

    /// <summary>
    /// 
    /// </summary>
    private static StreamWriter writer = null;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public static void Open()
    {
#if !UNITY_EDITOR
        if (debug)
        {
    #if UNITY_ANDROID
            string filename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
    #elif UNITY_IOS
            string filename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
    #else
            string filename = LFS.CombinePath(Directory.GetCurrentDirectory(), "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
    #endif
            LFS.MakeDir(filename);
            writer = new StreamWriter(filename);

            Application.logMessageReceived += LogReceivedHandler;
        }
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    public static void Close()
    {
#if !UNITY_EDITOR
        if (debug)
        {
            Application.logMessageReceived -= LogReceivedHandler;

            if (writer != null)
            {
                writer.Close();
            }
            writer = null;
        }
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public static void Log(string text)
    {
#if UNITY_EDITOR
        Debug.Log(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
#else
        if (debug)
        {
            Debug.Log(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
            //WriteToFile(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
        }
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public static void LogWarning(string text)
    {
#if UNITY_EDITOR
        Debug.LogWarning(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
#else
        if (debug)
        {
            Debug.LogWarning(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
            //WriteToFile(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
        }
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    public static void LogError(string text)
    {
#if UNITY_EDITOR
        Debug.LogError(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
#else
        if (debug)
        {
            Debug.LogError(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
            //WriteToFile(DateTime.Now.ToString("HH:mm:ss.fff: ") + text);
        }
#endif
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="condition"></param>
    /// <param name="stackTrace"></param>
    /// <param name="type"></param>
    private static void LogReceivedHandler(string condition, string stackTrace, LogType type)
    {
        WriteToFile(condition + "\n" + stackTrace);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    private static void WriteToFile(string content)
    {
        if (writer != null)
        {
            writer.WriteLine(content);
            writer.Flush();
        }
    }

    #endregion
}
