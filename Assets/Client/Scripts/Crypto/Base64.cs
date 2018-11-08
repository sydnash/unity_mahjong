using System;
using System.Security.Cryptography;
using System.Text;

public class Base64
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Encrypt(byte[] content, int offset, int length)
    {
        string text = Convert.ToBase64String(content, offset, length);
        return Encoding.UTF8.GetBytes(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Decrypt(byte[] content, int offset, int length)
    {
        string text = Encoding.UTF8.GetString(content, offset, length);
        return Convert.FromBase64String(text);
    }
}
