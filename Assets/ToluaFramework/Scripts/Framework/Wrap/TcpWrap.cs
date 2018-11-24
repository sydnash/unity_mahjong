﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class TcpWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Tcp), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Connect", Connect);
		L.RegFunction("Disconnect", Disconnect);
		L.RegFunction("Send", Send);
		L.RegFunction("RegisterReceivedCallback", RegisterReceivedCallback);
		L.RegFunction("UnregisterReceivedCallback", UnregisterReceivedCallback);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Connect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			Tcp obj = (Tcp)ToLua.CheckObject<Tcp>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			System.Action<bool> arg3 = (System.Action<bool>)ToLua.CheckDelegate<System.Action<bool>>(L, 5);
			obj.Connect(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Disconnect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Tcp obj = (Tcp)ToLua.CheckObject<Tcp>(L, 1);
			obj.Disconnect();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Send(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			Tcp obj = (Tcp)ToLua.CheckObject<Tcp>(L, 1);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			System.Action arg2 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
			obj.Send(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegisterReceivedCallback(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Tcp obj = (Tcp)ToLua.CheckObject<Tcp>(L, 1);
			System.Action<byte[],int> arg0 = (System.Action<byte[],int>)ToLua.CheckDelegate<System.Action<byte[],int>>(L, 2);
			obj.RegisterReceivedCallback(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnregisterReceivedCallback(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Tcp obj = (Tcp)ToLua.CheckObject<Tcp>(L, 1);
			obj.UnregisterReceivedCallback();
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
			ToLua.Push(L, Tcp.instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

