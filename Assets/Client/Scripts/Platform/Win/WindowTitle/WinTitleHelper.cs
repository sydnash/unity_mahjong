using UnityEngine;
using System;
using System.Runtime.InteropServices;

class WinTitleHelper
{
    #region WIN32API
    delegate bool EnumWindowsCallBack(IntPtr hwnd, IntPtr lParam);
    [DllImport("user32", CharSet = CharSet.Unicode)]
    static extern bool SetWindowTextW(IntPtr hwnd, string title);
    [DllImport("user32")]
    static extern int EnumWindows(EnumWindowsCallBack lpEnumFunc, IntPtr lParam);
    [DllImport("user32")]
    static extern uint GetWindowThreadProcessId(IntPtr hWnd, ref IntPtr lpdwProcessId);
    #endregion

    static IntPtr myWindowHandle;
    public static void ChangeWindowTitle(string title)
    {
        IntPtr handle = (IntPtr)System.Diagnostics.Process.GetCurrentProcess().Id;  //获取进程ID
        EnumWindows(new EnumWindowsCallBack(EnumWindCallback), handle);     //枚举查找本窗口
        SetWindowTextW(myWindowHandle, title); //设置窗口标题
    }

    static bool EnumWindCallback(IntPtr hwnd, IntPtr lParam)
    {
        IntPtr pid = IntPtr.Zero;
        GetWindowThreadProcessId(hwnd, ref pid);
        if (pid == lParam)  //判断当前窗口是否属于本进程
        {
            myWindowHandle = hwnd;
            return false;
        }
        return true;
    }
}

