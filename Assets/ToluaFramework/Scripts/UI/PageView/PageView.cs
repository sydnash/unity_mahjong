using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;


public class PageView : MonoBehaviour, IBeginDragHandler, IEndDragHandler
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private ScrollRect mScrollRect; 

    /// <summary>
    /// 滑动的起始坐标 
    /// </summary>
    private float mTargetHorizontal = 0;

    /// <summary>
    /// 是否拖拽结束 
    /// </summary>
    private bool mIsDrag = false;

    /// <summary>
    /// 求出每页的临界角，页索引从0开始  
    /// </summary>
    private List<float> mPosList = new List<float>();

    /// <summary>
    /// 
    /// </summary>
    private int mCurrentPageIndex = -1;

    /// <summary>
    /// 
    /// </summary>
    private bool mStopMove = true;

    /// <summary>
    /// 滑动速度 
    /// </summary>
    [SerializeField]
    private float mSmooting = 4;

    /// <summary>
    /// 
    /// </summary>
    [SerializeField]
    private float mSensitivity = 0;

    /// <summary>
    /// 
    /// </summary>
    private float mDeltaTime = 0;

    /// <summary>
    /// 
    /// </summary>
    private float mStartDragHorizontal;

    #endregion

    #region Event

    /// <summary>
    /// 
    /// </summary>
    public Action<int> OnPageChanged;

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="listener"></param>
    public void AddListener(Action<int> listener)
    {
        OnPageChanged += listener;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="listener"></param>
    public void RemoveListener(Action<int> listener)
    {
        OnPageChanged -= listener;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="listener"></param>
    public void RemoveAllListeners()
    {
        OnPageChanged = null;
    }

    /// <summary>
    /// 
    /// </summary>
    public void Reset()
    {
        mScrollRect.horizontalNormalizedPosition = 0;
        mCurrentPageIndex = 0;
        PageTo(mCurrentPageIndex);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="index"></param>
    public void PageTo(int index)
    {
        if (index >= 0 && index < mPosList.Count)
        {
            mScrollRect.horizontalNormalizedPosition = mPosList[index];
            SetPageIndex(index);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="eventData"></param>
    public void OnBeginDrag(PointerEventData eventData)
    {
        mIsDrag = true;
        mStartDragHorizontal = mScrollRect.horizontalNormalizedPosition;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="eventData"></param>
    public void OnEndDrag(PointerEventData eventData)
    {
        float posX = mScrollRect.horizontalNormalizedPosition;
        posX += ((posX - mStartDragHorizontal) * mSensitivity);
        posX = Mathf.Clamp01(posX);

        int index = 0;
        float offset = Mathf.Abs(mPosList[index] - posX);

        for (int i = 1; i < mPosList.Count; i++)
        {
            float temp = Mathf.Abs(mPosList[i] - posX);
            if (temp < offset)
            {
                index = i;
                offset = temp;
            }
        }

        SetPageIndex(index);

        mTargetHorizontal = mPosList[index]; //设置当前坐标，更新函数进行插值  
        mIsDrag = false;
        mDeltaTime = 0;
        mStopMove = false;
    }

    /// <summary>
    /// 当前页的序号
    /// </summary>
    public int current
    {
        get { return mCurrentPageIndex; }
    }

    #endregion

    #region Private

    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mScrollRect = GetComponent<ScrollRect>();
        float width = GetComponent<RectTransform>().rect.width;
        float horizontalLength = mScrollRect.content.rect.width - width;
        mPosList.Add(0);
        for (int i = 1; i < mScrollRect.content.childCount - 1; i++)
        {
            mPosList.Add(width * i / horizontalLength);
        }
        mPosList.Add(1);
    }

    /// <summary>
    /// 
    /// </summary>
    private void Update()
    {
        if (!mIsDrag && !mStopMove)
        {
            mDeltaTime += Time.deltaTime;
            float t = mDeltaTime * mSmooting;
            mScrollRect.horizontalNormalizedPosition = Mathf.Lerp(mScrollRect.horizontalNormalizedPosition, mTargetHorizontal, t);
            
            if (t >= 1)
            {
                mStopMove = true;
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="index"></param>
    private void SetPageIndex(int index)
    {
        if (mCurrentPageIndex == index) return;

        mCurrentPageIndex = index;
        if (OnPageChanged != null)
        {
            OnPageChanged(mCurrentPageIndex);
        }
    }

    #endregion
}
