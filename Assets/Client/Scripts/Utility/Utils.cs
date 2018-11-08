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
    /// <param name="a"></param>
    /// <param name="b"></param>
    public static byte[] ConcatBytes(byte[] a, int asize, byte[] b, int bsize)
    {
        if (a == null && b == null)
            return null;

        byte[] c = new byte[asize + bsize];

        if (a != null)
        {
            Array.Copy(a, 0, c, 0, asize);
        }

        if (b != null)
        {
            Array.Copy(b, 0, c, asize, bsize);
        }

        return c;
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
        int size = s.Length - length;
        if (s == null || size <= 0) return null;

        byte[] d = new byte[size];
        Array.Copy(s, length, d, 0, size);

        return d;
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
}
