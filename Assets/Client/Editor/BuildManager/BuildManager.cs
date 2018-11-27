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
    private bool mProcessResources = false;

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
        mDevelopment = EditorGUILayout.Toggle("Development", mDevelopment);
        mProcessResources = EditorGUILayout.Toggle("Process resources", mProcessResources);

        GUILayout.Space(10);

        if (GUILayout.Button("Build Lua"))
        {
            Build.BuildLuaFiles();
            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
            EditorUtility.DisplayDialog("Build", "Build lua over", "OK");
        }

        if (GUILayout.Button("Build Bundle"))
        {
            Build.BuildAssetBundles(mTargetPlatform);
            EditorUtility.DisplayDialog("Build", "Build bundle over", "OK");
        }

        if (GUILayout.Button("Build Patchlist"))
        {
            Build.BuildPatchlist();
            EditorUtility.DisplayDialog("Build", "Build patchlist over", "OK");
        }

        if (GUILayout.Button("Build Package"))
        {
            string suffix = string.Empty;
            switch (mTargetPlatform)
            {
                case BuildTarget.Android:
                    suffix = "apk";
                    PlayerSettings.Android.keystorePass = "com.bshy.mahjong";
                    PlayerSettings.Android.keyaliasName = "mahjong";
                    PlayerSettings.Android.keyaliasPass = "com.bshy.mahjong";
                    break;
                case BuildTarget.iOS:
                    suffix = string.Empty;
                    break;
                default:
                    suffix = "exe";
                    break;
            }

            string targetName = mDevelopment ? "debug" : "release";
            var targetPath = EditorUtility.SaveFilePanel( "Build", "", targetName, suffix);

            if (!string.IsNullOrEmpty(targetPath))
            {
                if (mProcessResources) Build.PrepareRes();
                string err = Build.BuildPackage(targetPath, mTargetPlatform, mDevelopment);
                if (mProcessResources) Build.ResetRes();

                EditorUtility.DisplayDialog("Build", string.IsNullOrEmpty(err) ? "Build succeeded" : "Build failed", "OK");
            }
        }
    }
}
