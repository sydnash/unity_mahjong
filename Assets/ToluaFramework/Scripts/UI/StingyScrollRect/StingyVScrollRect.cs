using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StingyVScrollRect : StingyScrollRect
{
    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="spacing"></param>
    protected override void SetContentSpacing(float spacing)
    {
        scrollContent.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, spacing);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="v"></param>
    protected override void OnScrollRectValueChangedHandler(Vector2 delta)
    {
        float headTop = mHeadIndex * mItemSpacing;
        float headBottom = (mHeadIndex + 1) * mItemSpacing;

        while (mTailIndex < mCapacity - 1 && scrollContent.anchoredPosition.y > headBottom)
        {
            MoveHeadToTail();
            headBottom = (mHeadIndex + 1) * mItemSpacing;
        }

        while (mHeadIndex > 0 && scrollContent.anchoredPosition.y < headTop)
        {
            MoveTailToHead();
            headTop = mHeadIndex * mItemSpacing;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="scrollRectTransform"></param>
    /// <returns></returns>
    protected override float GetScrollRectSpacing()
    {
        RectTransform rectTransform = GetComponent<RectTransform>();
        return rectTransform.rect.height;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="item"></param>
    /// <param name="index"></param>
    protected override void SetItemPosition(RectTransform item, int index)
    {
        float x = 0;
        float y = (scrollContent.rect.height - mItemSpacing) * 0.5f - (index * mItemSpacing);

        item.anchoredPosition = new Vector2(x, y);
    }

    #endregion
}
