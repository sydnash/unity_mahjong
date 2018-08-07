using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

public static class MD5 
{
    private static readonly byte[] CRYPTOGRAM_KEY = { 169, 66, 129, 191, 81, 74, 97, 160 };

    public static string GetHashFromFile(string filename)
    {
        try
        {
            if (File.Exists(filename))
            {
                FileStream file = new FileStream(filename, FileMode.Open);
                MD5CryptoServiceProvider crypto = new MD5CryptoServiceProvider();
                byte[] bytes = crypto.ComputeHash(file);
                file.Close();

                return ConvertBytesToHexString(bytes);
            }
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }

        return null;
    }

    //private static byte[] GenerateKey()
    //{
    //    DESCryptoServiceProvider crypto = DESCryptoServiceProvider.Create() as DESCryptoServiceProvider;
    //    return crypto.Key;
    //}

    public static byte[] Encrypt(byte[] content)
    {
        try
        {
            DESCryptoServiceProvider crypto = new DESCryptoServiceProvider();
            crypto.Key = CRYPTOGRAM_KEY;
            crypto.IV  = CRYPTOGRAM_KEY;

            MemoryStream ms = new MemoryStream();
            CryptoStream cs = new CryptoStream(ms, crypto.CreateEncryptor(), CryptoStreamMode.Write);
            cs.Write(content, 0, content.Length);
            cs.FlushFinalBlock();
            cs.Close();

            return ms.ToArray();
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }

        return null;
    }

    public static byte[] Decrypt(byte[] content)
    {
        try
        {
            DESCryptoServiceProvider crypto = new DESCryptoServiceProvider();
            crypto.Key = CRYPTOGRAM_KEY;
            crypto.IV  = CRYPTOGRAM_KEY;

            MemoryStream ms = new MemoryStream();
            CryptoStream cs = new CryptoStream(ms, crypto.CreateDecryptor(), CryptoStreamMode.Write);
            cs.Write(content, 0, content.Length);
            cs.FlushFinalBlock();
            cs.Close();

            return ms.ToArray();
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }

        return null;
    }

    private static string ConvertBytesToHexString(byte[] bytes)
    {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bytes.Length; i++)
        {
            sb.Append(bytes[i].ToString("x2"));
        }

        return sb.ToString();
    }

    //private static byte[] ConvertHexStringToBytes(string content)
    //{
    //    content = content.Replace(" ", "");

    //    if ((content.Length % 2) != 0)
    //    {
    //        content += " ";
    //    }

    //    byte[] bytes = new byte[content.Length / 2];
    //    for (int i = 0; i < bytes.Length; i++)
    //    {
    //        bytes[i] = System.Convert.ToByte(content.Substring(i * 2, 2), 16);
    //    }

    //    return bytes;
    //}
}
