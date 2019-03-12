using System.Collections;
using System.Collections.Generic;

public class CSV
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, string> mDic = new Dictionary<string, string>();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static CSV mInstance = new CSV();

    /// <summary>
    /// 
    /// </summary>
    public static CSV instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>
    public string Query(string key)
    {
        if (mDic.ContainsKey(key))
        {
            return mDic[key];
        }

        return null;
    }

    #endregion

    #region

    /// <summary>
    /// 
    /// </summary>
    private CSV()
    {
        mDic.Add("http", "1");
        mDic.Add("stingyscrollview", "1");
    }

    #endregion
}
