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
        ToLua.AddLuaLoader(L);

        LuaDLL.tolua_pushcfunction(L, Print);
        LuaDLL.lua_setglobal(L, "print");

        tasks.Add(L, this);
    }
    
    
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int Print(IntPtr L)
        {
#if UNITY_EDITOR
            try
            {
                int n = LuaDLL.lua_gettop(L);   
                             
                using (CString.Block())
                {
                    CString sb = CString.Alloc(256);
#if UNITY_EDITOR
                    int line = LuaDLL.tolua_where(L, 1);
                    string filename = LuaDLL.lua_tostring(L, -1);
                    LuaDLL.lua_settop(L, n);
                    int offset = filename[0] == '@' ? 1 : 0;

                    if (!filename.Contains("."))
                    {
                        sb.Append('[').Append(filename, offset, filename.Length - offset).Append(".lua:").Append(line).Append("]:");
                    }
                    else
                    {
                        sb.Append('[').Append(filename, offset, filename.Length - offset).Append(':').Append(line).Append("]:");
                    }
#endif

                    for (int i = 1; i <= n; i++)
                    {
                        if (i > 1) sb.Append("    ");

                        if (LuaDLL.lua_isstring(L, i) == 1)
                        {
                            sb.Append(LuaDLL.lua_tostring(L, i));
                        }
                        else if (LuaDLL.lua_isnil(L, i))
                        {
                            sb.Append("nil");
                        }
                        else if (LuaDLL.lua_isboolean(L, i))
                        {
                            sb.Append(LuaDLL.lua_toboolean(L, i) ? "true" : "false");
                        }
                        else
                        {
                            IntPtr p = LuaDLL.lua_topointer(L, i);

                            if (p == IntPtr.Zero)
                            {
                                sb.Append("nil");
                            }
                            else
                            {
                                sb.Append(LuaDLL.luaL_typename(L, i)).Append(":0x").Append(p.ToString("X"));
                            }
                        }
                    }

                    UnityEngine.Debug.Log(sb.ToString());
                }
                return 0;
            }
            catch (Exception e)
            {
                return LuaDLL.toluaL_exception(L, e);
            }
#endif
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
            } else {
                string errMsg = LuaDLL.lua_tostring(L, -1);
                UnityEngine.Debug.Log(string.Format("call file {0} failed. {1}", filename, errMsg));
            }
        } else {
            UnityEngine.Debug.Log(string.Format("load file {0} failed.", filename));
        }

        UnityEngine.Debug.Log(string.Format("do file {0} failed.", filename));
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
            int functionIdx = LuaDLL.lua_gettop(L);

            LuaDLL.lua_getglobal(L, "_GDB_TRACKBACK_");
            int errFuncIdx = 0;
            if (LuaDLL.lua_isfunction(L, -1)) {
                errFuncIdx = functionIdx;
                LuaDLL.lua_insert(L, errFuncIdx);
            } else {
                LuaDLL.lua_pop(L, 1);
            }

            LuaDLL.lua_pushstring(L, args);
            if (LuaDLL.lua_pcall(L, 1, 1, errFuncIdx) == 0) {
                int curTop = LuaDLL.lua_gettop(L);
                ret = LuaDLL.lua_tostring(L, curTop);
            } else {
                string errMsg = LuaDLL.lua_tostring(L, -1);
                UnityEngine.Debug.Log(string.Format("call function {0} failed. {1}", name, errMsg));
            }
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