using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class CustomMapComponent : MonoBehaviour 
{
     public Dictionary<string, string> mDic = new Dictionary<string, string>();

    public void Add(string key, string value)
    {
        mDic[key] = value;
    }

    public string Get(string key) 
    {
        if (mDic.ContainsKey(key)) {
            return mDic[key];
        }
        return "";
    }

    public bool ContainsKey(string key)
    {
        return mDic.ContainsKey(key);
    }
}
