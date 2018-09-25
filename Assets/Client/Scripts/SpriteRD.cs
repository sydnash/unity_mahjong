using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 
/// </summary>
[RequireComponent(typeof(UnityEngine.SpriteRenderer))]
public class SpriteRD : MonoBehaviour
{
    #region Class

    /// <summary>
    /// 
    /// </summary>
    [System.Serializable]
    public class SpriteItem
    {
        public string key;
        public UnityEngine.Sprite sprite;

        public SpriteItem(string k, UnityEngine.Sprite s)
        {
            key = k;
            sprite = s;
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// 
    /// </summary>
    private SpriteRenderer mRenderer = null;

    /// <summary>
    /// 
    /// </summary>
    [SerializeField]
    private List<SpriteItem> mItems = new List<SpriteItem>();

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    public string spriteName
    {
        set
        {
            foreach (SpriteItem item in mItems)
            {
                if (item.key == value)
                {
                    mRenderer.sprite = item.sprite;
                    break;
                }
            }
        }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mRenderer = GetComponent<SpriteRenderer>();
    }

    #endregion
}
