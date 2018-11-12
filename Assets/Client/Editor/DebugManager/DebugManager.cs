using System;
using UnityEngine;
using UnityEditor;

class DebugManager
{

#if UNITY_ANDROID
    private const BuildTargetGroup mBuildTargetGroup = BuildTargetGroup.Android;
#elif UNITY_IOS
    private const BuildTargetGroup mBuildTargetGroup = BuildTargetGroup.iOS;
#else
    private const BuildTargetGroup mBuildTargetGroup = BuildTargetGroup.Standalone;
#endif

    /// <summary>
    /// 
    /// </summary>
    [MenuItem("Debug/Simulate Runtime Environment", false, 203)]
    static void SimulateRuntimeEnvironment()
    {
        string defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(mBuildTargetGroup);
        string[] symbols = defineSymbols.Split(';');

        if (IsSimulateRuntimeEnvironmentDefined(symbols))
        {
            Menu.SetChecked("Debug/Simulate Runtime Environment", true);
            UncheckSimulateRuntimeEnvironment(symbols);
        }
        else
        {
            Menu.SetChecked("Debug/Simulate Runtime Environment", false);
            CheckSimulateRuntimeEnvironment(symbols);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    [MenuItem("Debug/Simulate Runtime Environment", true)]
    static bool SimulateRuntimeEnvironmentCheck()
    {
        string defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(mBuildTargetGroup);
        string[] symbols = defineSymbols.Split(';');

        Menu.SetChecked("Debug/Simulate Runtime Environment", IsSimulateRuntimeEnvironmentDefined(symbols));
        return true;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="symbols"></param>
    /// <returns></returns>
    static bool IsSimulateRuntimeEnvironmentDefined(string[] symbols)
    {
        foreach (string s in symbols)
        {
            if (s == "SIMULATE_RUNTIME_ENVIRONMENT")
            {
                return true;
            }
        }

        return false;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="symbols"></param>
    static void CheckSimulateRuntimeEnvironment(string[] symbols)
    {
        string defineSymbols = string.Empty;

        foreach (string s in symbols)
        {
            defineSymbols += s + ";";
        }
        defineSymbols += "SIMULATE_RUNTIME_ENVIRONMENT";

        PlayerSettings.SetScriptingDefineSymbolsForGroup(mBuildTargetGroup, defineSymbols);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="symbols"></param>
    static void UncheckSimulateRuntimeEnvironment(string[] symbols)
    {
        string defineSymbols = string.Empty;

        foreach (string s in symbols)
        {
            if (s != "SIMULATE_RUNTIME_ENVIRONMENT")
            {
                defineSymbols += s + ";";
            }
        }

        PlayerSettings.SetScriptingDefineSymbolsForGroup(mBuildTargetGroup, defineSymbols);
    }
}
