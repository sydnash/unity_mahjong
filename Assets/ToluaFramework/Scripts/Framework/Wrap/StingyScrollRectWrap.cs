﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class StingyScrollRectWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(StingyScrollRect), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Init", Init);
		L.RegFunction("Add", Add);
		L.RegFunction("Remove", Remove);
		L.RegFunction("Refresh", Refresh);
		L.RegFunction("Reset", Reset);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("items", get_items, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			StingyScrollRect obj = (StingyScrollRect)ToLua.CheckObject<StingyScrollRect>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			LuaFunction arg1 = ToLua.CheckLuaFunction(L, 3);
			LuaFunction arg2 = ToLua.CheckLuaFunction(L, 4);
			obj.Init(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Add(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			StingyScrollRect obj = (StingyScrollRect)ToLua.CheckObject<StingyScrollRect>(L, 1);
			obj.Add();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Remove(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			StingyScrollRect obj = (StingyScrollRect)ToLua.CheckObject<StingyScrollRect>(L, 1);
			obj.Remove();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Refresh(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			StingyScrollRect obj = (StingyScrollRect)ToLua.CheckObject<StingyScrollRect>(L, 1);
			obj.Refresh();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Reset(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			StingyScrollRect obj = (StingyScrollRect)ToLua.CheckObject<StingyScrollRect>(L, 1);
			obj.Reset();
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
	static int get_items(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			StingyScrollRect obj = (StingyScrollRect)o;
			System.Collections.Generic.List<LuaInterface.LuaTable> ret = obj.items;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index items on a nil value");
		}
	}
}

