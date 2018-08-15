using System.Text;
using System.Security.Cryptography;
using System.IO;

class AES
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private static readonly byte[] PASSWORD = { 54, 56, 52, 55, 53, 70, 55, 49, 66, 57, 69, 52, 52, 55, 65, 67, 56, 68, 50, 69, 57, 57, 54, 50, 50, 52, 54, 68, 68, 50, 57, 53 };//"68475F71B9E447AC8D2E9962246DD295";
    
    /// <summary>
    /// 
    /// </summary>
    private static readonly byte[] IV = { 0x00, 0x23, 0x4b, 0x89, 0xaa, 0x96, 0xfe, 0xcd, 0xaf, 0x80, 0xfb, 0xf1, 0x78, 0xa2, 0x56, 0x21 };

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Encrypt(string content)
    {
        using (Aes aes = Aes.Create())
        {
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.PKCS7;
            aes.KeySize = 256;
            aes.BlockSize = 128;

            var encryptor = aes.CreateEncryptor(PASSWORD, IV);

            using (var ms = new MemoryStream())
            {
                using (var cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
                {
                    using (var sw = new StreamWriter(cs))
                    {
                        sw.Write(content);
                    }

                    return ms.ToArray();
                }
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static byte[] Encrypt(byte[] content)
    {
        string text = Encoding.UTF8.GetString(content);
        return Encrypt(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static string Decrypt(byte[] content)
    {
        using (Aes aes = Aes.Create())
        {
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.PKCS7;
            aes.KeySize = 256;
            aes.BlockSize = 128;

            var decryptor = aes.CreateDecryptor(PASSWORD, IV);

            using (var ms = new MemoryStream(content))
            {
                using (var cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                {
                    using (var sr = new StreamReader(cs))
                    {
                        return sr.ReadToEnd();
                    }
                }
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static string Decrypt(string content)
    {
        byte[] bytes = Encoding.UTF8.GetBytes(content);
        return Decrypt(bytes);
    }

    #endregion
}
