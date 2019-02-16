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
    private static readonly WaitForEndOfFrame WAIT_FOR_END_OF_FRAME = new WaitForEndOfFrame();

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
        mScenePath = scenePath;
        mLoader = new AssetLoader(mScenePath);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sceneName"></param>
    public void Load(string sceneName, Action<bool, float> callback)
    {
        sceneName = sceneName;

#if UNITY_EDITOR && !SIMULATE_RUNTIME_ENVIRONMENT
        mSceneName = LFS.CombinePath(mScenePath, sceneName + ".unity");

        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.path.EndsWith(mSceneName, StringComparison.OrdinalIgnoreCase))
            {
                mSceneName = scene.path;
                break;
            }
        }
#else
        if (!string.IsNullOrEmpty(mSceneName))
        {
            mLoader.UnloadDependentAB(mSceneName);
        }

        mSceneName = LFS.CombinePath(mScenePath, sceneName);
#endif

        StartCoroutine(LoadCoroutine(sceneName, callback));
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bundleNames"></param>
    /// <param name="sceneName"></param>
    /// <param name="checkExists"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    private IEnumerator LoadCoroutine(string sceneName, Action<bool, float> callback)
    {
#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        string key = mLoader.LoadDependentAB(string.Empty, sceneName);

        InvokeCallback(callback, false, 0.2f);
        yield return WAIT_FOR_END_OF_FRAME;
        
        AssetBundle ab = mLoader.LoadAB(mSceneName);
#endif
        InvokeCallback(callback, false, 0.4f);
        yield return WAIT_FOR_END_OF_FRAME;

#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
        if (ab != null)
        {
#endif
            AsyncOperation op = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(sceneName, UnityEngine.SceneManagement.LoadSceneMode.Single);
            while (!op.isDone)
            {
                InvokeCallback(callback, false, 0.4f + op.progress * 0.6f);
                yield return WAIT_FOR_END_OF_FRAME;
            }
#if !UNITY_EDITOR || SIMULATE_RUNTIME_ENVIRONMENT
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
