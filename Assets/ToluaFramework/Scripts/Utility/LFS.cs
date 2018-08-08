using System;
using System.IO;
using System.Text;
using UnityEngine;

public static class LFS
{
    public static readonly Encoding UTF8_WITHOUT_BOM  = new System.Text.UTF8Encoding(false);
    public static readonly string LOCALIZED_DATA_PATH = Application.streamingAssetsPath;
    public static readonly string DOWNLOAD_DATA_PATH  = Application.persistentDataPath;
        
    /// <summary>
    /// 
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    /// <returns></returns>
    public static string CombinePath(string a, string b)
    {
        return Path.Combine(a, b).Replace('\\', '/');
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    /// <param name="c"></param>
    /// <returns></returns>
    public static string CombinePath(string a, string b, string c)
    {
        return Path.Combine(Path.Combine(a, b), c).Replace('\\', '/');
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="content"></param>
    public static void WriteFile(string filename, string content, Encoding encode)
    {
        try
        {
            MakeDir(filename);

            StreamWriter sw = new StreamWriter(filename, false, encode);
            sw.Write(content);
            sw.Close();
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
    /// <param name="filename"></param>
    /// <param name="content"></param>
    public static void WriteFile(string filename, byte[] content)
    {
        try
        {
            MakeDir(filename);
            File.WriteAllBytes(filename, content);
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
    /// <param name="from"></param>
    /// <param name="to"></param>
    public static void MoveFile(string src, string dst)
    {
        try
        {
            MakeDir(dst);
            if (File.Exists(src)) File.Move(src, dst);
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
    /// <param name="src"></param>
    /// <param name="dst"></param>
    public static void CopyFile(string src, string dst)
    {
        try
        {
            MakeDir(dst);
            if (File.Exists(src)) File.Copy(src, dst, true);
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
    /// <param name="filename"></param>
    public static void RemoveFile(string filename)
    {
        try
        {
            if (File.Exists(filename))
            {
                File.Delete(filename);
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
    /// <param name="filename"></param>
    public static void MakeDir(string filename)
    {
        try
        {
            string path = Path.GetDirectoryName(filename);

            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
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
    /// <param name="from"></param>
    /// <param name="to"></param>
    public static void CopyDir(string from, string to)
    {
        try
        {
            MakeDir(to);

            if (Directory.Exists(from))
            {
                string[] pathes = Directory.GetFiles(from, "*.*", SearchOption.AllDirectories);
                foreach (string path in pathes)
                {
                    if (!IsDirectory(path))
                    {
                        string src = path;
                        string dst = path.Replace(from, to);

                        CopyFile(src, dst);
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
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="path"></param>
    public static void RemoveDir(string path)
    {
        try
        {
            if (Directory.Exists(path))
            {
                Directory.Delete(path, true);
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
    /// <param name="path"></param>
    /// <returns></returns>
    private static bool IsDirectory(string path)
    {
        FileAttributes fa = File.GetAttributes(path);
        return (fa == FileAttributes.Directory);
    }
}
