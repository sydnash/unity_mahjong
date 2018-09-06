using UnityEngine;

[RequireComponent(typeof(Camera))]
public class GameObjectPicker : MonoBehaviour
{
    #region Data

    /// <summary>
    /// 
    /// </summary>
    private Camera mCamera = null;

    #endregion

    #region Instance

    /// <summary>
    /// 
    /// </summary>
    private static GameObjectPicker mInstance = null;

    /// <summary>
    /// 
    /// </summary>
    public static GameObjectPicker instance
    {
        get { return mInstance; }
    }

    #endregion

    #region Public

    /// <summary>
    /// 
    /// </summary>
    /// <param name="screenPos"></param>
    /// <returns></returns>
    public GameObject Pick(Vector3 screenPos)
    {
        Ray ray = mCamera.ScreenPointToRay(screenPos);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 100, LayerMask.GetMask("InhandMahjong")))
        {
            return hit.collider.gameObject;
        }

        return null;
    }

    /// <summary>
    /// 
    /// </summary>
    public Camera camera
    {
        get { return mCamera; }
    }

    #endregion

    #region Private 
    
    /// <summary>
    /// 
    /// </summary>
    private void Awake()
    {
        mInstance = this;
        mCamera = GetComponent<Camera>();
    }

    #endregion
}
