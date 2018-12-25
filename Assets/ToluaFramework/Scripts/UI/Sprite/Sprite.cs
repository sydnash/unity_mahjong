using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UnityEngine.UI
{
    /// <summary>
    /// 
    /// </summary>
    [RequireComponent(typeof(UnityEngine.UI.Image))]
    public class Sprite : MonoBehaviour
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
        private Image mImage = null;
        private RectTransform mRectTransform = null;

        /// <summary>
        /// 
        /// </summary>
        [SerializeField]
        private bool mAutoSize = true;

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
                        mImage.sprite = item.sprite;
                        if (mAutoSize)
                        {
                            mImage.SetNativeSize();
                        }
                        break;
                    }
                }
            }
        }

        public void SetSize(Vector2 size)
        {
            mRectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, size.x);
            mRectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, size.y);
        }

        #endregion

        #region Private

        /// <summary>
        /// 
        /// </summary>
        private void Awake()
        {
            mImage = GetComponent<Image>();
            mRectTransform = GetComponent<RectTransform>();
        }

        #endregion
    }
}
