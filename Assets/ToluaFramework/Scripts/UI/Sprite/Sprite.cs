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

        /// <summary>
        /// 
        /// </summary>
        [SerializeField]
        private List<SpriteItem> items = new List<SpriteItem>();

        #endregion

        #region Public 

        /// <summary>
        /// 
        /// </summary>
        public string spriteName
        {
            set
            {
                foreach (SpriteItem item in items)
                {
                    if (item.key == value)
                    {
                        mImage.sprite = item.sprite;
                        mImage.SetNativeSize();
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
            mImage = GetComponent<Image>();
        }

        #endregion
    }
}
