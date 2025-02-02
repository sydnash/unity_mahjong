﻿using UnityEngine;

public static class LuaConst
{
    public static string luaDir = Application.dataPath + "/ToluaFramework/Lua"; //lua逻辑代码目录
    public static string toluaDir = Application.dataPath + "/ToluaFramework/ToLua/Lua"; //tolua lua文件目录
    public static string frameworkDir = Application.dataPath + "/ToluaFramework/Scripts/Framework"; //tolua lua文件目录
    public static string clientLuaDir = Application.dataPath + "/Client/Lua";

#if UNITY_STANDALONE
    public const string osDir = "Win";
#elif UNITY_ANDROID
    public const string osDir = "Android";
#elif UNITY_IPHONE
    public const string osDir = "iOS";
#else
    public const string osDir = "";
#endif

    public const string patchDir = "Patches";

    public static string luaResDir = string.Format("{0}/{1}/Lua", Application.persistentDataPath, patchDir); //手机运行时lua文件下载目录    

#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN    
    public static string zbsDir = "D:/ZeroBraneStudio/lualibs/mobdebug"; //ZeroBraneStudio目录       
#elif UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX
	public static string zbsDir = "/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio/lualibs/mobdebug";
#else
    public static string zbsDir = luaResDir + "/mobdebug/";
#endif    

    public static bool openLuaSocket = true;    //是否打开Lua Socket库
    public static bool openLuaDebugger = false; //是否连接lua调试器
}