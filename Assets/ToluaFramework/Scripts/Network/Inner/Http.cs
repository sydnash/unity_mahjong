using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public class Http
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    public class Token
    {
        public bool working = false;
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private byte[] mDownloadBuffer = new byte[1024 * 100];

    /// <summary>
    /// 
    /// </summary>
    private Token mToken = new Token();

    /// <summary>
    /// 
    /// </summary>
    private const string HTTPS = "https";

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public Token token
    {
        get { return mToken; }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <param name="method"></param>
    /// <param name="timeout"></param>
    /// <param name="callback"></param>
    public void Request(string url, string method, int timeout, Action<string, byte[], int, bool> callback)
    {
        HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;

        if (url.StartsWith(HTTPS, StringComparison.OrdinalIgnoreCase))
        {
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            request.ProtocolVersion = HttpVersion.Version10;
        }

        try
        {
            request.Method = method;
            request.Timeout = timeout;
            request.ReadWriteTimeout = timeout;

            HttpWebResponse response = request.GetResponse() as HttpWebResponse;

            if (response != null && response.StatusCode == HttpStatusCode.OK)
            {
                int contentLength = (int)response.ContentLength;
                System.IO.Stream responseStream = response.GetResponseStream();

                mToken.working = true;
                int downloadLength = 0;

                while (mToken.working && downloadLength < contentLength)
                {
                    int size = Math.Min(mDownloadBuffer.Length, contentLength - downloadLength);
                    size = responseStream.Read(mDownloadBuffer, 0, size);

                    if (size > 0)
                    {
                        downloadLength += size;

                        if (callback != null)
                        {
                            byte[] content = new byte[size];
                            Array.Copy(mDownloadBuffer, content, size);

                            callback(url, content, contentLength, downloadLength == contentLength);
                        }
                    }
                }

                responseStream.Close();
            }
            else
            {
                if (response != null)
                {
                    Logger.LogError("http failed: " + response.StatusDescription);
                }

                if (callback != null)
                {
                    callback(url, null, 0, false);
                }
            }
        }
        catch (Exception ex)
        {
            Logger.LogError("http exception: " + ex.Message + "\n" + ex.StackTrace);

            if (callback != null)
            {
                callback(url, null, 0, false);
            }
        }
        finally
        {
            request.Abort();
            mToken.working = false;
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="certificate"></param>
    /// <param name="chain"></param>
    /// <param name="errors"></param>
    /// <returns></returns>
    private static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        return true; //总是接受  
    }
    #endregion
}

