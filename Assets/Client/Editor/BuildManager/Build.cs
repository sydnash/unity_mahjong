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
                EditorUtility.DisplayProgressBar("Build", path, 0.0f);
                byte[] bytes = MD5.Encrypt(File.ReadAllBytes(file));
                string filename = LFS.CombinePath(targetPath, path);
                LFS.WriteBytes(filename, bytes);
                EditorUtility.DisplayProgressBar("Build", path, 1.0f);
            }
        }

        EditorUtility.ClearProgressBar();
    }

    /// <summary>
    /// 
    /// </summary>
    public static void BuildAssetBundles(BuildTarget buildTarget)
    {
        string targetDir = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, "Res");
        LFS.RemoveDir(targetDir);

        AssetBundleBrowser.AssetBundleBrowserMain.ExecuteBuild(buildTarget, targetDir);
    }

    public const string PATCHLIST_FILE_NAME = "patchlist.txt";
    public const string VERSION_FILE_NAME = "version.txt";

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
            EditorUtility.DisplayProgressBar("Build", file, 0.0f);

            string path = file.Substring(resourcesPath.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("[\"{0}\"]=", path);
            sb.Append("{");
            sb.AppendFormat("[\"hash\"]=\"{0}\", [\"size\"]={1}", code, info.Length);
            sb.Append("},\n");

            EditorUtility.DisplayProgressBar("Build", file, 1.0f);
        }

        string resPath = LFS.CombinePath(Application.streamingAssetsPath, "Res");
        string[] resFiles = Directory.GetFiles(resPath, "*.*", SearchOption.AllDirectories);

        for (int i=0; i<resFiles.Length; i++)
        {
            string file = resFiles[i];
            if (file.EndsWith(".meta")) continue;

            EditorUtility.DisplayProgressBar("Build", file, 0.0f);

            string path = file.Substring(Application.streamingAssetsPath.Length + 1).Replace("\\", "/");
            string code = MD5.GetHashFromFile(file);
            FileInfo info = new FileInfo(file);

            sb.AppendFormat("[\"{0}\"]=", path);
            sb.Append("{");
            sb.AppendFormat("[\"hash\"]=\"{0}\", [\"size\"]={1}", code, info.Length);
            sb.Append("},\n");

            EditorUtility.DisplayProgressBar("Build", file, 1.0f);
        }

        sb.Append("}");

        string text = sb.ToString();
        LFS.WriteText(LFS.CombinePath(Application.dataPath, "Resources", PATCHLIST_FILE_NAME), text, LFS.UTF8_WITHOUT_BOM);

        EditorUtility.ClearProgressBar();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ver"></param>
    /// <param name="url"></param>
    public static void BuildVersion(int ver, string url)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("return {\n");
        sb.AppendFormat("[\"num\"]={0},\n", ver);
        sb.AppendFormat("[\"url\"]=\"{0}\",\n", url);
        sb.Append("}");

        string text = sb.ToString();
        LFS.WriteText(LFS.CombinePath(Application.dataPath, "Resources", VERSION_FILE_NAME), text, LFS.UTF8_WITHOUT_BOM);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void PrepareRes()
    {
        string from = LFS.CombinePath(Application.dataPath, "Client/Resources");
        string to = LFS.CombinePath(Application.dataPath, "Client/_Resources");
        
        LFS.MoveDir(from, to);
        LFS.MoveFile(LFS.CombinePath(to, PATCHLIST_FILE_NAME), LFS.CombinePath(from, PATCHLIST_FILE_NAME));

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
