using System;
using UnityEngine;

public class LocationHelper
{
    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    //public static void StartLocation(AndroidJavaObject javaObject)
    //{
    //    javaObject.Call("StartLocation");
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    //public static void StopLocation(AndroidJavaObject javaObject)
    //{
    //    javaObject.Call("StopLocation");
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public static bool GetStatus(AndroidJavaObject javaObject)
    //{
    //    return javaObject.Call<bool>("GetLocationStatus");
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public static float GetLatitude(AndroidJavaObject javaObject)
    //{
    //    return javaObject.Call<float>("GetLocationLatitude");
    //}

    ///// <summary>
    ///// 
    ///// </summary>
    ///// <param name="javaObject"></param>
    ///// <returns></returns>
    //public static float GetLongitude(AndroidJavaObject javaObject)
    //{
    //    return javaObject.Call<float>("GetLocationLongitude");
    //}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="javaObject"></param>
    /// <param name="la1"></param>
    /// <param name="lo1"></param>
    /// <param name="la2"></param>
    /// <param name="lo2"></param>
    /// <returns></returns>
    public static float GetDistance(AndroidJavaObject javaObject, float la1, float lo1, float la2, float lo2)
    {
        return javaObject.Call<float>("GetDistance", la1, lo1, la2, lo2);
    }
}
