using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class LuaPanel : MonoBehaviour 
{
    /// <summary>
    /// 
    /// </summary>
    public enum WidgetType
    {
        GameObject, //
        Panel,      //
        Text,       //
        Sprite,     //
        Image,      //
        Button,     //
        Toggle,     //
        Slider,     //
        Input,      //
        ScrollView, //
        ScrollRect, //
        PageView,   //
    }

    /// <summary>
    /// 
    /// </summary>
    [System.Serializable]
    public class Widget
    {
        /// <summary>
        /// 
        /// </summary>
        public string variableName;

        /// <summary>
        /// 
        /// </summary>
        public WidgetType widgetType;

        /// <summary>
        /// 
        /// </summary>
        public GameObject gameObject;

        /// <summary>
        /// 
        /// </summary>
        public string panelScript = string.Empty;
    }

    /// <summary>
    /// 
    /// </summary>
    [SerializeField]
    protected List<Widget> mWidgets = new List<Widget>();

    /// <summary>
    /// 
    /// </summary>
    /// <param name="lua"></param>
    public void Bind(LuaTable lua, LuaFunction function)
    {
        foreach (Widget w in widgets)
        {
            function.Call(lua, w.variableName, w.gameObject, w.widgetType, w.panelScript);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public List<Widget> widgets
    {
        get { return mWidgets; }
    }
}
