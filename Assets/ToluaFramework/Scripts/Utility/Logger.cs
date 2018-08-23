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
#if UNITY_EDITOR
        Debug.Log("logger is open");
#else
        if (debug)
        {
#if UNITY_ANDROID
            string dependencies = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
#elif UNITY_IOS
            string dependencies = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
#else
            string filename = LFS.CombinePath(Directory.GetCurrentDirectory(), "Log", DateTime.Now.ToString("yyyyMMddHHmmssfff")+".txt");
#endif
            LFS.MakeDir(filename);
            writer = new StreamWriter(filename);
        }
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    public static void Close()
    {
        if (writer != null)
        {
            writer.Close();
        }
        writer = null;

#if UNITY_EDITOR
        Debug.Log("logger is closed");
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
            string timestamp = DateTime.Now.ToString("HH:mm:ss.fff: ");
            Debug.Log(timestamp + text);
            WriteToFile(timestamp, text);
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
            string timestamp = DateTime.Now.ToString("HH:mm:ss.fff: ");
            Debug.LogWarning(timestamp + text);
            WriteToFile(timestamp, text);
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
            string timestamp = DateTime.Now.ToString("HH:mm:ss.fff: ");
            Debug.LogError(timestamp + text);
            WriteToFile(timestamp, text);
        }
#endif
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    private static void WriteToFile(string timestamp, string text)
    {
        if (writer != null)
        {
            writer.WriteLine(timestamp + "\n" + text);
            writer.Flush();
        }
    }

    #endregion
}
