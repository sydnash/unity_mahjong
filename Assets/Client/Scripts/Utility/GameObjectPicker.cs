using UnityEngine;

public class GameObjectPicker
{
    public static GameObject Pick(Camera camera, Vector3 screenPos)
    {
        Ray ray = camera.ScreenPointToRay(screenPos);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            return hit.collider.gameObject;
        }

        return null;
    }
}
