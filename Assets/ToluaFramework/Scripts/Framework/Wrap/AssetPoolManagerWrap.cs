﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class AssetPoolManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(AssetPoolManager), typeof(System.Object));
		L.RegFunction("Setup", Setup);
		L.RegFunction("AddPool", AddPool);
		L.RegFunction("Alloc", Alloc);
		L.RegFunction("Dealloc", Dealloc);
		L.RegFunction("Update", Update);
		L.RegFunction("UnloadUnused", UnloadUnused);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Setup(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			obj.Setup();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddPool(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
			AssetPool o = obj.AddPool(arg0, arg1, arg2);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Alloc(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			string arg2 = ToLua.CheckString(L, 4);
			UnityEngine.Object o = obj.Alloc(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Dealloc(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.CheckObject<UnityEngine.Object>(L, 3);
			bool o = obj.Dealloc(arg0, arg1);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			obj.Update();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnloadUnused(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			AssetPoolManager obj = (AssetPoolManager)ToLua.CheckObject<AssetPoolManager>(L, 1);
			obj.UnloadUnused();
			return 0;
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
			ToLua.PushObject(L, AssetPoolManager.instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

