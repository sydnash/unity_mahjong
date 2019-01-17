﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class TalkingDataGAWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(TalkingDataGA), typeof(System.Object));
		L.RegFunction("AttachCurrentThread", AttachCurrentThread);
		L.RegFunction("DetachCurrentThread", DetachCurrentThread);
		L.RegFunction("GetDeviceId", GetDeviceId);
		L.RegFunction("OnStart", OnStart);
		L.RegFunction("OnEnd", OnEnd);
		L.RegFunction("OnKill", OnKill);
		L.RegFunction("OnEvent", OnEvent);
		L.RegFunction("SetVerboseLogDisabled", SetVerboseLogDisabled);
		L.RegFunction("New", _CreateTalkingDataGA);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateTalkingDataGA(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				TalkingDataGA obj = new TalkingDataGA();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: TalkingDataGA.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AttachCurrentThread(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			TalkingDataGA.AttachCurrentThread();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DetachCurrentThread(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			TalkingDataGA.DetachCurrentThread();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDeviceId(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = TalkingDataGA.GetDeviceId();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnStart(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			string arg0 = ToLua.CheckString(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			TalkingDataGA.OnStart(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnEnd(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			TalkingDataGA.OnEnd();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnKill(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			TalkingDataGA.OnKill();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnEvent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			string arg0 = ToLua.CheckString(L, 1);
			System.Collections.Generic.Dictionary<string,object> arg1 = (System.Collections.Generic.Dictionary<string,object>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.Dictionary<string,object>));
			TalkingDataGA.OnEvent(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetVerboseLogDisabled(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			TalkingDataGA.SetVerboseLogDisabled();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

