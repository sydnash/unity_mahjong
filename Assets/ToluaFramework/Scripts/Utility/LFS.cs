﻿using System;
using System.IO;
using System.Text;
using UnityEngine;

public static class LFS
{
    public static readonly Encoding UTF8_WITHOUT_BOM  = new System.Text.UTF8Encoding(false);
    public static readonly string LOCALIZED_DATA_PATH = Application.streamingAssetsPath;
    public static readonly string DOWNLOAD_DATA_PATH  = Application.persistentDataPath;
    public static readonly string OS_PATH = LuaConst.osDir;
    public static readonly string PATCH_PATH = CombinePath(DOWNLOAD_DATA_PATH, LuaConst.patchDir);

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
    /// <param name="path"></param>
    /// <returns></returns>
    public static bool FileExist(string path)
    {
        return File.Exists(path);
    }

    /// <summary>
    /// 将文本写入文件
    /// 如果该文件不存在则创建新文件，否则覆盖写入
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="content"></param>
    public static void WriteText(string filename, string content, Encoding encode)
    {
        try
        {
            MakeDirByFilename(filename);

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
    public static void WriteBytes(string filename, byte[] content)
    {
        try
        {
            MakeDirByFilename(filename);
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
    /// 将文本写入文件
    /// 如果该文件不存在则创建新文件，否则在文件尾部添加
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="content"></param>
    /// <param name="encode"></param>
    public static void AppendText(string filename, string content, Encoding encode)
    {
        try
        {
            MakeDirByFilename(filename);

            StreamWriter sw = new StreamWriter(filename, true, encode);
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
    /// 将文本作为独立一行写入文件
    /// 如果该文件不存在则创建新文件，否则在文件尾部添加
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="content"></param>
    /// <param name="encode"></param>
    public static void AppendLine(string filename, string content, Encoding encode)
    {
        try
        {
            MakeDirByFilename(filename);

            StreamWriter sw = new StreamWriter(filename, true, encode);
            sw.WriteLine(content);
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
    /// <param name="bytes"></param>
    public static void AppendBytes(string filename, byte[] bytes)
    {
        try
        {
            MakeDirByFilename(filename);

            FileStream fs = new FileStream(filename, FileMode.Append, FileAccess.Write);
            fs.Write(bytes, 0, bytes.Length);
            fs.Close();
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
    /// <param name="encode"></param>
    /// <returns></returns>
    public static string ReadText(string filename, Encoding encode)
    {
        string text = string.Empty;

        try
        {
            if (File.Exists(filename))
            {
                StreamReader sr = new StreamReader(filename, encode);
                text = sr.ReadToEnd();
                sr.Close();
            }
        }
        catch(Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }

        return text;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public static byte[] ReadBytes(string filename)
    {
        byte[] bytes = null;

        try
        {
            if (File.Exists(filename))
            {
                bytes = File.ReadAllBytes(filename);
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }

        return bytes;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="encode"></param>
    /// <returns></returns>
    public static string[] ReadLines(string filename, Encoding encode)
    {
        string[] lines = null;

        try
        {
            if (File.Exists(filename))
            {
                lines = File.ReadAllLines(filename, encode);
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            Debug.LogError(ex.Message);
#endif
        }

        return lines;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public static string ReadTextFromResources(string filename)
    {
        TextAsset asset = Resources.Load<TextAsset>(filename);
        return (asset == null) ? null : asset.text;
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
            MakeDirByFilename(dst);
            if (File.Exists(src))
            {
                File.Copy(src, dst, true);
                File.Delete(src);
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
    /// <param name="src"></param>
    /// <param name="dst"></param>
    public static void CopyFile(string src, string dst)
    {
        try
        {
            MakeDirByFilename(dst);
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
    public static void MakeDir(string path)
    {
        try
        {
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
    /// <param name="filename"></param>
    public static void MakeDirByFilename(string filename)
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
    public static void MoveDir(string from, string to)
    {
        try
        {
            if (Directory.Exists(from))
            {
                CopyDir(from, to);
                RemoveDir(from);
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
    public static void CopyDir(string from, string to, string exceptPostfix = null)
    {
        try
        {
            MakeDirByFilename(to);

            if (Directory.Exists(from))
            {
                string[] pathes = Directory.GetFiles(from, "*.*", SearchOption.AllDirectories);
                foreach (string path in pathes)
                {
                    string src = path;
                    string dst = path.Replace(from, to);

                    if (!IsDirectory(path))
                    {
                        if (!string.IsNullOrEmpty(exceptPostfix) && path.EndsWith(exceptPostfix))
                            continue;
                        
                        CopyFile(src, dst);
                    }
                    else
                    {
                        CopyDir(src, dst, exceptPostfix);
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
