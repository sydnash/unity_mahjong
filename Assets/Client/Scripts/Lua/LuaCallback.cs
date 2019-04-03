using System;
using System.Collections.Generic;
using LuaInterface;

class LuaCallback
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class Method
    {
        /// <summary>
        /// 
        /// </summary>
        public LuaFunction func = null;

        /// <summary>
        /// 
        /// </summary>
        public string args = string.Empty;
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<int, LuaFunction> callbacks = new Dictionary<int, LuaFunction>();

    /// <summary>
    /// 
    /// </summary>
    private Queue<Method> methods = new Queue<Method>();

    /// <summary>
    /// 
    /// </summary>
    private int tokenAcc = 1;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static LuaCallback mInstance = new LuaCallback();

    /// <summary>
    /// 
    /// </summary>
    public static LuaCallback instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    /// <returns></returns>
    public int Add(LuaFunction callback)
    {
        int token = tokenAcc;
        tokenAcc++;

        if (callback != null)
        {
            lock (callbacks)
            {
                callbacks.Add(token, callback);
            }
        }

        return token;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="token"></param>
    /// <param name="args"></param>
    public void Invoke(int token, string args)
    {
        LuaFunction func = null;
        lock (callbacks)
        {
            if (callbacks.ContainsKey(token))
            {
                func = callbacks[token];
            }
        }

        if (func != null)
        {
            lock (methods)
            {
                Method m = new Method();
                m.func = func;
                m.args = args;

                methods.Enqueue(m);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
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
            m.func.Call(m.args);
        }
    }

    #endregion
}