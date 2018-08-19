using System;
using System.Collections.Generic;
using System.Text;

public class ByteUtils
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
    public static int BytesToInt32(byte[] bytes, int offset = 0)
    {
        return BitConverter.ToInt32(bytes, offset);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="startIndex"></param>
    /// <param name="length"></param>
    /// <returns></returns>
    public static byte[] NewByteArray(byte[] s, int offset, int length)
    {
        if (s == null || length == 0) return null;

        byte[] d = new byte[length];
        Array.Copy(s, offset, d, 0, length);

        return d;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    public static byte[] ConcatBytes(byte[] a, int asize, byte[] b, int bsize)
    {
        if (a == null && b == null)
            return null;

        byte[] c = new byte[asize + bsize];

        if (a != null)
        {
            Array.Copy(a, 0, c, 0, asize);
        }

        if (b != null)
        {
            Array.Copy(b, 0, c, asize, bsize);
        }

        return c;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="startIndex"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static byte[] SubBytes(byte[] s, int start, int length)
    {
        if (s == null || length <= 0) return null;

        byte[] d = new byte[length];
        Array.Copy(s, start, d, 0, length);
        
        return d;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="length"></param>
    /// <returns></returns>
    public static byte[] TrimBytes(byte[] s, int length)
    {
        int size = s.Length - length;
        if (s == null || size <= 0) return null;

        byte[] d = new byte[size];
        Array.Copy(s, length, d, 0, size);

        return d;
    }
}
