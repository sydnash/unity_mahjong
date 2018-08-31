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
    private static readonly WaitForEndOfFrame WAIT_FOR_END_OF_FRAME = new WaitForEndOfFrame();

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
    public void Load(string sceneName, Action<bool, float> callback)
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
    private IEnumerator LoadCoroutine(SceneBundle[] bundleInfos, string sceneName, Action<bool, float> callback)
    {
        float time = Time.realtimeSinceStartup;
        AssetBundle bundle = null;

        foreach (SceneBundle sb in bundleInfos)
        {
            string bundleName = sb.bundleName;
            bool checkExist = sb.checkExists;

            if (checkExist && System.IO.File.Exists(bundleName))
            {
                var request = AssetBundle.LoadFromFileAsync(bundleName);

                while (!request.isDone)
                {
                    InvokeCallback(callback, false, request.progress * 0.5f);
                    yield return WAIT_FOR_END_OF_FRAME;
                }

                bundle = request.assetBundle;
                if (bundle != null)
                {
                    break;
                }
            }
        }

        while (Time.realtimeSinceStartup - time < 0.4f)
        {
            yield return WAIT_FOR_END_OF_FRAME;
        }

        InvokeCallback(callback, false, 0.5f);
        yield return WAIT_FOR_END_OF_FRAME;

        time = Time.realtimeSinceStartup;

        if (bundle != null)
        {
            AsyncOperation op = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Single);

            while (!op.isDone)
            {
                InvokeCallback(callback, false, 0.5f + op.progress * 0.5f);
                yield return WAIT_FOR_END_OF_FRAME;
            }

            bundle.Unload(false);
        }
        else
        {
            Logger.LogError(string.Format("can't load the scene: {0}", sceneName));
        }

        while (Time.realtimeSinceStartup - time < 0.4f)
        {
            yield return WAIT_FOR_END_OF_FRAME;
        }

        InvokeCallback(callback, false, 1.0f);
        time = Time.realtimeSinceStartup;
        yield return WAIT_FOR_END_OF_FRAME;

        while (Time.realtimeSinceStartup - time < 0.2f)
        {
            yield return WAIT_FOR_END_OF_FRAME;
        }

        InvokeCallback(callback, true, 1.0f);
        yield return WAIT_FOR_END_OF_FRAME;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="callback"></param>
    /// <param name="completed"></param>
    /// <param name="progress"></param>
    private void InvokeCallback(Action<bool, float> callback, bool completed, float progress)
    {
        if (callback != null)
        {
            callback(completed, progress);
        }
    }

    #endregion
}
