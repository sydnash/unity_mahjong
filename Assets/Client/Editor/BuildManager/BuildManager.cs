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

    private bool mDevelopment = true;
    private bool mBuildLua = true;
    private bool mBuildBundle = true;
    private bool mBuildPatch = true;
    private bool mBuildPackage = true;
    private bool mProcessResources = false;
    private string mPackagePath = string.Empty;

    [MenuItem("Window/Build Manager #&B", priority = 2051)]
    private static void Init()
    {
        BuildManager window = EditorWindow.GetWindow(typeof(BuildManager)) as BuildManager;
        window.Show();
    }

    /// <summary>
    /// 
    /// </summary>
    private void OnGUI()
    {
        GUILayout.Space(10);

        mTargetPlatform = (BuildTarget)EditorGUILayout.EnumPopup("Platform", mTargetPlatform);
        mDevelopment    = EditorGUILayout.Toggle("Development", mDevelopment);
        mBuildLua       = EditorGUILayout.Toggle("Build Lua", mBuildLua);
        mBuildBundle    = EditorGUILayout.Toggle("Build Bundle", mBuildBundle);
        mBuildPatch     = EditorGUILayout.Toggle("Build Patch", mBuildPatch);
        mBuildPackage   = EditorGUILayout.Toggle("Build Package", mBuildPackage);

        if (mBuildPackage)
        {
            mProcessResources = EditorGUILayout.Toggle("Process Resources", mProcessResources);

            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.TextField("Package Path", mPackagePath);
                if (GUILayout.Button("...", GUILayout.Width(30)))
                {
                    string packagePath = EditorUtility.SaveFolderPanel("Build", mPackagePath, string.Empty);

                    if (!string.IsNullOrEmpty(packagePath))
                    {
                        mPackagePath = packagePath;
                    }
                }
            }
            EditorGUILayout.EndHorizontal();
        }

        GUILayout.Space(10);

        if (GUILayout.Button("Build"))
        {
            string timestamp = System.DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss");

            if (mBuildLua)
            {
                Build.BuildLuaFiles();
                Debug.Log(timestamp + ": build lua over");
            }

            if (mBuildBundle)
            {
                Build.BuildAssetBundles(mTargetPlatform);
                Debug.Log(timestamp + ": build bundle over");
            }

            if (mBuildPatch)
            {
                Build.BuildPatchlist();

                string patchPath = LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patches");
                LFS.MakeDir(patchPath);

                string luaFrom = LFS.CombinePath(Application.dataPath, "Resources/Lua");
                string luaTo = LFS.CombinePath(patchPath, "Lua");
                LFS.CopyDir(luaFrom, luaTo);

                string resFrom = LFS.CombinePath(Application.streamingAssetsPath, "Res");
                string resTo = LFS.CombinePath(patchPath, "Res");
                LFS.CopyDir(resFrom, resTo);

                Debug.Log(timestamp + ": build patch over");
            }

            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);

            if (mBuildPackage && !string.IsNullOrEmpty(mPackagePath))
            {
                string packageName = string.Empty;

                switch (mTargetPlatform)
                {
                    case BuildTarget.Android:
                        packageName = timestamp + "_mahjong_" + (mDevelopment ? "debug" : "release") + ".apk";
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

                if (mProcessResources) Build.PrepareRes();
                packageName = LFS.CombinePath(mPackagePath, packageName);
                string err = Build.BuildPackage(packageName, mTargetPlatform, mDevelopment);
                if (mProcessResources) Build.ResetRes();

                PlayerSettings.companyName = companyName;
                PlayerSettings.productName = productName;

                EditorUtility.DisplayDialog("Build", string.IsNullOrEmpty(err) ? "Build succeeded" : "Build failed", "OK");

                Debug.Log(timestamp + ": build package over");
            }
        }
    }
}
