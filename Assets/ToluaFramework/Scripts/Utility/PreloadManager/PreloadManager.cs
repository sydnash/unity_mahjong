using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PreloadManager : MonoBehaviour
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    class PreloadData
    {
        /// <summary>
        /// 
        /// </summary>
        public string assetType;

        /// <summary>
        /// 
        /// </summary>
        public string assetPath;

        /// <summary>
        /// 
        /// </summary>
        public string assetName;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="assetPath"></param>
        /// <param name="assetName"></param>
        public PreloadData(string assetType, string assetPath, string assetName)
        {
            this.assetType = assetType;
            this.assetPath = assetPath;
            this.assetName = assetName;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private int mToken = 1;

    /// <summary>
    /// 
    /// </summary>
    private Dictionary<int, Queue<PreloadData>> mDict = new Dictionary<int, Queue<PreloadData>>();

    /// <summary>
    /// 
    /// </summary>
    private static readonly WaitForEndOfFrame WAIT_FOR_END_OF_FRAME = new WaitForEndOfFrame();

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static PreloadManager mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static PreloadManager instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetPath"></param>
    /// <param name="assetName"></param>
    public void Push(int token, string assetType, string assetPath, string assetName)
    {
        Queue<PreloadData> queue = mDict.ContainsKey(token) ? mDict[token] : null;
        if (queue == null)
        {
            queue = new Queue<PreloadData>();
            mDict.Add(token, queue);
        }

        PreloadData d = new PreloadData(assetType, assetPath, assetName);
        queue.Enqueue(d);
    }

    /// <summary>
    /// 
    /// </summary>
    public void Load(int token, int loadCountPreFrame)
    {
        StartCoroutine(LoadCoroutine(token, Mathf.Max(1, loadCountPreFrame)));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="token"></param>
    /// <returns></returns>
    public void End(int token)
    {
        Queue<PreloadData> queue =  mDict.ContainsKey(token) ? mDict[token] : null;
        if (queue != null)
        {
            queue.Clear();
            mDict.Remove(token);
        }
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
    /// <param name="token"></param>
    /// <param name="loadCountPreFrame"></param>
    /// <returns></returns>
    private IEnumerator LoadCoroutine(int token, int loadCountPreFrame)
    {
        Queue<PreloadData> queue = mDict[token];
#if UNITY_EDITOR
        int preloadCount = 0;
#endif

        while (queue.Count > 0)
        {
            for (int i = 0; i < loadCountPreFrame; i++)
            {
                PreloadData d = queue.Dequeue();
                AssetPoolManager.instance.Preload(d.assetType, d.assetPath, d.assetName);
#if UNITY_EDITOR
                preloadCount++;
#endif
            }
            yield return WAIT_FOR_END_OF_FRAME;
        }
        mDict.Remove(token);

#if UNITY_EDITOR
        Debug.LogFormat("preload {0} assets over", preloadCount);
#endif
        yield return WAIT_FOR_END_OF_FRAME;
    }

    #endregion
}
