using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class Utils
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static byte[] StringToBytes(string text)
    {
        return Encoding.UTF8.GetBytes(text);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bytes"></param>
    /// <returns></returns>
    public static string BytesToString(byte[] bytes, int offset, int length)
    {
        return Encoding.UTF8.GetString(bytes, offset, length);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static byte[] Int32ToBytes(int value)
    {
        return BitConverter.GetBytes(value);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="bytes"></param>
    /// <param name="startIndex"></param>
    /// <returns></returns>
    public static int BytesToInt32(byte[] bytes, int offset = 0)
    {
        return BitConverter.ToInt32(bytes, offset);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="startIndex"></param>
    /// <param name="length"></param>
    /// <returns></returns>
    public static byte[] NewByteArray(byte[] s, int offset, int length)
    {
        if (s == null || length == 0) return null;

        byte[] d = new byte[length];
        Array.Copy(s, offset, d, 0, length);

        return d;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="length"></param>
    /// <returns></returns>
    public static byte[] NewEmptyByteArray(int length)
    {
        if (length <= 0) return null;
        return new byte[length];
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="from"></param>
    /// <param name="fromOffset"></param>
    /// <param name="to"></param>
    /// <param name="toOffset"></param>
    /// <param name="length"></param>
    /// <returns></returns>
    public static int CopyBytes(byte[] from, int fromOffset, byte[] to, int toOffset, int length)
    {
        if (from == null || to == null || length <= 0) return 0;

        fromOffset = Mathf.Max(fromOffset, 0);
        toOffset = Mathf.Max(toOffset, 0);

        int size = Mathf.Min(from.Length - fromOffset, to.Length - toOffset, length);
        if (size > 0)
        {
            Array.Copy(from, fromOffset, to, toOffset, size);
        }

        return size;
    }

    //private static byte[] mConcatBytesBuffer = null;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    public static byte[] ConcatBytes(byte[] buffer, byte[] a, int asize, byte[] b, int bsize)
    {
        if (a == null && b == null)
            return null;

        if (buffer == null || buffer.Length < (asize + bsize))
        {
            buffer = new byte[asize + bsize];
        }

        if (a != null)
        {
            Array.Copy(a, 0, buffer, 0, asize);
        }

        if (b != null)
        {
            Array.Copy(b, 0, buffer, asize, bsize);
        }

        return buffer;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="startIndex"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static byte[] SubBytes(byte[] s, int start, int length)
    {
        if (s == null || length <= 0) return null;

        byte[] d = new byte[length];
        Array.Copy(s, start, d, 0, length);

        return d;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="s"></param>
    /// <param name="length"></param>
    /// <returns></returns>
    public static byte[] TrimBytes(byte[] s, int length)
    {
        if (s == null) return null;
        int size = s.Length - length;
        if (size <= 0) return s;

        Array.Copy(s, length, s, 0, size);
        return s;
    }

    /// <summary>
    /// 将图片缩放为指定尺寸
    /// </summary>
    /// <param name="originalTexture"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static Texture2D SizeTextureBilinear(Texture2D originalTexture, Vector2 size)
    {
        Texture2D newTexture = new Texture2D(Mathf.CeilToInt(size.x), Mathf.CeilToInt(size.y));
        
        float scaleX = originalTexture.width / size.x;
        float scaleY = originalTexture.height / size.y;
        int maxX = originalTexture.width - 1;
        int maxY = originalTexture.height - 1;
        
        for (int y = 0; y < newTexture.height; y++)
        {
            for (int x = 0; x < newTexture.width; x++)
            {
                float targetX = x * scaleX;
                float targetY = y * scaleY;
                int x1 = Mathf.Min(maxX, Mathf.FloorToInt(targetX));
                int y1 = Mathf.Min(maxY, Mathf.FloorToInt(targetY));
                int x2 = Mathf.Min(maxX, x1 + 1);
                int y2 = Mathf.Min(maxY, y1 + 1);

                float u = targetX - x1;
                float v = targetY - y1;
                float w1 = (1 - u) * (1 - v);
                float w2 = u * (1 - v);
                float w3 = (1 - u) * v;
                float w4 = u * v;
                Color color1 = originalTexture.GetPixel(x1, y1);
                Color color2 = originalTexture.GetPixel(x2, y1);
                Color color3 = originalTexture.GetPixel(x1, y2);
                Color color4 = originalTexture.GetPixel(x2, y2);
                Color color = new Color(Mathf.Clamp01(color1.r * w1 + color2.r * w2 + color3.r * w3 + color4.r * w4),
                    Mathf.Clamp01(color1.g * w1 + color2.g * w2 + color3.g * w3 + color4.g * w4),
                    Mathf.Clamp01(color1.b * w1 + color2.b * w2 + color3.b * w3 + color4.b * w4),
                    Mathf.Clamp01(color1.a * w1 + color2.a * w2 + color3.a * w3 + color4.a * w4)
                );
                newTexture.SetPixel(x, y, color);
            }
        }
        newTexture.Apply();

        return newTexture;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="camera"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static Texture2D CaptureScreenshot(Camera camera)
    {
        int w = (int)camera.pixelRect.width;
        int h = (int)camera.pixelRect.height;

        RenderTexture rt = new RenderTexture(w, h, 0);

        RenderTexture ct = camera.targetTexture;
        camera.targetTexture = rt;
        camera.Render();

        RenderTexture.active = rt;
        Texture2D screenshot = new Texture2D(w, h, TextureFormat.RGBA32, false);

        screenshot.ReadPixels(camera.pixelRect, 0, 0);
        screenshot.Apply();

        camera.targetTexture = ct;
        RenderTexture.active = null;
        GameObject.Destroy(rt);

        //byte[] bytes = screenshot.EncodeToJPG();
        //string filename = Application.persistentDataPath + "/screenshot.jpg";
        //System.IO.File.WriteAllBytes(filename, bytes);

        return screenshot;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="from"></param>
    /// <param name="to"></param>
    /// <param name="subject"></param>
    /// <param name="body"></param>
    /// <param name="attachment"></param>
    /// <param name="password"></param>
    public static void CommitError(string from, string to, string subject, string body, string attachment, string password)
    {
        ErrorEmail.Commit(from, to, subject, body, attachment, password);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="tex"></param>
    /// <returns></returns>
    public static Sprite ConvertTextureToSprite(Texture2D tex, Vector2 pivot)
    {
        if (tex != null)
        {
            Sprite sprite = Sprite.Create(tex, new Rect(0, 0, tex.width, tex.height), pivot);
            return sprite;
        }

        return null;
    }

	public static Dictionary<string, object> CreateDictionarySO() {
		return new Dictionary<string, object>();
	}
    public static void AddDictionarySO(Dictionary<string, object> dic, string key, object value) 
    {
        if (dic.ContainsKey(key)) 
        {
            dic[key] = value;
        }
        else 
        {
            dic.Add(key, value);
        }
    }
}
