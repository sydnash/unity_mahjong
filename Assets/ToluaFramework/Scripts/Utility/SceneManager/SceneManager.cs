using System;
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
    public string mScenePath = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    public string mSceneName = string.Empty;

    /// <summary>
    /// 
    /// </summary>
    private AssetLoader mLoader = null;

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
    private static string SUB_PATH = string.Empty;

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
    /// <param name="scenePath"></param>
    public void Setup(string scenePath)
    {
        mScenePath = scenePath.ToLower();
        mLoader = new AssetLoader(mScenePath);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sceneName"></param>
    public void Load(string sceneName, Action<bool, float> callback)
    {
        if (!string.IsNullOrEmpty(mSceneName))
        {
            string key = AssetLoader.CreateAssetKey(string.Empty, mSceneName);
            mLoader.UnloadDependencies(key);
        }

        mSceneName = sceneName.ToLower();

        SceneBundle[] sceneBundles = null;

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        sceneName = LFS.CombinePath(mScenePath, mSceneName + ".unity");

        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.path.EndsWith(mSceneName, StringComparison.OrdinalIgnoreCase))
            {
                mSceneName = scene.path;
                break;
            }
        }
#else
        sceneBundles = new SceneBundle[2]{ new SceneBundle(LFS.CombinePath(mDownloadPath,  mScenePath, mSceneName), true),
                                           new SceneBundle(LFS.CombinePath(mLocalizedPath, mScenePath, mSceneName), false)
        };
#endif

        StartCoroutine(LoadCoroutine(sceneBundles, mSceneName, callback));
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

        SUB_PATH = LFS.CombinePath("Res", LFS.OS_PATH);
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
#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        mLoader.LoadDependentAB(string.Empty, sceneName);

        InvokeCallback(callback, false, 0.2f);
        yield return WAIT_FOR_END_OF_FRAME;
        
        AssetBundle bundle = null;
        foreach (SceneBundle sb in bundleInfos)
        {
            if (!sb.checkExists || System.IO.File.Exists(sb.bundleName))
            {
                bundle = mLoader.LoadAssetBundle(sb.bundleName);
                if (bundle != null) break;
            }
        }
#endif

        InvokeCallback(callback, false, 0.4f);
        yield return WAIT_FOR_END_OF_FRAME;

#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        if (bundle != null)
        {
#endif
            AsyncOperation op = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(sceneName, UnityEngine.SceneManagement.LoadSceneMode.Single);
            while (!op.isDone)
            {
                InvokeCallback(callback, false, 0.4f + op.progress * 0.6f);
                yield return WAIT_FOR_END_OF_FRAME;
            }
#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
            //TODO: xieheng  这里scene使用完毕之后，直接清除依赖和bundle，避免后面的重复加载导致失败
            bundle.Unload(false);
            string key = AssetLoader.CreateAssetKey(string.Empty, mSceneName);
            mLoader.UnloadDependencies(key);
            mLoader.ClearBundlePool();
        }
        else
        {
            Logger.LogError(string.Format("can't load the scene: {0}", sceneName));
        }
#endif

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
