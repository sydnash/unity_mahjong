using System;
using System.Collections.Generic;
using System.Text;

public class DataConvert
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static byte[] StringToBytes(string text)
    {
        return Encoding.UTF8.GetBytes(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bytes"></param>
    /// <returns></returns>
    public static string BytesToString(byte[] bytes)
    {
        return Encoding.UTF8.GetString(bytes);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static byte[] Int32ToBytes(int value)
    {
        return BitConverter.GetBytes(value);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bytes"></param>
    /// <param name="startIndex"></param>
    /// <returns></returns>
    public static int BytesToInt32(byte[] bytes, int startIndex = 0)
    {
        return BitConverter.ToInt32(bytes, startIndex);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    public static byte[] ConcatBytes(byte[] a, byte[] b)
    {
        byte[] c = new byte[a.Length + b.Length];

        Array.Copy(a, 0, c, 0, a.Length);
        Array.Copy(b, 0, c, a.Length, b.Length);

        return c;
    }
}
