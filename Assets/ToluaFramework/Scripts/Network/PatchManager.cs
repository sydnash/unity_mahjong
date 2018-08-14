using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using LuaInterface;

public class PatchManager : MonoBehaviour
{
    #region Classes

    /// <summary>
    /// 
    /// </summary>
    private class Patch
    {
        public string fileName = string.Empty;
        public string hashCode = string.Empty;
        public int    fileSize = 0;

        public Patch(string filename, string hashcode, int filesize)
        {
            fileName = filename;
            hashCode = hashcode;
            fileSize = filesize;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    private class CallbackWrap
    {
        public LuaFunction function = null;
        public object args = null;

        public CallbackWrap(LuaFunction function, object args)
        {
            this.function = function;
            this.args = args;
        }
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private HttpDownload mHttp = null;

    /// <summary>
    /// 
    /// </summary>
    private string mPatchRootURL = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private string mLocalVersion = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private string mVersion = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<string, Patch> mLocalPatchDict = null;
    
    /// <summary>
    /// 
    /// </summary>
    private string mPatchlistText = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private List<Patch> mDownloadPatches = new List<Patch>();

    /// <summary>
    /// 
    /// </summary>
    private int mDownloadBytes = 0;

    /// <summary>
    /// 
    /// </summary>
    private int mDownloadedCount = 0;

    /// <summary>
    /// 
    /// </summary>
    private const string VERSION_FILENAME = "version.txt";

    /// <summary>
    /// 
    /// </summary>
    private const string PATCHLIST_FILENAME = "patchlist.txt";

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public void Check(LuaFunction callback, object args)
    {
        mLocalVersion = string.Empty;
        mPatchlistText = string.Empty;
        mDownloadPatches.Clear();
        mDownloadBytes = 0;
        mDownloadedCount = 0;

        if (mHttp != null)
        {
            string[] files = new string[] { LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  VERSION_FILENAME),
                                            LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, VERSION_FILENAME) };

            mHttp.DownloadAny(files, OnLocalVersionDownloadedHandler, new CallbackWrap(callback, args));
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public void Download(LuaFunction callback, object args)
    {
        if (mHttp != null)
        {
            string[] urls = new string[mDownloadPatches.Count];

            for (int i = 0; i < mDownloadPatches.Count; i++)
            {
                urls[i] = LFS.CombinePath(mPatchRootURL, mDownloadPatches[i].fileName);
            }

            mHttp.DownloadAll(urls, OnPatchDownloadHandler, new CallbackWrap(callback, args));
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public int downloadBytes
    {
        get { return mDownloadBytes; }
    }

    /// <summary>
    /// 
    /// </summary>
    public int downloadCount
    {
        get { return mDownloadPatches.Count; }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mHttp = gameObject.AddComponent<HttpDownload>();
        //mPatchRootURL = AppConfig.instance.patchURL;
        mPatchRootURL = "file:///" + LFS.CombinePath(Directory.GetParent(Application.dataPath).FullName, "Patch");
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="text"></param>
    /// <param name="args"></param>
    private void OnLocalVersionDownloadedHandler(HttpDownload.StatusCode code, string text, object args)
    {
        if (code == HttpDownload.StatusCode.OK)
        {
            mLocalVersion = text;
        }
#if UNITY_EDITOR
        else
        {
            Debug.LogError("load local version file failed!");
        }
#endif

        DownloadRemoteVersion(args);
    }

    /// <summary>
    /// 
    /// </summary>
    private void DownloadRemoteVersion(object args)
    {
        if (mHttp != null)
        {
            string url = LFS.CombinePath(mPatchRootURL, VERSION_FILENAME);
            mHttp.Download(url, OnRemoteVersionDownloadedHandler, args);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="text"></param>
    /// <param name="args"></param>
    private void OnRemoteVersionDownloadedHandler(HttpDownload.StatusCode code, string text, object args)
    {
        CallbackWrap wrap = args as CallbackWrap;

        LuaFunction function = wrap.function;
        object target = wrap.args;

        if (code == HttpDownload.StatusCode.OK)
        {
            if (text != mLocalVersion)
            {
                mVersion = text;
                DownloadLocalPatchlist(args);
            }
            else
            {
                if (function != null)
                {
                    function.Call(target, false, 0);
                }
            }
        }
        else
        {
            if (function != null)
            {
                function.Call(target, true, 0);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void DownloadLocalPatchlist(object args)
    {
        if (mHttp != null)
        {
            string[] files = new string[] { LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  PATCHLIST_FILENAME),
                                            LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, PATCHLIST_FILENAME) };

            mHttp.DownloadAny(files, OnLocalPatchlistDownloadedHandler, args);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="text"></param>
    /// <param name="args"></param>
    private void OnLocalPatchlistDownloadedHandler(HttpDownload.StatusCode code, string text, object args)
    {
        if (code == HttpDownload.StatusCode.OK)
        {
            mLocalPatchDict = Parse(text);
        }
#if UNITY_EDITOR
        else
        {
            Debug.LogError("load local patchlist file failed!");
        }
#endif

        DownloadRemotePatchlist(args);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="args"></param>
    private void DownloadRemotePatchlist(object args)
    {
        if (mHttp != null)
        {
            string url = LFS.CombinePath(mPatchRootURL, PATCHLIST_FILENAME);
            mHttp.Download(url, OnRemotePatchlistDownloadedHandler, args);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="text"></param>
    /// <param name="args"></param>
    private void OnRemotePatchlistDownloadedHandler(HttpDownload.StatusCode code, string text, object args)
    {
        CallbackWrap wrap = args as CallbackWrap;

        LuaFunction function = wrap.function;
        object target = wrap.args;

        if (code == HttpDownload.StatusCode.OK)
        {
            mPatchlistText = text;
            Dictionary<string, Patch> remotePatchDict = Parse(mPatchlistText);

            foreach (var patch in remotePatchDict)
            {
                if (mLocalPatchDict == null || !mLocalPatchDict.ContainsKey(patch.Key) ||
                    mLocalPatchDict[patch.Key].hashCode != patch.Value.hashCode)
                {
                    mDownloadBytes += patch.Value.fileSize;
                    mDownloadPatches.Add(patch.Value);
                }
            }

#if UNITY_EDITOR
            Debug.Log(string.Format("checked {0} patches, about {1} bytes", mDownloadPatches.Count, mDownloadBytes));
#endif
            if (function != null)
            {
                function.Call(target, false, mDownloadBytes);
            }
        }
        else
        {
            if (function != null)
            {
                function.Call(target, true, 0);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="code"></param>
    /// <param name="bytes"></param>
    /// <param name="args"></param>
    private void OnPatchDownloadHandler(HttpDownload.StatusCode code, string url, byte[] bytes, object args)
    {
        CallbackWrap wrap = args as CallbackWrap;

        LuaFunction function = wrap.function;
        object target = wrap.args;

        if (code == HttpDownload.StatusCode.OK)
        {
            string filePath = url.Substring(mPatchRootURL.Length + 1);
            string targetPath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, filePath);

            LFS.WriteFile(targetPath, bytes);
            mDownloadedCount++;

            if (mDownloadedCount == mDownloadPatches.Count)
            {
                LFS.WriteFile(LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, VERSION_FILENAME), mVersion, LFS.UTF8_WITHOUT_BOM);
                LFS.WriteFile(LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, PATCHLIST_FILENAME), mPatchlistText, LFS.UTF8_WITHOUT_BOM);
            }

            function.Call(target, false, bytes.Length);
        }
        else
        {
#if UNITY_EDITOR
            Debug.LogError("download patch failed!");
#endif
            function.Call(target, true, -1);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="patches"></param>
    /// <returns></returns>
    private Dictionary<string, Patch> Parse(string patches)
    {
        Dictionary<string, Patch> dict = new Dictionary<string, Patch>();

        string[] files = patches.Split('\n');
        foreach (string file in files)
        {
            if (!string.IsNullOrEmpty(file))
            {
                string[] cc = file.Split('|');
                if (cc.Length == 3)
                {
                    string path = cc[0];
                    string code = cc[1];
                    int    size = int.Parse(cc[2]);

                    dict.Add(path, new Patch(path, code, size));
                }
            }
        }

        return dict;
    }

    #endregion
}
