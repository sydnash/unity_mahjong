﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class PatchManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(PatchManager), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Check", Check);
		L.RegFunction("Download", Download);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("downloadBytes", get_downloadBytes, null);
		L.RegVar("downloadCount", get_downloadCount, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Check(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			PatchManager obj = (PatchManager)ToLua.CheckObject<PatchManager>(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			object arg1 = ToLua.ToVarObject(L, 3);
			obj.Check(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Download(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			PatchManager obj = (PatchManager)ToLua.CheckObject<PatchManager>(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			object arg1 = ToLua.ToVarObject(L, 3);
			obj.Download(arg0, arg1);
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
	static int get_downloadBytes(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PatchManager obj = (PatchManager)o;
			int ret = obj.downloadBytes;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index downloadBytes on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_downloadCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PatchManager obj = (PatchManager)o;
			int ret = obj.downloadCount;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index downloadCount on a nil value");
		}
	}
}

