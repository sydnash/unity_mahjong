﻿using System;
using System.Collections;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class SceneManager : MonoBehaviour
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
    private const string SUB_PATH = "Res/Android";
#elif UNITY_IOS
    private const string SUB_PATH = "Res/iOS";
#else
    private const string SUB_PATH = "Res/StandaloneWindows";
#endif

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static SceneManager mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static SceneManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sceneName"></param>
    public void Load(string scenePath, string sceneName, Action<bool, float> callback)
    {
        scenePath = scenePath.ToLower();
        sceneName = sceneName.ToLower();

        SceneBundle[] sceneBundles = null;

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        sceneName = LFS.CombinePath(scenePath, sceneName + ".unity");

        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.path.EndsWith(sceneName, StringComparison.OrdinalIgnoreCase))
            {
                sceneName = scene.path;
                break;
            }
        }
#else
        sceneBundles = new SceneBundle[2]{ new SceneBundle(LFS.CombinePath(mDownloadPath,  scenePath, sceneName), true),
                                           new SceneBundle(LFS.CombinePath(mLocalizedPath, scenePath, sceneName), false)
        };
#endif

        StartCoroutine(LoadCoroutine(sceneBundles, sceneName, callback));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public string GetActivedSceneName()
    {
        return UnityEngine.SceneManagement.SceneManager.GetActiveScene().name.ToLower();
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

#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        AssetBundle bundle = null;

        foreach (SceneBundle sb in bundleInfos)
        {
            string bundleName = sb.bundleName;
            bool checkExist = sb.checkExists;

            if (!checkExist || System.IO.File.Exists(bundleName))
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
#endif

        InvokeCallback(callback, false, 0.5f);
        yield return WAIT_FOR_END_OF_FRAME;

        time = Time.realtimeSinceStartup;

#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        if (bundle != null)
        {
#endif
            AsyncOperation op = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(sceneName, UnityEngine.SceneManagement.LoadSceneMode.Single);
            while (!op.isDone)
            {
                InvokeCallback(callback, false, 0.5f + op.progress * 0.5f);
                yield return WAIT_FOR_END_OF_FRAME;
            }
#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
            bundle.Unload(false);
        }
        else
        {
            Logger.LogError(string.Format("can't load the scene: {0}", sceneName));
        }
#endif

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
