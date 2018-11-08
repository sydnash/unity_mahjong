using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public static class Hash
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private const string HASH_EXTRA_STR = "68475F71B9E447AC8D2E9962246DD295";

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
