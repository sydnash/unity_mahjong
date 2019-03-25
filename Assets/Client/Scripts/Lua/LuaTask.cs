using System;
using System.Threading;
using System.Collections.Generic;
using LuaInterface;

public class LuaTask
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    protected class Method
    {
        /// <summary>
        /// 
        /// </summary>
        public string method = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        public string args = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        public int token = 0;
    }

    #endregion

    #region Data
    
    /// <summary>
    /// 
    /// </summary>
    protected IntPtr L = IntPtr.Zero;

    /// <summary>
    /// 
    /// </summary>
    protected Thread thread = null;

    /// <summary>
    /// 
    /// </summary>
    protected bool working = false;

    /// <summary>
    /// 
    /// </summary>
    protected Queue<Method> methods = new Queue<Method>();

    /// <summary>
    /// 
    /// </summary>
    protected static Dictionary<IntPtr, LuaTask> tasks = new Dictionary<IntPtr, LuaTask>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public LuaTask()
    {
        L = LuaDLL.luaL_newstate();
        LuaException.Init(L);

        LuaDLL.tolua_openlibs(L);
        OpenCJsonLib();
        LuaDLL.lua_settop(L, 0);

        tasks.Add(L, this);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public bool DoFile(string filename)
    {
        byte[] buffer = LuaFileUtils.Instance.ReadFile(filename);
        if (LuaDLL.luaL_loadbuffer(L, buffer, buffer.Length, ChunkName(filename)) == 0)
        {
            if (LuaDLL.lua_pcall(L, 0, LuaDLL.LUA_MULTRET, 0) == 0)
            {
                working = true;

                thread = new Thread(OnThread);
                thread.Start();

                return true;
            }
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="name"></param>
    /// <param name="args"></param>
    /// <returns></returns>
    public void Call(string method, string args, LuaFunction callback)
    {
        int token = LuaCallback.instance.Add(callback);

        lock (methods)
        {
            Method m = new Method();
            m.method = method;
            m.args = args;
            m.token = token;

            methods.Enqueue(m);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Destroy()
    {
        tasks.Remove(L);
        Reset();
    }

    /// <summary>
    /// 
    /// </summary>
    public static void DestroyAll()
    {
        foreach(KeyValuePair<IntPtr, LuaTask> kvp in tasks)
        {
            kvp.Value.Reset();
        }
        tasks.Clear();
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    protected void OpenCJsonLib()
    {
        LuaDLL.lua_getfield(L, LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");

        LuaDLL.luaopen_cjson(L);
        LuaDLL.lua_setfield(L, -2, "cjson");

        LuaDLL.luaopen_cjson_safe(L);
        LuaDLL.lua_setfield(L, -2, "cjson.safe");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    protected string ChunkName(string name)
    {
        if (LuaConst.openLuaDebugger)
        {
            name = LuaFileUtils.Instance.FindFile(name);
        }

        return "@" + name;
    }

    /// <summary>
    /// 
    /// </summary>
    protected void OnThread()
    {
        try
        {
            while (working)
            {
                Method m = null;

                lock (methods)
                {
                    if (methods.Count > 0)
                    {
                        m = methods.Dequeue();
                    }
                }

                if (m != null)
                {
                    string ret = InvokeFunction(m.method, m.args);
                    LuaCallback.instance.Invoke(m.token, ret);
                }

                Thread.Sleep(10);
            }
        }
        catch (Exception ex)
        {
#if UNITY_EDITOR
            UnityEngine.Debug.LogError(ex.Message);
#endif
        }
    }

    protected string InvokeFunction(string name, string args)
    {
        string ret = string.Empty;

        int oldTop = LuaDLL.lua_gettop(L);
        LuaDLL.lua_getglobal(L, name);
        if (LuaDLL.lua_isfunction(L, -1))
        {
            LuaDLL.lua_pushstring(L, args);
            LuaDLL.lua_pcall(L, 1, 1, -1);
            int curTop = LuaDLL.lua_gettop(L);
            ret = LuaDLL.lua_tostring(L, curTop);
        }
        LuaDLL.lua_settop(L, oldTop);

        return ret;
    }

    /// <summary>
    /// 
    /// </summary>
    protected void Reset()
    {
        try
        {
            working = false;

            if (thread != null)
            {
                thread.Abort();
            }

            if (L != IntPtr.Zero)
            {
                LuaDLL.lua_close(L);
                L = IntPtr.Zero;
            }
        }
        catch
        {

        }
    }

    #endregion
}