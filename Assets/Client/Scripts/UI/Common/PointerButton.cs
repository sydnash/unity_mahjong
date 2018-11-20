using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

namespace UnityEngine.UI
{
    public class PointerButton : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
    {
        [System.Serializable]
        public class PointerButtonEvent : UnityEvent<Vector2>
        {
            public PointerButtonEvent(){ }
        }

        public bool interactable = true;

        public PointerButtonEvent onDown = new PointerButtonEvent();
        public PointerButtonEvent onMove = new PointerButtonEvent();
        public PointerButtonEvent onUp = new PointerButtonEvent();
        
        private bool pressed = false;

        public void OnPointerDown(EventSystems.PointerEventData eventData)
        {
            if (interactable)
            {
                pressed = true;
                onDown.Invoke(eventData.position);
            }
        }

        public void OnPointerUp(EventSystems.PointerEventData eventData)
        {
            if (interactable)
            {
                pressed = false;
                onUp.Invoke(eventData.position);
            }
        }

        private void Update()
        {
            if (interactable && pressed)
            {
#if UNITY_STANDALONE_WIN || UNITY_EDITOR
                //if (Input.GetMouseButtonDown(0))
                {
                    Vector2 pos = Input.mousePosition;
                    onMove.Invoke(pos);
                }
#elif UNITY_ANDROID || UNITY_IPHONE
                if (Input.touchCount > 0)
                {
                    Vector2 pos = Input.GetTouch(0).position;
                    onMove.Invoke(pos);
                }
#endif
            }
        }
    }
}