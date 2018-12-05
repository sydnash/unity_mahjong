﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class WINHelperWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(WINHelper), typeof(System.Object));
		L.RegFunction("ChangeWindowTitle", ChangeWindowTitle);
		L.RegFunction("New", _CreateWINHelper);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateWINHelper(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				WINHelper obj = new WINHelper();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: WINHelper.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeWindowTitle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			WINHelper obj = (WINHelper)ToLua.CheckObject<WINHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.ChangeWindowTitle(arg0);
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
			ToLua.PushObject(L, WINHelper.instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

