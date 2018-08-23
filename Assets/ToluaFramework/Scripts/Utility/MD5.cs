using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

public static class MD5
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private const string HASH_EXTRA_STR = "68475F71B9E447AC8D2E9962246DD295";

    /// <summary>
    /// 
    /// </summary>
    private static readonly byte[] CRYPTOGRAM_KEY = { 169, 66, 129, 191, 81, 74, 97, 160 };

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static string GetHash(string content)
    {
        using (MD5CryptoServiceProvider crypto = new MD5CryptoServiceProvider())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(content + HASH_EXTRA_STR);
            byte[] hash = crypto.ComputeHash(bytes);

            return ConvertBytesToHexString(hash);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public static string GetHashFromFile(string filename)
    {
        try
        {
            if (File.Exists(filename))
            {
                using (MD5CryptoServiceProvider crypto = new MD5CryptoServiceProvider())
                {
                    FileStream file = new FileStream(filename, FileMode.Open);
                    byte[] bytes = crypto.ComputeHash(file);
                    file.Close();

                    return ConvertBytesToHexString(bytes);
                }
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }

        return null;
    }

    //private static byte[] GenerateKey()
    //{
    //    DESCryptoServiceProvider crypto = DESCryptoServiceProvider.Create() as DESCryptoServiceProvider;
    //    return crypto.Key;
    //}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Encrypt(byte[] content)
    {
        try
        {
            using (DESCryptoServiceProvider crypto = new DESCryptoServiceProvider())
            {
                crypto.Key = CRYPTOGRAM_KEY;
                crypto.IV = CRYPTOGRAM_KEY;

                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, crypto.CreateEncryptor(), CryptoStreamMode.Write);
                cs.Write(content, 0, content.Length);
                cs.FlushFinalBlock();
                cs.Close();

                return ms.ToArray();
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }

        return null;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Decrypt(byte[] content)
    {
        try
        {
            using (DESCryptoServiceProvider crypto = new DESCryptoServiceProvider())
            {
                crypto.Key = CRYPTOGRAM_KEY;
                crypto.IV = CRYPTOGRAM_KEY;

                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, crypto.CreateDecryptor(), CryptoStreamMode.Write);
                cs.Write(content, 0, content.Length);
                cs.FlushFinalBlock();
                cs.Close();

                return ms.ToArray();
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex.Message);
        }

        return null;
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bytes"></param>
    /// <returns></returns>
    private static string ConvertBytesToHexString(byte[] bytes)
    {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bytes.Length; i++)
        {
            sb.Append(bytes[i].ToString("x2"));
        }

        return sb.ToString();
    }

    #endregion
}
