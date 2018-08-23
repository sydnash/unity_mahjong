using UnityEngine;

public class AnimationEvent : MonoBehaviour
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="key"></param>
    public void OnTrigger(string key)
    {
        AnimationEventManager.instance.OnTrigger(key);
    }
}
