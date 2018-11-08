﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UtilsWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Utils), typeof(System.Object));
		L.RegFunction("SizeTextureBilinear", SizeTextureBilinear);
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
}

