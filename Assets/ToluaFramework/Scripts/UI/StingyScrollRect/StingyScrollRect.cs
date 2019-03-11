using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using LuaInterface;

public abstract class StingyScrollRect : MonoBehaviour
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    protected ScrollRect mScrollRect = null;

    /// <summary>
    /// 
    /// </summary>
    [SerializeField]
    protected float mItemSpacing = 60;

    /// <summary>
    /// 
    /// </summary>
    protected int mCapacity = 0;

    /// <summary>
    /// 
    /// </summary>
    protected List<LuaTable> mLuaList = new List<LuaTable>();

    /// <summary>
    /// 
    /// </summary>
    protected int mHeadIndex = -1;

    /// <summary>
    /// 
    /// </summary>
    protected int mTailIndex = -1;

    /// <summary>
    /// 
    /// </summary>
    protected LuaFunction mItemRefreshCallback = null;

    #endregion

    #region Public 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="item"></param>
    public void Init(int capacity, LuaFunction itemInstantiateCallback, LuaFunction itemRefreshCallback)
    {
        mItemRefreshCallback = itemRefreshCallback;

        if (mScrollRect == null)
        {
            mScrollRect = GetComponent<ScrollRect>();
        }
        mScrollRect.onValueChanged.AddListener(OnScrollRectValueChangedHandler);

        mCapacity = Mathf.Max(0, capacity);
        SetContentSpacing(mCapacity * mItemSpacing);

        if (itemInstantiateCallback != null)
        {
            float scrollRectSpacing = GetScrollRectSpacing();
            int itemCount = Mathf.Min(mCapacity, Mathf.CeilToInt(scrollRectSpacing / mItemSpacing) + 1);

            if (itemCount > 0)
            {
                mHeadIndex = 0;
            }

            for (int i = 0; i < itemCount; i++)
            {
                mTailIndex++;

                LuaTable lua = itemInstantiateCallback.Invoke<LuaTable>();
                RectTransform item = GetRectTransform(lua);
                item.SetParent(scrollContent, false);
                SetItemPosition(item, i);

                LuaFunction func = lua.GetLuaFunction("show");
                func.Call(lua);

                mLuaList.Add(lua);
                InvokeItemRefreshCallback(lua, i);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Add()
    {
        mCapacity++;
        SetContentSpacing(mCapacity * mItemSpacing);

        if (mTailIndex == mCapacity - 1)
        {
            mHeadIndex++;

            LuaTable lua = mLuaList[0];
            mLuaList.RemoveAt(0);
            mLuaList.Add(lua);
        }

        float scrollRectSpacing = GetScrollRectSpacing();
        int itemCount = Mathf.Min(mCapacity, Mathf.CeilToInt(scrollRectSpacing / mItemSpacing) + 1);
        //Logger.Log("itemcount = " + itemCount.ToString());
        for (int i = 0; i < itemCount; i++)
        {
            LuaTable lua = mLuaList[i];
            RectTransform item = GetRectTransform(lua);
            SetItemPosition(item, mHeadIndex + i);
            InvokeItemRefreshCallback(lua, mHeadIndex + i);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Remove()
    {
        mCapacity = Mathf.Max(0, mCapacity - 1);
        SetContentSpacing(mCapacity * mItemSpacing);

        float scrollRectSpacing = GetScrollRectSpacing();
        int itemCount = Mathf.Min(mCapacity, Mathf.CeilToInt(scrollRectSpacing / mItemSpacing) + 1);

        for (int i = 0; i < itemCount; i++)
        {

        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Reset()
    {
        mCapacity = 0;
        mHeadIndex = -1;
        mTailIndex = -1;

        foreach (LuaTable lua in mLuaList)
        {
            LuaFunction func = lua.GetLuaFunction("close");
            func.Call(lua);
        }
        mLuaList.Clear();

        if (mScrollRect != null)
        {
            mScrollRect.content.anchoredPosition = Vector2.zero;
            mScrollRect.onValueChanged.RemoveAllListeners();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public List<LuaTable> items
    {
        get { return mLuaList; }
    }

    #endregion

    #region Private 

    /// <summary>
    /// 
    /// </summary>
    /// <param name="spacing"></param>
    protected abstract void SetContentSpacing(float spacing);

    /// <summary>
    /// 
    /// </summary>
    /// <param name="v"></param>
    protected abstract void OnScrollRectValueChangedHandler(Vector2 delta);

    /// <summary>
    /// 
    /// </summary>
    /// <param name="scrollRectTransform"></param>
    /// <returns></returns>
    protected abstract float GetScrollRectSpacing();

    /// <summary>
    /// 
    /// </summary>
    /// <param name="item"></param>
    /// <param name="index"></param>
    protected abstract void SetItemPosition(RectTransform item, int index);

    /// <summary>
    /// 
    /// </summary>
    protected RectTransform scrollContent
    {
        get { return mScrollRect.content; }
    }

    /// <summary>
    /// 
    /// </summary>
    protected void MoveHeadToTail()
    {
        mHeadIndex++;
        mTailIndex++;

        LuaTable lua = mLuaList[0];
        mLuaList.RemoveAt(0);
        mLuaList.Add(lua);

        RectTransform item = GetRectTransform(lua);
        SetItemPosition(item, mTailIndex);

        InvokeItemRefreshCallback(lua, mTailIndex);
    }

    /// <summary>
    /// 
    /// </summary>
    protected void MoveTailToHead()
    {
        mHeadIndex--;
        mTailIndex--;

        LuaTable lua = mLuaList[mLuaList.Count - 1];
        mLuaList.RemoveAt(mLuaList.Count - 1);
        mLuaList.Insert(0, lua);

        RectTransform item = GetRectTransform(lua);
        SetItemPosition(item, mHeadIndex);

        InvokeItemRefreshCallback(lua, mHeadIndex);
    }

    /// <summary>
    /// 
    /// </summary>
    protected void InvokeItemRefreshCallback(LuaTable lua, int index)
    {
        if (mItemRefreshCallback != null)
        {
            mItemRefreshCallback.Call<LuaTable, int>(lua, index);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="lua"></param>
    /// <returns></returns>
    protected RectTransform GetRectTransform(LuaTable lua)
    {
        return lua["rectTransform"] as RectTransform;
    }

    #endregion
}
