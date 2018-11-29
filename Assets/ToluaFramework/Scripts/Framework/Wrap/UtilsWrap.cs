﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UtilsWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Utils), typeof(System.Object));
		L.RegFunction("StringToBytes", StringToBytes);
		L.RegFunction("BytesToString", BytesToString);
		L.RegFunction("Int32ToBytes", Int32ToBytes);
		L.RegFunction("BytesToInt32", BytesToInt32);
		L.RegFunction("NewByteArray", NewByteArray);
		L.RegFunction("NewEmptyByteArray", NewEmptyByteArray);
		L.RegFunction("ConcatBytes", ConcatBytes);
		L.RegFunction("SubBytes", SubBytes);
		L.RegFunction("TrimBytes", TrimBytes);
		L.RegFunction("SizeTextureBilinear", SizeTextureBilinear);
		L.RegFunction("CaptureScreenshot", CaptureScreenshot);
		L.RegFunction("New", _CreateUtils);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUtils(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				Utils obj = new Utils();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Utils.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StringToBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			byte[] o = Utils.StringToBytes(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BytesToString(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 3);
			string o = Utils.BytesToString(arg0, arg1, arg2);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Int32ToBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			byte[] o = Utils.Int32ToBytes(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BytesToInt32(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
				int o = Utils.BytesToInt32(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 2)
			{
				byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
				int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
				int o = Utils.BytesToInt32(arg0, arg1);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Utils.BytesToInt32");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NewByteArray(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 3);
			byte[] o = Utils.NewByteArray(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NewEmptyByteArray(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			byte[] o = Utils.NewEmptyByteArray(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ConcatBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			byte[] arg2 = ToLua.CheckByteBuffer(L, 3);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 4);
			byte[] o = Utils.ConcatBytes(arg0, arg1, arg2, arg3);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SubBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 3);
			byte[] o = Utils.SubBytes(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TrimBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			byte[] o = Utils.TrimBytes(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SizeTextureBilinear(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Texture2D arg0 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 1, typeof(UnityEngine.Texture2D));
			UnityEngine.Vector2 arg1 = ToLua.ToVector2(L, 2);
			UnityEngine.Texture2D o = Utils.SizeTextureBilinear(arg0, arg1);
			ToLua.PushSealed(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CaptureScreenshot(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.Camera arg0 = (UnityEngine.Camera)ToLua.CheckObject(L, 1, typeof(UnityEngine.Camera));
			UnityEngine.Texture2D o = Utils.CaptureScreenshot(arg0);
			ToLua.PushSealed(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

