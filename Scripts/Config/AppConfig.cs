using UnityEngine;

public class AppConfig
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Lua mLua = new Lua();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static AppConfig mInstance = new AppConfig();

    /// <summary>
    /// 
    /// </summary>
    public static AppConfig instance
    {
        get 
        {
            return mInstance; 
        }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public bool debug
    {
        get { return mLua.GetBool("debug"); }
    }

    /// <summary>
    /// 
    /// </summary>
    public string patchURL
    {
        get { return mLua.GetString("patchURL"); }
    }

    /// <summary>
    /// 
    /// </summary>
    public string gameURL
    {
        get { return mLua.GetString("gameURL"); }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private AppConfig()
    {
        mLua.Require("config/appConfig");
    }

    #endregion
}
