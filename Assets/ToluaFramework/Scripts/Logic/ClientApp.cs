using LuaInterface;
using UnityEngine;

public class ClientApp : LuaClient
{
    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    protected override LuaFileUtils InitLoader()
    {
        return new LuaResLoader();
    }

    /// <summary>
    /// 
    /// </summary>
    protected override void OnAwake()
    {
        DontDestroyOnLoad(gameObject);

        AssetPoolManager.instance.Setup();
        Screen.sleepTimeout = SleepTimeout.NeverSleep;//屏幕常亮

        base.OnAwake();
    }

    /// <summary>
    /// 
    /// </summary>
    protected void Update()
    {
        AssetPoolManager.instance.Update();
        AudioManager.instance.Update();
        LuaCallback.instance.Update();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="status"></param>
    protected void OnApplicationPause(bool status)
    {
        luaState.Call<bool>("onApplicationPause", status, false);
    }

    /// <summary>
    /// 
    /// </summary>
    protected void OnApplicationQuit()
    {
        LuaTask.DestroyAll();
        Destroy();
    }
}
