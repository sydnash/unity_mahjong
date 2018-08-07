using System;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    private class SceneBundle
    {
        /// <summary>
        /// 
        /// </summary>
        public string bundleName = string.Empty;

        /// <summary>
        /// 
        /// </summary>
        public bool checkExists = false;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="check"></param>
        public SceneBundle(string name, bool check)
        {
            bundleName = name;
            checkExists = check;
        }
    }

    #endregion

    #region Datas

    /// <summary>
    /// 
    /// </summary>
    private string mLocalizedPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private string mDownloadPath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
#if UNITY_ANDROID
    private const string SUB_PATH = "Res/Android/scene";
#elif UNITY_IOS
    private const string SUB_PATH = "Res/iOS/scene";
#else
    private const string SUB_PATH = "Res/StandaloneWindows/scene";
#endif

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static SceneLoader mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static SceneLoader instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sceneName"></param>
    public void Load(string sceneName, Action callback)
    {
        sceneName = sceneName.ToLower();

        SceneBundle[] sceneBundles = { new SceneBundle(LFS.CombinePath(mDownloadPath,  sceneName), false),
                                       new SceneBundle(LFS.CombinePath(mLocalizedPath, sceneName), true)
        };

        StartCoroutine(LoadCoroutine(sceneBundles, sceneName, callback));
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;

        mLocalizedPath = LFS.CombinePath(LFS.LOCALIZED_DATA_PATH, SUB_PATH);
        mDownloadPath  = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH,  SUB_PATH);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleNames"></param>
    /// <param name="sceneName"></param>
    /// <param name="checkExists"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator LoadCoroutine(SceneBundle[] bundleInfos, string sceneName, Action callback)
    {
        AssetBundle bundle = null;

        foreach (SceneBundle sb in bundleInfos)
        {
            string bundleName = sb.bundleName;
            bool checkExist = sb.checkExists;

            if (checkExist && System.IO.File.Exists(bundleName))
            {
                var request = AssetBundle.LoadFromFileAsync(bundleName);
                yield return request;

                bundle = request.assetBundle;
                if (bundle != null)
                {
                    break;
                }
            }
        }

        if (bundle != null)
        {
            AsyncOperation op = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Single);

            while (!op.isDone)
            {
                yield return new WaitForEndOfFrame();
            }

            bundle.Unload(false);
        }
#if UNITY_EDITOR
        else
        {
            Debug.LogErrorFormat("can't load the scene: {0}", sceneName);
        }
#endif

        yield return new WaitForEndOfFrame();

        if (callback != null)
        {
            callback();
        }

        yield return new WaitForEndOfFrame();
    }

    #endregion
}
