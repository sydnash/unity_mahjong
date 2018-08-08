﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class SceneLoaderWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(SceneLoader), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Load", Load);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Load(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			SceneLoader obj = (SceneLoader)ToLua.CheckObject<SceneLoader>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			System.Action<bool,float> arg1 = (System.Action<bool,float>)ToLua.CheckDelegate<System.Action<bool,float>>(L, 3);
			obj.Load(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_instance(IntPtr L)
	{
		try
		{
			ToLua.Push(L, SceneLoader.instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

