using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BuildManager : EditorWindow
{
#if UNITY_ANDROID
    private BuildTarget mTargetPlatform = BuildTarget.Android;
#elif UNITY_IOS
    private BuildTarget mTargetPlatform = BuildTarget.iOS;
#else
    private BuildTarget mTargetPlatform = BuildTarget.StandaloneWindows64;
#endif

    private const string PATCH_PATH = "Patches";

    private static bool mDebug = true;
    private static bool mDevelopment = false;
    private static bool mBuildLua = true;
    private static bool mBuildBundle = true;
    private static bool mBuildPatch = false;
    private static Dictionary<string, string> mVersionDic = new Dictionary<string, string>();
    private static bool mCopyPatch = false;
    private static bool mBuildPackage = true;
    private static string mPackagePath = string.Empty;

    [MenuItem("Window/Build Manager #&B", priority = 2051)]
    private static void Init()
    {
        mDevelopment = EditorUserBuildSettings.development;
        ParseDebug();
        ReadVersion();
        ReadPackageOutputPath();

        BuildManager window = EditorWindow.GetWindow(typeof(BuildManager)) as BuildManager;
        window.Show();
    }

    /// <summary>
    /// 
    /// </summary>
    private void OnGUI()
    {
        GUILayout.Space(10);

        string numk = mDebug ? "num_debug" : "num_release";
        string urlk = mDebug ? "url_debug" : "url_release";

        EditorGUILayout.BeginHorizontal();
        {
            mTargetPlatform = (BuildTarget)EditorGUILayout.EnumPopup("Platform", mTargetPlatform);
            bool development = EditorGUILayout.ToggleLeft("Development", mDevelopment, GUILayout.Width(100));
            if (development != mDevelopment)
            {
                mDevelopment = development;
                EditorUserBuildSettings.development = mDevelopment;
            }
        }
        EditorGUILayout.EndHorizontal();

        mBuildLua = EditorGUILayout.Toggle("Build Lua", mBuildLua);
        mBuildBundle = EditorGUILayout.Toggle("Build Bundle", mBuildBundle);
        mBuildPatch = EditorGUILayout.Toggle("Build Version & Patchlist", mBuildPatch);

        ParseDebug();
        if (mVersionDic.Count < 2)
        {
            ReadVersion();
        }

        GUI.enabled = mBuildPatch;
        mVersionDic[numk] = EditorGUILayout.IntField("Version Num", int.Parse(mVersionDic[numk])).ToString();
        GUI.enabled = false;
        mVersionDic[urlk] = EditorGUILayout.TextField("Version Url", mVersionDic[urlk]);
        GUI.enabled = true;

        mCopyPatch = EditorGUILayout.Toggle("Copy To Patch Folder", mCopyPatch);

        if (string.IsNullOrEmpty(mPackagePath)) {
            ReadPackageOutputPath();
        }
        mBuildPackage = EditorGUILayout.Toggle("Build Package", mBuildPackage);

        EditorGUILayout.BeginHorizontal();
        {
            GUI.enabled = mBuildPackage;
            EditorGUILayout.TextField("Package Path", mPackagePath);
            GUI.enabled = true;

            if (GUILayout.Button("...", GUILayout.Width(30)))
            {
                string packagePath = EditorUtility.SaveFolderPanel("Build", mPackagePath, string.Empty);

                if (!string.IsNullOrEmpty(packagePath) && packagePath != mPackagePath)
                {
                    mPackagePath = packagePath;
                }
            }
        }
        EditorGUILayout.EndHorizontal();

        GUILayout.Space(10);

        if (GUILayout.Button("Build"))
        {
            if (EditorUtility.DisplayDialog("Build", "Are you sure to build package?", "OK", "Cancel"))
            {
                WritePackageOutputPath();

                string finishedText = string.Empty;
                string timestamp = System.DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss");

                if (mBuildLua)
                {
                    Build.BuildLuaFiles();
                    finishedText = "Build lua files finished";
                }

                if (mBuildBundle)
                {
                    Build.BuildAssetBundles(mTargetPlatform);
                    finishedText = "Build asset bundles finished";
                }

                if (mBuildPatch)
                {
                    WriteVersion();

                    Build.BuildPatchlist();
                    Build.BuildVersion(int.Parse(mVersionDic[numk]), mVersionDic[urlk]);
                    finishedText = "Build asset bundles finished";
                }

                if (mCopyPatch)
                {
                    string patchPath = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, PATCH_PATH);
                    LFS.MakeDir(patchPath);

                    string verPath = LFS.CombinePath(patchPath, mVersionDic[numk]);
                    LFS.MakeDir(verPath);

                    EditorUtility.DisplayProgressBar("Build", "Copy lua fils", 0.45f);

                    string luaFrom = LFS.CombinePath(Application.dataPath, "Resources/Lua");
                    string luaTo = LFS.CombinePath(verPath, "Lua");
                    LFS.CopyDir(luaFrom, luaTo, ".meta");

                    EditorUtility.DisplayProgressBar("Build", "Copy asset bundle fils", 0.9f);

                    string resFrom = LFS.CombinePath(Application.streamingAssetsPath, "Res");
                    string resTo = LFS.CombinePath(verPath, "Res");
                    LFS.CopyDir(resFrom, resTo, ".meta");

                    EditorUtility.DisplayProgressBar("Build", "Copy patchlist fil", 0.95f);

                    string patchlistFrom = LFS.CombinePath(Application.dataPath, "Resources", Build.PATCHLIST_FILE_NAME);
                    string patchlistTo = LFS.CombinePath(verPath, Build.PATCHLIST_FILE_NAME);
                    LFS.CopyFile(patchlistFrom, patchlistTo);

                    EditorUtility.DisplayProgressBar("Build", "Copy version file", 1.0f);

                    string versionFrom = LFS.CombinePath(Application.dataPath, "Resources", Build.VERSION_FILE_NAME);
                    string versionTo = LFS.CombinePath(patchPath, Build.VERSION_FILE_NAME);
                    LFS.CopyFile(versionFrom, versionTo);

                    EditorUtility.ClearProgressBar();
                    finishedText = "Copy patch files finished";
                }

                AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);

                if (mBuildPackage)
                {
                    if (string.IsNullOrEmpty(mPackagePath))
                    {
                        EditorUtility.DisplayDialog("Build", "Please set the package output path!", "OK");
                        return;
                    }

                    string packageName = string.Empty;

                    switch (mTargetPlatform)
                    {
                        case BuildTarget.Android:
                            string debug = mDebug ? "_debug" : "_release";
                            string dev = mDevelopment ? "_dev" : "";

                            packageName = timestamp + "_mahjong_" + debug + dev + ".apk";
                            PlayerSettings.Android.keystoreName = Application.dataPath + "/Keystore/mahjong.keystore";
                            PlayerSettings.Android.keystorePass = "com.bshy.mahjong";
                            PlayerSettings.Android.keyaliasName = "mahjong";
                            PlayerSettings.Android.keyaliasPass = "com.bshy.mahjong";
                            break;
                        case BuildTarget.iOS:
                            packageName = "mahjong_" + (mDevelopment ? "debug" : "release");
                            break;
                        default:
                            packageName = "mahjong_" + (mDevelopment ? "debug" : "release") + ".exe";
                            break;
                    }

                    string companyName = PlayerSettings.companyName;
                    string productName = PlayerSettings.productName;

                    PlayerSettings.companyName = "成都巴蜀互娱科技有限公司";
                    PlayerSettings.productName = "幺九麻将";

                    string packageFullName = LFS.CombinePath(mPackagePath, packageName);
                    string err = Build.BuildPackage(packageFullName, mTargetPlatform, mDevelopment);

                    PlayerSettings.companyName = companyName;
                    PlayerSettings.productName = productName;

                    finishedText = "Build package " + (string.IsNullOrEmpty(err) ? "successfully! " : "failed!") + "\n" + packageName;
                }

                EditorUtility.DisplayDialog("Build", finishedText, "OK");
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private static void ParseDebug()
    {
        string path = LFS.CombinePath(Application.dataPath, "ToluaFramework/Lua/config/appConfig.lua");
        string[] lines = File.ReadAllLines(path);

        foreach (string line in lines)
        {
            string[] spt = line.Split('=');
            if (spt.Length != 2)
                continue;

            string k = spt[0].Trim();
            string v = spt[1].Trim();

            if (k == "debug")
            {
                if (v.EndsWith(","))
                {
                    v = v.Substring(0, v.Length - 1);
                }

                mDebug = bool.Parse(v);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private static void ReadVersion()
    {
        string path = LFS.CombinePath(Application.dataPath, "Client/Editor/BuildManager/version.txt");
        string[] lines = File.ReadAllLines(path);

        foreach(string line in lines)
        {
            string[] spt = line.Split('=');

            if (mVersionDic.ContainsKey(spt[0]))
            {
                mVersionDic[spt[0]] = spt[1];
            }
            else
            {
                mVersionDic.Add(spt[0], spt[1]);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void WriteVersion()
    {
        string text = string.Empty;
        string path = LFS.CombinePath(Application.dataPath, "Client/Editor/BuildManager/version.txt");

        foreach(KeyValuePair<string, string> kvp in mVersionDic)
        {
            text += string.Format("{0}={1}\n", kvp.Key, kvp.Value);
        }

        File.WriteAllText(path, text);
    }

    /// <summary>
    /// 
    /// </summary>
    private static void ReadPackageOutputPath()
    {
        string path = LFS.CombinePath(Application.dataPath, "Client/Editor/BuildManager/output.txt");
        if (File.Exists(path))
        {
            mPackagePath = File.ReadAllText(path);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private void WritePackageOutputPath()
    {
        string path = LFS.CombinePath(Application.dataPath, "Client/Editor/BuildManager/output.txt");
        File.WriteAllText(path, mPackagePath);
    }
}
