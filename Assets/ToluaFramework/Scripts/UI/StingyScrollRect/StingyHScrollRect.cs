using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StingyHScrollRect : StingyScrollRect
{
    #region Private

    /// <summary>
    /// 
    /// </summary>
    /// <param name="spacing"></param>
    protected override void SetContentSpacing(float spacing)
    {
        scrollContent.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, spacing);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="v"></param>
    protected override void OnScrollRectValueChangedHandler(Vector2 delta)
    {
        float headLeft = mHeadIndex * mItemSpacing;
        float headRight = (mHeadIndex + 1) * mItemSpacing;

        while (mTailIndex < mCapacity - 1 && scrollContent.anchoredPosition.x > headRight)
        {
            MoveHeadToTail();
            headRight = (mHeadIndex + 1) * mItemSpacing;
        }

        while (mHeadIndex > 0 && scrollContent.anchoredPosition.y < headLeft)
        {
            MoveTailToHead();
            headLeft = mHeadIndex * mItemSpacing;
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
        return rectTransform.rect.width;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="item"></param>
    /// <param name="index"></param>
    protected override void SetItemPosition(RectTransform item, int index)
    {
        float x = (scrollContent.rect.width - mItemSpacing) * 0.5f - (index * mItemSpacing);
        float y = 0;

        item.anchoredPosition = new Vector2(x, y);
    }

    #endregion
}
