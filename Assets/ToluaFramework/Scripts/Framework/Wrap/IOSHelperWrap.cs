﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class IOSHelperWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(IOSHelper), typeof(System.Object));
		L.RegFunction("RegisterLoginWXCallback", RegisterLoginWXCallback);
		L.RegFunction("RegisterShareWXCallback", RegisterShareWXCallback);
		L.RegFunction("LoginWX", LoginWX);
		L.RegFunction("ShareTextWX", ShareTextWX);
		L.RegFunction("ShareUrlWX", ShareUrlWX);
		L.RegFunction("ShareImageWX", ShareImageWX);
		L.RegFunction("OnLoginWxHandler", OnLoginWxHandler);
		L.RegFunction("OnWxShareHandler", OnWxShareHandler);
		L.RegFunction("RegisterInviteSGCallback", RegisterInviteSGCallback);
		L.RegFunction("SetLogined", SetLogined);
		L.RegFunction("ShareTextSG", ShareTextSG);
		L.RegFunction("ShareInvitationSG", ShareInvitationSG);
		L.RegFunction("ShareImageSG", ShareImageSG);
		L.RegFunction("GetParamsSG", GetParamsSG);
		L.RegFunction("ClearSGInviteParam", ClearSGInviteParam);
		L.RegFunction("OnInviteSgHandler", OnInviteSgHandler);
		L.RegFunction("GetDeviceId", GetDeviceId);
		L.RegFunction("OpenExplore", OpenExplore);
		L.RegFunction("SetToClipboard", SetToClipboard);
		L.RegFunction("GetFromClipboard", GetFromClipboard);
		L.RegFunction("GetDistance", GetDistance);
		L.RegFunction("StartLocationOnce", StartLocationOnce);
		L.RegFunction("StartLocationUpdate", StartLocationUpdate);
		L.RegFunction("StopLocationUpdate", StopLocationUpdate);
		L.RegFunction("SetLocationUpdateHandler", SetLocationUpdateHandler);
		L.RegFunction("New", _CreateIOSHelper);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("instance", get_instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateIOSHelper(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				IOSHelper obj = new IOSHelper();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: IOSHelper.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegisterLoginWXCallback(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			System.Action<string> arg0 = (System.Action<string>)ToLua.CheckDelegate<System.Action<string>>(L, 2);
			obj.RegisterLoginWXCallback(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegisterShareWXCallback(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			System.Action<string> arg0 = (System.Action<string>)ToLua.CheckDelegate<System.Action<string>>(L, 2);
			obj.RegisterShareWXCallback(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoginWX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			obj.LoginWX();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareTextWX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
			obj.ShareTextWX(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareUrlWX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 6);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			string arg2 = ToLua.CheckString(L, 4);
			UnityEngine.Texture2D arg3 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 5, typeof(UnityEngine.Texture2D));
			bool arg4 = LuaDLL.luaL_checkboolean(L, 6);
			obj.ShareUrlWX(arg0, arg1, arg2, arg3, arg4);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareImageWX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			UnityEngine.Texture2D arg0 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 2, typeof(UnityEngine.Texture2D));
			UnityEngine.Texture2D arg1 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 3, typeof(UnityEngine.Texture2D));
			bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
			obj.ShareImageWX(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnLoginWxHandler(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.OnLoginWxHandler(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWxShareHandler(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.OnWxShareHandler(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegisterInviteSGCallback(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			System.Action<string> arg0 = (System.Action<string>)ToLua.CheckDelegate<System.Action<string>>(L, 2);
			obj.RegisterInviteSGCallback(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLogined(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.SetLogined(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareTextSG(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.ShareTextSG(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareInvitationSG(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 7);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			UnityEngine.Texture2D arg2 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 4, typeof(UnityEngine.Texture2D));
			string arg3 = ToLua.CheckString(L, 5);
			string arg4 = ToLua.CheckString(L, 6);
			string arg5 = ToLua.CheckString(L, 7);
			obj.ShareInvitationSG(arg0, arg1, arg2, arg3, arg4, arg5);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareImageSG(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			UnityEngine.Texture2D arg0 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 2, typeof(UnityEngine.Texture2D));
			obj.ShareImageSG(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetParamsSG(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string o = obj.GetParamsSG();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearSGInviteParam(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			obj.ClearSGInviteParam();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInviteSgHandler(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.OnInviteSgHandler(arg0);
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
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string o = obj.GetDeviceId();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OpenExplore(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.OpenExplore(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetToClipboard(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.SetToClipboard(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFromClipboard(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			string o = obj.GetFromClipboard();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDistance(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 4);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 5);
			float o = obj.GetDistance(arg0, arg1, arg2, arg3);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartLocationOnce(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			obj.StartLocationOnce();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartLocationUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			obj.StartLocationUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopLocationUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			obj.StopLocationUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLocationUpdateHandler(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			IOSHelper obj = (IOSHelper)ToLua.CheckObject<IOSHelper>(L, 1);
			System.Action<string> arg0 = (System.Action<string>)ToLua.CheckDelegate<System.Action<string>>(L, 2);
			obj.SetLocationUpdateHandler(arg0);
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
			ToLua.PushObject(L, IOSHelper.instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

