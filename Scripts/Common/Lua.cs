using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class Lua
{
    #region Data

    private static LuaState mLuaState = null;

    private LuaTable mLua = null;
    private Dictionary<string, LuaFunction> mFunctions = new Dictionary<string, LuaFunction>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="luaState"></param>
    public static void Setup(LuaState luaState)
    {
        mLuaState = luaState;
    }

    /// <summary>
    /// 
    /// </summary>
    public static void Release()
    {
        mLuaState = null;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="luaName"></param>
    /// <param name="component"></param>
    public void Require(string luaName)
    {
        if (mLuaState != null)
        {
            mLua = mLuaState.DoFile<LuaTable>(luaName);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="variableName"></param>
    /// <returns></returns>
    public bool GetBool(string variableName)
    {
        return (bool)mLua[variableName];
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="variableName"></param>
    /// <returns></returns>
    public int GetInt(string variableName)
    {
        return (int)mLua[variableName];
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="variableName"></param>
    /// <returns></returns>
    public float GetFloat(string variableName)
    {
        return (float)mLua[variableName];
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="variableName"></param>
    /// <returns></returns>
    public string GetString(string variableName)
    {
        return mLua[variableName] as string;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="variableName"></param>
    /// <returns></returns>
    public LuaTable GetTable(string variableName)
    {
        return mLua[variableName] as LuaTable;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="functionName"></param>
    public void CallMemberFunction(string functionName)
    {
        CallFunction<LuaTable>(functionName, mLua);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="functionName"></param>
    /// <param name="t"></param>
    public void CallMemberFunction<T>(string functionName, T t)
    {
        CallFunction<LuaTable, T>(functionName, mLua, t);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="functionName"></param>
    public void CallFunction(string functionName)
    {
        LuaFunction function = GetFunction(functionName);
        if (function != null)
        {
            function.Call();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="functionName"></param>
    /// <param name="t"></param>
    public void CallFunction<T>(string functionName, T t)
    {
        LuaFunction function = GetFunction(functionName);
        if (function != null)
        {
            function.Call(t);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T1"></typeparam>
    /// <typeparam name="T2"></typeparam>
    /// <param name="functionName"></param>
    /// <param name="t1"></param>
    /// <param name="t2"></param>
    public void CallFunction<T1, T2>(string functionName, T1 t1, T2 t2)
    {
        LuaFunction function = GetFunction(functionName);
        if (function != null)
        {
            function.Call(t1, t2);
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="functionName"></param>
    /// <returns></returns>
    private LuaFunction GetFunction(string functionName)
    {
        return GetFunction(mLua, functionName);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="table"></param>
    /// <param name="functionName"></param>
    /// <returns></returns>
    private LuaFunction GetFunction(LuaTable table, string functionName)
    {
        if (mFunctions.ContainsKey(functionName))
            return mFunctions[functionName];

        LuaFunction function = table.GetLuaFunction(functionName);
        if (function != null)
        {
            mFunctions.Add(functionName, function);
        }

        return function;
    }

    #endregion
}
