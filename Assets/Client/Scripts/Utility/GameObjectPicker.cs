using UnityEngine;

public class GameObjectPicker : MonoBehaviour
{
    private Camera mCamera = null;
    private Ray mRay;

    private static GameObjectPicker mInstance = null;

    public static GameObjectPicker instance
    {
        get { return mInstance; }
    }

    public GameObject Pick(Vector3 screenPos)
    {
        mRay = mCamera.ScreenPointToRay(screenPos);
        RaycastHit hit;

        if (Physics.Raycast(mRay, out hit, 100, LayerMask.GetMask("InhandMahjong")))
        {
            return hit.collider.gameObject;
        }

        return null;
    }

    public Camera camera
    {
        get { return mCamera; }
    }

    void Awake()
    {
        mInstance = this;
        mCamera = GetComponent<Camera>();
    }

    void Update()
    {
        Debug.DrawRay(mRay.origin, mRay.direction * 100000, Color.red, 3);
    }
}
