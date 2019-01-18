﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class TDGAAccountWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(TDGAAccount), typeof(System.Object));
		L.RegFunction("SetAccount", SetAccount);
		L.RegFunction("SetAccountName", SetAccountName);
		L.RegFunction("SetAccountType", SetAccountType);
		L.RegFunction("SetLevel", SetLevel);
		L.RegFunction("SetAge", SetAge);
		L.RegFunction("SetGender", SetGender);
		L.RegFunction("SetGameServer", SetGameServer);
		L.RegFunction("New", _CreateTDGAAccount);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateTDGAAccount(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				TDGAAccount obj = new TDGAAccount();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: TDGAAccount.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccount(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			TDGAAccount o = TDGAAccount.SetAccount(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccountName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.SetAccountName(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccountType(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			AccountType arg0 = (AccountType)ToLua.CheckObject(L, 2, typeof(AccountType));
			obj.SetAccountType(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLevel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.SetLevel(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAge(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.SetAge(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetGender(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			Gender arg0 = (Gender)ToLua.CheckObject(L, 2, typeof(Gender));
			obj.SetGender(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetGameServer(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			TDGAAccount obj = (TDGAAccount)ToLua.CheckObject<TDGAAccount>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.SetGameServer(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

