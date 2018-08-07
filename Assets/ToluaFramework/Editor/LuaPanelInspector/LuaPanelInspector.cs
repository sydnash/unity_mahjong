using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(LuaPanel))]
public class LuaPanelInspector : Editor 
{
    /// <summary>
    /// 
    /// </summary>
    class Item
    {
        /// <summary>
        /// 
        /// </summary>
        public LuaPanel.Widget widget = null;

        /// <summary>
        /// 
        /// </summary>
        public bool expand = true;
    }

    /// <summary>
    /// 
    /// </summary>
    private LuaPanel mPanel = null;

    /// <summary>
    /// 
    /// </summary>
    private List<Item> mItemList = new List<Item>();

    /// <summary>
    /// 
    /// </summary>
    private void OnEnable()
    {
        mPanel = target as LuaPanel;

        foreach (LuaPanel.Widget widget in mPanel.widgets)
        {
            Item item = new Item();
            item.widget = widget;
            item.expand = false;

            mItemList.Add(item);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public override void OnInspectorGUI()
    {
        GUILayout.Space(4);

        GUI.color = Color.green;
        if (GUILayout.Button("Add Widget"))
        {
            Item item = new Item();
            item.widget = new LuaPanel.Widget();
            item.expand = true;

            mItemList.Add(item);
            mPanel.widgets.Add(item.widget);
        }
        GUI.color = Color.white;

        Item needRemoveItem = null;

        for (int i = mItemList.Count - 1; i >= 0; i--)
        {
            Item item = mItemList[i];
            needRemoveItem = DrawItem(item);
        }

        if (needRemoveItem != null)
        {
            mItemList.Remove(needRemoveItem);
            mPanel.widgets.Remove(needRemoveItem.widget);
        }

        Repaint();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="item"></param>
    /// <returns></returns>
    private Item DrawItem(Item item)
    {
        Item needRemoveItem = null;

        LuaPanel.Widget widget = item.widget;
        bool expand = item.expand;

        Rect rect = EditorGUILayout.BeginHorizontal();
        {
            if (GUILayout.Button("", EditorStyles.miniButtonLeft))
            {
                item.expand = !expand;
            }

            GUI.color = Color.red;
            if (GUILayout.Button("\u2716", EditorStyles.miniButtonRight, GUILayout.Width(32)))
            {
                needRemoveItem = item;
            }
            GUI.color = Color.white;
        }
        EditorGUILayout.EndHorizontal();

        rect.x = rect.x + 4;
        EditorGUI.LabelField(rect, (expand ? "\u25BC " : "\u25BA ") + widget.variableName, EditorStyles.miniLabel);

        if (expand)
        {
            EditorGUILayout.BeginVertical(EditorStyles.textArea);
            {
                GUILayout.Space(2);

                widget.variableName = EditorGUILayout.TextField("Variable Name", widget.variableName);
                widget.widgetType = (LuaPanel.WidgetType)EditorGUILayout.EnumPopup("Type", widget.widgetType);
                widget.gameObject = EditorGUILayout.ObjectField("Target Object", widget.gameObject, typeof(GameObject)) as GameObject;

                if (widget.widgetType == LuaPanel.WidgetType.Panel)
                {
                    widget.panelScript = DrawPanelScriptFiled(widget);
                }

                GUILayout.Space(2);
            }
            EditorGUILayout.EndVertical();
        }

        return needRemoveItem;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="widget"></param>
    /// <returns></returns>
    private string DrawPanelScriptFiled(LuaPanel.Widget widget)
    {
        string scriptName = widget.panelScript;

        Rect dragRect = EditorGUILayout.BeginHorizontal();
        {
            if (dragRect.Contains(Event.current.mousePosition))
            {
                if (Event.current.type == EventType.DragUpdated)
                {
                    if (DragAndDrop.paths != null && DragAndDrop.paths.Length > 0)
                    {
                        string path = DragAndDrop.paths[0];

                        if (string.IsNullOrEmpty(path) || System.IO.Path.GetExtension(path).ToLower() != ".lua")
                        {
                            DragAndDrop.visualMode = DragAndDropVisualMode.Rejected;
                        }
                        else
                        {
                            DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
                        }
                    }
                }
                else if (Event.current.type == EventType.DragPerform)
                {
                    if (DragAndDrop.paths != null && DragAndDrop.paths.Length > 0)
                    {
                        string path = DragAndDrop.paths[0];

                        if (!string.IsNullOrEmpty(path) && System.IO.Path.GetExtension(path).ToLower() == ".lua")
                        {
                            string rootPath = "Assets/Lua/";
                            scriptName = path.Substring(rootPath.Length, path.Length - rootPath.Length - 4).Replace("/", ".");
                        }
                    }
                }
            }

            EditorGUILayout.TextField("Panel Script", scriptName);
        }
        EditorGUILayout.EndHorizontal();

        return scriptName;
    }
}
