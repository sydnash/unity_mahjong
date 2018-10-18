using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class Build
{
    /// <summary>
    /// 
    /// </summary>
    public static void BuildLuaFiles()
    {
        string targetPath = LFS.CombinePath(Application.dataPath, "Resources/Lua");
        if (Directory.Exists(targetPath))
        {
            Directory.Delete(targetPath, true);//删除已有文件
        }

        string[] luaDirs = new string[] { LuaConst.luaDir, 
                                          LuaConst.toluaDir, 
                                          LuaConst.clientLuaDir,
        };

        foreach (string dir in luaDirs)
        {
            string[] luaFiles = Directory.GetFiles(dir, "*.lua", SearchOption.AllDirectories);
            foreach (string file in luaFiles)
            {
                int start = dir.Length + 1;
                string path = file.Substring(start).Replace(".lua", ".bytes");

                byte[] bytes = MD5.Encrypt(File.ReadAllBytes(file));
                string filename = LFS.CombinePath(targetPath, path);
                LFS.WriteBytes(filename, bytes);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public static void BuildAssetBundles(BuildTarget buildTarget)
    {
        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/StandaloneWindows");

        if (buildTarget == BuildTarget.Android)
        {
            targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/Android");
        }
        else if (buildTarget == BuildTarget.iOS)
        {
            targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/IOS");
        }

        LFS.RemoveDir(targetDir);

        AssetBundleBrowser.AssetBundleBrowserMain.ExecuteBuild(buildTarget, targetDir);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void BuildPatchlist()
    {
        string patchDir = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patch");
        LFS.MakeDir(patchDir);

        StringBuilder sb = new StringBuilder();

        string luaPath = LFS.CombinePath(patchDir, "Lua");
        string[] luaFiles = Directory.GetFiles(luaPath, "*.bytes", SearchOption.AllDirectories);
        foreach (string file in luaFiles)
        {
            string path = file.Substring(patchDir.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("{0}|{1}|{2}\n", path, code, info.Length);
        }

#if UNITY_ANDROID
        string resPath = LFS.CombinePath(patchDir, "Res/Android");
#elif UNITY_IOS
        string resPath = LFS.CombinePath(patchDir, "Res/IOS");
#else
        string resPath = LFS.CombinePath(patchDir, "Res/StandaloneWindows");
#endif
        string[] resFiles = Directory.GetFiles(resPath, "*.*", SearchOption.AllDirectories);
        foreach (string file in resFiles)
        {
            string path = file.Substring(patchDir.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("{0}|{1}|{2}\n", path, code, info.Length);
        }

        string text = sb.ToString();
        LFS.WriteText(LFS.CombinePath(patchDir, "patchlist.txt"), text, LFS.UTF8_WITHOUT_BOM);

        EditorUtility.DisplayDialog("Build", "Build patchlist over", "OK");
    }

    /// <summary>
    /// 
    /// </summary>
    //public static void CopyLuaToResources()
    //{
    //    string fromDir = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patch/Lua");
    //    string toDir = LFS.CombinePath(Application.dataPath, "Resources/Lua");

    //    LFS.RemoveDir(toDir);

    //    string[] files = Directory.GetFiles(fromDir, "*.bytes", SearchOption.AllDirectories);
    //    foreach (string file in files)
    //    {
    //        string from = file;
    //        string to = file.Replace(fromDir, toDir);

    //        LFS.CopyFile(from, to);
    //    }

    //    AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
    //}

    /// <summary>
    /// 
    /// </summary>
//    public static void CopyBundlesToStreamingAssets()
//    {
//#if UNITY_ANDROID
//        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/Android");
//#elif UNITY_IOS
//        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/IOS");
//#else
//        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res/StandaloneWindows");
//#endif
//        LFS.RemoveDir(targetDir);

//        string patchDir = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patch");

//#if UNITY_ANDROID
//        string resPath = LFS.CombinePath(patchDir, "Res/Android");
//#elif UNITY_IOS
//        string resPath = LFS.CombinePath(patchDir, "Res/IOS");
//#else
//        string resPath = LFS.CombinePath(patchDir, "Res/StandaloneWindows");
//#endif

//        string[] files = Directory.GetFiles(resPath, "*.*", SearchOption.AllDirectories);
//        foreach (string file in files)
//        {
//            string from = file;
//            string to = file.Replace(patchDir, LFS.LOCALIZED_DATA_PATH);

//            LFS.CopyFile(from, to);
//        }

//        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
//    }

    /// <summary>
    /// 
    /// </summary>
    static void CopyPatchlistToStreamingAssets()
    {
        string patchDir = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patch");

        string from = LFS.CombinePath(patchDir, "patchlist.txt");
        string to = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "patchlist.txt");

        LFS.CopyFile(from, to);
        EditorUtility.DisplayDialog("Build", "Copy Patchlist to StreamingAssets over", "OK");
    }

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
    [MenuItem("Build/Simulate Runtime Environment", false, 203)]
    static void SimulateRuntimeEnvironment()
    {
        string defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(mBuildTargetGroup);
        string[] symbols = defineSymbols.Split(';');

        if (IsSimulateRuntimeEnvironmentDefined(symbols))
        {
            Menu.SetChecked("Build/Simulate Runtime Environment", true);
            UncheckSimulateRuntimeEnvironment(symbols);
        }
        else
        {
            Menu.SetChecked("Build/Simulate Runtime Environment", false);
            CheckSimulateRuntimeEnvironment(symbols);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    [MenuItem("Build/Simulate Runtime Environment", true)]
    static bool SimulateRuntimeEnvironmentCheck()
    {
        string defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(mBuildTargetGroup);
        string[] symbols = defineSymbols.Split(';');

        Menu.SetChecked("Build/Simulate Runtime Environment", IsSimulateRuntimeEnvironmentDefined(symbols));
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

    /// <summary>
    /// 
    /// </summary>
    public static void PrepareRes()
    {
        LFS.MoveDir(LFS.CombinePath(Application.dataPath, "Client/Resources"), 
                    LFS.CombinePath(Application.dataPath, "Client/_Resources"));
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
    }

    /// <summary>
    /// 
    /// </summary>
    public static string BuildPackage(string targetPath, BuildTarget targetPlatform, bool isDevelopment)
    {
        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();

        buildPlayerOptions.scenes = new string[EditorBuildSettings.scenes.Length];
        for (int i = 0; i < EditorBuildSettings.scenes.Length; i++)
        {
            EditorBuildSettingsScene scene = EditorBuildSettings.scenes[i];
            buildPlayerOptions.scenes[i] = scene.path;
        }

        buildPlayerOptions.locationPathName = targetPath;
        buildPlayerOptions.target = targetPlatform;
        buildPlayerOptions.options = isDevelopment ? BuildOptions.Development : BuildOptions.None;

        return BuildPipeline.BuildPlayer(buildPlayerOptions);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void ResetRes()
    {
        LFS.MoveDir(LFS.CombinePath(Application.dataPath, "Client/_Resources"),
                    LFS.CombinePath(Application.dataPath, "Client/Resources"));
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
    }

    /// <summary>
    /// 
    /// </summary>
    //static void CopyToResources()
    //{
    //    string[] folders = { "Model", 
    //                         "UI",
    //                         "Sound",
    //                         "Texture"};

    //    foreach (string folder in folders)
    //    {
    //        string from = LFS.CombinePath(LFS.CombinePath(Application.dataPath, "_Resources"), folder);
    //        string to = LFS.CombinePath(LFS.CombinePath(Application.dataPath, "Resources"), folder);

    //        LFS.RemoveDir(to);
    //        LFS.CopyDir(from, to);
    //    }

    //    AssetDatabase.Refresh();
    //}

    /// <summary>
    /// 
    /// </summary>
    //static void RemoveFromResources()
    //{
    //    string resources = LFS.CombinePath(Application.dataPath, "Resources");
    //    string[] folders = { "Model", 
    //                         "UI",
    //                         "Sound",
    //                         "Texture"};

    //    foreach (string folder in folders)
    //    {
    //        string path = LFS.CombinePath(resources, folder);
    //        LFS.RemoveDir(path);
    //        string meta = LFS.CombinePath(resources, folder + ".meta");
    //        LFS.RemoveFile(meta);
    //    }

    //    AssetDatabase.Refresh();
    //}
}
