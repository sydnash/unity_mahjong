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
    public static byte[] Encrypt(byte[] content)
    {
        string text = Convert.ToBase64String(content);
        return Encoding.UTF8.GetBytes(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Decrypt(byte[] content)
    {
        string text = Encoding.UTF8.GetString(content);
        return Convert.FromBase64String(text);
    }
}
