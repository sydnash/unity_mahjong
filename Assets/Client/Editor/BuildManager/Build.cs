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
        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res", LFS.OS_PATH);
        LFS.RemoveDir(targetDir);

        AssetBundleBrowser.AssetBundleBrowserMain.ExecuteBuild(buildTarget, targetDir);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void BuildPatchlist()
    {
        string resourcesPath = LFS.CombinePath(Application.dataPath, "Resources");

        StringBuilder sb = new StringBuilder();
        sb.Append("return {\n");

        string luaPath = LFS.CombinePath(resourcesPath, "Lua");
        string[] luaFiles = Directory.GetFiles(luaPath, "*.bytes", SearchOption.AllDirectories);
        for (int i = 0; i < luaFiles.Length; i++)
        {
            string file = luaFiles[i];

            string path = file.Substring(resourcesPath.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("[\"{0}\"]=", path);
            sb.Append("{");
            sb.AppendFormat("[\"hash\"]=\"{0}\", [\"size\"]={1}", code, info.Length);
            sb.Append("},\n");
        }

        string resPath = LFS.CombinePath(Application.streamingAssetsPath, "Res", LFS.OS_PATH);
        string[] resFiles = Directory.GetFiles(resPath, "*.*", SearchOption.AllDirectories);

        for (int i=0; i<resFiles.Length; i++)
        {
            string file = resFiles[i];
            if (file.EndsWith(".meta")) continue;

            string path = file.Substring(Application.streamingAssetsPath.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("[\"{0}\"]=", path);
            sb.Append("{");
            sb.AppendFormat("[\"hash\"]=\"{0}\", [\"size\"]={1}", code, info.Length);
            sb.Append("},\n");
        }

        sb.Append("}");

        string text = sb.ToString();
        LFS.WriteText(LFS.CombinePath(Application.streamingAssetsPath, "patchlist.txt"), text, LFS.UTF8_WITHOUT_BOM);
    }

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
}
