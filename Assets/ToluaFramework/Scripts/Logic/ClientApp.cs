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
        base.OnAwake();

        //string t = "abcdefghijklmn1234567890";
        //byte[] b = Base64.Encrypt(System.Text.Encoding.UTF8.GetBytes(t));
        //Debug.Log(System.Text.Encoding.UTF8.GetString(b));
    }

    /// <summary>
    /// 
    /// </summary>
    protected void Update()
    {
        AssetPoolManager.instance.Update();
        AudioManager.instance.Update();
    }
}
