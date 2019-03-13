using UnityEngine;

public class DeviceInfo 
{
    /// <summary>
    /// 获取电量
    /// </summary>
    /// <returns>
    ///      -1：没获取到
    ///     0~1：电量百分比
    /// </returns>
    public static float GetBatteryLevel()
    {
        return SystemInfo.batteryLevel;
    }

    /// <summary>
    /// 获取电池状态
    /// </summary>
    /// <returns>
    ///     0：没检测到
    ///     1：充电
    ///     2：没充电
    ///     3：没充电
    ///     4：充满了
    /// </returns>
    public static int GetBatteryStatus()
    {
        return (int)SystemInfo.batteryStatus;
    }

    /// <summary>
    /// 获取网络状态
    /// </summary>
    /// <returns>
    ///     0：不可用
    ///     1：移动网络
    ///     2：WIFI
    /// </returns>
    public static int GetNetworkType()
    {
        return (int)Application.internetReachability;
    }
}
